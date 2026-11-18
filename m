Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052297;
	b=i7sLzxhk6iePGmN1fVblSTVnAvdD3PnlFAOOrMf59Dejh03b2wk/6K5GGUAQZMRYDUwr
	 OUlHKyt0PRjr1QQpj2C4O/KbS+ZloAov23S+Pma9TkHMpDcb8BoJVdEMXFSRG/M9Ey2xz
	 GWcqOz26JTJAL7mbS8jeVYwb2oX2HKRA8IOLkXDp2k72f9Y/pDqHMo9vVF40txAiovgIg
	 KxW0n91KuyADgozgpAxbzM4tVhLOqyhV/jRk78BXAhbQsjyGGiM8gbTqVxC1VJioZ8ivS
	 /pQXDhLNReO9DRJOYu95D3xGbsVNkGVPuC7O18UE7QLdu57PMWD3TtdRUuFxjn+lJOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H4nri+4GxzSjUz73XF5Qs0pBYLZJ5arV38LbdunNWPM=;
	b=XcRcyIqi20f57XgGrVjv4gdXsLSD/kKfxl6wZRr1twbE4/GNLUGXP6fGkFGRgVtC61DZ
	 I4uCEtiuVfRMXr2E8A54Lw5XEUw5NuBAZGLIYwqClWU3QTIzyA/fbA/FVGC2tOBHiSXEp
	 xKxSm4SzEMhlr9sPxhekNRQ3zq5KQx053VqN5CRKN/cSTkR1Z2ljIRf2XtFCpUGD2B/DV
	 9vi8Ul89EJLQqTPWlR7VMZeygyoRIaXlB8r+8rHssQblQ65QV1dEADBZxCuDhI+XlfKAF
	 ZyndkVbPlCFV/5xGnwPBnZTf+9cQtbOP2XfCAzlgD7ZPtxA2dzXaT7HA+YjM76ksT4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+mwLJUT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8D2606A31C;
	Thu, 19 Nov 2026 01:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+mwLJUT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8451F000C4;
	Thu, 19 Nov 2026 01:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052297;
	bh=H4nri+4GxzSjUz73XF5Qs0pBYLZJ5arV38LbdunNWPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+mwLJUTzZ5Xc3BGsRnppZ0T0MKaywVEpnfee7sbyIWwOKZDit8b0IuIAmM3OZ5pP
	 GSEF+iTm8YYdp3BDWn3aM31PGzKbhHmEvF6yytUqkJkrhWuV4LI6Qf7/1YcCfnBgvF
	 cfCseqtnU9WhBQjLtGLPR+smL9Hb7jdJGnFGo6zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cong Nguyen <congnt264@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0511/2214] staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error
Date: Wed, 18 Nov 2026 15:36:27 +0100
Message-ID: <20261118150031.561356812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 07643be7b1eff94f7a49e142c1e92a1029d3db21 ]

device_run() allocates an ipu_image_convert_run object and, on the
success path, hands it to the IPU image conversion core via
ipu_image_convert_queue(); the run object is then freed asynchronously
by the completion callback ipu_ic_pp_complete().

However, if ipu_image_convert_queue() fails, the core never takes
ownership of the run object and the completion callback is never
invoked. The "err" label finishes the mem2mem job and reports the
buffers as errored, but never frees the run object that was just
allocated, leaking it on every queue failure.

Free the run object in the error path. There is no risk of a double
free: the completion callback only runs after the object was
successfully queued, which is mutually exclusive with reaching the
error path. It is also safe for the earlier "goto err" on allocation
failure, since run is NULL there and kfree(NULL) is a no-op.

Fixes: a8ef0488cc59 ("media: imx: add csc/scaler mem2mem device")
Cc: stable@kernel.org
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-csc-scaler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/imx/imx-media-csc-scaler.c b/drivers/staging/media/imx/imx-media-csc-scaler.c
index b6be029470e53..898ac25d193bc 100644
--- a/drivers/staging/media/imx/imx-media-csc-scaler.c
+++ b/drivers/staging/media/imx/imx-media-csc-scaler.c
@@ -144,6 +144,7 @@ static void device_run(void *_ctx)
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
+	kfree(run);
 }
 
 /*
-- 
2.53.0




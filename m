Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058238;
	b=5qn9TWy7p8TABaH2OzrRFJ1p1rr/2suvGDhaeNuQiM8ysHxD/fyCehsZjA9XlAqk5taP
	 THOPdcF254/OTzGZ919fmJuOLM3VyQ9Wu5grSBZBvj6EpkGrTlFMX01IovKaNrLRKBODb
	 9PPSoMX2L2YXG+4X5VmP3EOjASzyMwq/SvcWWxQF4o/7q+zchAaNt4B2DYqGs6hdKinZM
	 Of1hNsZPXmLaOgATQOZbgke4FhSIzCBWuaxK3BkKMngUX542LahQD8lpUe+bmnTFeRnj6
	 SON1TgBdllgpa/RDo71CK0jrmcJtFGpBZVP6pp70h4GxBAChOI+TJQopZ7b/H/+gjdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdrXr7m8La9eYG8SrBbepGczhPe/uZDnd1ePc/SkP1U=;
	b=BTeluQfPMPXREp/bVkKeVSP+/8VwrIIJcFePADAccLALg5cqeuIy15m6FD+NFa9NQ9oL
	 K09BpMnE6f1WKOHi+uUHOpUHut3f/g9lPs45UaOf53pXFYRi8DjpCwdbK/YlRqdk8+l+B
	 cJ5WthbRQMPBA7nKgOz11M4kZnQr0Nm+weJb3paiTN6+QOoJwv5K2KVrgE+cc6bTzCYUD
	 Bi9sToBtigKerI6Dx/UsXytVghA7x9e2f+r7rg8ejgIkpdHyNn/3dcLuantxezA79cOxW
	 PsZbyqsDOMWQs5XCzd0r5uFBt6iVcNIoi3c2D08kEPLzOUp/IEoyb9SsdM7ltMzaKtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGxrrxX8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B60606A325;
	Thu, 19 Nov 2026 03:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGxrrxX8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1629B1F000C4;
	Thu, 19 Nov 2026 03:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058238;
	bh=DdrXr7m8La9eYG8SrBbepGczhPe/uZDnd1ePc/SkP1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGxrrxX8E6F1ZQ923G0mJ/4jpjMvSoYzKiEN0VyFS8/0N3EHdv0dlD+u0amX2oB/9
	 OcHKGLBi6EBen//OUEA6rTdG0vwwlYLvT29UxgErmFFiBOyFEUY47v2fmAs6hUvtTk
	 ihYl4T0qSnXK5Fu60c/nbwOcuNghL1xNyTbZUrmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cong Nguyen <congnt264@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0415/1848] staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error
Date: Wed, 18 Nov 2026 15:40:53 +0100
Message-ID: <20261118145931.351588721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7ffd9e80a1d42..e04371c6d9b08 100644
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




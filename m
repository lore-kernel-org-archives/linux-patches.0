Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045210;
	b=od/3rlxaTTHdYfd/jkttJNecrFrf2+mlB39TpuSuJYqdkcLfuKfYKAlg5Q9UF0P8NyNk
	 BfNFl7NgS+W9vhdwnbLMzOB7x2YOfnKQ2jCMnQPta5/XnEpHiXmKDvIK5+hj6K4E4H6kE
	 ZMB+VIb9vguNYuduN/oBZ7iVy9vuka7k8DNjRwm4K8IymLqPhF3Dlu+KeZzSeOAy6dlAs
	 TdHVhKs9LYZ2c/pA48Fq5Gttpn4SfA9BUbq2+QW3wCRsqr/Fq1yjs/YUu1MXPLumucM9v
	 OuUcTpN7eafqo1GkjX8rSCkdARPocf33uwEcmR+Hi+FewlEWnK1RdrnCAYodVSMuKvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+35uPy7OBS1+pYXo25ZFdDDNU32UuX0/QHQ4KhAJbo=;
	b=FPSDlqURXTruiQiblZ+KWnP/5dJaJ/tSz7l6WTgS5zxOsvMc9bhpaQxgGyE1BO7L6B1l
	 wMxDcsdtlnsD0hLsbRBhGUGcPCctyo0vQMUefQkJqvHUsoLhZrk+ED5pVWaH3YrSJczK/
	 io1yAVYdilF7kD6Xr19Omy5JKsDdnL+PPMrBNwJlbCM/ChdaDi6g4ka3jcUXDBN0eXIfd
	 Wv6+TYXh0pcNTMAXB2r+xSMfZtumj2xuZ7D9WW2Ac8n17AIGJpdT1yTwdQCshqUNP5KVU
	 xB7Dg8JCg656yRh/RzJTquPv04oFP9o9TvCuhFFp4Ypqxzyhq9MxDuHVaI1Nd2UgMUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQdY4Wq1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEF8606A32C;
	Wed, 18 Nov 2026 23:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQdY4Wq1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71761F000C4;
	Wed, 18 Nov 2026 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045210;
	bh=Q+35uPy7OBS1+pYXo25ZFdDDNU32UuX0/QHQ4KhAJbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQdY4Wq1MWEYthOtuIkLIiw2ta5HLZHAwA/Idzt7e7jzLQvhGFcnFDSFA2gsrisKw
	 T0995EV7A8xy0SZQpP9mn4Bdx8u/vx0ZWbCxp0ZE5pw5nj7eMAH+WdAaK4dabAEN+m
	 EsZevmFcXU74fmVmFdQYcUl+vnEBCD/pPJ4eRJII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cong Nguyen <congnt264@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0791/2857] staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error
Date: Wed, 18 Nov 2026 15:30:25 +0100
Message-ID: <20261118150230.048909154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 07104e7f5a5f9..6643f09aa44d0 100644
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




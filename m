Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052472;
	b=pk8Y6MqG/EujkVgK6pfNhm3wfKDYkqb8p4117adXmXKuip5/IMS2O1TVGsYnEqtntKR2
	 sja3f23f4ps/6XAIbg5yqMDvdX0e/MHbDTVwBEJmw4dj/IoyBN4F7OvNT6c39VgQXxLZ0
	 bqM6NRQMngOl3VOUDVZf5ngVbuBVXn5SG2svFx7WQsLlQfUzxObCUMUjbFb8qqywL5L+e
	 9YzPCRqg4BABt0UWsgZAwjV1VNgungBakP4tUtnsHdgwonwAJeUIkN7fruwATbc5kKyXm
	 UfTrcqIr5tQ/LHXSvcL3zz377qhZR5T2AeOe8VbgTSWeznEjnW5ixb1mRTGlKeh214w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EZtaLbNG8Z1O3C7KoJn3xV27myTuItVMTanyiRbLVtM=;
	b=pEyHMqWzjflGf4bOzE1G1KyS5sT2q0fc/cH2LtifyQ8crEN08ZUZImzKtwlBwWL/7/kK
	 bmsIQLA9pFHJzM4Kd8TDSBykF0Ctjd7hsUfaWoBVUuHw4llcOoRrU37D3vbnrOSVnIe29
	 x0CuKvRfRYeqohumcnqaNJUbeKULwDWobg6l/a3nFLf//DOEtFEVDxniGy+uWF5hqj3O3
	 5TN+lMX0vi6pgFuTQa05p+DIYtTbQj5Twjms0rfu66n00Jrb6yOxuSw01oKIK50y639d1
	 I88CDuwnaYGy5bEwAAeD3o3VpuES8S6z419IXUfSuUlICVhNOLJxCjC7P5+DzbkqG0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TByLK6iz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A36606A31C;
	Thu, 19 Nov 2026 01:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TByLK6iz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848E51F000C4;
	Thu, 19 Nov 2026 01:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052472;
	bh=EZtaLbNG8Z1O3C7KoJn3xV27myTuItVMTanyiRbLVtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TByLK6izUU/0PX+Zu/WA1ZiPeZcJl8TWTmb84/9/7zOszttiVOZwHyLssP82n251W
	 s5c0AMUoGD+mBEBeOicGiIkNtMNi5DKUf95k+u8QCXoG/CrX6HMevuoQYeee7aMHwd
	 ZX1C8YFWiCEOO9FgQE3zMAgEmhcaYZZ2HVWj4XXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0573/2214] media: hantro: Harden MPEG-2 control access against NULL
Date: Wed, 18 Nov 2026 15:37:29 +0100
Message-ID: <20261118150033.880313375@linuxfoundation.org>
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

From: Tharit Tangkijwanichakul <tharitt97@gmail.com>

[ Upstream commit 2b685dba4226792933f45b1cbf8991e89ccd21ce ]

The MPEG-2 sequence and picture controls are validated
before a job is queued, so hantro_get_ctrl() is not expected to return
NULL in hantro_g1_mpeg2_dec_run(). The controls are nonetheless
dereferenced unconditionally.

Harden the invariant by checking the sequence and picture controls with
WARN_ON().

Found by code inspection.

Fixes: f329e21e9dad ("media: uapi: mpeg2: Split sequence and picture parameters")
Cc: stable@vger.kernel.org
Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_g1_mpeg2_dec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/hantro/hantro_g1_mpeg2_dec.c b/drivers/staging/media/hantro/hantro_g1_mpeg2_dec.c
index 9aea331e1a3c9..ffdd385ba11fb 100644
--- a/drivers/staging/media/hantro/hantro_g1_mpeg2_dec.c
+++ b/drivers/staging/media/hantro/hantro_g1_mpeg2_dec.c
@@ -161,8 +161,13 @@ int hantro_g1_mpeg2_dec_run(struct hantro_ctx *ctx)
 
 	seq = hantro_get_ctrl(ctx,
 			      V4L2_CID_STATELESS_MPEG2_SEQUENCE);
+	if (WARN_ON(!seq))
+		return -EINVAL;
+
 	pic = hantro_get_ctrl(ctx,
 			      V4L2_CID_STATELESS_MPEG2_PICTURE);
+	if (WARN_ON(!pic))
+		return -EINVAL;
 
 	reg = G1_REG_DEC_AXI_RD_ID(0) |
 	      G1_REG_DEC_TIMEOUT_E(1) |
-- 
2.53.0




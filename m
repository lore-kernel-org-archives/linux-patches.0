Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064463;
	b=OksnUzPEv1O/cSn3OA+/2Hn/H4BntMXuJYAh2SRF3gtItVL7c+nlJGvgqL1PtQ7cbOVx
	 3wy6KvhlrYH1Drx1c8SjEiGrBXL50ERD+itxAhBaurFyazkhHB8LyPRSUrHGCPt/Mm7UT
	 RLWtyW3qr5sGbYXvdHO4u7MqzMtK9g7IaxiAcv2mXTuMhECco4LpHFEGgOPdQGYSXAHGt
	 OtdHLBGL+drIEEdMDbAK8hoAEse32MhZza5cbuVBLxG5o71OyReZP61dvwJt43C9r5bjU
	 6kbMbNOcMBMHUC1HEMV88JFgC4G2H4fcv66otHNyT43EERHKSlMcdZz51IgcbXymUpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U9BL02B7l7LEN6mIvp1lgK6Hmd5y26tImZZbReeHUO8=;
	b=B4cOofoxOY3Q8RHpkRDBoJ5Ibjy9rDWV//do1HeBvCCRIpAB3wbRGYYXnkTo5pbvn0SY
	 aA1kWjmvyUNiQ9yCLXM+WQtVPGRnkNB7/FMHzvF4VNG2/OHX8ljNL2krA1UxV5Zyno1HU
	 DHDLMCwaVY+chO9luHtnNFtg29VvLkZ3+W8CjrkwNPglA4KIcz4lZhNWcfvnInk7ElbDM
	 GyPHaW/6Bg+nK7CLeYQWiZeus4o2uzH9AkrYq2Nt6zbpM6Jcm61NWjhbi110Ycim7ZSwY
	 +gY5osaD+5t61a00JIwqL5BGPi+cNFG7QE/aoLJ+VtR1uFXQk0F1mxm/ns4ckw+CGXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIpTPV39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEBF606A9E7;
	Sat,  7 Nov 2026 15:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIpTPV39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7CA1F008A3;
	Sat,  7 Nov 2026 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064462;
	bh=U9BL02B7l7LEN6mIvp1lgK6Hmd5y26tImZZbReeHUO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIpTPV39uDh2NvNjQBnqG/96VRsE+qYqzBuDqRiVxQUbcSkeww8BZnGdX2Up/7Lwz
	 YmG2UOTQ7oybslaog6CQ25Tp/ZAioifPVfaYtv3px7zuVotvT1ez7++WDQA9I9SaN4
	 azkTCbSPCbIupkButicz/LRXEcQTzzUQI2z6OSfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0466/1257] media: hantro: Harden MPEG-2 control access against NULL
Date: Sat,  7 Nov 2026 08:46:02 -0500
Message-ID: <20261107134952.335715169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c b/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
index e0d6bd0a6e44f..6a942f4b8a2dd 100644
--- a/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
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




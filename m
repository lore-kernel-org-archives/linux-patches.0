Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060713;
	b=KdV4KMRB4o0irqFuVi8bmYTDW/ef0o78XS1BpwA6bjdlMQlM+6jhzHJgoUQ75mR7kDTF
	 h48syVPnz5jWL2JiSgQQE0owkA+lJQC8I3TyKnO3Zr92x1Dt1mehI3P2O3iqdmdtrlBUJ
	 8j56SQ98UPPyClf5oNAoiAaQWHBCB8KtVRBZs25ncUhVCBAfwnqHnEcr3Bz2wuhNuVbdI
	 xEmBCYZDjcZaDvoNMCDb2CEQlDxY1M9WoA+G4A9Nurr9pyRKz6v3jlWdbcnpA1OB2B8w0
	 chDViy7fOeB7oOey/UFgP7feFMkOWtjLKOwqzWgHgjGLu388x3L9w1Z2ywPZ57R+mLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=svIquXhl5Wxic6KEMgyIR38e5OzARvaMjdAKXiIGX4s=;
	b=sIQnKgoeWh7AWF2Hpt+LjzBDgp0ksahB2j0Krrw+dEDv7DlaFx7nOJIyQAuLOsZ0XmDI
	 7jvxY8EeU6tdNtzRyPiodWVwA3nmDgGC2EWPzK8pGg0bMdXbuCtXlnrGJIR4r8GewQViy
	 gY9zbs1uCCMdYy0KqA32QhlXE1TnxD8+DEdZPZ8zusG8aNv4HPWpBSLA/M/xB6iAaUtJ6
	 YSVXctW/s+4nU3QLBJodQTp4pld8kile2y7g6KJGFeoCgh4ApvTZXc6rCdnHToTPESjEp
	 9mo2umrwZ1YirmxPZVG9oHUcOaLmd0Tn+FMLmmHkCfEIOUVpGHDOTStL3xu6Nfxatjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ekMzkXo7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFB1606A326;
	Sat,  7 Nov 2026 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ekMzkXo7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2190D1F0089F;
	Sat,  7 Nov 2026 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060712;
	bh=svIquXhl5Wxic6KEMgyIR38e5OzARvaMjdAKXiIGX4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekMzkXo7uJVxJbu3mNOsmcdn0lZyRKinVnj6mYoq99vi0PNdxoelBV5vtw80RAP6I
	 ox85of1LFtKsyKJwF7a6GhnaH3v5MVGfws6pT8j5VUViedjikfwcz4UqyiX6lpSeX2
	 JYWoKyy/3nn3rcxItEZS0mKSIhVQ6LGtKTpBlGH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0138/1536] media: cec: tegra_cec: dont break off msg on NACK
Date: Sat,  7 Nov 2026 08:35:54 -0500
Message-ID: <20261107135001.565858869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit be627f257ce283c95fd2988080dc0db3a20d0d2a ]

The Tegra CEC hardware has a bug where, if the first attempt
to transmit a message is NACKed so the transmit is aborted,
then the second attempt can contain corrupt data.

Ensure that the full message is always transmitted to avoid hitting
this bug.

I suspect some internal state is not reset in the case of aborting
a message due to a NACK.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index a199a41589422..7ebd25d3e8807 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -243,7 +243,18 @@ static int tegra_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		  TEGRA_CEC_INT_MASK_RX_REGISTER_FULL |
 		  TEGRA_CEC_INT_MASK_RX_START_BIT_DETECTED);
 
-	cec_write(cec, TEGRA_CEC_HW_CONTROL, TEGRA_CEC_HWCTRL_TX_RX_MODE);
+	/*
+	 * TX_NAK_MODE ensures that the whole message is transmitted even
+	 * if each byte is NACKed. Without this flag the retransmit of the
+	 * messages after a NACK can be corrupt. This is a bug in the hardware.
+	 *
+	 * While less efficient, in practice you rarely transmit messages
+	 * that can be NACKed, with the exception of POLL messages which
+	 * are just one byte anyway.
+	 */
+	cec_write(cec, TEGRA_CEC_HW_CONTROL,
+		  TEGRA_CEC_HWCTRL_TX_RX_MODE |
+		  TEGRA_CEC_HWCTRL_TX_NAK_MODE);
 	return 0;
 }
 
-- 
2.53.0




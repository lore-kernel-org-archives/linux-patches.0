Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051213;
	b=aHRQUwyPRik3Lu9kglYiNxGvyqXVpG5fHyPahsyKELavv+XMK8NnqIeHyNIHg1guOpgq
	 UY3UHG+N7uOjmGvEqPfeE1UwLcTi8Spz0gxwk6v2ClpuYPmWyasBgv3srPX/V6/ZY11Cw
	 UMF+HXk7JDI5VdRVBDEN4DUgB9zj5PzvC0lWQW+iHa0DKT58Vqljr+BtUWwDsSghTGNpZ
	 h4X8DhALZpuvpa9/xllv82H77oN/ZyHKSxxrrUoJncbhwJHP6cxcT+/17YCbueGsllc61
	 SLIs2sVHuiTw1zBgIgrHnpx3MkpDng01L1n7c6ddDUDbzsrRQJDPsD8DEJM6niApR7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Akwap0ZkJDuEo+MsEZLAbFi2dBShuXhkV4Nx3wwYKxw=;
	b=yzqIAn6zXV2Zy1q83Uq0zuu9adDB161swz+8jeNZVPfso0SqWImZqsRZXVqrnL8J/SO6
	 N88FQfk1oPlDnEvehNpSLz19BuBoL/YHEJrMI25APmmV25a3RxeDlfK5Cc9bH8/czGeGP
	 1DzKKfH6GDLNhRhKISSe8OmQuXxp42sn1PMDaTaAHtXBfTEWAU/JCsRLzb7LemOYG/ixf
	 Nks055pKyCDFhn2nh6XdyOM9Qm/KxxG/T9YAMc+PLYhwpuR9dtruRLX4kRwBFjQ8gdszg
	 kbrbng7VSU5AEt03BVgPys7RM0f855QPUJBLpQMGTKHpkurffi9bg28vLSzYP/Tz/aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YreDDUHf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6106B606A336;
	Thu, 19 Nov 2026 01:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YreDDUHf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C921F000C6;
	Thu, 19 Nov 2026 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051213;
	bh=Akwap0ZkJDuEo+MsEZLAbFi2dBShuXhkV4Nx3wwYKxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YreDDUHfmXennbvVt8Ve/2IRfybHIIovBFX3NzWkpjA5AgOGYIDaZVOCWN99AapOW
	 5QOk+HUb/j03DkSDlhW7kG3hnt3bP88UK6/RuvEgMcV0hvS/UhygKkGjpvC1hTQeYD
	 OViEeFPYWGeRoXtP1fo8FA28WqMeebDo3dY+ppJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0088/2214] media: cec: tegra_cec: dont break off msg on NACK
Date: Wed, 18 Nov 2026 15:29:24 +0100
Message-ID: <20261118150013.504781542@linuxfoundation.org>
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
index 43fe54f792b65..c30df776bf8a5 100644
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




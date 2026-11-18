Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043127;
	b=Y/86Bo1oqU2ezWL8Px5Zfh2HYsp3sD23I4plYjh0NJe+dgVtxtEVrjj+D4HGUb9DD9s8
	 3VvSnTDVKxvWyl3JPRV6Qc04CYvlOuzAshfTEEsvebW+XYFL5Gim7ESYfbpMYKCU0HLhP
	 p1xvgt8Jz3DS74vR5RvBZLdR43rPaYOt5OxGNKFpqHUxQFN/lUxvxvK+M0j1B5mTS1Blq
	 UbzRnw7uZt9siRTVboBDzSxjbaB93wxSLqbklROBCEp+PMZQ9UFhRFQT0DnJVYl51yXvw
	 jMm7JqYLnBfl81JPIy2CVNqVeUzMUM5n/3seoNq7Tf2MvNTHzZOdKwcmgRwvhudOVvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mMe36E6PQ6hA5Dzzm6cSOkv6ZTuplKd22EOhmhbfGdg=;
	b=LcSNqmkW/UIsVJQ7EYB74e6a5PpcTyACR/37bZcjKLk385GD3Qz+OcrChh0KuTe/LMYg
	 /JjzmpBut+4g8ahaKC+g36A4mtc0OvtDhSV/bPl+vRDqfAKGpLjBEmVxufntMAxEkPrEh
	 tS0VCg/eGzL1AyauChYhwHWLPBU17gmbgHEUsYL3X9Qx2TWuiSPgsua5yM8xVbEmT3dP4
	 gExltqDX3hNsGNz+JH7ZGxzZN2+qWLf6H4Hw/eXQjKrS/059Y5NiN6VOOp58EBmT2ylwX
	 hZ8STuIDnQMMp1fhw35/ZpL1z4o+4RLOFZtiP9pYxe58sZya9lrXOdMXrnpr3pGkbNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oDGZRX/t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6DB606A31C;
	Wed, 18 Nov 2026 23:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDGZRX/t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DDE1F000C5;
	Wed, 18 Nov 2026 23:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043127;
	bh=mMe36E6PQ6hA5Dzzm6cSOkv6ZTuplKd22EOhmhbfGdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDGZRX/tiBbYbaeLUqkqoZQ08WV02IUn9dgSHp8r0SlqbNs8D6yB55BYR+kmewppm
	 ZPeBXTu872mRAXknxbt/pVl80ginlyaN+awsFosAMPSelauRRz3oUImt42OiQ1u3Bv
	 lW62kK5zsKxGRqUdi0Omlx7eG76uyEFf1wQHykJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0098/2857] media: cec: tegra_cec: dont break off msg on NACK
Date: Wed, 18 Nov 2026 15:18:52 +0100
Message-ID: <20261118150204.785734813@linuxfoundation.org>
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




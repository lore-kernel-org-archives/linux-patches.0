Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043651;
	b=m48Q77NOQqgvUtP2nSj4aKhXkMBG/uttiRm63//xLR7/HwnPPGZJCccD21vVeq2kcBbJ
	 tQqqyjuXVx6nL1VkdKvNIIG813rKgFNjQfnqJdH9R/ETchz0lCIOldFdgaW0LHoCF/D6u
	 H+QwUfPIsTL+74L7b48HeTWXsEC9SSAZAan7CGOaqjSkb51K1lSlaV9uRF6iSLNIlQdQT
	 DhMlFeSh9eumzrrNpD0GWimWOPsCtbh8sU90fcc9WlEH1egfB5dtE7UiePmAgC5YsftnY
	 T1R5P8SPB8fKGFT1oUwf8AJGbVFKGYiAO2TfULOczLqN08JqkxsMhnnC7c/yFpabPNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwIKPT9O0QLDK/looF4QSt16K/5kwNJjIyWlsGD2xoc=;
	b=BXZsY3wjKAYFo9r/L96VKcgFSoXqZQ4+NmmK2neIL0hLTglfwEYtTQHYs8GorZxjb6ro
	 adpnTUvsAU4u3f255bBf4JHRQrA174DlcDa6Sw2zKU4+EELa+0k6DYsmj6JRiJMTDNmp9
	 HWEykQ3KCJ10pWNeeqS1Kga7DGFEUi1QtNElWP2qt3u3xKQRENy6ZQYCmB6TO4vi0EE2h
	 DvXkAZJ6CtNOdp373SMrHNU9A6mv7aXHVT2nlA1GxLa6Uq7fgCOzuKL1AXPJky4PgIue/
	 ow13toqFcrd+ubn9rMPUOCzU1k1oTRBi+ZnFzngRnCPUv4Vx09fSPSpmOn67gp4XkpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhvP5GZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69D5606A320;
	Wed, 18 Nov 2026 23:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhvP5GZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148C21F000C4;
	Wed, 18 Nov 2026 23:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043651;
	bh=AwIKPT9O0QLDK/looF4QSt16K/5kwNJjIyWlsGD2xoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhvP5GZBIYSaa78NftCfmTLFf/NWjt1CvWhZXc3TokCBPCl2B+7FAtYJCWmSwZt2Y
	 ZG3tISvYCiu8tf/xPQqiqgcTapAwhGg5cI77TW52fG/vc/AIp/MwFuwC+axR+jg1I9
	 r3CGfp8fPOTnAjel4rQ+1S/+lnNFtbeaDXRDLgGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Adachi <seiji_adachi@yahoo.co.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0287/2857] ASoC: amd: yc: Add Lenovo ThinkPad E16 Gen 2 (21JN) to quirks
Date: Wed, 18 Nov 2026 15:22:01 +0100
Message-ID: <20261118150211.751858981@linuxfoundation.org>
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

From: Seiji Adachi <seiji_adachi@yahoo.co.jp>

[ Upstream commit 4cae4ca34992d210d115e8e891f1e88c9df5f24c ]

Signed-off-by: Seiji Adachi <seiji_adachi@yahoo.co.jp>
Link: https://patch.msgid.link/20260917131851.2122144-1-seiji_adachi@yahoo.co.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1ba845212eae0..8046030dc9576 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -234,6 +234,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21JN"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0




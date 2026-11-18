Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034353;
	b=cnmYJCMi9reGsyIT4EVYygcKNUbTTaZwCMabZQNvdYrg3UBaOoxllQ1I9IlkbjJdWF92
	 ACKhWNHgr2EjFMPQRSj78bpZ4XKnY32KLRsr7MNHIRiPk6LZLU2c05LInuCGRSk9KM5WE
	 LevGNUUEvpAzAc+mgL48hNiUyKY4J4/npzR4ev1csWChhwts74NV1H8O9ib+REbATq2qW
	 Q6KNlyNER+z2UTjupsGVMbsNEvJO16sBrhiEwoRBZI3rQ6mwOMm31C43WRJbY6j/PEJS5
	 aArdTj51CaA+hV2P13vjlyuRoBGOipedlSoxWPeWDl95h5ixzAu5nS63hXgQ8RCALcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A9ZZusBo5CLwmb40hkVwIHXM4qzdDYh3shyIhR+GVrA=;
	b=H2nNl9s8WvduMcObF0ZJLfXmAvjrA3a/BIvOk4XDfhgCk/Olf4D4MFg5O7RpKC3hzWoh
	 13YPEeySls3+CE8SWkK1JlTrYJri7gfON3sqgq0fqMZSetYeOz2/GEvRnb70R9dpg6qPb
	 bnsytlGVW+LrSl7XUXaMDmnzerYylqwW5+g15nfVDOtTpgIebd4EwxMf642SEfLPsfHkr
	 80bEvNhnAcZZYoH5v/IB43YKvpZkTF6XzPJTTKH/HIKLay0qWe//qMcwoTFu5f9c8e81q
	 KtDq26qUthmPJiXIqRzRxg4Db2fFhjkp4OLMQVJmN7ZM9d8fbeJZKT5Bl1q4GoIDTTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03Vqwzfg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A5F606A31C;
	Wed, 18 Nov 2026 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03Vqwzfg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C627D1F000C4;
	Wed, 18 Nov 2026 20:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034353;
	bh=A9ZZusBo5CLwmb40hkVwIHXM4qzdDYh3shyIhR+GVrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03VqwzfgeIYIjzeqs8EejfWA+McLbIrlePNDVQeas/WLLzLORGaTol9NM0mz1gkUR
	 1FDcLx/6rLN/JXMfrOEI68Rw1uH0jxTaqTVaS8YGWCrZtWGJj1PZITfudPDhVpcGbw
	 QekFoUi/k9txS4R/Np0zKw2n7qItowuvNfAPa7vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Ortiz <letargopausado@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0340/3318] ASoC: amd: yc: Add DMI quirk for Lenovo V15 G6 ARP
Date: Wed, 18 Nov 2026 15:16:02 +0100
Message-ID: <20261118150326.185742444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Ortiz <letargopausado@gmail.com>

[ Upstream commit d395e1b62d9694f2e4add9122f8d473eacd374aa ]

The Lenovo V15 G6 ARP (product name 83UU) uses the ACP6x PDM interface
for its internal digital microphone array. Its firmware exposes neither
the AcpDmicConnected _DSD property nor the _WOV method, so acp6x_probe()
falls through to the DMI check and returns -ENODEV, leaving
acp_yc_mach.0 unbound and no capture device registered.

Add a DMI quirk entry for this model. With it, the machine driver binds
and the DMIC capture device is created:

  acp_yc_mach acp_yc_mach.0: Enabling ACP DMIC support via DMI
  card 2: acp6x [acp6x], device 0: DMIC capture dmic-hifi-0

Capture was verified working with arecord and PipeWire.

Signed-off-by: Daniel Ortiz <letargopausado@gmail.com>
Link: https://patch.msgid.link/20260920011920.2482786-1-letargopausado@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index deef794229550..73bff3a22fe21 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -367,6 +367,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83UU"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0




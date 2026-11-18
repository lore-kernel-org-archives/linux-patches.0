Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038734;
	b=cdDtaPRSAO1XKuG2b381lPEIXCLR/HoeoFbVsTCoC4yPegRvyW2W+TOnb9dTpgYrh0iG
	 YJsCDDE3ryEt/gX8rhURtfwrHHxa69O9Y6zv7sATnVZDK8cAwXy6gALfVhPBcMgjlpwbS
	 Ds/igLujtvXM5ml44Q1OCcboNzsDWOIzwGSJFegpHjz1FMoJ/BvdfrxLITSeIOxNRYwTJ
	 MYqLEgU3vsKJPC8RKIQHmxL9z6HiXgiXJvOORB28FS0Jfrad6scDCsonPpMih4alNdf3X
	 A5qV/Qq1fpRiF0CwA8bubxzh22aF3xnUy1HPx9S0I45hLyn302VivxGSjlMZyqmaVhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=14c47VTBWAp4BcONKzrftPdQiP8RipSGYdasjvZaams=;
	b=BGVqbVPsCPumn7WLPmL+H1bD3jVB9oF9o+ss6dzkoS0op4U6VPswWApFd5aSgDNJ10er
	 +6WyORFTQJFQqPIETrfdlG33jWy1NKEMkZF4dknA8OMmIB6Huy0DJAnTqv+untdv0tckt
	 rw6ijfd6iTscGBhLlceNrRM6P98nymqvW8x4QQKHEsLLNI/506/8D8OffAT7rumZ7k4nd
	 qGlnu9eLDdi6I/Epw+Guq1qm++x9uYaMna6GeHjbIEslqPgenvNmGysAx/Lo4SQrqCQRb
	 x5GfjEx+RhXMDyf6KaePpT+OCAa4I87vzZNiEFlkCccvdhDEnHWjipj0VCpsALW1IfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1Amec6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61624606A31C;
	Wed, 18 Nov 2026 21:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1Amec6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C231F000C4;
	Wed, 18 Nov 2026 21:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038734;
	bh=14c47VTBWAp4BcONKzrftPdQiP8RipSGYdasjvZaams=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1Amec6Ia7dmRfRdfu35Me6+zPdeNX80GTqk31n/AWdIsVk6JJ8rZbKcbSGVKqciy
	 W6caQGnxeG2B0T74b01jAPJzjNnvREjli9ktpt6rlwR9zMxyXGfuBV4qIIVvoL1FI0
	 Ddt8wSYWrGzina2Qhegh4xbvhb0Qkr7E8nrIbpsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianluca Balboni <gianluca.balboni06@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1848/3318] ASoC: amd: yc: Add DMI quirk for HP OmniBook 3 Laptop 16-by0xxx
Date: Wed, 18 Nov 2026 15:41:10 +0100
Message-ID: <20261118150417.304364173@linuxfoundation.org>
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

From: Gianluca Balboni <gianluca.balboni06@gmail.com>

[ Upstream commit 1e73257dff33ff851af60d5bb00d73893a8b6dc8 ]

The HP OmniBook 3 Laptop 16-by0xxx (board ID 8EE3) has an internal DMIC
connected to the AMD ACP6x audio coprocessor. The BIOS does not set the
AcpDmicConnected _DSD property or the _WOV method, and the board is missing
from yc_acp_quirk_table[], so acp6x_probe() returns -ENODEV and no DMIC
capture device is registered.

Add a DMI quirk entry for this model to enable ACP DMIC support.

Cc: stable@vger.kernel.org
Signed-off-by: Gianluca Balboni <gianluca.balboni06@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20261031102136.24600-1-gianluca.balboni06@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: adjusted insertion context from board 8DC2 to board 8BD6 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 73bff3a22fe21..4b86d1cf3c1a2 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -675,6 +675,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8BD6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EE3"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0




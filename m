Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831067;
	b=aq4T/u0sOt56fYVPra3uQf3natWHiolthqInVqA6qwhxzcwleCpWu0plM01i4KIKd2IR
	 CgII0Ojng7D1LWJK57cmTS1kywaIbVnHa1F9lgcigW2AZ91sOmc9yK7niq38cwuEquq/h
	 W2yLxSm30gAiBQp3RINU3LkWZ3c/XxXX0NqKmQug/2258bM0twQAVkvdl4ztWgt+DiML1
	 B3kCxQfj/DuqvSUKjhsMNga5JwqtS8o1Ol51URLw4ZjDkjLH3qsRk7SemBFheiTmiXP0T
	 cMUzKFmyjJ81j5svZrBwJ1AM3jyXhKmMXWUg5hQjzngepTH9RN0BKUH6Knj1XNRPotQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rWc5HqNFz9UPIXWk0vwEPwcKkWAhEgINcqIU/FuNCyo=;
	b=cMnu2hYUGRZ3egy4sb0UUot5sbSgXkghkU47QTCqRoLi3a7wbKen3QW9ZtZwF6FdlSAD
	 x1hNpuoRE8gLlWTKjfQrg3U+r8bKRYk5iSzXEBTYXksCFETHLg5RYFFz3sMjkzPn2Gm9b
	 wjoqTFPtDRUCpAcQmkVskHEVRn3stegg/KC4DhS5kfcYHYBDQ+rQboNFA11b5g7Sz53UX
	 zHC9Fn45ihLbqC9SwyAvB1/Ir+8tx7PDlh+OxPlQ3x8HE/YWIj0/CEAETgFl5BqRi71zI
	 M2pz0UC9hK3yzMrgNxOVZVz1PIDwhLt2sFu378Kw1LdcZtQ548YfBdCdFxaOELGTRXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxjpeWpF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F991606A32C;
	Wed,  4 Nov 2026 22:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxjpeWpF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4331F000C1;
	Wed,  4 Nov 2026 22:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831066;
	bh=rWc5HqNFz9UPIXWk0vwEPwcKkWAhEgINcqIU/FuNCyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxjpeWpFfcdsp+QcaHt3NQOMsq99ovGlQUSohUdIQTAQH8qSZnqbcVbcDDlurLSPB
	 +Xov3l2lr+VpQhcrDOSYm7rsdcccPKIO+FylC26viEDYhDJjyfdEszMhrkgbbdjtsP
	 cW0IieYeEOcpYXxkYQQwx/VgdPsb/mfXyjCX2haU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Ortiz <letargopausado@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0485/1005] ASoC: amd: yc: Add DMI quirk for Lenovo V15 G6 ARP
Date: Wed,  4 Nov 2026 16:03:38 -0500
Message-ID: <20261104211057.567633241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 507c07efc069b..209ac43f9e31e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -374,6 +374,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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




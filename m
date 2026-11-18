Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034168;
	b=K+RegxjSv3Dr9dSP69tSlLin5jyWWQsluRetc0Kac6QHXOw8Gcwa7TnmpIG1eQCiveQG
	 WqQj4orhb+HwBWXXZIM1CEAD5uFypxqTfv/6kI8MNej9xa5trkqhIrB+fyhW4MrfcH/l5
	 H9meCNRfuVKIeIiCaCrC9G+rPe0x7TYY4ntNzqRPozDL7MbuEZ9HxaJI8FNrfulKnur77
	 lSU3hkRVXKVKV5DhU7S3KAiTIh7uooJabyQ1LstPRY1ZGMVZmOAEf3Ar5MW4ZR4kPMbpR
	 2lKkAnKlO6+jdy4GqPw5cvtHhLcYAyiL9MjXPZ+doGpgbvgXPBjrREzGevEwR+hSL3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oT5e66hY1iVdV6fDbA/mLqraR+ld3P4GaMzocIjl4GM=;
	b=wyAQgfe9YrYOV+8LnLBDBmtrx9e8sjx5tLVgIPMHkAahrBasqROjycnjhHfXMoNlTOi7
	 ewjROB2E8Io0dRtfkN2Ah8sAZbeLdIFEDzrAZ8Ya/1uymVq9493uXYnTG2gLTR+SRgm/3
	 JezhyJRcA/Lt8JJQaB5J+U677HRknpkuV5ncjcKkCbnXxBj31ToIrQxiQ3Rb/Jzcu9akJ
	 +6xLBrE6y1kTRXWLFtkoWgKkWT1Wv2nVlV4I2XT9ynbhXe0qKqXltn+05cr8p+huyi44U
	 3aPVu/BR9WzyFgjL4QAf2rxY/H6nwIFmm4tgm/Vjmn74MWHprbWSzDXBiarbLbWuxMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IGPEC4/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C132460A2628;
	Wed, 18 Nov 2026 20:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGPEC4/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D6C1F000C7;
	Wed, 18 Nov 2026 20:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034168;
	bh=oT5e66hY1iVdV6fDbA/mLqraR+ld3P4GaMzocIjl4GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGPEC4/KI0BPRb3Hc8B+Ad3rbfqwPhvtmse84vwX4uJFw+Csu4HWQqobEMLdDai0W
	 PBqewY+QlD3kSSRDStIUk5Yrkc18e2WhXCJa7rBxtT5lxpDN0pQpTiAmohHyFaiS0G
	 JWt0ZHgE8D9Ivty68wFYwgzxp//I/HsJbnZtRl1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0274/3318] soundwire: dmi-quirks: Disable ghost Realtek on Asus ROG Zephyrus Duo
Date: Wed, 18 Nov 2026 15:14:56 +0100
Message-ID: <20261118150323.690243182@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5b08a3afd2995e5312c4c47ffea9d21b651e8e13 ]

The Asus ROG Zephyrus Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Suggested-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260807121425.1952003-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index f738e547a1f30..768255dd12db6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -193,6 +193,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "GX651AR"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0




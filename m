Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BC41CAA6C;
	Wed, 30 Sep 2026 19:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794820; cv=none; b=HafhrpJEJP1j4EDbN8bbAeFroIJNY4j3K40/D3EDub/vZK9earfxeJdFA2T55RBEQlc3R1atH2sQFiulFA8E1AYR0Xil1JDKqbbMEJxL0GrmkNvL6OOh63OwoDZqlHV+lsZpnc6V7EvZ24pW9jLS1u8Vozr51xeBZmoHtq6eEyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794820; c=relaxed/simple;
	bh=Y+JNmhR7fvOfX/8Ul8lEYa9ZcZmd265W0AEEk55easw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7vEXY0Yn/i5pZ4ay+rqnWAj3ppVF8vzGy+bGERNnFJjl6YSDNUilUUN6p8Rki9NfQQDn6EhaOpfF4ENoMJP5RL8KopGYnmA1SrzCX++6ltg0pjq37ovnQMEfSrU1kJko0fGXZUDmun2QXAPNat7gfE2MUcN5G7CuGK4Q9l+9bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMY5vO0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMY5vO0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF2C1F00898;
	Wed, 30 Sep 2026 19:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794818;
	bh=Hstw+ONVYNTNPLGe1lEjYQK8xoVtKWY2lutl24Jp+TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMY5vO0Ft7mnpqCOy5a4Dy5FaI4CfhbtUbvQRT81QZWIv/itrYqI/7+25tOmcI8+J
	 bcuY3Q0gb3Y+suPmhfwcKMyJkaM9wyYDGYqho/afi36SaPc7rjy3I8/KpE+IyINF2w
	 +yIVaZ4kcpHBw4860xbsP/i3X7maoXGRGWnYaE50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Xianglin <1021538027@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0344/1193] ASoC: amd: yc: Add DMI quirk for HyperX OMEN Gaming Laptop 16-ap1xxx
Date: Wed, 30 Sep 2026 17:17:08 +0200
Message-ID: <20260930152441.805955256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Xianglin <1021538027@qq.com>

[ Upstream commit fe21db8c5e7c2a9815a9be54a1f5d556f905506e ]

The HyperX OMEN Gaming Laptop 16-ap1xxx (HP board 8F06) has an
internal digital microphone array attached to the AMD ACP PDM
controller, but the acp6x machine driver does not register the DMIC
sound card because this board is missing from the DMI quirk table,
leaving the internal microphone unusable.

Add a DMI quirk entry for the HP board "8F06" so the acp6x DMIC
capture card gets registered.

Signed-off-by: Lin Xianglin <1021538027@qq.com>
Link: https://patch.msgid.link/tencent_428392223C2AD3BF23E7ABAA7521FE5C0C07@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index ed99d43fe0592..429c2566add55 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -668,6 +668,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8E35"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8F06"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0




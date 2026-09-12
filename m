Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE85B386C0D;
	Sat, 12 Sep 2026 08:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203384; cv=none; b=EQR6qkX1Jrn5h+vpunERBGfXXohPl2X2jrcZmw8Bf/CdRwJxNr5wP3BzLC1nwJipYPczbqSLUCnVBzkoA4f36i98rajJdXjrzvI8+OlqrLb4ADUGyhDsHIHNeWAilj6noIAUdNu7sE1HbHctaqK4UZg0XvSK+dU0xvYWzIEvpO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203384; c=relaxed/simple;
	bh=azsz+4IOpx2tMKcw5hDWjPwgHHrCwDOQ7xoP+jVRfoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxN73QGKCCqTOY2J1eQ85zsC9pfEUuPkKisJAfuhGsR4dsq+wchBmJ5xK4eXZDrN2BMNs7Z5U6Uis0Ex/OVSeuwDKZZieQJxnElknOuq+Vg1U7ahBXpNIr5CYLAUon4aQ0S1DzI79WT2sAErkswf0OeoYYROo6aNm4xXihnYae8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGivFgyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGivFgyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894B31F000FF;
	Sat, 12 Sep 2026 08:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203382;
	bh=32BqL6cfsmn6QTO4YNo8WbQfjSgMvhz/OzWvQ8y/CQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGivFgyDl1EVdRl4PG2i/YfFJH48bCSu5Vb891GeeWTZQKelfCx8vzax0BP3m9dgK
	 fhWEM3NdKapbsh87yYalseNummWI/E/ZvrjzqR+ZE0VSJE/yTtu6K+2y1PaaeCZMX6
	 yngo3hjGZYrdaI21N/veAUScHJsU2SNXDIV6Q2bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1397/1815] mfd: cs42l43: Fix regmap defaults ordering
Date: Sat, 12 Sep 2026 08:52:27 +0200
Message-ID: <20260912065721.820820879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 9d0e4b1ae5b045a2c92b0b9a1c3b268191c219d9 ]

The regmap defaults should be ordered as binary search is done on the
array. A few registers were added in the wrong places, move these to be
in register address order.

Fixes: a6fe20d67dc7 ("mfd: cs42l43: Add support for the B variant")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260805120109.4024451-1-ckeepax@opensource.cirrus.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/cs42l43.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/cs42l43.c b/drivers/mfd/cs42l43.c
index ed6d93893de04..af7fee9ee2cf7 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -115,14 +115,14 @@ const struct reg_default cs42l43_reg_default[CS42L43_N_DEFAULTS] = {
 	{ CS42L43_DECIM_HPF_WNF_CTRL2,			0x00000001 },
 	{ CS42L43_DECIM_HPF_WNF_CTRL3,			0x00000001 },
 	{ CS42L43_DECIM_HPF_WNF_CTRL4,			0x00000001 },
-	{ CS42L43B_DECIM_HPF_WNF_CTRL5,			0x00000001 },
-	{ CS42L43B_DECIM_HPF_WNF_CTRL6,			0x00000001 },
 	{ CS42L43_DMIC_PDM_CTRL,			0x00000000 },
 	{ CS42L43_DECIM_VOL_CTRL_CH1_CH2,		0x20122012 },
 	{ CS42L43_DECIM_VOL_CTRL_CH3_CH4,		0x20122012 },
 	{ CS42L43B_DECIM_VOL_CTRL_CH1_CH2,		0x20122012 },
 	{ CS42L43B_DECIM_VOL_CTRL_CH3_CH4,		0x20122012 },
 	{ CS42L43B_DECIM_VOL_CTRL_CH5_CH6,		0x20122012 },
+	{ CS42L43B_DECIM_HPF_WNF_CTRL5,			0x00000001 },
+	{ CS42L43B_DECIM_HPF_WNF_CTRL6,			0x00000001 },
 	{ CS42L43_INTP_VOLUME_CTRL1,			0x00000180 },
 	{ CS42L43_INTP_VOLUME_CTRL2,			0x00000180 },
 	{ CS42L43_AMP1_2_VOL_RAMP,			0x00000022 },
@@ -160,10 +160,10 @@ const struct reg_default cs42l43_reg_default[CS42L43_N_DEFAULTS] = {
 	{ CS42L43_SWIRE_DP2_CH2_INPUT,			0x00000000 },
 	{ CS42L43_SWIRE_DP3_CH1_INPUT,			0x00000000 },
 	{ CS42L43_SWIRE_DP3_CH2_INPUT,			0x00000000 },
-	{ CS42L43B_SWIRE_DP3_CH3_INPUT,			0x00000000 },
-	{ CS42L43B_SWIRE_DP3_CH4_INPUT,			0x00000000 },
 	{ CS42L43_SWIRE_DP4_CH1_INPUT,			0x00000000 },
 	{ CS42L43_SWIRE_DP4_CH2_INPUT,			0x00000000 },
+	{ CS42L43B_SWIRE_DP3_CH3_INPUT,			0x00000000 },
+	{ CS42L43B_SWIRE_DP3_CH4_INPUT,			0x00000000 },
 	{ CS42L43B_SWIRE_DP4_CH3_INPUT,			0x00000000 },
 	{ CS42L43B_SWIRE_DP4_CH4_INPUT,			0x00000000 },
 	{ CS42L43_ASRC_INT1_INPUT1,			0x00000000 },
@@ -178,14 +178,10 @@ const struct reg_default cs42l43_reg_default[CS42L43_N_DEFAULTS] = {
 	{ CS42L43_ISRC1INT2_INPUT1,			0x00000000 },
 	{ CS42L43_ISRC1DEC1_INPUT1,			0x00000000 },
 	{ CS42L43_ISRC1DEC2_INPUT1,			0x00000000 },
-	{ CS42L43B_ISRC1DEC3_INPUT1,			0x00000000 },
-	{ CS42L43B_ISRC1DEC4_INPUT1,			0x00000000 },
 	{ CS42L43_ISRC2INT1_INPUT1,			0x00000000 },
 	{ CS42L43_ISRC2INT2_INPUT1,			0x00000000 },
 	{ CS42L43_ISRC2DEC1_INPUT1,			0x00000000 },
 	{ CS42L43_ISRC2DEC2_INPUT1,			0x00000000 },
-	{ CS42L43B_ISRC2DEC3_INPUT1,			0x00000000 },
-	{ CS42L43B_ISRC2DEC4_INPUT1,			0x00000000 },
 	{ CS42L43_EQ1MIX_INPUT1,			0x00800000 },
 	{ CS42L43_EQ1MIX_INPUT2,			0x00800000 },
 	{ CS42L43_EQ1MIX_INPUT3,			0x00800000 },
@@ -212,6 +208,10 @@ const struct reg_default cs42l43_reg_default[CS42L43_N_DEFAULTS] = {
 	{ CS42L43_AMP4MIX_INPUT2,			0x00800000 },
 	{ CS42L43_AMP4MIX_INPUT3,			0x00800000 },
 	{ CS42L43_AMP4MIX_INPUT4,			0x00800000 },
+	{ CS42L43B_ISRC1DEC3_INPUT1,			0x00000000 },
+	{ CS42L43B_ISRC1DEC4_INPUT1,			0x00000000 },
+	{ CS42L43B_ISRC2DEC3_INPUT1,			0x00000000 },
+	{ CS42L43B_ISRC2DEC4_INPUT1,			0x00000000 },
 	{ CS42L43_ASRC_INT_ENABLES,			0x00000100 },
 	{ CS42L43_ASRC_DEC_ENABLES,			0x00000100 },
 	{ CS42L43_PDNCNTL,				0x00000000 },
-- 
2.53.0




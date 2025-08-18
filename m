Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C661C345739;
	Mon, 18 Aug 2025 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525866; cv=none; b=nfBARXkzIvuqCAl5s8pD4F37o2z4tbmj9EydNDzkJykPLt4OvcOVXfXTDIdrBdT31eAKMMWRhXlsFaAW/6o65GauFEqeCF3Qw93WTjJDoggh8gjhlnYoeAp5tXkP3vJAJK/NKWbBbzYUFzOZ5lCi1aPdy+uwgUVexniZ3R4oV1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525866; c=relaxed/simple;
	bh=z9fInwTmPxEDvfhxnkuYOovrQsXFqxLniAIGODzz9qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRnKXRQs8d+OxZMhoNLAlBWFaT22/GX2r2DWxJ0P11Kwoa+2E2Ditn8puFq0ry0cWKQ4ZVqh2K9uTyvH64AnTHu1ZG9+qcH/3qn10uZBHgmZJ/rrpb8670cr8j1r35a6Ug0dsUoA1OZzu+6CBmc6d+0sqXTgngXzgTzpPWoeZuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8sz4+WB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8sz4+WB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36339C116C6;
	Mon, 18 Aug 2025 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525866;
	bh=z9fInwTmPxEDvfhxnkuYOovrQsXFqxLniAIGODzz9qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8sz4+WBaGQgB59fZ2QhdJLXL+gNuDSxl7ZY6i8Sq0CywGOeDhXciqv03VIFQfrp3
	 ENFAioub5E6DzdufxrLyZ4OaEgY6VFX9194j3JUUHCTVVGJcRPOFMNzcAYF1uiUr+G
	 8qllS2DyKgYXAGlWiYfuMvxv4q9fpbcm1DnwLyXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 390/570] media: i2c: vd55g1: Fix RATE macros not being expressed in bps
Date: Mon, 18 Aug 2025 14:46:17 +0200
Message-ID: <20250818124520.874774252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Mugnier <benjamin.mugnier@foss.st.com>

[ Upstream commit 5b69a84005b686365e9cacb2ca942271ed74867a ]

As a bit rate is expressed in bps, use MEGA instead of HZ_PER_MHZ.

Signed-off-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/vd55g1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/vd55g1.c b/drivers/media/i2c/vd55g1.c
index 8552ce75e1aa..d00daf89be96 100644
--- a/drivers/media/i2c/vd55g1.c
+++ b/drivers/media/i2c/vd55g1.c
@@ -129,8 +129,8 @@
 #define VD55G1_FWPATCH_REVISION_MINOR			9
 #define VD55G1_XCLK_FREQ_MIN				(6 * HZ_PER_MHZ)
 #define VD55G1_XCLK_FREQ_MAX				(27 * HZ_PER_MHZ)
-#define VD55G1_MIPI_RATE_MIN				(250 * HZ_PER_MHZ)
-#define VD55G1_MIPI_RATE_MAX				(1200 * HZ_PER_MHZ)
+#define VD55G1_MIPI_RATE_MIN				(250 * MEGA)
+#define VD55G1_MIPI_RATE_MAX				(1200 * MEGA)
 
 static const u8 patch_array[] = {
 	0x44, 0x03, 0x09, 0x02, 0xe6, 0x01, 0x42, 0x00, 0xea, 0x01, 0x42, 0x00,
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410D27D766;
	Tue, 27 May 2025 17:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368568; cv=none; b=cMJ1L6PnGf3aKTu2P3HjtCJXgEHsU+gDgrfWYATTjVBsa0BQJxIYa67y6glJ5UMfa8u+cEQiS69U/z2ck4pZ27oWpmlWJydNWG6BUJ9M6ttaryyP4eWDjKDITXISZCtFdd4uXIgGvO35qFkVD4CW8hMbDj8z9vdca4QTt/vFGVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368568; c=relaxed/simple;
	bh=2ofF2/jxi8Kl02gL+xVRHNrPwp6Jy//3jeQB3se+6hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9koRZzoQP6toRUdLPYVITjYQfYTp8QqGYU56zA2rw+hTNExXM5gfBcQXFiSDpFqZ3VjO0Q6XcsiAX5G2dlHPGP5oTCrM4Tw6u6eowdEde1fmJqY0OV25aFW8oKkzALSFwuXww2hLg21rE4FA/AyDyjUgjCX3RcUE1rArcl15/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHIx823B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHIx823B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C247C4CEE9;
	Tue, 27 May 2025 17:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368567;
	bh=2ofF2/jxi8Kl02gL+xVRHNrPwp6Jy//3jeQB3se+6hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHIx823B7D6bdf000W+q9GAEDS69Gjpa6PurcS1SfoY0EFpE2BZciWFo1OFbPaHpz
	 ZpkkEtdVkdiPnQ6NU5Q8ade9an1ClIFQzFSHMuHAFKqvJgyY/G4tGhbZi3rzjjZT0d
	 r5jIFZSqK2KKMQ7B/ghmqCvnuZhPs7xQb704eU40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 749/783] Input: xpad - add more controllers
Date: Tue, 27 May 2025 18:29:06 +0200
Message-ID: <20250527162543.632920470@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

commit f0d17942ea3edec191f1c0fc0d2cd7feca8de2f0 upstream.

Adds support for a revision of the Turtle Beach Recon Wired Controller,
the Turtle Beach Stealth Ultra, and the PowerA Wired Controller.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/20250513225950.2719387-1-vi@endrift.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -289,6 +289,8 @@ static const struct xpad_device {
 	{ 0x1038, 0x1430, "SteelSeries Stratus Duo", 0, XTYPE_XBOX360 },
 	{ 0x1038, 0x1431, "SteelSeries Stratus Duo", 0, XTYPE_XBOX360 },
 	{ 0x10f5, 0x7005, "Turtle Beach Recon Controller", 0, XTYPE_XBOXONE },
+	{ 0x10f5, 0x7008, "Turtle Beach Recon Controller", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
+	{ 0x10f5, 0x7073, "Turtle Beach Stealth Ultra Controller", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x11c9, 0x55f0, "Nacon GC-100XF", 0, XTYPE_XBOX360 },
 	{ 0x11ff, 0x0511, "PXN V900", 0, XTYPE_XBOX360 },
 	{ 0x1209, 0x2882, "Ardwiino Controller", 0, XTYPE_XBOX360 },
@@ -353,6 +355,7 @@ static const struct xpad_device {
 	{ 0x1ee9, 0x1590, "ZOTAC Gaming Zone", 0, XTYPE_XBOX360 },
 	{ 0x20d6, 0x2001, "BDA Xbox Series X Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x20d6, 0x2009, "PowerA Enhanced Wired Controller for Xbox Series X|S", 0, XTYPE_XBOXONE },
+	{ 0x20d6, 0x2064, "PowerA Wired Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x20d6, 0x281f, "PowerA Wired Controller For Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x2345, 0xe00b, "Machenike G5 Pro Controller", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5000, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },



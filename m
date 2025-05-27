Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E3913790B;
	Tue, 27 May 2025 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366114; cv=none; b=peApj0c7X30th4Hn6beXUYJesimk/DDuDH4oKNPu6zzvhqDecxjG5oHWtf8F27CafP4lC1QcM3v8IKwDag2zDiCQLFxNJ+zs1+ujz+hjsOoBuBLLM90pCgz907XPAjj+OP+UZExNJDI+AQCWrzeni6vK33zEtz9hRLgS0lPXzug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366114; c=relaxed/simple;
	bh=BauiZ9ool/deSQ4cBhmWD4wlOw5x4MYsKuROTyF2+XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFlflzA6PawtLNuwuSUHtosl85kz5KGvskyHHUqKGadMus8SSfVj9R14c9zLubXRTHuVSeoRkqhtCXXy0Y/yKsaBj3IJynO1ikKIeco1rVJC7SwHlTGN3bzzA1n1gcvCYMDfas5SPN42Dk9UK7wtGhSe4SDw3U4CCm00FyrtVFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQwJLjEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQwJLjEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C71C4CEE9;
	Tue, 27 May 2025 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366114;
	bh=BauiZ9ool/deSQ4cBhmWD4wlOw5x4MYsKuROTyF2+XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQwJLjEhQYa2k+ZnNT3N0jhZW9bNHKK74Fdu2JjdaTq1EnkHvSUqzw1x4RrZ6BAiw
	 7LqZMUSUtHq3Z0ca4pz7KWxJqMjKxLWPXTryiQGkViqo7TzwCyumLTb2xFkT7qZYIV
	 0juhNbwsctlAt/PaMGaz9GHH4dDi+hNkmXTYDK3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 595/626] Input: xpad - add more controllers
Date: Tue, 27 May 2025 18:28:08 +0200
Message-ID: <20250527162509.169277077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



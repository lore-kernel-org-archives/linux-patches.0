Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEF8509EFA;
	Wed, 30 Sep 2026 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783491; cv=none; b=dv20QTMLQFo7rLOTHjU/FblNqvmCwNJ0VmR9gZIXk+36LeOc3W9G19nd1wNWNsBhT8A3qelyd389EfVOcsF598WaxbstK0sCwAHT4yUrxvE2/Jz2/4yv7y/gPJDB6pOammY+gTsrtEB8FIZoD5LPYzSnO9pgbCLsOvDJ+hx+3XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783491; c=relaxed/simple;
	bh=WozPgXspcrUHRqxJNTgI3W1wr2v/3NiHaFLRXhnjec4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGf6UiK/Uq6ssBa7r87gCW7PCmLs7AzTpX4kYrpYsLm/EvGE1zaTN/w4Mblii5eFKlB4VirfKxVQ6NICPNlmIBWmTGT1iFP2zog4lRyK7ryfFeRolLHiBU4QzD+9BA2ZJjjw6N0mKMR5oWvNhMgW/DFEhVCEqZU1Ku+Y0eZtWZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy6v8Pnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy6v8Pnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397B81F000FF;
	Wed, 30 Sep 2026 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783486;
	bh=oCK7246BhzdO2wyMtGtc28uKNygGaoLuIV6UCNLo7vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hy6v8PnqmDiEpNMMW4fFQaN6JeUE707j3Zkhg20BK+n8zeYiUZC/sS5vcUM4UONRZ
	 VJx+2iwvgq6tDtV7FfQPqUsEH3dRsFQx1Ju1Z5yLOGIihg46+7ARWexPZJzrM9Cv9m
	 9ZIDI1oP0mCA7rcC8SKN4/2wQEeV6lswyfrVCugA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erich Sartison <byt.es@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 417/595] Input: xpad - add support for Victrix Pro BFG Controller
Date: Wed, 30 Sep 2026 17:25:10 +0200
Message-ID: <20260930152356.648730549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erich Sartison <byt.es@mailbox.org>

commit 971fa7ea8621e123feb9c8d7dc61be1c656bd945 upstream.

The controller doesn't currently work via USB-cable.

Signed-off-by: Erich Sartison <byt.es@mailbox.org>
Link: https://patch.msgid.link/20260903103137.630170-1-byt.es@mailbox.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -220,6 +220,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0213, "Afterglow Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x021f, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x0246, "Rock Candy Gamepad for Xbox One 2015", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x024c, "PDP Victrix Pro BFG Wired Controller for Xbox", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a0, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a1, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a2, "PDP Wired Controller for Xbox One - Crimson Red", 0, XTYPE_XBOXONE },



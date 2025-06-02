Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7880222D9ED;
	Mon,  2 Jun 2025 14:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874483; cv=none; b=XTllNWamE0Y2ivzgYk4MlW8AMF112FoZq9NhkLXiERa02F+cNvgGxB1VTiw4lQH9hGlXWlMfp771EEEOtzLTpiN183HBG9fAqUIhR/Kns86+f1X5TIfq/9tcTrUuC0nvoct8d5mYOtQBRxSQ43huiVu5YaTf+EF5nTGKU2X+nM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874483; c=relaxed/simple;
	bh=udiIGy0dkDxGm0R+6NnrA1b5Qx1jqiT3/Icf3T+NrjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYE8DjWSJ9PBHolXGwgOo6xm11D+XwT6VT3ZKUPzvv7wfdYMeOYb8ba3tQ39JxCOzWQtKALbv/tcATZoirTFWYQYJeIBhSH0egxkI6uUXJRZBAE5XC+y5Rd7CBOgok5Onqowq+an3v2F7CO1rIZnuMw8e3I9xPWy4BDHyRoQW7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbiJVjJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbiJVjJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF3BC4CEEB;
	Mon,  2 Jun 2025 14:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874483;
	bh=udiIGy0dkDxGm0R+6NnrA1b5Qx1jqiT3/Icf3T+NrjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbiJVjJyLvBq1WrKxdTFopnurqxXjVHEo65jdMdV8rSdROZfDZihk3KG6MBMAXsdz
	 geqLaZxdtJRY/jf1LCQ5foPv0qjKYagxh7ZchuqIUNQov4Hmusg2nOgqxoApQafVBa
	 njsRfg9ubBDMlXeybo5gPtQBDUgtfcVfCctAmqfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 037/204] Input: synaptics - enable InterTouch on Dynabook Portege X30-D
Date: Mon,  2 Jun 2025 15:46:10 +0200
Message-ID: <20250602134257.136752804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

commit 6d7ea0881000966607772451b789b5fb5766f11d upstream.

[    5.989588] psmouse serio1: synaptics: Your touchpad (PNP: TOS0213 PNP0f03) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
[    6.039923] psmouse serio1: synaptics: Touchpad model: 1, fw: 9.32, id: 0x1e2a1, caps: 0xf00223/0x840300/0x12e800/0x52d884, board id: 3322, fw id: 2658004

The board is labelled TM3322.

Present on the Toshiba / Dynabook Portege X30-D and possibly others.

Confirmed working well with psmouse.synaptics_intertouch=1 and local build.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB9597711E7933A08389FEC31DB888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -189,6 +189,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"TOS0213", /* Dynabook Portege X30-D */
 	NULL
 };
 



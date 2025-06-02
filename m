Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44E9227E97;
	Mon,  2 Jun 2025 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875174; cv=none; b=Pn1GwHfj5P9PsrDhnJpArMNxRNzta9bTabee4nLnJ2LE3DK6I4pnqs9bmnZ0P41398s1bQX7QXdbgAhGD0BCAka/ydPER4LRr77mKMdY7+dYDI7jmTBdYLGYapj4+pMr+yyWwnmxiQy0/N24fuLvROMr6Y6M0QZcqJy0OvcFf00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875174; c=relaxed/simple;
	bh=0M6R8rRLLTKFziTfEL7XEidqaJHT6EiJGso7lEdRxJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbMxxRt2myPDCss3r2bbsiqQHNDbUf5GaNa8oAsXYNIh6s3qLB8ML73cn0r06Q9+yQ190mUQxaXzwsbl5NSJb3OLvox6s7Y8Y0c8pNzEzztSdgmWe/iO6AdQbjCiFbQ/GK92jB1OvXYddVD1Y492zBmuUHSwqFU/RG/e7IUednY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LavqCHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LavqCHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33220C4CEEB;
	Mon,  2 Jun 2025 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875174;
	bh=0M6R8rRLLTKFziTfEL7XEidqaJHT6EiJGso7lEdRxJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LavqCHlvp3hsdSp4JJEI4GV/HrSdafoHAQ1J0IvHTLLGtxwegUwZWoT4qEzLQSCX
	 w3azpvev/JhydrrUDxXqUX3w8KsmF9Mlhta5bEKcRb6t2CPlvIZ19o7WRsbHZez9KJ
	 VYfhAJPHyREKw++bqgMHocuaVzSwtWJAda/2pzVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 051/270] Input: synaptics - enable InterTouch on Dynabook Portege X30-D
Date: Mon,  2 Jun 2025 15:45:36 +0200
Message-ID: <20250602134309.282564881@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -192,6 +192,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"TOS0213", /* Dynabook Portege X30-D */
 	NULL
 };
 



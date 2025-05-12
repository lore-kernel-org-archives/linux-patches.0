Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85402298CAD;
	Mon, 12 May 2025 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073298; cv=none; b=hlFS2IXEZYH71vVKvBXUcZ673oZOLXVA5MmJSXHUe4O4PVQk9rbvqBR8Vi0mVCn+0kl0Jh1vC12cED/0HNKw2u0m0OnGyBO6QOaUnNn8kdvb/jCxfycjS3zwGOgHFE3VUcutU26NvXpq+y4H92lpg969SzjZidb7tGnPEV75zmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073298; c=relaxed/simple;
	bh=58M61s/9aa6hYG4I+HCbtbUTp+/kaB4enVLE4w3Wpl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQhtBK7Qug3qgYRzvSTvS4vIVwHsH2mPodNKoe3u+VdvuvqrjqBShhTjUEKZChfr1jnf9bkSRHjNuutbmZwOVTYvMqLMgcYV69jzcE3KDJBvsBFnrH3MzydFHAcW6cTS0pS0u8nEBsXW/tG98eQcx/EFLpjW34uUZTqWAeFd++4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gj/2+10d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gj/2+10d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1DAC4CEEF;
	Mon, 12 May 2025 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073298;
	bh=58M61s/9aa6hYG4I+HCbtbUTp+/kaB4enVLE4w3Wpl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gj/2+10dinTG95eGo3rbQllOiFEKspXLMxN1/xQWDV6oWNcobHiVdMl/OlO4tTO4T
	 eMBKzNIbAXBf95CdrcyBcdEfTwOJBsTXP9WCX07Xfb10pcnqp3pKZU953y4oiK5eIg
	 ndRbx2t25DnPcT6frr2Tq3Mgf3MOzHRRiYQwxRuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 032/113] Input: synaptics - enable InterTouch on Dynabook Portege X30-D
Date: Mon, 12 May 2025 19:45:21 +0200
Message-ID: <20250512172028.981649575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -194,6 +194,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"TOS0213", /* Dynabook Portege X30-D */
 	NULL
 };
 



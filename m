Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E428228C92;
	Mon,  2 Jun 2025 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875187; cv=none; b=QaT7JxzC75rEh1xgxhYcwCbsEbk1HbG2dXw2D0XsAZ7wPr5aLigKu2vSTmwploAKxAJXnqHSQhe6g28DzPgDhr9JV7Tfn1pYc9UfJMPX+h2ExZzQskOXVHRXZ7lkvBDYitfYpEGlehwHqbgCpacZPW/xGbi50xjKdIkgFkdkJZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875187; c=relaxed/simple;
	bh=dwmos0jgyfMgtHhDp43+Yd5ueZ69Ce8WUpjFKFxS/vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDJ5IKdrXWtVrRgJ3KT+SY3f3kCDQjoEfdlGqCwN2eOd+ATwU/Db7lUketrZFaLvh3/HOeDLiGJKHTZvC1Kcf1WST6DtHdrFYlWVwP1SBbRsawjgrBQB4+Br2vbUnsKK8ZdMLuat2TL/yn6IQqZQT5Mk8HkM/7H+OUeRzN5Kgck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5Jog1Q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5Jog1Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED95C4CEEB;
	Mon,  2 Jun 2025 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875187;
	bh=dwmos0jgyfMgtHhDp43+Yd5ueZ69Ce8WUpjFKFxS/vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5Jog1Q1lpGE4/aqiIac3hIMvAiXH438BtXZP9NSKq1Zgg1Qi95wesqioq+n5AVvS
	 LN10HIUuXkNZKnIHgNMZTtaIcmO7pf0d6joaGS/pyT2Hyy+4PqTwTPuoEWRbwdatD3
	 Ggu0K3q25WUXfByaZj+e3dtpFnpYM9ElERbwLtNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Eilert <kernel.hias@eilert.tech>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 055/270] Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5
Date: Mon,  2 Jun 2025 15:45:40 +0200
Message-ID: <20250602134309.445829021@linuxfoundation.org>
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

From: Aditya Garg <gargaditya08@live.com>

commit 2abc698ac77314e0de5b33a6d96a39c5159d88e4 upstream.

Enable InterTouch mode on TUXEDO InfinityBook Pro 14 v5 by adding
"SYN1221" to the list of SMBus-enabled variants.

Add support for InterTouch on SYN1221 by adding it to the list of
SMBus-enabled variants.

Reported-by: Matthias Eilert <kernel.hias@eilert.tech>
Tested-by: Matthias Eilert <kernel.hias@eilert.tech>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB9597C033C4BC20EE2A0C4543B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -188,6 +188,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2068", /* T14 Gen 1 */
+	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */
 	"SYN3015", /* HP EliteBook 840 G2 */
 	"SYN3052", /* HP EliteBook 840 G4 */



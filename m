Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B98227EB6;
	Mon,  2 Jun 2025 14:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875181; cv=none; b=P4tz780KJCbH8DmZV2TGOWPw6qPmVUkbcZ+HB7xY3D58fdEekfDCCDOCu1pOtqTJZTZYs5SyKCcJS492xAYmIS+RcUHq33ZDrQNUkIQdZe8c8xF2uTX1WmTLx9hdGTYPuDlDL5X/GqpoM0X3xSkirA3Leu4wsiYvLmatiZuUlUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875181; c=relaxed/simple;
	bh=TVxAD8MeHEJ3KFTGC2f620wrTSOhLCpO9tAGngNJt1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZF8y25YLAqw8Vsc5O5G++vHuIvdRdcQagExulAgwH/+70vbiV5XTAwusx01ehPFmk9rxeZllZ/EAvyxBLwy7o5Eyj+ZwyLnL81kIwvSG4+Ij2A3Pp0TvBrtXdxrG6X5Gcf+2vJ6BaTrt8i5euYCbIE63IuHhkuGbFQUktIWggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKqG9lwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKqG9lwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE33C4CEEB;
	Mon,  2 Jun 2025 14:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875180;
	bh=TVxAD8MeHEJ3KFTGC2f620wrTSOhLCpO9tAGngNJt1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKqG9lwFwth6zvxhCiacuQOI7wHiKndHKxOSVKdhz6za8+DxZsFf+VYnM6XFFXyEJ
	 l6xy1OpeoV64A5D82ihNeHaXgvrF/6Nui9Ktxmv4WVpWLKCXOJPTBkTuSH663/ERYR
	 X28HsDcWp5j+3um4TcztCGE/403oOBQYw154WEnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Rathgeb <maggu2810@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 053/270] Input: synaptics - enable InterTouch on Dell Precision M3800
Date: Mon,  2 Jun 2025 15:45:38 +0200
Message-ID: <20250602134309.367413837@linuxfoundation.org>
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

commit a609cb4cc07aa9ab8f50466622814356c06f2c17 upstream.

Enable InterTouch mode on Dell Precision M3800 by adding "DLL060d" to
the list of SMBus-enabled variants.

Reported-by: Markus Rathgeb <maggu2810@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB959789DD6D574E16141E5DC4B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -163,6 +163,7 @@ static const char * const topbuttonpad_p
 
 static const char * const smbus_pnp_ids[] = {
 	/* all of the topbuttonpad_pnp_ids are valid, we just add some extras */
+	"DLL060d", /* Dell Precision M3800 */
 	"LEN0048", /* X1 Carbon 3 */
 	"LEN0046", /* X250 */
 	"LEN0049", /* Yoga 11e */



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB57296FDB;
	Mon, 12 May 2025 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073305; cv=none; b=b5mHRSIy9J+5ljjbr3DgRlilaV2n1z/+ztJ1LimaXpx38on/BivuMM8UO1Tbp4javZxZXSyImPNTDTMtA4AAmb5oPU3PRmn8WN8bB8EQFJmdCQsW6+OgwSVu1uLpaaz+ogvOCE5ecWTerrlIlDuUUxUN/yKuU5BIiw3ISXV7uM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073305; c=relaxed/simple;
	bh=QK/RuxzKeJHZqR6GlDWzkf/hLT84C3hinmM8VfpfRsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3YvB/6mhp0JyFh7xy23aDDrvn33baaIBFaLJKOSVVd6RTu53QHDF+4vLXUapi9hsiqZL/f9bnas8RAkS9KgmIfqHXSIV0+icjWxILskDotbyUvDSE5MT30w7FO17Iut4optIZZ3wRG79GgTKOUXRbL9x198YAgIOvXtRw1jJ/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lf8NmqxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lf8NmqxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E552C4CEE7;
	Mon, 12 May 2025 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073305;
	bh=QK/RuxzKeJHZqR6GlDWzkf/hLT84C3hinmM8VfpfRsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lf8NmqxO6NmIr61Lfjw8WM3Ohxlll5Kc4YGhzCcHB8A5yp84c1LBmVCG2l39LApq3
	 8s/hh0BzlPs9z+1Fikz/HaZn1SVYvEfWGMVd9nyR48hIbaGd8xoX0YRs13DqwY1fVF
	 rnTiyK0veer4TBWnpBhjW5uS9W5Yyg5w4usSZyYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Rathgeb <maggu2810@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 034/113] Input: synaptics - enable InterTouch on Dell Precision M3800
Date: Mon, 12 May 2025 19:45:23 +0200
Message-ID: <20250512172029.062348277@linuxfoundation.org>
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



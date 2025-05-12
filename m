Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A7324BCE8;
	Mon, 12 May 2025 17:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071993; cv=none; b=QPxtLZ17W5jgfATbxDodv/L+Yx5EpRuea0VPOLpmU/kcqB5QAHIQiU+CVKLnBCXrmOk+fl4qyi4CxsZ/4q0KbOv8uJonfNWviHz8r/wxGnMkjtLD+dX18I2hd39do9Epe+eSLvaM04KA7Gc7yIho+m4rW4d8BXz+NfRJ136H7Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071993; c=relaxed/simple;
	bh=fBGD4msOgkIi57PgHn0pliLMjBZDaSdw7mbgrgQjDWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWrPofZiqo2Kmkpot5EeQdhV8OgvITaxfOHg0jpWwOp0zuc8xinkuF5z7vG/5BCH3ElRk487W0KJpzFB3c74aeOgrXZMyeLtkIHbmOvjR5ZiYuYW/DKf5lbFG9ffups7KFMzlAbB5Cyz3ExDafS756xb5z/U8rFMsbJ4qYdLuvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISTB/lGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISTB/lGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C50C4CEE7;
	Mon, 12 May 2025 17:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071993;
	bh=fBGD4msOgkIi57PgHn0pliLMjBZDaSdw7mbgrgQjDWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISTB/lGp5kWtP7rF17eyktQH5H8J0KqwUYd/VvCxnJWU0lGddJL3BRIpIu2ch7bOg
	 IHuikKD7N2GZrWvcXRo3BWoy0qSfWXZvG5TpcmgrrJDC934PPNA5ag7NV01Zocpg4Q
	 DfhhdYHB7wZXaZjmYqcEZPYoI4wa2PgDlnoNorUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Rathgeb <maggu2810@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 062/197] Input: synaptics - enable InterTouch on Dell Precision M3800
Date: Mon, 12 May 2025 19:38:32 +0200
Message-ID: <20250512172046.909423551@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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



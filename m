Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93622330F;
	Mon,  2 Jun 2025 14:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874509; cv=none; b=RGyhPo5mdeabiz7RszLv0I5YBLs4IJ5TieWavM3sM6Z2oj6HuUVfMttr1RW9EuDFaMf1h+zrbbBkdV8bO5InFmO0TUAAqMcYjo1tcp4wDblS4PlAujfle33vzvDTCHdMtsgbAw0xGUkJJQ/r5YxWElTT+qgPLtdDYijcUaaOdw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874509; c=relaxed/simple;
	bh=t23FnSEZmkumq9WhAZxjeGs+q/cSN1M742TwWi7fpgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqK+Sp2mkNy3LzfzdACQdVQAfhHKFp1ECDHPtcsMe1TO8ePzby/Wh/L8p+Ax6mHiXeY+aCx0xx0jVp2odZDIVMPFkk165t6KGGR1QWWEboGlplRshHRzYbvKxJ7KG/k1v4yScxBsGnU1ycpPeIbdjp/Htp15Y4ysyZCZxz5E4Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abcC788H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abcC788H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DEAC4CEEB;
	Mon,  2 Jun 2025 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874508;
	bh=t23FnSEZmkumq9WhAZxjeGs+q/cSN1M742TwWi7fpgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abcC788H/3Ig7aWDnth6WibtM8j9jUh6soXordAPPs/2RAko1GKIaoYbugEwckby3
	 fAYXd8vPaJeilK1aALpAPIHFhEmhZ7mmgajTVmXjfjmIyDdJOkXQN6/47tZzUQWdgF
	 9H0sL0o66CMaWM3MeRG8VWUN0Io8lxhXCha+Arck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Rathgeb <maggu2810@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 039/204] Input: synaptics - enable InterTouch on Dell Precision M3800
Date: Mon,  2 Jun 2025 15:46:12 +0200
Message-ID: <20250602134257.212561718@linuxfoundation.org>
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



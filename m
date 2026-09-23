Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14AE5304A0;
	Wed, 23 Sep 2026 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173394; cv=none; b=Yd0xNag9gU5H2mW+qJ8+tS/HUWDqy0zq4cAyCKy0rI47qGoBFzl76XCpOy0QBty1qrg5fQ0CF//DuVjSb8nVgzwNfGfZqdQTDb94SG4RV4ZT2cQHfAydPmIic82r+0e4wgtVeHH6mEOtCxwaoUC60vnjDKRxglIdmelPF4XpPtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173394; c=relaxed/simple;
	bh=h1nDkl/9JsapMDzw1fjdjkNOYqGVoxwpTgCvZFlnU3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GghW6NCujwIKN2axuhIIuirukk/Xn8EcmhZxtd2+0vyk0uhUB7QMQ49z6WOdnFAmbvkdzQnPGPhCrY07P3Jzt7//BVD7d8FxJyu5POnO9O6l88bV4VSfhVF3Zhm3cExK4bPGP2Uvu/SxsiLduNc/ATt326JNacsMoFV6O7/JJtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8SXWrCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8SXWrCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277A91F000FF;
	Wed, 23 Sep 2026 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173393;
	bh=ffHEhXfdI1pyHqV+5DsH/kW2rPpzAl1u/5ia7hpDzSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8SXWrCElrFuCes2lDnBYJBg7RD2drKJqKJJxul5EYyuyrPvN869wqaVQ+wUKBK04
	 kdYKfyEkPwyNXG3G8U4DfT4w3s2pjvGlUehssZM9UpmGi5EbdVXOcUGdLGRX8V8G5U
	 zG+e+UJQCJHrtOK/vSVqGkUl4yDBx4XISkAxxxEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erich Sartison <byt.es@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 233/438] Input: xpad - add support for Victrix Pro BFG Controller
Date: Wed, 23 Sep 2026 16:04:14 +0200
Message-ID: <20260923140650.804339013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -227,6 +227,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0213, "Afterglow Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x021f, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x0246, "Rock Candy Gamepad for Xbox One 2015", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x024c, "PDP Victrix Pro BFG Wired Controller for Xbox", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a0, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a1, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a2, "PDP Wired Controller for Xbox One - Crimson Red", 0, XTYPE_XBOXONE },



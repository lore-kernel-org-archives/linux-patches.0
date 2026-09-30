Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274754E36D0;
	Wed, 30 Sep 2026 17:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788618; cv=none; b=EQwL6jYY+ckddAuVlcKO+1vexwrsWtrjnmJgTedl3HcbGo0hActACZqr4NTBlVxYMjfVX/YLjPjwupK3af1iAzJ0UxCWlKnHrEWJqgMeiFrh32dnGaG4T6pw71UDmalaJPtsIdmgkKfqhbXkyedj+B1r0+cvcsTFC8fnK6CNJbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788618; c=relaxed/simple;
	bh=zJzOqOP+AxGYbV/w2/bkATiFjm9apdSOEsQKax/DQoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9/frpD3vavc2XNlNFhI6yWP4YEshpHxFKuubY0tsXs4R48q9a33YZpU2wn6PeCxrGfctaFKiAx0abfm7Ooggtg5V703oObKiFnyp58aMvHWHFIgGqhZFiEMSw2sgK1CuFRJVlZShHiUf4FDrI49pTgur/6tsHcdvvRIOpFXYj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0pfhRxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0pfhRxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832C11F000FF;
	Wed, 30 Sep 2026 17:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788617;
	bh=LjkmusUkBMXvpY54vZ6TDBi7QilkBopL/SjViIeyGOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0pfhRxBtJfZXhDXujd8icEOZvA3nZFWxaqPS3hTPKvvs5ER95OoYlhGG2JA76UOo
	 DvgFzLhwPXM+2nkIqN+H/s2Soe0laxNSO/gQqgUaM4s4KgqKOpka/vysuPPnLbdVdv
	 Nd3DBbLTDJST2Hv6wOJHsHpdI4pVYQ8pKK1bGbKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erich Sartison <byt.es@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 161/877] Input: xpad - add support for Victrix Pro BFG Controller
Date: Wed, 30 Sep 2026 17:17:52 +0200
Message-ID: <20260930152418.194092394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -256,6 +256,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0213, "Afterglow Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x021f, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x0246, "Rock Candy Gamepad for Xbox One 2015", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x024c, "PDP Victrix Pro BFG Wired Controller for Xbox", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a0, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a1, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a2, "PDP Wired Controller for Xbox One - Crimson Red", 0, XTYPE_XBOXONE },



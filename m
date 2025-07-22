Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359A12E36E8;
	Tue, 22 Jul 2025 13:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192004; cv=none; b=TJ5W/AmK/WPZLQ4yS594sscY8khDevAuaPRg8J4sf58Sr7hH6/Hk9jkfJxS4kEw4PTJ/Qxd9GI4Lb9uJiyCvLDiNFqKq20q3mz/H/w6b4PP/cy7Xj9w2LsLANasCuGhyfwHWWw5zr/IWCDVgTse0BjNfIVcuq9HQoQqrIuWa8c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192004; c=relaxed/simple;
	bh=6+wLirOVEhbufO6Gehv186/NMpnB8+owJZqZ/pOy1Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfAbDPtJhzqssZFzLpdan1P5V9po4qDxeNHbGaa7ZlxaiZRPLDDKkYUsZRu2TDFhnKPCvma4tGhH92/JT+se8Z8HDmi6xwBS49wwtTUFf1d2NkE03p5wKXsXw2YdHBpkIACJ8XppdBzK73b7hXZtHpFdceHMpo3Oy0R8TGgqR3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avN1vvoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avN1vvoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8A0C4CEEB;
	Tue, 22 Jul 2025 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192003;
	bh=6+wLirOVEhbufO6Gehv186/NMpnB8+owJZqZ/pOy1Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avN1vvoFaStED5cXxKOruX3gjimSNHOL5hXbHjN5qx2wdVrKxBTbLrIaLY0mT4wfw
	 9zgSG3vhA0m5sbYawe9g7P5MYb7rDkQOlvrWj7yMXfB+EZ2W+GH1ZiJTJeXvGM/wRp
	 dPBH0vFbxkUMj8Za5Stw11SirKd1oWqfUk8CZTzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 08/79] Input: xpad - set correct controller type for Acer NGR200
Date: Tue, 22 Jul 2025 15:44:04 +0200
Message-ID: <20250722134328.687203296@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit bcce05041b21888f10b80ea903dcfe51a25c586e upstream.

The controller should have been set as XTYPE_XBOX360 and not XTYPE_XBOX.
Also the entry is in the wrong place. Fix it.

Reported-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Link: https://lore.kernel.org/r/20250708033126.26216-2-niltonperimneto@gmail.com
Fixes: 22c69d786ef8 ("Input: xpad - support Acer NGR 200 Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -162,12 +162,12 @@ static const struct xpad_device {
 	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", 0, XTYPE_XBOX },
 	{ 0x046d, 0xca8a, "Logitech Precision Vibration Feedback Wheel", 0, XTYPE_XBOX },
 	{ 0x046d, 0xcaa3, "Logitech DriveFx Racing Wheel", 0, XTYPE_XBOX360 },
+	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX360 },
 	{ 0x056e, 0x2004, "Elecom JC-U3613M", 0, XTYPE_XBOX360 },
 	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", 0, XTYPE_XBOX },
 	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3030, "Chic Controller", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3031, "Chic Controller", 0, XTYPE_XBOX },
-	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0020, "Logic3 Xbox GamePad", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0033, "Competition Pro Steering Wheel", 0, XTYPE_XBOX },
 	{ 0x06a3, 0x0200, "Saitek Racing Wheel", 0, XTYPE_XBOX },



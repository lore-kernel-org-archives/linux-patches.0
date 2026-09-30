Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274463E315C;
	Wed, 30 Sep 2026 19:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796209; cv=none; b=HB0i3nKp+fKOz75d/hHLFS+lEh3pfIBZn6lvN0zulVdMkAISOyHZ67m1oNa1vE/Qc1JAm1gKrwW+Mc/kLGqa5shvZfmsjyzNINqXJU3tBFqTEaH/ZGowRPL0fVCaalvTySVWcnM9hwI2AclA7j3vccYG5B2Bu3CYCqNMt1KWnKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796209; c=relaxed/simple;
	bh=AIqS5+8bDbsJfr09RMCKZepCj876cKF3E/RPIq+A74g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEnn2Vb78mP269IJmB0CLycRwbzph0IFn3OsF+iD5PNBo3jV7F+T5Dto2ANTEu894WP8d3H1A892IQ5ewkJiVn3TOraKdJZqWX6PesLGstqiT0tt9n6ZFRB0tI3Unpf0mbgUn69Neb8zIrc/i47TTityJ1j0zToZCADs1dh+yYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvYZD4Di; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvYZD4Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808F51F000FF;
	Wed, 30 Sep 2026 19:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796208;
	bh=ulZlDU5GsX0EZ+a1kMuXCIrEtz7nUfp+yggohfknCH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvYZD4DirYQz0s3IZYRYvTEUwJ85ypQTUZXMtQeVKAgSX6x1IdCUpw/IQgcEPZuYq
	 w3zv8ZyJgZYrAsKf/7YANjACWTzb0W2Je6UWyiEAOiaTEXvKu7fwcN/zrulLcVJCjX
	 DftS8Z8exah0SkJvOtuE+TPIPAqGFU4LSagW4vw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erich Sartison <byt.es@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0832/1193] Input: xpad - add support for Victrix Pro BFG Controller
Date: Wed, 30 Sep 2026 17:25:16 +0200
Message-ID: <20260930152452.727932564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF90383;
	Thu, 30 Jan 2025 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246572; cv=none; b=MdJyhUVqsl7uaKK686aPrJFDeQGFFqh1mx5W9nTg3cCy5dC4pCidyXuZ5pGvAfFWgbaxxeIWUykz5BITRqEREBCvTS2nxXBR1SegXWZpNCEIrL9obwVlfAvvoIfBPwZdc+kerdydRCZ+3analmqv42xZnR8Dg5SJOgyRjiERvgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246572; c=relaxed/simple;
	bh=YeYzWVPI6h1P7w4sYGqbdhMb9TRTa15tATa29XSKgi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBFbw26YVmIrcBr7ZgkOV5uwFSbsqB5UH7GeuRKWTOgzRZEeffJITsRZtXxZwFSXA4xW65tQB062fQJ17zDnOLzItr3iJMWfQsSsyVK6TE6VKoumabPu5SkSZiqT52v3wx9CS7F+EcOQIhYkKbnliR6/0scMNQKhb4ylhYhfAiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFIJfd7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFIJfd7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F52CC4CED2;
	Thu, 30 Jan 2025 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246571;
	bh=YeYzWVPI6h1P7w4sYGqbdhMb9TRTa15tATa29XSKgi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFIJfd7iGTkfOl+a14DRQ/xVW+0ZsdQXb8ElZePiJdBFaZhgwx6yESpbAH8/w7sFA
	 xgsyfRMNQ4oY/dMqcpm00ztAedhxWrmUtklSqju7Gb6Lza6cTqqEcDYeX9UUpqKxgO
	 R3S4ev8mOIcMyJm/XCtqp+a5/aXjIv0Y3j2v1ipk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Nobelis <nicolas@nobelis.eu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 37/43] Input: xpad - add support for Nacon Pro Compact
Date: Thu, 30 Jan 2025 14:59:44 +0100
Message-ID: <20250130133500.393601055@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

From: Nicolas Nobelis <nicolas@nobelis.eu>

commit 1bba29603a2812e7b3dbb4ec1558ecb626ee933e upstream.

Add Nacon Pro Compact to the list of supported devices. These are the
ids of the "Colorlight" variant. The buttons, sticks and vibrations
work. The decorative LEDs on the other hand do not (they stay turned
off).

Signed-off-by: Nicolas Nobelis <nicolas@nobelis.eu>
Link: https://lore.kernel.org/r/20241116182419.33833-1-nicolas@nobelis.eu
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -382,6 +382,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
+	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },



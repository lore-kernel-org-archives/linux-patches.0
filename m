Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777371BBBEB;
	Thu, 30 Jan 2025 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245708; cv=none; b=u0/eavQeqPTnhtyGBpMZzk+zkvRz9L35wZexSL2rsBOoL9Hi0M6/7W77KX71z3+VjbO7Ym9pk0zeSixHnZFN87sjM0qmC2jDb7ATrDLFYNZezUjqez5KmUFs4sOhwqQTXAMmhJCRewuksLpxjdlB+y6o0W5mKCvaosmZaD/QCIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245708; c=relaxed/simple;
	bh=qJRJaI2tfOSEqZbprPbxh9OS4nSwD5V0m3+QfOEs7/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF19vlK5VxPZFqjggINsGENI8fa63oznFhyrS0Vq+VPpSobshKd2XTQP9gUB2Zgb0ZtU5BDn0S+2AU8LqotYqU+4GeMlt0+hRrj8ZqDUmZNfuX4RUdINHAY+0T18i7vADow12n5puPjaicCAs80760m/caO6I9gbQEmkv/+0KSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4i3nSGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4i3nSGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07633C4CED2;
	Thu, 30 Jan 2025 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245708;
	bh=qJRJaI2tfOSEqZbprPbxh9OS4nSwD5V0m3+QfOEs7/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4i3nSGRDYhg0WxhHgZhdR3KXMRpt3nR9UPEsfsCk1kft2fxVe86T9dRNkYBlcFiq
	 XCjD4difnIi+BVAL5C9KshWhsk8ZIk21uSvJgHTqSWPta9Y/u+5Bagmtyvk7Ki/txn
	 1npVxoUeDlaQ1QQAf6s3Xbg0ABtYbDV46Zmgf554=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Nobelis <nicolas@nobelis.eu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 34/40] Input: xpad - add support for Nacon Pro Compact
Date: Thu, 30 Jan 2025 14:59:34 +0100
Message-ID: <20250130133501.075123552@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -383,6 +383,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
+	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },



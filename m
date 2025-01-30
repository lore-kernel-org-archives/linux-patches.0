Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC6F1BEF85;
	Thu, 30 Jan 2025 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245591; cv=none; b=HKsg0kSJAdCJDkW+MxCJfI/VD8wRPT/n5N4Yf3lemIy9IA74utrThyJzSZ2Bja5KWSuzuRrXVwd5WunxfZJ0IuXGw5XVm519BLXADAkd5TyhUh5PKGbfVbPBZr91RsAIrjbRXV3hEn6yELf64IZM9JhOzlB/CI8+tKuQqNyGnbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245591; c=relaxed/simple;
	bh=uF/QYygn9MwGoRNeMnQM6nPADORTbla2r6iOkXpIEKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PckO7NsM+Amb4j4FwYmmx6Rd6GT26BOIcMH2AADV1QL6O5KeIHE1hWG8hTZ0uqshrza4aVcem0goxsSyCN2UZNFBHLrKKiXerKZ4dHqbcUUoR6GeCvi7msfCdIfaadUvGsCBgi3JagUz7/snIWIz985S+BuoZKVRHXYV94/i+q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qq7Ym5oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qq7Ym5oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB3DC4CED2;
	Thu, 30 Jan 2025 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245591;
	bh=uF/QYygn9MwGoRNeMnQM6nPADORTbla2r6iOkXpIEKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qq7Ym5ojbBNpOmB4FHcAXhPnqeStSR4hhLl3LcwK4JYSRxCmHVudLcorfksmI0XlT
	 E6ICBcSuboj5IztlMXuUAjDlww4R3ceyQxQCVAoQXuPIywXHEF2iD0gFw3JR23Z2An
	 BQDvMSfwe6d7oXmpzRRn7VBptxZr4WD2f938CyBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Nobelis <nicolas@nobelis.eu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 19/25] Input: xpad - add support for Nacon Pro Compact
Date: Thu, 30 Jan 2025 14:59:05 +0100
Message-ID: <20250130133457.712843367@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



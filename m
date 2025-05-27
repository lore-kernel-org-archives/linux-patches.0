Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B481CD0C;
	Tue, 27 May 2025 17:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366834; cv=none; b=AeH9h9EQV4cDJEUw5fEu0anBRrs2A6HqvG5HbFlSLen9Hqalw/h4BRHl0ZvOhvxV/PFZIdZSpH4NUBwbO09SbR/btT2p+KXLpSy7ygdmwheFuZMBvmppt4tKounrPnHMI4YDZUeVXg2rkCnG1bWxIlwq5dJA/SHL+3WJbhbHy+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366834; c=relaxed/simple;
	bh=l1YHFp/hf5beRTsZT8QD1SDBttiqQvW02x0wsfn7G/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHjMQpwHxMBOm01du4NRL22BoNStSjhR9DJP7SN8wsY3f3G81gXdaHTzZ3t/HGE9hcvwBR7ZPGZ1s2DNbNSkYwpNoMa+rXuUW+jZPFtL5LFwKQzbedXFLgZFn1fBwuFHwe62YbePYWvsBbe1zcahBucK4HWguyG4bvaPHkjBYvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKtUv04+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKtUv04+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DF5C4CEE9;
	Tue, 27 May 2025 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366833;
	bh=l1YHFp/hf5beRTsZT8QD1SDBttiqQvW02x0wsfn7G/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKtUv04+xZmmdrnl83+APp44ZiOS7yW0pZFunEgwcguiIA+tXqUf/JDbGgPxRbUQv
	 l4dmFAlytHpHI+U60rZDgyXxHWCSFBcyV9LjvplpfT4uQGWRjWtPTskxz9mBHnO2GM
	 bnWdfFVPHpYHHRXlVevbseudCdvOKjtv5pCe0Nvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 192/783] leds: Kconfig: leds-st1202: Add select for required LEDS_TRIGGER_PATTERN
Date: Tue, 27 May 2025 18:19:49 +0200
Message-ID: <20250527162520.973473008@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit be2f92844d0f8cb059cb6958c6d9582d381ca68e ]

leds-st1202 requires the LED Pattern Trigger (LEDS_TRIGGER_PATTERN), which
is not selected when LED Trigger support is (LEDS_TRIGGERS).

To reproduce this:

- make menuconfig KCONFIG_CONFIG=
- select LEDS_ST1202 dependencies OF, I2C and LEDS_CLASS.
- select LEDS_ST1202
- LEDS_TRIGGERS is selected but LEDS_TRIGGER_PATTERN isn't.

The absence of LEDS_TRIGGER_PATTERN explicitly required can lead to builds
in which LEDS_ST1202 is selected while LEDS_TRIGGER_PATTERN isn't. The direct
result of that would be that /sys/class/leds/<led>/hw_pattern wouldn't be
available and there would be no way of interacting with the driver and
hardware from user space.

Add select LEDS_TRIGGER_PATTERN to Kconfig to meet the requirement and
indirectly document it as well.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Link: https://lore.kernel.org/r/CWLP123MB5473F4DF3A668F7DD057A280C5C22@CWLP123MB5473.GBRP123.PROD.OUTLOOK.COM
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 2b27d043921ce..8859e8fe292a9 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -971,6 +971,7 @@ config LEDS_ST1202
 	depends on I2C
 	depends on OF
 	select LEDS_TRIGGERS
+	select LEDS_TRIGGER_PATTERN
 	help
 	  Say Y to enable support for LEDs connected to LED1202
 	  LED driver chips accessed via the I2C bus.
-- 
2.39.5




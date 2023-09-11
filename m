Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB141170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182EDC433C8;
	Mon, 11 Sep 2023 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441977;
	bh=XS+fN4myixTlZVAcz3C+IX7aRD0gU8kfIWyfca+a7T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFpH6u2NxGFcLKkSaUM2PS0tlrlfQSruEbI4rRyLYnhKXa8zS9yOIcarvSp+8Jp+i
	 +LgGqXOIDMRF0XdBXGl+NXaEZzlwVetFBMw7OSypACj0f0BLUHBjaoVIChyRdPqbl6
	 uWkuhWcdy0D72HrCz+PbKrxlEnSXBPHuQAvZwULo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 602/739] leds: simatic-ipc-leds-gpio: Restore LEDS_CLASS dependency
Date: Mon, 11 Sep 2023 15:46:41 +0200
Message-ID: <20230911134707.914646672@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 66c5e98bbf7b7b2ba0a095ef25bf55c7230e846e ]

A recent rework accidentally lost the dependency on LEDS_CLASS, which
leads to a link error when LED support is disbled:

x86_64-linux-ld: drivers/leds/simple/simatic-ipc-leds.o: in function `simatic_ipc_leds_probe':
simatic-ipc-leds.c:(.text+0x10c): undefined reference to `devm_led_classdev_register_ext'

Add back the dependency that was there originally.

Fixes: a6c80bec3c935 ("leds: simatic-ipc-leds-gpio: Add GPIO version of Siemens driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230623152233.2246285-1-arnd@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/simple/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/simple/Kconfig b/drivers/leds/simple/Kconfig
index 44fa0f93cb3b3..02443e745ff3b 100644
--- a/drivers/leds/simple/Kconfig
+++ b/drivers/leds/simple/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config LEDS_SIEMENS_SIMATIC_IPC
 	tristate "LED driver for Siemens Simatic IPCs"
+	depends on LEDS_CLASS
 	depends on SIEMENS_SIMATIC_IPC
 	help
 	  This option enables support for the LEDs of several Industrial PCs
-- 
2.40.1




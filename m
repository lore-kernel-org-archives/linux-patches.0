Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5831863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B0AC433D2;
	Wed, 28 Dec 2022 15:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242592;
	bh=2GhQZGupkqUg6fU4c7ZVtBbEaE3HVr1BFKuG4lX8e1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+rfbP5RxrvEcYqfnHBSjgLGY5I9l4mVLVvucv0BtGYgnXKeXprgXj6NKV01RQeAm
	 hBvk5bKQ9mv755re8SQSCOTKfAHmuAuWXSjROrXNxdVCKk7I3PWJ2veFRnW4wrrsQG
	 kWmVtvHd7Asb0IDs2jdJHUKXrskFAd6N/mAahsBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0429/1073] Input: wistron_btns - disable on UML
Date: Wed, 28 Dec 2022 15:33:37 +0100
Message-Id: <20221228144339.679886594@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b2b80d9dd14cb5b70dc254bddbc4eea932694791 ]

The wistron_btns driver calls rtc_cmos_read(), which isn't
available with UML builds, so disable this driver on UML.

Prevents this build error:

ld: drivers/input/misc/wistron_btns.o: in function `poll_bios':
wistron_btns.c:(.text+0x4be): undefined reference to `rtc_cmos_read'

Fixes: 0bbadafdc49d ("um: allow disabling NO_IOMEM") # v5.14+
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20221130161604.1879-1-rdunlap@infradead.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index a18ab7358d8f..54c116e56e9d 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -330,7 +330,7 @@ config INPUT_CPCAP_PWRBUTTON
 
 config INPUT_WISTRON_BTNS
 	tristate "x86 Wistron laptop button interface"
-	depends on X86_32
+	depends on X86_32 && !UML
 	select INPUT_SPARSEKMAP
 	select NEW_LEDS
 	select LEDS_CLASS
-- 
2.35.1




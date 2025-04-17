Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9F71DF733;
	Thu, 17 Apr 2025 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915324; cv=none; b=KWAy0+MVLXh5eJoY9sqGGcglC8NRzt9fm7RDwvSyFfMLpWzSgFJ9SE5SDbT9dvn/r1PcidVSuehh1G9NWHjB4ZbsmJynj2gO19AXzvjsX/oLYUDNV64iVGHfj2faONnpWV81HIR25+EWgT3KEk/wPtCIbhola2YvUn+nOw0GcfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915324; c=relaxed/simple;
	bh=VUPNaQObw0u+UJ7yesxwRnnL0juIMVA6NXdA+1j9vFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/ykf3aIXR034sRXHkaQxRQXaSjKOftuW/6jX10qil3WJVy4bmGbeH8Yqe451t5TqSHaaHe80zo16viqAfnVM98p+NI9lihuVQVTFvn62FQEzlF24ps+UF5MXwJIhXMhrJWVkA1HkElE91ak+GhPQSCYp/8N4oJ0A9idm+ZeFkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4Z6Nbfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4Z6Nbfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF553C4CEE4;
	Thu, 17 Apr 2025 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915324;
	bh=VUPNaQObw0u+UJ7yesxwRnnL0juIMVA6NXdA+1j9vFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4Z6Nbfzn+WLDnyn1rXgmLBnk/0jugf3U/MpGHQfrDBUiyZg2rXSdQEcry4gNGAb5
	 QZ23YpPTtP3KzxjEfWjmOYl+LlnljZGNKfok4F7VV2NT3qHd6N0EeeAMEjbFUI/Uhu
	 dAGFCBvzxN6tkDtw2G8QuF0l4rrc8bj8J6+VrWg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Makarenko Oleg <oleg@makarenk.ooo>,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/393] HID: pidff: Convert infinite length from Linux API to PID standard
Date: Thu, 17 Apr 2025 19:47:50 +0200
Message-ID: <20250417175110.047549920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 37e0591fe44dce39d1ebc7a82d5b6e4dba1582eb ]

Software uses 0 as de-facto infinite lenght on Linux FF apis (SDL),
Linux doesn't actually define anythi as of now, while USB PID defines
NULL (0xffff). Most PID devices do not expect a 0-length effect and
can't interpret it as infinite. This change fixes Force Feedback for
most PID compliant devices.

As most games depend on updating the values of already playing infinite
effects, this is crucial to ensure they will actually work.

Previously, users had to rely on third-party software to do this conversion
and make their PID devices usable.

Co-developed-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 3b4ee21cd8111..5fe4422bb5bad 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -21,6 +21,7 @@
 #include "usbhid.h"
 
 #define	PID_EFFECTS_MAX		64
+#define	PID_INFINITE		0xffff
 
 /* Report usage table used to put reports into an array */
 
@@ -301,7 +302,12 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 		pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0];
 	pidff->set_effect_type->value[0] =
 		pidff->create_new_effect_type->value[0];
-	pidff->set_effect[PID_DURATION].value[0] = effect->replay.length;
+
+	/* Convert infinite length from Linux API (0)
+	   to PID standard (NULL) if needed */
+	pidff->set_effect[PID_DURATION].value[0] =
+		effect->replay.length == 0 ? PID_INFINITE : effect->replay.length;
+
 	pidff->set_effect[PID_TRIGGER_BUTTON].value[0] = effect->trigger.button;
 	pidff->set_effect[PID_TRIGGER_REPEAT_INT].value[0] =
 		effect->trigger.interval;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D706379C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FF1C433D6;
	Wed, 30 Nov 2022 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833726;
	bh=RUpOMe3BO0dzbxwVHpa6aIEvvuaeeCposlJJy+mWPjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTOjtt8fYgzNNJP4ncwq7ki7kE54Z/81YRfB4QID6AN73DQKPwsQM6ajQn1AnIY+O
	 sYg92CMAseUEp8fIYNDw+JmLOhBjWqTOeIMYwHYbIcSAO8Xvg7CvisSXiLvv2QPlk8
	 dGsGy18kHhEwyGsM5ipOc2fvKWtMPlP55vp9FoUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/206] Input: i8042 - apply probe defer to more ASUS ZenBook models
Date: Wed, 30 Nov 2022 19:23:43 +0100
Message-Id: <20221130180537.376669320@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 26c263bf1847d4dadba016a0457c4c5f446407bf ]

There are yet a few more ASUS ZenBook models that require the deferred
probe.  At least, there are different ZenBook UX325x and UX425x
models.  Let's extend the DMI matching table entries for adapting
those missing models.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20221108142027.28480-1-tiwai@suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 4b0201cf71f5..3a41ac9af2e7 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -114,18 +114,18 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* ASUS ZenBook UX425UA */
+		/* ASUS ZenBook UX425UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* ASUS ZenBook UM325UA */
+		/* ASUS ZenBook UM325UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
-- 
2.35.1




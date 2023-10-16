Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3192615AE3
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl0aBTqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5586C433C7;
	Mon, 16 Oct 2023 08:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446098;
	bh=x+v/ccWTJwEIDQzUSEFFW8UcF9CYjOObsL2yZsIEFCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dl0aBTqhuXc3lEKa9BCecjTs06uKglvwroYpYv/Xx7/qIDOnyJ6h4cGM/+OsCr6n/
	 JduCUDvJK8bbSZq/trbiaikpLFlDRpxyO9RAVYk/K2jx5hSH7iq1XA4rQNaK7NYGHI
	 yRqdSX2sG5O5zsCL8DKdDa9ImfBNPV2t32cOuDs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szilard Fabian <szfabian@bluemarch.art>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 071/102] Input: i8042 - add Fujitsu Lifebook E5411 to i8042 quirk table
Date: Mon, 16 Oct 2023 10:41:10 +0200
Message-ID: <20231016083955.593028584@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szilard Fabian <szfabian@bluemarch.art>

commit 80f39e1c27ba9e5a1ea7e68e21c569c9d8e46062 upstream.

In the initial boot stage the integrated keyboard of Fujitsu Lifebook E5411
refuses to work and it's not possible to type for example a dm-crypt
passphrase without the help of an external keyboard.

i8042.nomux kernel parameter resolves this issue but using that a PS/2
mouse is detected. This input device is unused even when the i2c-hid-acpi
kernel module is blacklisted making the integrated ELAN touchpad
(04F3:308A) not working at all.

Since the integrated touchpad is managed by the i2c_designware input
driver in the Linux kernel and you can't find a PS/2 mouse port on the
computer I think it's safe to not use the PS/2 mouse port at all.

Signed-off-by: Szilard Fabian <szfabian@bluemarch.art>
Link: https://lore.kernel.org/r/20231004011749.101789-1-szfabian@bluemarch.art
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -610,6 +610,14 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
 	{
+		/* Fujitsu Lifebook E5411 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU CLIENT COMPUTING LIMITED"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E5411"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOAUX)
+	},
+	{
 		/* Gigabyte M912 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),



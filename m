Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864683254BB;
	Tue, 25 Aug 2026 13:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665362; cv=none; b=LqUlWs6Z1eaqHEN8F8qF/ksyXTlUfkpw8ZFivBy5TVKnPQivq6kkIjHjPw7kPjMF9j4K/WQtXaKeK0bZg6obQMlUEBfrrKmljM5/qcDhpJ4TG9UDrbCUo48I5ppCwUFgvGSJ8H60rj2YXmAsdam+W6g/ivQ9x+lT41ucBV3nJso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665362; c=relaxed/simple;
	bh=vcmSumjdd5iGeSxVCEHugJIfHYoBygk+SuIKQyaaAtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6yybBJYiSPPHgRhpOOednW3IZ09IoHchqyqsm5DLqSJwaQqVAzqcPedzGh7NnLzL4RHJFnCzcePBe9J67/P4a+uP2otWOZv1SGhfEOLGzppF2VnCWiHywAIBPhLkMorBr2EG4X9Np5+SSN5qHzHhXKaqdi+d4LoEQTeRxKzNQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAxxIIiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAxxIIiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D4C1F000E9;
	Tue, 25 Aug 2026 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665361;
	bh=m0ZQNhTBG3lbsqITRoKMMBJulVojQjKRBi+HR462bNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAxxIIiqjIZdHYCAuaJQVJTWiOjSj0MTavi7mM5OxQnL8LOojXyWukjTYPNhWcAwh
	 78s5RkCdpRA3eaxzbnIWVIp+eaBZBaa5APNv/EygVIJjth9BAo6HYHFY+gzfBkBs7f
	 GLIdvT6Pmqywvxg/0XSBd+ERkN+8dv2NAFIQmqms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donglin Lyu <donglin_lyu@outlook.com>,
	Ruslan Shevchenko <adefka@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 74/94] Input: atkbd - skip deactivate for HONOR ZQC-P
Date: Tue, 25 Aug 2026 15:26:10 +0200
Message-ID: <20260825132544.775545242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donglin Lyu <DongLin_Lyu@outlook.com>

[ Upstream commit 410c44b1096789d0c40fbee706520e981dba7bc1 ]

The internal keyboard on the HONOR ZQC-P (HONOR MagicBook Pro 14 2026)
does not work after boot.

Using the kernel command line 'i8042.dumbkbd=1' makes the keyboard
functional, but the CapsLock LED does not work. Adding the
'atkbd_deactivate_fixup' quirk fixes the keyboard and CapsLock LED
natively without requiring boot parameters.

DMI: HONOR ZQC-P/ZQC-P-PCB, BIOS 1.09 03/19/2026

Fixes: 9cf6e24c9fbf ("Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID")
Signed-off-by: Donglin Lyu <donglin_lyu@outlook.com>
Tested-by: Ruslan Shevchenko <adefka@gmail.com>
Link: https://patch.msgid.link/20260801151115.52709-1-donglin_lyu@outlook.com
Cc: stable@vger.kernel.org
[dtor: keep all HONOR entries together]
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1940,22 +1940,30 @@ static const struct dmi_system_id atkbd_
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HONOR"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "FMB-P"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BCC-N"),
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
 	{
-		/* Lenovo Yoga Air 14 (83QK) */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "83QK"),
+			DMI_MATCH(DMI_SYS_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FMB-P"),
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
 	{
+		/* HONOR MagicBook Pro 14 2026 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HONOR"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "BCC-N"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZQC-P"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
+	{
+		/* Lenovo Yoga Air 14 (83QK) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83QK"),
 		},
 		.callback = atkbd_deactivate_fixup,
 	},



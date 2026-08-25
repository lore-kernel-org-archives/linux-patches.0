Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB9E417BF9;
	Tue, 25 Aug 2026 13:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665803; cv=none; b=edQBL9smMBbM6tRctaPveWOmV4z8x/2wkRQtrUutGJ9uKp/J9fsys20ZRB+snCj8Unw/0DMZWFLeR1Z2Yg4lVkXMOnet+AYpRofh888Z6MxAKjq9BFnyDCQyOZ1zDRO7AebG7wK/aBukJylNbSSv3lR1bcizjTl6Wsex8ZDyAPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665803; c=relaxed/simple;
	bh=y6xKxFFCz1l8IJdQEeAyw2Ix0IaZHp+Jjw99ozzOi+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyLtdGD2o6CD3fEdm/ev/8PDyIiqEfSN9rdT2eobSdse7/llQpi76oLV0nGF5gxXKpPZVBMpBbPPrLkIeehf7awWiP+H6qV1obuzVN7LfgfSxZg6g8MrcN3N+v8cBt3tSM9eiLWttJz5EYhdK3KYqNubvVblOmoGpCnI14GH6m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfdcp9I8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfdcp9I8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11B11F000E9;
	Tue, 25 Aug 2026 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665801;
	bh=hIzT3lbRlP09U0K8NkBpm00amzDrRS9rRwVAYj3mXSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mfdcp9I8IQ4v9HXkiHhWS85aMPiqkpkfBPdwW8b0Jo4wLWiE3hUQ3/JDfinfcq7Mu
	 XWU42dXbzfgdHu5CZLmPnzo+lQ0o+b62MZ70mjiOM9rv1GhyHCUi2LrwPf0qZMsnNY
	 a07Ajy//fnbdPiaho5+/jDUn5YB0s4Rp2z5IVeGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donglin Lyu <donglin_lyu@outlook.com>,
	Ruslan Shevchenko <adefka@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 71/87] Input: atkbd - skip deactivate for HONOR ZQC-P
Date: Tue, 25 Aug 2026 15:26:34 +0200
Message-ID: <20260825132544.598338913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1947,22 +1947,30 @@ static const struct dmi_system_id atkbd_
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



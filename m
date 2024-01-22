Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD6662805;
	Tue, 23 Jan 2024 00:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971502; cv=none; b=LW1AEt/GgrHsjYKXb1fIhVPUazMQ+mhZAy70kfhWhU1WhjAAA2mkM/CaAqm3erl9xllySJ71CHUgtKnHTXlT9fpthEVIbjPj7w022QtGeF0WyF02AIwuE9dI9ge7vXI18hlIHIIDZP8bM6LKtLm8c98fMDCaC8ElFt6yEliFGB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971502; c=relaxed/simple;
	bh=4oq6AUSfjT/I/EswXic8zITuJAk/ewOQTHPRj2ZvUhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=riIr9vw96RYG7mlDNB1JKwhoDY8rvwPpvq2Lf6d2QQaMekGV3yzk7wia7rF7b0FdkrEjQvBYGV9YeEcmo1GNPQdHGUxv8TI1RLhPkWp6NQPp9Ot2op9fMfVl7fVbQHvSypaByIaeneDwWGleCbC8sOUXVsMPWK0iAqqyps82Ubc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Coou+FCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Coou+FCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB93C433F1;
	Tue, 23 Jan 2024 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971501;
	bh=4oq6AUSfjT/I/EswXic8zITuJAk/ewOQTHPRj2ZvUhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Coou+FCSnUdq8azUCUn/BmBrpqi5/RSqEytXSnWFncGa/fi0fqJFJpXl9fK71QJvG
	 MSGAUEtVFvxtrSWXN8ryHHpJT5oGlJeehCllaTxdYZEaXS6sawcFQFhJyqcUVjlsJw
	 +kvw7kVqHIzWcUywQGl8Ui/il2R7hZlmk35XSIoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 253/417] Input: atkbd - use ab83 as id when skipping the getid command
Date: Mon, 22 Jan 2024 15:57:01 -0800
Message-ID: <20240122235800.642567765@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 58f65f9db7e0de366a5a115c2e2c0703858bba69 upstream.

Barnabás reported that the change to skip the getid command
when the controller is in translated mode on laptops caused
the Version field of his "AT Translated Set 2 keyboard"
input device to change from ab83 to abba, breaking a custom
hwdb entry for this keyboard.

Use the standard ab83 id for keyboards when getid is skipped
(rather then that getid fails) to avoid reporting a different
Version to userspace then before skipping the getid.

Fixes: 936e4d49ecbc ("Input: atkbd - skip ATKBD_CMD_GETID in translated mode")
Reported-by: Barnabás Pőcze <pobrn@protonmail.com>
Closes: https://lore.kernel.org/linux-input/W1ydwoG2fYv85Z3C3yfDOJcVpilEvGge6UGa9kZh8zI2-qkHXp7WLnl2hSkFz63j-c7WupUWI5TLL6n7Lt8DjRuU-yJBwLYWrreb1hbnd6A=@protonmail.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240116204325.7719-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -772,9 +772,9 @@ static bool atkbd_is_portable_device(voi
  * not work. So in this case simply assume a keyboard is connected to avoid
  * confusing some laptop keyboards.
  *
- * Skipping ATKBD_CMD_GETID ends up using a fake keyboard id. Using a fake id is
- * ok in translated mode, only atkbd_select_set() checks atkbd->id and in
- * translated mode that is a no-op.
+ * Skipping ATKBD_CMD_GETID ends up using a fake keyboard id. Using the standard
+ * 0xab83 id is ok in translated mode, only atkbd_select_set() checks atkbd->id
+ * and in translated mode that is a no-op.
  */
 static bool atkbd_skip_getid(struct atkbd *atkbd)
 {
@@ -792,6 +792,7 @@ static int atkbd_probe(struct atkbd *atk
 {
 	struct ps2dev *ps2dev = &atkbd->ps2dev;
 	unsigned char param[2];
+	bool skip_getid;
 
 /*
  * Some systems, where the bit-twiddling when testing the io-lines of the
@@ -813,7 +814,8 @@ static int atkbd_probe(struct atkbd *atk
  */
 
 	param[0] = param[1] = 0xa5;	/* initialize with invalid values */
-	if (atkbd_skip_getid(atkbd) || ps2_command(ps2dev, param, ATKBD_CMD_GETID)) {
+	skip_getid = atkbd_skip_getid(atkbd);
+	if (skip_getid || ps2_command(ps2dev, param, ATKBD_CMD_GETID)) {
 
 /*
  * If the get ID command was skipped or failed, we check if we can at least set
@@ -823,7 +825,7 @@ static int atkbd_probe(struct atkbd *atk
 		param[0] = 0;
 		if (ps2_command(ps2dev, param, ATKBD_CMD_SETLEDS))
 			return -1;
-		atkbd->id = 0xabba;
+		atkbd->id = skip_getid ? 0xab83 : 0xabba;
 		return 0;
 	}
 



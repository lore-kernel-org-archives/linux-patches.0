Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDE11D0492;
	Tue, 15 Oct 2024 11:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993243; cv=none; b=GgrcucT2gz+lnvbSFXe4TIOHxlORpPnOXbTxdV3yaCfaDczM3zzbVHYRlZyQXRbUZdFHeTI6oqlhXl+/BOax3dnmWECYmslAfDx6ScrLWFRfjO8iGF8Ya7yiSDSG0PGGFWjk3RcVNcWFJzS2bwi1IIDyG02yDGIhZvZ8nQswcO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993243; c=relaxed/simple;
	bh=Y/ZzbXpiFFrMc9KaJee1dc0qNO5Ti4tUH1r3kmeDdIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaJ4/E7fKzjB3Vif/fN5cdHw8ch9zsmDeOfaxnuAnzq71Zyip56lo5aJxTu6iUo11JeNQIUEPtDirixsEw7+SZTN+cT7x2kQg9DmehEg8woOTNsdKgwyyWnZUC2Qi97Bp4bH6ncll53GAe5VuQg6Ob1mVu9Fooqr+xWTxMr+ghw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kEZDEJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kEZDEJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C202BC4CEC6;
	Tue, 15 Oct 2024 11:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993243;
	bh=Y/ZzbXpiFFrMc9KaJee1dc0qNO5Ti4tUH1r3kmeDdIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kEZDEJrfL7zRvP+fG458zMQ4JEEa80GE6JJRelPmvsI4S7d18IAJzEgssGqvTb1O
	 absh3jpz+1srN2kVDxV0T5XTH5V+DcqHYgEnCyNTuly3HtJpz3zQ/eTSPEuGy+2ETH
	 +SaAtDduEbXYQx+xQyScIwdqjz3UMeURAoM1CWMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 312/691] Input: i8042 - add another board name for TUXEDO Stellaris Gen5 AMD line
Date: Tue, 15 Oct 2024 13:24:20 +0200
Message-ID: <20241015112452.720259854@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit 01eed86d50af9fab27d876fd677b86259ebe9de3 upstream.

There might be devices out in the wild where the board name is GMxXGxx
instead of GMxXGxX.

Adding both to be on the safe side.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240910094008.1601230-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1128,6 +1128,13 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxx"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887791C07F8;
	Tue, 15 Oct 2024 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997574; cv=none; b=R0mAaL27oY9h6raWrIkq1/krw/zEHL7yg5FJ+Fq4oLDKRycbztJFXp+iOVeKct4xR/TmLIfcceyMVwjW01/uEqYoB6ETUim9k9GccHtXqr31xiDdWp74CMOvtyiMhcJy+LtaA2rtwPBkNE5fchfSFuWDrRzh2d1Td2BeOwYnWQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997574; c=relaxed/simple;
	bh=CzmQVkMQujZbIc0G9d4X6M387d81ET+MysmrXJBkyVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+xSrfRgW0/pN5M8RGjXhinWVCc6hLPztPZv3NgQ3/xu7/EFKO8L1WPHgcVzTyGwM6Z3r1qDTWFxmxbePVFGLXwZl7+NlCdPjPhHtY0AW24DM5jLjMtuPoDktc3kjvnDj4PGy3y4xXA5um6qH8IapgkXyVnO+LZpn/uxXcu3vBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9KytWKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9KytWKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F88AC4CEC6;
	Tue, 15 Oct 2024 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997574;
	bh=CzmQVkMQujZbIc0G9d4X6M387d81ET+MysmrXJBkyVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9KytWKYfPVotgYbV+zoS3Icz+AUg1O1an4DnD79u1LdtD6Nfj7rtf5qcsig6EQah
	 PdJ4NqcY6SntIK6cBMyWG85mXLP2yC1w7I1NuiN60riD2dsGyz//HlCFn3bbbOL/7l
	 /rEwMdP1QKmp657OZSr5+fbVpGPdLRm0AIykhHpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 222/518] Input: i8042 - add another board name for TUXEDO Stellaris Gen5 AMD line
Date: Tue, 15 Oct 2024 14:42:06 +0200
Message-ID: <20241015123925.565148900@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1136,6 +1136,13 @@ static const struct dmi_system_id i8042_
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



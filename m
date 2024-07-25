Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9B98468;
	Thu, 25 Jul 2024 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918958; cv=none; b=maSS856o3RDAa6Ab+JC8z3Pkf0Gr/b6T8SRJsYlAwIbJiBHLBs0p92poewn/3JZ8RRJMPO7IlMh2t7hAtEpOLbiWpT2DIE/G6MFlJDZHtSxniF1rqyY42N8fTxxEKLw1F6QD2R2gZgup1TguOBLos7PmTuwMdGXA43n7LHgBvaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918958; c=relaxed/simple;
	bh=CcC7FdBhpdWZDGcV5XW/byaD1kq6o685APtb+sTtiiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cagIWnpC9aw3twtxaxDAZqFVpgPrGyW+bEwKsBPO5hpvkG3rJSqcSj+EyNltL3Jpxs09Krk8icoQeB4MPi8XVgBMtz/3Vj7hS9OrfDQrfk5RLZ2gFGI1fzvE4mFd4av7UIdIxbj0AwQMlNtJHEf4csfDf+2ELBhXwHe0t4CkCKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxzFLIMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxzFLIMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EE8C116B1;
	Thu, 25 Jul 2024 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918958;
	bh=CcC7FdBhpdWZDGcV5XW/byaD1kq6o685APtb+sTtiiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxzFLIMPy+rPDLWRWDfX0gYVFlNgPKCKsZbTF4Mvs9edBbf2VvgtpbySXdGaE2MiH
	 Vd0catArjBBPxuRiCCm2jzRgckyxL+REeR+7R62Vp/5NeWJf9uCpD1BGL7r/LaVBLP
	 EGZfnInDwiD950jY9dUrkEkRxXcPTNkC8DcFeUCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/59] Input: i8042 - add Ayaneo Kun to i8042 quirk table
Date: Thu, 25 Jul 2024 16:37:13 +0200
Message-ID: <20240725142734.136701696@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

[ Upstream commit 955af6355ddfe35140f9706a635838212a32513b ]

See the added comment for details. Also fix a typo in the
quirk's define.

Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Link: https://lore.kernel.org/r/20240531190100.3874731-1-tjakobi@math.uni-bielefeld.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-acpipnpio.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/i8042-acpipnpio.h
index 6804970d8f51a..91edfb88a218e 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -75,7 +75,7 @@ static inline void i8042_write_command(int val)
 #define SERIO_QUIRK_PROBE_DEFER		BIT(5)
 #define SERIO_QUIRK_RESET_ALWAYS	BIT(6)
 #define SERIO_QUIRK_RESET_NEVER		BIT(7)
-#define SERIO_QUIRK_DIECT		BIT(8)
+#define SERIO_QUIRK_DIRECT		BIT(8)
 #define SERIO_QUIRK_DUMBKBD		BIT(9)
 #define SERIO_QUIRK_NOLOOP		BIT(10)
 #define SERIO_QUIRK_NOTIMEOUT		BIT(11)
@@ -1235,6 +1235,20 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		/*
+		 * The Ayaneo Kun is a handheld device where some the buttons
+		 * are handled by an AT keyboard. The keyboard is usually
+		 * detected as raw, but sometimes, usually after a cold boot,
+		 * it is detected as translated. Make sure that the keyboard
+		 * is always in raw mode.
+		 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AYANEO"),
+			DMI_MATCH(DMI_BOARD_NAME, "KUN"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_DIRECT)
+	},
 	{ }
 };
 
@@ -1553,7 +1567,7 @@ static void __init i8042_check_quirks(void)
 		if (quirks & SERIO_QUIRK_RESET_NEVER)
 			i8042_reset = I8042_RESET_NEVER;
 	}
-	if (quirks & SERIO_QUIRK_DIECT)
+	if (quirks & SERIO_QUIRK_DIRECT)
 		i8042_direct = true;
 	if (quirks & SERIO_QUIRK_DUMBKBD)
 		i8042_dumbkbd = true;
-- 
2.43.0




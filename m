Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F87450903;
	Tue, 16 Jun 2026 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625884; cv=none; b=b9rI7h86P9bS5AK6URnrGlt2IhPZNkb5vNJmcKTeCsjDJ2v4z1uiRcz0+uYhCQ+fZUUoOqOVxxR/0eBmrDXL45m1rAc7aH+EBLz2iJKXERtYcJa8GCyfzDijw39+KyVvDe+vDOshS+5GHx7BYbON3BWWAWFOeRfX/goBNtS/OTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625884; c=relaxed/simple;
	bh=mLl+11nF9bgzFkNWe2/tT2aj7jNppvRBXqBnGIEdD8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WocB4EYTC7I01q/PZlBTRdypzJSvBnUOSKo1K2DVGiTUjhLMNz9V34g2pktgpL7unHJdzERrhOjPpSI5PhsKQlxxXzV7h/uKY7oNW2Crpg2G4pvr4G3qnV5lDJHOvLd8MV765A0BAQv/Btj6DyHVnZT0kx4w9/phYfYcRi6oLhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr7Oy1YT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr7Oy1YT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761341F000E9;
	Tue, 16 Jun 2026 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625883;
	bh=kuw1HL1vdT2kaj+ugcX7u9uRwSqhOxdjbiTi85LYHik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wr7Oy1YTv7+VWMqxSJbHhgvGL/bo0MdHQqoAxZGdpKPkqdWth4d5jXWo7DrhXJwiA
	 13cCDiEfibixz9gEfOErq0TH1h1QfgISPsKdF6ZbdK9053aZ7INnldVO2LYkda/NiU
	 XT7Xb4TDmLj672eEY0ETPIQcv+4FupOzN2IwhOdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfei Ren <lcrhf@outlook.com>,
	stable@kernel.org,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 226/325] Input: atkbd - skip deactivate for HONOR BCC-Ns internal keyboard
Date: Tue, 16 Jun 2026 20:30:22 +0530
Message-ID: <20260616145109.642087179@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>

commit fb402386af4cdce108ff991a796386de55439735 upstream.

After commit 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 ("Input: atkbd -
do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID"), HONOR
BCC-N, aka HONOR MagicBook 14 2026's internal keyboard stops
working. Adding the atkbd_deactivate_fixup quirk fixes it.

DMI: HONOR BCC-N/BCC-N-PCB, BIOS 1.04 04/07/2026

Fixes: 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 ("Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID")
Reported-by: Hongfei Ren <lcrhf@outlook.com>
Link: https://github.com/colorcube/Linux-on-Honor-Magicbook-14-Pro/issues/1#issuecomment-4562679891
Tested-by: Hongfei Ren <lcrhf@outlook.com>
Cc: stable@kernel.org
Signed-off-by: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Link: https://patch.msgid.link/20260605-honor-v1-1-78e05e491193@linux.dev
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1945,6 +1945,13 @@ static const struct dmi_system_id atkbd_
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BCC-N"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
 	{ }
 };
 



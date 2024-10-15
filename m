Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97401AF0A5;
	Tue, 15 Oct 2024 12:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996834; cv=none; b=E47Czc1x+UOTH9A0AzX24pk2DU1GUgNwxhbBNf7zw2KJrn206zf9ricH1tuASgm8tNjI0cEt9/CwVJFH9Uv0HWv6kv7M+ZAq0HsIDqQtIz+8VHB0MtsvxOBAR2wExL5HMB1buh4zNEByCUgqF2uKuFNeeWWO0pvcPGBzcNI4JXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996834; c=relaxed/simple;
	bh=sdDbWNUstnIpmEbxt22ra4k0fKwxlH1qmYn1FDJt4go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXnwL+6b+I6lU1FJGcMut+oWq6ODsU3Rc/nUd9lq5t2lIrTWulj5DUH/WuOrYObRm70Jn2QdwR6K83EHu5t6W/D46v22Qa9w9sfZmr6d60JzlzZhtiwLWpdMohD0rpL3SruQ4DdPluEO/8St+2QG//G6jq24Dg1DeJuabnJLrTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiyuHx3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiyuHx3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFE0C4CED0;
	Tue, 15 Oct 2024 12:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996834;
	bh=sdDbWNUstnIpmEbxt22ra4k0fKwxlH1qmYn1FDJt4go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiyuHx3TCrDBXpUm6zczGUEn8kf2qhap8OsvSHmbfDJwnW3RQEbSS9tcgyD6Y/6xH
	 o9vht3CCz8GVbSnzsEYlPEARG487bX0+Z//WmVzzXvsmNL767bflPfS0kY6oXYXmJJ
	 RG2pEfzo0x0vF0BvxDp58F0I4N/69YRx/+EEit9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/518] Input: i8042 - add Fujitsu Lifebook E756 to i8042 quirk table
Date: Tue, 15 Oct 2024 14:38:37 +0200
Message-ID: <20241015123917.346985994@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7ce7c2283fa6843ab3c2adfeb83dcc504a107858 ]

Yet another quirk entry for Fujitsu laptop.  Lifebook E756 requires
i8041.nomux for keeping the touchpad working after suspend/resume.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1229056
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240814100630.2048-1-tiwai@suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-acpipnpio.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/i8042-acpipnpio.h
index 91edfb88a218..29676ff37766 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -617,6 +617,15 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
+	{
+		/* Fujitsu Lifebook E756 */
+		/* https://bugzilla.suse.com/show_bug.cgi?id=1229056 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E756"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
 	{
 		/* Fujitsu Lifebook E5411 */
 		.matches = {
-- 
2.43.0




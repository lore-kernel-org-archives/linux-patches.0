Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC7814AD19;
	Mon, 16 Sep 2024 12:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488550; cv=none; b=kSLDVQYEIgLmtfIIlljWuxdr45fWjZEj5RJv9LSkMhCc35LIUOOWDOez2zDj+F08arsIwrmQBF3dfZAT3DAYkTGkAlKM4O+0pvLem+TfWLYh/DzKCY2qBT85fm0cbouua7p6JRgy2lXaY7tBbkH4Z2vjJkXHGeNjT3/b2bNVaA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488550; c=relaxed/simple;
	bh=tMKOq/lNvN80djiOQ/kG0kMCUvS788OgevL1dm0nIfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuP3wy2z8cLxcE9XqHJ7p2hpKdZoQ5ADxvqzjxpcTvrK+zoKc0Fp21fijt7ySnTV2u58AQ0ki35HNxFvdVIPCiYnnFMnKvDMwbBoD/EwcHCkvYFEbPSbbhDIYTtrsYXk84HcRpoLcHmNwM/lP/HxwqWRs1aKlpBoVHqwU9fB7/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vt9jDpxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vt9jDpxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90CCC4CEC4;
	Mon, 16 Sep 2024 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488550;
	bh=tMKOq/lNvN80djiOQ/kG0kMCUvS788OgevL1dm0nIfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vt9jDpxHzLAWCF3Ib4KQSKk5bbcP02/PE12cYI/tFSYvNV4JiSOUw44o58+ARqPsI
	 F6kIj5LSBsjGk+9UGc+0+RvR46knwgY6HRS4tEU00Pkr9ACEq6r4yi06a0G8MN341E
	 Lh+Oc91D7iimf0Nb3kQkdIz1RqBQSE3ZrlcODHFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 31/91] Input: i8042 - add Fujitsu Lifebook E756 to i8042 quirk table
Date: Mon, 16 Sep 2024 13:44:07 +0200
Message-ID: <20240916114225.535888493@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e9eb9554dd7b..bad238f69a7a 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -627,6 +627,15 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
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




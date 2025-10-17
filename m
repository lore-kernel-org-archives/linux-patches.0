Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA54A330B00;
	Fri, 17 Oct 2025 15:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716058; cv=none; b=N2k0CMXp3/4jfnjComI9MKj6qLL9OmTWBYQGkd0qssChNoDnJVoqd2+De15DPeOFR6qpCGGdT8bmNqMvPmDk/glHI7jjp8pLZd0SA5785ogOfypqgYprGASSWj3TPjDqMspULTyQ1KIxv4dJtN3vRG1dMOyUbyo0sXTs4zjWRDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716058; c=relaxed/simple;
	bh=UbK+71BGv92NipMnult1zG/kSSXvTYDp0CmE2JYXhq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvQ+yyTQTVaWCvxPM4dAaxmC7Naz7kNuEJ09t2l982P0zA2w6IIFP4HdlM9wPGEmD+KuqxP2FJ9QNiYbRlG/oT0m6bjk2RJipAzosoqvi9oRofAPVXpGskuz+Y78MXqH5OprB1oZ42scmkc0FeIqjyxfkzhbzfzJWMrzQCJr6ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7Ige+7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7Ige+7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6E4C4CEE7;
	Fri, 17 Oct 2025 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716057;
	bh=UbK+71BGv92NipMnult1zG/kSSXvTYDp0CmE2JYXhq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7Ige+7iyBApJn3PGZ8nWv7ugqxgTtgNc8N76vUEvhpmJ6zmfjLZQJpV/0OgEfz7D
	 /MrS4ld2i9sA9RVfTUUSHzsrEuK8VRkVIFMV6k7zYbmsfMu2slz/8JzK2i1oT5A9o/
	 uvksWxTC0+emFhy7LO5TBGpapY/R8ycZgj9A4Ld0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/276] ALSA: lx_core: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:31 +0200
Message-ID: <20251017145144.606788402@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 4ef353d546cda466fc39b7daca558d7bcec21c09 ]

Change the 'ret' variable from u16 to int to store negative error codes or
zero returned by lx_message_send_atomic().

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants. Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

No effect on runtime.

Fixes: 02bec4904508 ("ALSA: lx6464es - driver for the digigram lx6464es interface")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Link: https://patch.msgid.link/20250828081312.393148-1-rongqianfeng@vivo.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/lx6464es/lx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index b5b0d43bb8dcd..c3f2717aebf25 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -316,7 +316,7 @@ static int lx_message_send_atomic(struct lx6464es *chip, struct lx_rmh *rmh)
 /* low-level dsp access */
 int lx_dsp_get_version(struct lx6464es *chip, u32 *rdsp_version)
 {
-	u16 ret;
+	int ret;
 
 	mutex_lock(&chip->msg_lock);
 
@@ -330,10 +330,10 @@ int lx_dsp_get_version(struct lx6464es *chip, u32 *rdsp_version)
 
 int lx_dsp_get_clock_frequency(struct lx6464es *chip, u32 *rfreq)
 {
-	u16 ret = 0;
 	u32 freq_raw = 0;
 	u32 freq = 0;
 	u32 frequency = 0;
+	int ret;
 
 	mutex_lock(&chip->msg_lock);
 
-- 
2.51.0




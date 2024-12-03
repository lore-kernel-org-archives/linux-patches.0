Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5990B2AF05;
	Tue,  3 Dec 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237637; cv=none; b=XIWHEZh3/Kwd+iSNx7h/o4nqjUFGpzpfZvLY3b0tEiB39VObkQRMbXMdZgvoFhmYYA6V0JEemWg7Xom6dAz0Lz2WDCLojNzgb8/YmMU+9htTz15zOVvzMzgxM/eM3W72/LOU48XMqraHvF8yDuyBsA+NPJyXD+apwzeBGeL5Emo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237637; c=relaxed/simple;
	bh=sfQFc+DrHXobU9NNhJTJ5zBe+RbDUZj/IjNP+1xqcPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+alXNPRnZIa344BsiBUvmpAaQ9DDp/jYy/QcZVUxiBpA+/Sc4NnH/tgyX5LoHj7mIuB9xhk6e1V7aqqxfxJWAQQrcppnIVjImvpAXFgItzw+MPFFpcuDla82+Nt+rDGRYRWqbQZdQUFFxHmror+avY+Qq/PEiSW29DXdlU5V58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4I9q0Cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4I9q0Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D7EC4CECF;
	Tue,  3 Dec 2024 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237636;
	bh=sfQFc+DrHXobU9NNhJTJ5zBe+RbDUZj/IjNP+1xqcPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4I9q0Cc7tz16sGbrmgvElY5tCWdylvubI8Dorn+NmprSsdyh5GR/lpRS4JEJYpEb
	 zvh6v4xWoWygYELSPbvJ8fI7c7vmrYeupYaBeccw50Toz9Bo+uRDS/8L6hnUYw9DRC
	 H8z9MqKrYuzb+47q7YaHELfQf6y1TiJG4KrgmJHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renato Caldas <renato@calgera.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 027/817] platform/x86: ideapad-laptop: add missing Ideapad Pro 5 fn keys
Date: Tue,  3 Dec 2024 15:33:19 +0100
Message-ID: <20241203143956.709457063@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Renato Caldas <renato@calgera.com>

[ Upstream commit 36e66be874a7ea9d28fb9757629899a8449b8748 ]

The scancodes for the Mic Mute and Airplane keys on the Ideapad Pro 5
(14AHP9 at least, probably the other variants too) are different and
were not being picked up by the driver. This adds them to the keymap.

Apart from what is already supported, the remaining fn keys are
unfortunately producing windows-specific key-combos.

Signed-off-by: Renato Caldas <renato@calgera.com>
Link: https://lore.kernel.org/r/20241102183116.30142-1-renato@calgera.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index b58df617d4fda..2fde38f506508 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1159,6 +1159,9 @@ static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY,	0x27 | IDEAPAD_WMI_KEY, { KEY_HELP } },
 	/* Refresh Rate Toggle */
 	{ KE_KEY,	0x0a | IDEAPAD_WMI_KEY, { KEY_REFRESH_RATE_TOGGLE } },
+	/* Specific to some newer models */
+	{ KE_KEY,	0x3e | IDEAPAD_WMI_KEY, { KEY_MICMUTE } },
+	{ KE_KEY,	0x3f | IDEAPAD_WMI_KEY, { KEY_RFKILL } },
 
 	{ KE_END },
 };
-- 
2.43.0




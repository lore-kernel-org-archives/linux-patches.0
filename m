Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA93C4BEE2C;
	Sat, 12 Sep 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232055; cv=none; b=ERTyDtJ6pjsTJVnmJ7MI5X0tbqBF7zJLkOeWGqfZhpkyNjdi23BlkBfuumaSuM72U2KpBuawXHLtJo4p1eWyYpaSo7CXSX4HZVeqJ65FAa3HUqJfx4w75tLwpeP3Q88yrQtddn315LN8Y8JmWWppbrc/yrBHlBFKHj1H8K06UTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232055; c=relaxed/simple;
	bh=WhY6AKWjOJSJFD/y98KXQlXmE01ziliotASbJ/CbHHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/83c2cEUZtmwpRlC6fKohkvRGSZVr0QFyplW7Sq9dwryHCTAFOSvJmSlBY0VG9x4rsfaEJIYkhHk1BGpbqVbK5FQmjvBUJ/mUh+ZFaYhgtWsJdLafMMMj6gxYxJtFgweY7M8Rm9IYZou6dTAXPnP5InIZQ9AhEbey3D/I9/uV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7Uw12bd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7Uw12bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A7B1F000FF;
	Sat, 12 Sep 2026 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232053;
	bh=M+IWWTSn0fUaQl6KrsK/Crk+6lqngaNI4j0GA0bpw28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7Uw12bdSPLpeWvpXVotadcs0jjD/35W4mAMCF5RTvi5GXiFdlCjUpa2+iDE3XGkH
	 Us1qJ8K00C4bQmpC6jiQ1wBhvdMYwQMruNNshG4ZwLYPZOfDs5R0iOBvRcCJAlV1Ov
	 V8N++W8dZdfj0e3aDXaVunUcr6Zjf5n3QUE6PwdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1124/1191] ALSA: control: Make snd_ctl_find_id() argument const
Date: Sat, 12 Sep 2026 09:04:12 +0200
Message-ID: <20260912065613.398570635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6723670a483501497dc339ae37676525245a913a ]

The id object passed to snd_ctl_find_id() is only read, and we can
mark it with const gracefully.

Link: https://lore.kernel.org/r/20230718141304.1032-9-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 74e3b979ce8b ("ALSA: control: Don't add invalid kcontrols to LED layer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/control.h | 2 +-
 sound/core/control.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index cc3dcc6cfb0f2..e61b749bf2041 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -141,7 +141,7 @@ int snd_ctl_rename_id(struct snd_card * card, struct snd_ctl_elem_id *src_id, st
 void snd_ctl_rename(struct snd_card *card, struct snd_kcontrol *kctl, const char *name);
 int snd_ctl_activate_id(struct snd_card *card, struct snd_ctl_elem_id *id, int active);
 struct snd_kcontrol *snd_ctl_find_numid(struct snd_card * card, unsigned int numid);
-struct snd_kcontrol *snd_ctl_find_id(struct snd_card * card, struct snd_ctl_elem_id *id);
+struct snd_kcontrol *snd_ctl_find_id(struct snd_card *card, const struct snd_ctl_elem_id *id);
 
 int snd_ctl_create(struct snd_card *card);
 
diff --git a/sound/core/control.c b/sound/core/control.c
index 41b178ac25d87..54b9aa5dd9865 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -829,7 +829,7 @@ EXPORT_SYMBOL(snd_ctl_find_numid);
  *
  */
 struct snd_kcontrol *snd_ctl_find_id(struct snd_card *card,
-				     struct snd_ctl_elem_id *id)
+				     const struct snd_ctl_elem_id *id)
 {
 	struct snd_kcontrol *kctl;
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CA4156237;
	Mon,  6 Jan 2025 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177271; cv=none; b=KL7iqSeOYeKREpHHzgA1SnViPnUZATkJvhDMhsdfOlRButuztZZ27jBv379XEgTLxMyt8TIM6XUCKZogCJ1tr+01lqMDsAIeCK6m9HtJz0lZBChQl5q0ePrysK4Qm0EY37MRg05nKsW0oCtWx7Ob1v6+rpdI1ASJ/TSa5u4VEbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177271; c=relaxed/simple;
	bh=AiKBp6GOqBO7hWjkPyqbgMkju0dQc8o9rFaQ59u9uVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naR7sjqesywMsdxnFzzdq4mWQ8g18j6/mz6rdMINksmQY2LMgro8NLaC8z7+UCQV9VA5qu+OC6nBzY7jVIB25urHekbIo4k6QdJGj2V9gfjr7KQlFDKdlEOVDTNYbx15GuHod+ywh+NZEc87ZuUVTRU8IqxWr/Pfw4JzMVVxfzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phkQmZt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phkQmZt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F66FC4CEE1;
	Mon,  6 Jan 2025 15:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177270;
	bh=AiKBp6GOqBO7hWjkPyqbgMkju0dQc8o9rFaQ59u9uVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phkQmZt9JfR/uE37z56C+VZ8ZFOR3mnmENzboQvoHzs7pkdahH3+xQse3ziiiPdcY
	 RUTsRQ+xONWTASQJ+1nOuceEHfHUiNAR7B6iKO/mThdKEqbTXH8HMF8SiwmUDtKNnU
	 Sg8hreVy9dEwZ6aphm5bzaATE/ZGHPAP56Jq0/I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/222] ALSA: ump: Indicate the inactive group in legacy substream names
Date: Mon,  6 Jan 2025 16:14:55 +0100
Message-ID: <20250106151154.041609781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit e29e504e7890b9ee438ca6370d0180d607c473f9 ]

Since the legacy rawmidi has no proper way to know the inactive group,
indicate it in the rawmidi substream names with "[Inactive]" suffix
when the corresponding UMP group is inactive.

Link: https://patch.msgid.link/20241129094546.32119-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 5a4a7d0b7cca..bb94f119869a 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1245,8 +1245,9 @@ static void fill_substream_names(struct snd_ump_endpoint *ump,
 		name = ump->groups[idx].name;
 		if (!*name)
 			name = ump->info.name;
-		snprintf(s->name, sizeof(s->name), "Group %d (%.16s)",
-			 idx + 1, name);
+		snprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
+			 idx + 1, name,
+			 ump->groups[idx].active ? "" : " [Inactive]");
 	}
 }
 
-- 
2.39.5




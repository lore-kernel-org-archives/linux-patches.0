Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B32E2AE68;
	Mon, 30 Dec 2024 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574263; cv=none; b=WeS3WhdnYwdiGkoszZuudGYVddYiImh+LS+25oZ78/OSmIxuCp30XAuYnXsnYFZimXyIJg/R7IdB/VNF9taS5nRW3E6MawhqFFUTdPuWTlXdMymQ54ygBjh0Rf5VxMW0xGQeUQlotu93e+8oE4X/horF6tydhlf0Meqzs44s7Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574263; c=relaxed/simple;
	bh=gjPXEhzzvGound2ZBlEFhXWSo4591PRVXLoBRW9i/iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUlZkwucL2xP0B+5kLkfMIVwsWT4BIwSxqA+9f56v9p9QYgFIpzmXJ9CJAMmp1Md4Be66O0qsVQxHfzsH4Q8HnEuNdsK5qIDGTaNzZDD0DxlfiMWZa/DWJ+uD+dVUTi8gooIfam5+TCgBQlSzfSf1QNe/lG7liCyoJmK4P+TW1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QK9dsKXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QK9dsKXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA720C4CED0;
	Mon, 30 Dec 2024 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574263;
	bh=gjPXEhzzvGound2ZBlEFhXWSo4591PRVXLoBRW9i/iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QK9dsKXl2MixKgRGjdZkFDH+kugzMl5Cmgm9JVDpG23TAOL3TT7f7+zyTwHS8XdO/
	 pqhIWXF/rtGa5YgEROZLuMid4eJizPoIukg17xwhrX4Ptv+TEKIUUe8NY/uX8m3wuQ
	 seJzjQTbcd9kbfcOge7kuvix5Iy24sj0LlNUthCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/114] ALSA: ump: Indicate the inactive group in legacy substream names
Date: Mon, 30 Dec 2024 16:42:52 +0100
Message-ID: <20241230154220.192385023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0ade67d6b089..55d5d8af5e44 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1256,8 +1256,9 @@ static void fill_substream_names(struct snd_ump_endpoint *ump,
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




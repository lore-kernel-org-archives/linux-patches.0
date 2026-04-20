Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B993B27F9;
	Mon, 20 Apr 2026 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691003; cv=none; b=sraMoxpxjxhWHP6oK8oKMirr+zDnpow1KrjRnz4crpwRw/OM6tf9pRqv1THrmAbbVtphb5a2tBNTLfFHin2/DkDvQ1KYiOhhnRbtKCiRdl9IZaX4khRnKWzZa5jecymS+vxLNdepR8uABfN9HmlF9PDipFwLZdtvn1YB4GHsPVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691003; c=relaxed/simple;
	bh=dnNRDrlfNShuJ8+x1ksVhZY4AYPz9Sur/UkjMGNGB9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kX0LZMLnnimxaNDlk2W8lvT+dnpqhrlalGkzATvNKmlESZ+dPDuzwnhE9+RgL/2MULzziHBvwBAVWJUDQ0qM0102RZ3K10nbdqxZL7LCK0HzdDf0vnzJthn2JAqjk468oUjlUmWhavE82qJUyW5fdiKBXg6Y4qROjLZdpYIQ1Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNYMym02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNYMym02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323C9C2BCB8;
	Mon, 20 Apr 2026 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691003;
	bh=dnNRDrlfNShuJ8+x1ksVhZY4AYPz9Sur/UkjMGNGB9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNYMym02YflqSnEDmKuYP3yZ3cUAxlKll7j5OSYcwSykNhVceMMdHU02F2zMFplu5
	 fn05Ab/z96SD6OVh/b6lOiMg7pEk6pZLu/iIOM/Dh983Kq2HGCs+HGVG0doyC+vcbw
	 KtyZWljafziR0gDfAJkIEf63TpybI/Lj8TD9oQHGkWx7HeJ0W7YSKFZrQa3jMTvzkK
	 0z2MmvQd5eEAC/DyHlqCWWfySBJnG/GKw/DQ7+C/xlCrWQShAPJR61aTXDgIASgX3e
	 KJvACRIgjHbaKcjuXcAGLXgDn//AC5zA56LvyaTuYlP7cIzPlpWPd39nlgX78yJBEO
	 a7jl/NCcwIVCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Dustin L. Howett" <dustin@howett.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: add quirk for Framework F111:000F
Date: Mon, 20 Apr 2026 09:08:23 -0400
Message-ID: <20260420131539.986432-37-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: "Dustin L. Howett" <dustin@howett.net>

[ Upstream commit bac1e57adf08c9ee33e95fb09cd032f330294e70 ]

Similar to commit 7b509910b3ad ("ALSA hda/realtek: Add quirk for
Framework F111:000C") and previous quirks for Framework systems with
Realtek codecs.

000F is another new platform with an ALC285 which needs the same quirk.

Signed-off-by: Dustin L. Howett <dustin@howett.net>
Link: https://patch.msgid.link/20260327-framework-alsa-000f-v1-1-74013aba1c00@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0c975005793e7..e7f7b148b40e5 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7555,6 +7555,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000f, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
-- 
2.53.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14D85A6E68;
	Mon, 31 Aug 2026 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184345; cv=none; b=Mqoj9d/XGq0oqVKFDf/DIVU7HVhXPwkmtpL3UMTnmYdHtnPgyynf9MqxaeJJ6rJK7V5zUt7eOl/ojSMr2DtEG65TZGseYnVprl5atiqF0W9PzzM4CruJnefM/7d8cGqaLhIXKNc/nzKhnXKEjIGiGMPAWPonO+LDuuIPGUosVaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184345; c=relaxed/simple;
	bh=MPtuHUmTOV12FzIgkWPyUZ4QGphBAbikJK35KVvShK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFnA1ENjVAEFY0jIJQk1vQp/RFbF4zKPwfSP3vIuYgOuu11YHHyV6c3kSnxObC1P8Z+gAUfPY6ge8WWeyvEm3xrU2uwZxhkRGCoqCRZgToj0oZCOxTFngm7Mkm8VfIA1Szqf1uauncsBJfdeqe3TtQ2+c98sQEIZsGZsldYxhj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGBqnHZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGBqnHZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFBE1F00ACF;
	Mon, 31 Aug 2026 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184343;
	bh=9CocnIRXRS7u2nUnljWPBOSgtxPjYYqHXkzuJp4StY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGBqnHZ1WKmBQT/Voh5gMCR5QXllJ9SP74rRxMauGHKWdJsQzhTa/uXNUvaI0Ika2
	 44KlSv6C4obGZElu25F3MmQKkOEoVLoeoF87GE14nRv5nSd7o5NUgQ3jvI4Hr4vWpD
	 rnfZFCrqBpXt8xeERxNnMqB2jmwcC7dQfjJbT11cO2TXp25+UtqL3zdXEzAITXrMHR
	 XWy7/Y7lX/dIDL4OLh41Tvm4BK9SLh7KB396rLyoEVNlHB4+SjeSrd0ZHJ/3cYZFRH
	 sSlwKGlQuOHzxDGwqL4/JsNhv33fS1OxLm9UMaAk6L392M9XNNg/p0KDnheFWzvL92
	 XxvleN+9BmvUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrei Faleichyk <andrei.faleichyk@noogadev.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP
Date: Mon, 31 Aug 2026 09:31:06 -0400
Message-ID: <20260831133314.4125787-638-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrei Faleichyk <andrei.faleichyk@noogadev.com>

[ Upstream commit 3580bc53520ce4efc94ece5886ad3670b93667ba ]

The internal microphone on ASUS VivoBook X509DAP (subsystem ID
0x1043:0x197e) is not detected without a quirk entry. Add
ALC256_FIXUP_ASUS_MIC_NO_PRESENCE to fix the issue.

Signed-off-by: Andrei Faleichyk <andrei.faleichyk@noogadev.com>
Link: https://patch.msgid.link/20260603213313.6298-1-andrei.faleichyk@noogadev.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background search finished. A repo-wide `git log -S '0x197e'` turned
up nothing related to this HDA quirk (only unrelated hits in other
subsystems), and there are no prior commits from Andrei Faleichyk in
`sound/hda/` in this tree — consistent with this being a new, standalone
quirk addition.

**Verdict for Linux 6.18.44:** backport **YES**. One-line
`SND_PCI_QUIRK` for ASUS VivoBook X509DAP (`0x1043:0x197e`) using the
existing `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE` fixup; applies cleanly and
matches the pattern of other ASUS VivoBook mic quirks already in stable.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 7a047bdbae462..0c23eb601ecaa 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7116,6 +7116,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1970, "ASUS UX550VE", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x197e, "ASUS VivoBook X509DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0


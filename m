Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567A03FFAB5;
	Thu, 12 Mar 2026 20:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346396; cv=none; b=K3Bqfihdl7gmgkonPzGsbJqAfPauwYPWqfD+ESsX8ZIkOoyE657SOqON2Gu3+e1QlmqRJl1NNkLnvWihyviuTZs90jWB1eG8V226bKNFO1bI+AmRsuMCl/1Dyay2rQ7SAsWqaUFICw6ejXgWRFA9hpbH/tDLfn6321fF+5JH1IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346396; c=relaxed/simple;
	bh=92oQ9cLl8LvAhNbQ3AsiMKdtX0sC6xEHhh7JEqGEnKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd2Jw2rA0h8B2jRDTV2RgVHqvVxDq3cY213GVPpFFkt5HtTMThB9STX2TnNXwteKahKWc9DZRvou+NLC25R7EH2VAj4ZxCMheH5w1p9vSURqQW/u9pd/AyCNs54LMgZdXX3ldJgMKnq5b9RXFrd8Eiv95dJQR20R1p702xfZkaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmWVHHiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmWVHHiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37B8C4CEF7;
	Thu, 12 Mar 2026 20:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346396;
	bh=92oQ9cLl8LvAhNbQ3AsiMKdtX0sC6xEHhh7JEqGEnKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmWVHHiqHDKPE1HqqrDHjHxpTiDoKnRckl3ZgwrEOIOUpUqPaxjl+6Oq6yGIQjCwV
	 UCkA77f9gulDVcSkp/qiGDtcIkU2KbXjgH6Ba2iy9LRwFDz9RnfWunr5CxeA8LZkBU
	 5AImez3xlnEP9XE766hReES+3dFV3mvlakREq8QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/265] ALSA: hda: cs35l56: Fix signedness error in cs35l56_hda_posture_put()
Date: Thu, 12 Mar 2026 21:06:59 +0100
Message-ID: <20260312201019.349179619@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 003ce8c9b2ca28fbb4860651e76fb1c9a91f2ea1 ]

In cs35l56_hda_posture_put() assign ucontrol->value.integer.value[0] to
a long instead of an unsigned long. ucontrol->value.integer.value[0] is
a long.

This fixes the sparse warning:

sound/hda/codecs/side-codecs/cs35l56_hda.c:256:20: warning: unsigned value
that used to be signed checked against zero?
sound/hda/codecs/side-codecs/cs35l56_hda.c:252:29: signed value source

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 73cfbfa9caea8 ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Link: https://patch.msgid.link/20260226111728.1700431-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 52d2ddf248323..2a936f43fad2d 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -250,7 +250,7 @@ static int cs35l56_hda_posture_put(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_value *ucontrol)
 {
 	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
-	unsigned long pos = ucontrol->value.integer.value[0];
+	long pos = ucontrol->value.integer.value[0];
 	bool changed;
 	int ret;
 
-- 
2.51.0




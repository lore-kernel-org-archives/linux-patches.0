Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FB02E634;
	Wed,  5 Feb 2025 14:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764429; cv=none; b=iGfuKgv50i6vmOScvYcGxW4wq9Dg0CzRjd2n7b9NDKCENGLyQ0fEBD7H5spE4LtMqdq1WPmEOeE2SAaLR0KM/FDJUo+dyrmCxbzJ/YD+mRQ1ZEq4ms8bpvUIS/dzuWPDXnFJTFYGnPUAGlQBXLOgAH1X4PZFkauR8Ac9uHnlWfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764429; c=relaxed/simple;
	bh=Jo5R8emoLK/aVjUoMCS+1EdS+puDkAgrsLfgQegyDfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQEHp/cO+nG3eTu7APpluY6jliOjRSx3WhxNw6E+fMK8nnuOtYjtuOtEXz5H1Uf+BjHAc6Bnx1Wfxqm0yE0V/kZU/ho0CQxrL9j5LNMZddG5zS3UCgW74dDjwaiYff51SyZg5kxebqnw9d55pMneJJycj3P+5VkaI92bt8sTdcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXyRZiJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXyRZiJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41DAC4CED6;
	Wed,  5 Feb 2025 14:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764429;
	bh=Jo5R8emoLK/aVjUoMCS+1EdS+puDkAgrsLfgQegyDfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXyRZiJ6OVsv2GDsgQAt9FiJdhh/6Ga701vwVdjzOiX2LRTNQm95V1vRgUQdQtnEl
	 7+49vjgeT0Mcy4xCR5ZXGjMRuPCKK/5HPy4nlI6eclt0aNIqxwmRYpf6QLSUzR2ouW
	 wOPUSqw5IwdrCpNKjoJh0vrbLNAMRYthRwnCZ23c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/393] ALSA: seq: remove redundant tristate for SND_SEQ_UMP_CLIENT
Date: Wed,  5 Feb 2025 14:41:30 +0100
Message-ID: <20250205134426.838025236@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 8e8bc5000328a1ba8f93d43faf427e8ac31fb416 ]

'def_tristate' is a shorthand for 'default' + 'tristate'.

Another 'tristate' is redundant.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20240215135304.1909431-1-masahiroy@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 9001d5154435 ("ALSA: seq: Make dependency on UMP clearer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/core/seq/Kconfig b/sound/core/seq/Kconfig
index c14981daf9432..0374bbf51cd4d 100644
--- a/sound/core/seq/Kconfig
+++ b/sound/core/seq/Kconfig
@@ -71,7 +71,6 @@ config SND_SEQ_UMP
 	  among legacy and UMP clients.
 
 config SND_SEQ_UMP_CLIENT
-	tristate
 	def_tristate SND_UMP
 
 endif # SND_SEQUENCER
-- 
2.39.5




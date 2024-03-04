Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E34D4C62A;
	Mon,  4 Mar 2024 21:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587677; cv=none; b=SECWOA44aGsD9NOftpBNiu4n/WZiF4oRlfYTYnHeQzG2adE3eMToYDoddM6WweNncXRdi1aw/rofjGjtH9EKOO9P4TDUP8iXcENEu+1vlJvG+oVc4GNJjCbAl+o+FzVw+81PBcstlk1pxJ9Ad0OThu99cd6GouSVHdOjr8ZikS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587677; c=relaxed/simple;
	bh=l2iV9vK+VdLOr2B86GJca5viwh6YfJeRO6r3kN/BOEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9px+Vd0jT+MpBXx59twXnBXR9DGNzX/eWIWbnMBNiQEoAc1iGgN3dDFTBsDjylS+jAMhiNilnQ2EzKdm8NQnwRaIwdAv8a1TarLJUwm/L1e1KWUBCApmuGX0dt95M7iK7MZ83914OmtWLo1/K/1cJQTEpKGujCGnc+9298QYXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0Fz9L+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0Fz9L+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210D4C433F1;
	Mon,  4 Mar 2024 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587677;
	bh=l2iV9vK+VdLOr2B86GJca5viwh6YfJeRO6r3kN/BOEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0Fz9L+PMgwzyTEgr3ZdFHFWml9FB98ksFZZisQXo3DohgQiwxOK2/bWyfM0SZ6Jh
	 JUay2vEp2WuPq80a7CzzYxYXxUL39BjiFX8sLf4izOytFJaszXReWyVl5MXe1pjtmj
	 7jOp+eT9r+VaiqwTfDMvaH+E9Oqgc1pJA0HnJdXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 048/162] ALSA: Drop leftover snd-rtctimer stuff from Makefile
Date: Mon,  4 Mar 2024 21:21:53 +0000
Message-ID: <20240304211553.385326584@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4df49712eb54141be00a9312547436d55677f092 ]

We forgot to remove the line for snd-rtctimer from Makefile while
dropping the functionality.  Get rid of the stale line.

Fixes: 34ce71a96dcb ("ALSA: timer: remove legacy rtctimer")
Link: https://lore.kernel.org/r/20240221092156.28695-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/core/Makefile b/sound/core/Makefile
index a6b444ee28326..f6526b3371375 100644
--- a/sound/core/Makefile
+++ b/sound/core/Makefile
@@ -32,7 +32,6 @@ snd-ump-objs      := ump.o
 snd-ump-$(CONFIG_SND_UMP_LEGACY_RAWMIDI) += ump_convert.o
 snd-timer-objs    := timer.o
 snd-hrtimer-objs  := hrtimer.o
-snd-rtctimer-objs := rtctimer.o
 snd-hwdep-objs    := hwdep.o
 snd-seq-device-objs := seq_device.o
 
-- 
2.43.0




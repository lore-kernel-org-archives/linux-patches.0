Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A348634E;
	Wed,  5 Feb 2025 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765652; cv=none; b=N8/Hr9LiRnWe/6IBLKggPUzqi0s+bxqSD8AMLQkv5lRFfeZpxg6sU+QX8rTsrSIwTzzxK1AAyF5Sb1j7x52/JmEbB0z6F/Q4F5nDg48yosQkC+jvxh/IhzBSyQ55tDcKP+W86iQluzEsOkVYPEcbMZuZuyZwzwKFzKtvRYk3cDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765652; c=relaxed/simple;
	bh=/uQuXrAyAayVdxKIyU/cd7uVY/NDQMgmqzRN5Iiy8qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn3xQyXyw7mdGQeJbavq0SxUGXQn1sD5Rb7B99o/J4ORvKMs01GZEdAgjo69e2ugH2mHw4WtnbuYJubJwlWxadpHL/Bc/2hwID2z3+xwnTnQzjvYcd3WtcmEUaSJmVC89MhGnlcJHnuKboMDEvBi+o5Fu1K5Jn9Wk3JBRbSX8yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0ku/Ur2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0ku/Ur2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59994C4CED1;
	Wed,  5 Feb 2025 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765651;
	bh=/uQuXrAyAayVdxKIyU/cd7uVY/NDQMgmqzRN5Iiy8qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0ku/Ur2UGYLs6C8iTAtIX3khVeKJa7IWN7qGn09Nu3DbQO7+xkvacNg98udzlQwb
	 dDjm+ip5cNXC6D0Y5Bp8xYc5+aRMxz+W1H6f9duk2w27BnbG1pwP93txSZ2mh8t0sk
	 EOV5hbGITD0GIE1etMLiFFJM8G3YU5NNTlX0TvQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/590] ASoC: wcd937x: Use *-y for Makefile
Date: Wed,  5 Feb 2025 14:39:55 +0100
Message-ID: <20250205134504.464848846@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

[ Upstream commit 582057d2233a5a38e1aec3f4a6d66b362b42076c ]

We should use *-y instead of *-objs in Makefile for the module
objects.  *-objs is used rather for host programs.

Fixes: 313e978df7fc ("ASoC: codecs: wcd937x: add audio routing and Kconfig")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241203141823.22393-6-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 56c519a5c897b..69cb0b39f2200 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -324,8 +324,8 @@ snd-soc-wcd-classh-y := wcd-clsh-v2.o
 snd-soc-wcd-mbhc-y := wcd-mbhc-v2.o
 snd-soc-wcd9335-y := wcd9335.o
 snd-soc-wcd934x-y := wcd934x.o
-snd-soc-wcd937x-objs := wcd937x.o
-snd-soc-wcd937x-sdw-objs := wcd937x-sdw.o
+snd-soc-wcd937x-y := wcd937x.o
+snd-soc-wcd937x-sdw-y := wcd937x-sdw.o
 snd-soc-wcd938x-y := wcd938x.o
 snd-soc-wcd938x-sdw-y := wcd938x-sdw.o
 snd-soc-wcd939x-y := wcd939x.o
-- 
2.39.5




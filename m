Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5B728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8956CC433EF;
	Mon, 30 Jan 2023 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087757;
	bh=DT/aYjU51HX+3mWs6zbdZSQ3hu7Wex2ZUvbW5F7iVlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elJ0+hokFPXwfV1CWPzYnjg0swrPY0SUT22SpKoaAjZEs/237ngKp+xddfM3a1D7r
	 er5Ckl+8942W8H76gTSzMoCiMe5FoaW8I7bv5sPT9QVQOTKd+4lKvBkIVfE9ONZnZZ
	 AI9sjky4wB7fD8jOtx6z6P48yu0/ytrBf4XEmEFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 300/313] treewide: fix up files incorrectly marked executable
Date: Mon, 30 Jan 2023 14:52:15 +0100
Message-Id: <20230130134350.708772456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 262b42e02d1e0b5ad1b33e9b9842e178c16231de ]

I'm not exactly clear on what strange workflow causes people to do it,
but clearly occasionally some files end up being committed as executable
even though they clearly aren't.

This is a reprise of commit 90fda63fa115 ("treewide: fix up files
incorrectly marked executable"), just with a different set of files (but
with the same trivial shell scripting).

So apparently we need to re-do this every five years or so, and Joe
needs to just keep reminding me to do so ;)

Reported-by: Joe Perches <joe@perches.com>
Fixes: 523375c943e5 ("drm/vmwgfx: Port vmwgfx to arm64")
Fixes: 5c439937775d ("ASoC: codecs: add support for ES8326")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h | 0
 sound/soc/codecs/es8326.c                 | 0
 sound/soc/codecs/es8326.h                 | 0
 3 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h
 mode change 100755 => 100644 sound/soc/codecs/es8326.c
 mode change 100755 => 100644 sound/soc/codecs/es8326.h

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h b/drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h
old mode 100755
new mode 100644
diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
old mode 100755
new mode 100644
diff --git a/sound/soc/codecs/es8326.h b/sound/soc/codecs/es8326.h
old mode 100755
new mode 100644
-- 
2.39.0




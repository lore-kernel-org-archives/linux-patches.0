Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AC43229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CF5C433D2;
	Mon, 30 Jan 2023 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088356;
	bh=dIubFkVQexVc21w5zlUMYqAmUd82j7Z8ro85bO0BezY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/tvOjUpStm54oFAqrKBwNBEDNFvtRZD0VMae3SFloLnLyqXQm7zzU+Q4t3fR0XsQ
	 cZ5LLGNuPlJCM4vEMSXTzlHV/jVeEkaNeobmzrNj23CK83QM6pmhFhNuFNQ5AWOyq6
	 8fynfRPkucv7+TFEk+tMasixyuwfgp4LxY/XGZ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/204] treewide: fix up files incorrectly marked executable
Date: Mon, 30 Jan 2023 14:52:40 +0100
Message-Id: <20230130134325.157727550@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h b/drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h
old mode 100755
new mode 100644
-- 
2.39.0




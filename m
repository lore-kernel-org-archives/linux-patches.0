Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5223F28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89B3C4339E;
	Mon, 30 Jan 2023 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087764;
	bh=iTiHWzZjjov1MJUgNFVsnjmAtZHuTtM1HQuWaMRhgK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcYfptEnc2GDBx33s7FfQD5MkuXwu2pfiUt99PoDUfVv8tpW6k7Zr75FBT9WP6q9N
	 7tR0NSuKk0D+NerNw/SUgAEJdW5so2D9ahsD/Ge9Y31HI4MlH2AxjDzRNZVw+44MEo
	 ZJuakuXKOwR7OhL87jSOW+uU2NiRSi5MkoXaka5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 302/313] Fix up more non-executable files marked executable
Date: Mon, 30 Jan 2023 14:52:17 +0100
Message-Id: <20230130134350.804990874@linuxfoundation.org>
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

[ Upstream commit c96618275234ad03d44eafe9f8844305bb44fda4 ]

Joe found another DT file that shouldn't be executable, and that
frustrated me enough that I went hunting with this script:

    git ls-files -s |
        grep '^100755' |
        cut -f2 |
        xargs grep -L '^#!'

and that found another file that shouldn't have been marked executable
either, despite being in the scripts directory.

Maybe these two are the last ones at least for now.  But I'm sure we'll
be back in a few years, fixing things up again.

Fixes: 8c6789f4e2d4 ("ASoC: dt-bindings: Add Everest ES8326 audio CODEC")
Fixes: 4d8e5cd233db ("locking/atomics: Fix scripts/atomic/ script permissions")
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/sound/everest,es8326.yaml | 0
 scripts/atomic/atomics.tbl                                  | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 Documentation/devicetree/bindings/sound/everest,es8326.yaml
 mode change 100755 => 100644 scripts/atomic/atomics.tbl

diff --git a/Documentation/devicetree/bindings/sound/everest,es8326.yaml b/Documentation/devicetree/bindings/sound/everest,es8326.yaml
old mode 100755
new mode 100644
diff --git a/scripts/atomic/atomics.tbl b/scripts/atomic/atomics.tbl
old mode 100755
new mode 100644
-- 
2.39.0




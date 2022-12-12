Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE82D28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38070C433D2;
	Mon, 12 Dec 2022 13:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852168;
	bh=uima7NwaS8OwqnhFDlO2OGrm2y1ElcTnY0VnoLuZ2Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BIM4fCI1Nw8aKxfaGXJrbaJiQn4op3gkCQ5FBquga/9K1M5IAqW/BkTDhBb2Gel/
	 kh6DUwmczwuTpjuwYG8FbUalq+eWIYAkOa7/kUFhd3N/xexKZFqNqVWHSZbUiNtXbQ
	 ytdwSoq9ITTjbHsEefmK/1Y+qbRD1nhgiEFY1mFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 025/157] LoongArch: Makefile: Use "grep -E" instead of "egrep"
Date: Mon, 12 Dec 2022 14:16:13 +0100
Message-Id: <20221212130935.526074773@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 83f638bca0ccd94942bc3c4eb9bcec24dd8a1cf9 ]

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E

Fix this up by changing the LoongArch Makefile to use "grep -E" instead.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index ec3de6191276..9123feb69854 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -68,7 +68,7 @@ KBUILD_LDFLAGS	+= -m $(ld-emul)
 
 ifdef CONFIG_LOONGARCH
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
-	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
+	grep -E -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif
 
-- 
2.35.1




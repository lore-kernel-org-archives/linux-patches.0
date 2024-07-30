Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7BD1A76A5;
	Tue, 30 Jul 2024 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360656; cv=none; b=LyrqH3kvFgIhc16yA+OeER6sA71WmUi3M8YWuOKv+jHCvY4xh7lJBTIaMmxe+6H++iDvD+BR5w/yKWLgVl/0IIMSe1hYDF96bdom6y+tjq8AgSiH7cxOWbo6p5ijme6g9Oh+yBJkPuG5PSHDllpdGN+XGU4A/VCDdDFN/27EHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360656; c=relaxed/simple;
	bh=lxgq3jmkWQb4RrCj1S0LoANA0v6vV362pca4e2WCNKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf47NtWKKwSLxgh+tib8XPWx/rhRDdivBuyby20L5qF4Lvif65Xwiy+mbQEG7HhZZ5mhp5UCiK2toXEXrljtb6Cnle7zv2Cv+S6J4/cf+XyPAHpJDB36KkIx9vdgFsgoiiMN1U8P9WqaPJDLh8PEV50xMB+G0WBmizmJpIbuZ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFnzhlRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFnzhlRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15ABC32782;
	Tue, 30 Jul 2024 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360656;
	bh=lxgq3jmkWQb4RrCj1S0LoANA0v6vV362pca4e2WCNKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFnzhlRD9u/uYCyyA+/gVnR9YxRELylMktaQow2BJX1XdVK9NnIaFIz4EIhobNnGo
	 7PegywGVTVDd7IPMu7WmNvNfW48fWyjfLDrmx1PIE2FoQmbSxUQd5Z8Rd+4KCVyEhm
	 /jNeFys68ZY/g9EiCMHw8HLrO96boJRT96Hh40iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liwei Song <liwei.song.lsong@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 759/809] tools/resolve_btfids: Fix comparison of distinct pointer types warning in resolve_btfids
Date: Tue, 30 Jul 2024 17:50:35 +0200
Message-ID: <20240730151754.939321054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liwei Song <liwei.song.lsong@gmail.com>

[ Upstream commit 13c9b702e6cb8e406d5fa6b2dca422fa42d2f13e ]

Add a type cast for set8->pairs to fix below compile warning:

main.c: In function 'sets_patch':
main.c:699:50: warning: comparison of distinct pointer types lacks a cast
  699 |        BUILD_BUG_ON(set8->pairs != &set8->pairs[0].id);
      |                                 ^~

Fixes: 9707ac4fe2f5 ("tools/resolve_btfids: Refactor set sorting with types from btf_ids.h")
Signed-off-by: Liwei Song <liwei.song.lsong@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20240722083305.4009723-1-liwei.song.lsong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index af393c7dee1f1..b3edc239fe562 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -696,7 +696,7 @@ static int sets_patch(struct object *obj)
 			 * Make sure id is at the beginning of the pairs
 			 * struct, otherwise the below qsort would not work.
 			 */
-			BUILD_BUG_ON(set8->pairs != &set8->pairs[0].id);
+			BUILD_BUG_ON((u32 *)set8->pairs != &set8->pairs[0].id);
 			qsort(set8->pairs, set8->cnt, sizeof(set8->pairs[0]), cmp_id);
 
 			/*
-- 
2.43.0




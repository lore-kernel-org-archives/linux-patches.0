Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17136184549;
	Tue, 30 Jul 2024 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358641; cv=none; b=ksVOJAG9kjRD7O2R+yQkPImVUaBoe4/lc+1uSZt4orTsqyRFk/jFrKIixm1J+7LTDk3UdMCjrqGDrmAT2rMke+va1PjftUtjn87SM8UXGWFGqhxLQTvJ8dZjHyvmb0ZFAc+hYA7om61EGU6qaZcUO86HmrIWgShQ0BK1aSCW+yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358641; c=relaxed/simple;
	bh=pqt+j/J5tngsqKhxnJwK01qtM1xmoBhfz3Niw7UqKuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfOxg8DTAWfHemFTdikCridB/cXBKfUB7VDIMcR2XHXe3ozuOzKawZDT3MPkKVGhD+3HulhCBRkvLS3umJeMoP9EFDJX9d82hOXPv7hX5YEDNGhjzYLEyck3/k10y+wYqVhmooB/30tzeeNNx3SJwcW+OD4UoqtI2lE3Mzv2l68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaLZZeY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaLZZeY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB89C4AF0E;
	Tue, 30 Jul 2024 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358640;
	bh=pqt+j/J5tngsqKhxnJwK01qtM1xmoBhfz3Niw7UqKuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaLZZeY8APZn1CgoClaeVJGvjmarsxcKK4EiaATaLfbmP8pwiv7bSG80hufmCzpDL
	 fOLe/3/9bFq+9Njgw1lvTx86iNZGTi9Q1v6hBXFmgEOVDjejAcYtHPZ2vryNUJzWLe
	 kWUdd3WC0EFmcBqZp0YG9LMuPiOK66nZjt3LyyjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liwei Song <liwei.song.lsong@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 409/440] tools/resolve_btfids: Fix comparison of distinct pointer types warning in resolve_btfids
Date: Tue, 30 Jul 2024 17:50:42 +0200
Message-ID: <20240730151631.769853678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 82bffa7cf8659..7775040182e39 100644
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




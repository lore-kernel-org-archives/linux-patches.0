Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923871A76D4;
	Tue, 30 Jul 2024 17:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359775; cv=none; b=etcRwWsYkiEHwB31VIVc8myhEGdjGHPngjOOnsG4sf7lGku/mpyEdtfuY89MjV/Ey2t5+GZCcVvE0wnLlA6O/a23IQ0cdK11Fx2qcjeUa9L1o6adFLZoQbPdpO038mOFoltKI8sVjcqYDI7DurzaOXl7lWT2janjY6migJEygyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359775; c=relaxed/simple;
	bh=/x/Kvkgp8Wqh+XekbydRsEj5vn9Yx0mN+ja2riPtxdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC4HYvCCq/u0A1hZ2Id0BG1e1Tfyxa0fwBroMrUHurSiX+w9HdOhaVHM3TkMVEznjF6E+kGYHIy06Fy9akSUGb/WJL1B+mYdDXnk7hSUCojyDr5JnyYNWo7kSd4T3ECg58mssAPu4L9QH2dOANglfjL2aKVhQ0/rshPmPD4cUag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uxj8dA5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uxj8dA5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EBEC32782;
	Tue, 30 Jul 2024 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359775;
	bh=/x/Kvkgp8Wqh+XekbydRsEj5vn9Yx0mN+ja2riPtxdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uxj8dA5HoqmvZzzp9b2yRjt+3jHEYebpJyuQjVI24BAKG3hrXPpgt19PET4FvUdrd
	 qCv5SuucOQRRXQDrOU6AfX9H5ovF5u7R3S37ag67rTw2jFikFJmjlU4NSE5b/056Qt
	 x1yB3dwCr1OA8lRUsLS/Rl/ogGO3h8J5sepO/CDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liwei Song <liwei.song.lsong@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 534/568] tools/resolve_btfids: Fix comparison of distinct pointer types warning in resolve_btfids
Date: Tue, 30 Jul 2024 17:50:41 +0200
Message-ID: <20240730151701.026804097@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




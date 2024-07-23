Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A57B13D896;
	Tue, 23 Jul 2024 18:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759870; cv=none; b=VmyvSLnV6j7Meq0PMq6Uc3+0SpZBmtnQXYk5XoBeK8QAU/I19YLjyTKcohjj0mDeFfI7bbdy+oTBaWkOjGrnxaKVncK56yaDghysgbDHySi5IGJNM9PRLO6DpDAKSrO/sEV1k23Pl0Tu5r086UDWQtYmReRQpusWwdETHGa2Bzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759870; c=relaxed/simple;
	bh=e07YCDadD+oIGbXZXfjojmUz6pgj03J5sCKLg3z9VUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SlU0cNZizdET/Ofl9g87wbGw80ojgHz4anh2Q+Vi9LhltMHGvJmQaDLVle598K4gTFlymp5QBAIbAbPk0Jvf5aT1e2XhvN0ote/KCrL4At2vK7jWKv355GnH0tIbmvwn/a1N650oNFKUHSaBOvgiZnQcQQ15eGjRQevbhxxULs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaV2oz0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaV2oz0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4410CC4AF0A;
	Tue, 23 Jul 2024 18:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759869;
	bh=e07YCDadD+oIGbXZXfjojmUz6pgj03J5sCKLg3z9VUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaV2oz0dceJ2QTXpI2BsXfb73hOdkBP/IDPuL7wWUxQiT1w6NMdY9f6diCTF/YyKK
	 ecUC7YEkByyxgr6J+ym90iohkaqYHVDb2dmlItnypt00hxYLQl8ZIK4zUJGOsiSg3R
	 bkh6ev657khMbjwne5ToTtf5CSqsKX0AutO2nhQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 025/163] selftests: cachestat: Fix build warnings on ppc64
Date: Tue, 23 Jul 2024 20:22:34 +0200
Message-ID: <20240723180144.442583661@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit bc4d5f5d2debf8bb65fba188313481549ead8576 ]

Fix warnings like:
  test_cachestat.c: In function ‘print_cachestat’:
  test_cachestat.c:30:38: warning: format ‘%llu’ expects argument of
  type ‘long long unsigned int’, but argument 2 has type ‘__u64’ {aka
  ‘long unsigned int’} [-Wformat=]

By switching to unsigned long long for u64 for ppc64 builds.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cachestat/test_cachestat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index b171fd53b004e..632ab44737ec3 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 
 #include <stdio.h>
 #include <stdbool.h>
-- 
2.43.0




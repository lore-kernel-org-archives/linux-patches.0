Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9726E2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAC4C433EF;
	Mon, 24 Apr 2023 13:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343317;
	bh=nxh/nNIrVThINx+3vd9bj9ZM++6RhoH+3cGJWJ7LkGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trVlZNvEnDGIHogkXjazUdSbHPkZnvkl74Za094QBVem2CkZZIRyJmbek6mPPvreP
	 rAHchWXY/8lhPgI7/+Ot0Db9Z7Daa781PlbxdAsBgIjR4YCXGJlKpNm+RqFn9OckXO
	 UH2hekcDF0ZUmh3ehIrBNA25ZfC/eU/NdnuuN/Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 47/68] [PATCH v2 stable-5.10.y stable-5.15.y] docs: futex: Fix kernel-doc references after code split-up preparation
Date: Mon, 24 Apr 2023 15:18:18 +0200
Message-Id: <20230424131129.482042457@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Salvatore Bonaccorso <carnil@debian.org>

In upstream commit 77e52ae35463 ("futex: Move to kernel/futex/") the
futex code from kernel/futex.c was moved into kernel/futex/core.c in
preparation of the split-up of the implementation in various files.

Point kernel-doc references to the new files as otherwise the
documentation shows errors on build:

    [...]
    Error: Cannot open file ./kernel/futex.c
    Error: Cannot open file ./kernel/futex.c
    [...]
    WARNING: kernel-doc './scripts/kernel-doc -rst -enable-lineno -sphinx-version 3.4.3 -internal ./kernel/futex.c' failed with return code 2

There is no direct upstream commit for this change. It is made in
analogy to commit bc67f1c454fb ("docs: futex: Fix kernel-doc
references") applied as consequence of the restructuring of the futex
code.

Fixes: 77e52ae35463 ("futex: Move to kernel/futex/")
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-hacking/locking.rst                    |    2 +-
 Documentation/translations/it_IT/kernel-hacking/locking.rst |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -1358,7 +1358,7 @@ Mutex API reference
 Futex API reference
 ===================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Further reading
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -1400,7 +1400,7 @@ Riferimento per l'API dei Mutex
 Riferimento per l'API dei Futex
 ===============================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Approfondimenti



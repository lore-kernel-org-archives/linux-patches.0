Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A931E85C;
	Thu, 16 Jul 2026 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210078; cv=none; b=L2ZmzGjfD0GHFUSM2ZM41seXK2GJItCIywMordf301Bg9wCYE1A3iTdigE9ZizqWij4SAriqUmUAKTm4WVjWztde85XmwmVmklTZ62qGDAWGTEb1f5Mm4Kfy7qbmQb6e66EeLjyE+YKUuRY0o60xzt12WL9BVTphxuEp2qYehCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210078; c=relaxed/simple;
	bh=kQQyc/Wn3iZWHQyMFM+xhsnqWxOoK2pLkbbZ5OzU/84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Odu+cTwKQLMjKUJDjVGthQkk/hbryDG6Bq9d1XBP16u031+G/e1cCljwqlvJISQmPyDIySWJjO+s+aPHGOS88xbhkkEkFym57C357kBjQl+P8jkzYFG+MgnwQ1+Zrmnmdjtn4tTNOcqdcHrEuL84pxg6ZwslVReYg3IWgRydftw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHV4egpE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHV4egpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE49D1F000E9;
	Thu, 16 Jul 2026 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210077;
	bh=Q2F+jWy8DLpiXP5J9AOEQpOW+BRbBe1X1BSk9SScoTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHV4egpExE4S1FwoThWf0X2NqCuxH32B2R2byc93aDMW5bZUHFLyQ+Ay91PAMeWe5
	 M2jN2FxFG64fLH9N+Mqs2VqCyeX9BamlZlqPogBAKLFM444H/GnPmKXxGOU9pkuY9j
	 addcYrwGqT+Cyj9KkHoOisiDkHTQLcCEcUgfqmRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 428/518] selftests/mm: fix ksft_process_madv.sh test category
Date: Thu, 16 Jul 2026 15:31:36 +0200
Message-ID: <20260716133057.206229291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Sharma <sarthak.sharma@arm.com>

commit 4b0363cb1f3ec42b0b1346e5ab0b8a3dceeee9be upstream.

ksft_process_madv.sh currently runs run_vmtests.sh with the mmap category.
Update it to run the process_madv category, since ksft_mmap.sh already
runs the mmap category tests.

This avoids running mmap tests twice and ensures that process_madv tests
are run through the kselftest harness.

Link: https://lore.kernel.org/20260608103224.344101-1-sarthak.sharma@arm.com
Fixes: 6ce964c02f1c ("selftests/mm: have the harness run each test category separately")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/ksft_process_madv.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksft_process_madv.sh b/tools/testing/selftests/mm/ksft_process_madv.sh
index 2c3137ae8bc8..edad2d2d888f 100755
--- a/tools/testing/selftests/mm/ksft_process_madv.sh
+++ b/tools/testing/selftests/mm/ksft_process_madv.sh
@@ -1,4 +1,4 @@
 #!/bin/sh -e
 # SPDX-License-Identifier: GPL-2.0
 
-./run_vmtests.sh -t mmap
+./run_vmtests.sh -t process_madv
-- 
2.55.0




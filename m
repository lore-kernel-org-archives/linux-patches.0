Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE47D3D89
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 19:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925CFC385A9;
	Wed, 27 Apr 2022 19:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1651088520;
	bh=Z0vz/2W6qPtjAA116S7QHDmsmc8iimqdYnZa8QLU2dc=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=DwdrLUSjCXZyjZVJvdB1mIGdieEPiFgF7uy9DuR8FLL58hiCZf+Lr/MVcCmguTsZH
	 wpgdwjCoQsFHRUeEx4o68sasmGJk9VhHQJ9/wN8m/OZn9xkBinJVbXLjee1SaBniMH
	 G83XrFDn0xBWzj2XNxqkfXNiv4twWfsSJquoQXnw=
Date: Wed, 27 Apr 2022 12:41:59 -0700
To: seakeel@gmail.com,hanshenghong2019@email.szu.edu.cn,corbet@lwn.net,baihaowen@meizu.com,akiyks@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220427124133.cc115bc8acb8de3dda921836@linux-foundation.org>
Subject: [patch 2/2] docs: vm/page_owner: use literal blocks for param description
Message-Id: <20220427194200.925CFC385A9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Akira Yokosawa <akiyks@gmail.com>
Subject: docs: vm/page_owner: use literal blocks for param description

Sphinx generates hard-to-read lists of parameters at the bottom of the
page.  Fix them by putting literal-block markers of "::" in front of them.

Link: https://lkml.kernel.org/r/cfd3bcc0-b51d-0c68-c065-ca1c4c202447@gmail.com
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Fixes: 57f2b54a9379 ("Documentation/vm/page_owner.rst: update the documentation")
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alex Shi <seakeel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~docs-vm-page_owner-use-literal-blocks-for-param-description
+++ a/Documentation/vm/page_owner.rst
@@ -110,7 +110,7 @@ Usage
    If you want to sort by the page nums of buf, use the ``-m`` parameter.
    The detailed parameters are:
 
-   fundamental function:
+   fundamental function::
 
 	Sort:
 		-a		Sort by memory allocation time.
@@ -122,7 +122,7 @@ Usage
 		-s		Sort by stack trace.
 		-t		Sort by times (default).
 
-   additional function:
+   additional function::
 
 	Cull:
 		--cull <rules>
@@ -153,6 +153,7 @@ Usage
 
 STANDARD FORMAT SPECIFIERS
 ==========================
+::
 
 	KEY		LONG		DESCRIPTION
 	p		pid		process ID
_

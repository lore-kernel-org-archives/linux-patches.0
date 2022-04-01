Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC47137F
	for <patches@lists.linux.dev>; Fri,  1 Apr 2022 18:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E765FC340F3;
	Fri,  1 Apr 2022 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648837279;
	bh=aT12qv/wZknok1Ce5MUhi+IHWGN6xFOfC6tQPEvg3u0=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=qzEl+/CF2s4PvpJA8Uzm7kjqpvEPSo5CXzbn/P5g98zYu8C5j8S5LwEbsYKtF67E/
	 BoqtC8YnAdf5b+j2a9gALULYhA11aWomiTuI+aXzG5Sm501HwPtcJpydeZkKQA0yPM
	 KkympWtD4q58JkIGMJfPqcO9kA5yaj+eAGwUgTbg=
Date: Fri, 01 Apr 2022 11:21:18 -0700
To: kirill.tkhai@openvz.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <l>
Subject: [patch 10/16] mailmap: update Kirill's email
Message-Id: <20220401182118.E765FC340F3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Kirill Tkhai <kirill.tkhai@openvz.org>
Subject: mailmap: update Kirill's email

My new email address is kirill.tkhai@openvz.org.

Link: https://lkml.kernel.org/r/164846762354.278960.13129571556274098855.stgit@pro
Signed-off-by: Kirill Tkhai <kirill.tkhai@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-kirills-email
+++ a/.mailmap
@@ -213,6 +213,7 @@ Kees Cook <keescook@chromium.org> <kees@
 Keith Busch <kbusch@kernel.org> <keith.busch@intel.com>
 Keith Busch <kbusch@kernel.org> <keith.busch@linux.intel.com>
 Kenneth W Chen <kenneth.w.chen@intel.com>
+Kirill Tkhai <kirill.tkhai@openvz.org> <ktkhai@virtuozzo.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <khlebnikov@yandex-team.ru>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
_

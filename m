Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B020C2C80
	for <patches@lists.linux.dev>; Fri,  8 Apr 2022 20:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7876BC385A1;
	Fri,  8 Apr 2022 20:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1649448557;
	bh=Xj7cE8c6+xY8r3iB8wRucoyiEjHGn6UoRMQ8ZHjC4qU=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=Xb1qjYWWe2cWTbQOm/+KmsTDPsYPP49AlY6kiJh7y5QdJoAgeYb672TzoEV9SxN1p
	 d9OZxHL6SH6KIXvxAEgTV6ekvTDQnUk+fjwcmEWPc/F2VQwc8Xjjkjjy/SVUFxSq17
	 2vzGSg1XwxWO9D60yHKARhteXIAkuyssVZ1fy+Z4=
Date: Fri, 08 Apr 2022 13:09:16 -0700
To: ndesaulniers@google.com,nathan@kernel.org,trix@redhat.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 9/9] MAINTAINERS: add Tom as clang reviewer
Message-Id: <20220408200917.7876BC385A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Tom Rix <trix@redhat.com>
Subject: MAINTAINERS: add Tom as clang reviewer

I have been helping with build breaks and other clang things and would
like to help with the reviews.

Link: https://lkml.kernel.org/r/20220407175715.3378998-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-self-as-clang-reviewer
+++ a/MAINTAINERS
@@ -4791,6 +4791,7 @@ F:	.clang-format
 CLANG/LLVM BUILD SUPPORT
 M:	Nathan Chancellor <nathan@kernel.org>
 M:	Nick Desaulniers <ndesaulniers@google.com>
+R:	Tom Rix <trix@redhat.com>
 L:	llvm@lists.linux.dev
 S:	Supported
 W:	https://clangbuiltlinux.github.io/
_

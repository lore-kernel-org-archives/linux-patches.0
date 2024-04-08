Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427487C6E9;
	Mon,  8 Apr 2024 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583678; cv=none; b=PPYwFMkJTrHhkaeuKXEljOh6LAX5Ap2JjFBuBa0wzB9ZqqM2h8SA/CSsbeZNv82maw6KRu+F2lN0WQuASjSfmzxJFJ3jA0b6RYjnspISaldBECecL0enGcvugia9q43xCOR2ya+abj6YuIiJrLYycQ0smzgRuC6SE64T1+EOKCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583678; c=relaxed/simple;
	bh=RqqpgnENvGBngZaFPGnwTMoXkHKQk6gcl+NUcRvOLKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oT9QZ/ShU+UZOYptRyQsL88DXqW1Jw9JrhgX1ecaDYJFOzhvJd9MUeVowjaqTtWkjjovjUkY5H4rjwzCl/FhypuRRIDpmr2xSijg183gwYBPQvzE/lrnlglJFmVPuWPED0/sk67CZQCaZlMFRd0Ee9E5SYUXSD1yJu4ym8/G7Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBi2qDe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBi2qDe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEACC433F1;
	Mon,  8 Apr 2024 13:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583678;
	bh=RqqpgnENvGBngZaFPGnwTMoXkHKQk6gcl+NUcRvOLKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBi2qDe4V0mo63PJb46ZhDpe5iO+6hoMlURY2TSSdmJx+xap/DSsZhrdqKJIbhmKC
	 n38OtZv9sFkXf4V4M48lMxx1bMVsdCqRK8JahrnhwhqvMzXJeg5nOjuTMNvWKgAP/X
	 iAVx0nmjQ3a+Ictcz92Dt7vK6ChnU/fCoAMI97EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 222/252] selftests/mm: include strings.h for ffsl
Date: Mon,  8 Apr 2024 14:58:41 +0200
Message-ID: <20240408125313.547213990@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Edward Liaw <edliaw@google.com>

commit 176517c9310281d00dd3210ab4cc4d3cdc26b17e upstream.

Got a compilation error on Android for ffsl after 91b80cc5b39f
("selftests: mm: fix map_hugetlb failure on 64K page size systems")
included vm_util.h.

Link: https://lkml.kernel.org/r/20240329185814.16304-1-edliaw@google.com
Fixes: af605d26a8f2 ("selftests/mm: merge util.h into vm_util.h")
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/vm_util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index c02990bbd56f..9007c420d52c 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -3,7 +3,7 @@
 #include <stdbool.h>
 #include <sys/mman.h>
 #include <err.h>
-#include <string.h> /* ffsl() */
+#include <strings.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
-- 
2.44.0




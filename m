Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EF079F0;
	Mon,  8 Apr 2024 13:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583963; cv=none; b=Lk9v7fAK+ptkfQ8dzpn4zxZzC5QVs5/8vfWaSFf9xC6lM7U77Y5Kgk6IU1XK8qkGEukvZqWBirTazlK5vJh/EDyFoCUOyvMJ8c11gqfgwW4xQV3spzLP4+L8WmFOJoGgC7LEsxYeLu8DxHo33v6IHUSgdHGGJVfgndEBdFnhNKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583963; c=relaxed/simple;
	bh=MlMZRk5X5i5GxhaH/tjqKVuagEXBbvFHDQhy82N2CsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNYhiUMKjOgosBEIudMx6JlIKBJdo05iVuktTd9muAu1/PAjIP20+Bxo+qIM1dnIeiVhZ+VYLWcylR52869aRn9DjxdfoZsNaYOUFepHvCvBPli9QP1snyBHiWziM+4WuUDysgOJkLETO/Et0cz6oQYA7dKhu/08MbEfq9fTols=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jby5Yu5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jby5Yu5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593BFC433C7;
	Mon,  8 Apr 2024 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583963;
	bh=MlMZRk5X5i5GxhaH/tjqKVuagEXBbvFHDQhy82N2CsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jby5Yu5nexCwDIA3UGP/WaohVctE4Q3tM1VEhgqdAv7e3lgBxhof/svtjdYsH08Dy
	 KwVDfNW5SlVl72dsViRhOnHuU6CRKkMBdGYTBJzCKE99g3f5N0a/jnYAjUYr6IuK58
	 89vz2C/Zm2VFRYil/mChyrOHExzPt0feLx4mnhrI=
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
Subject: [PATCH 6.8 239/273] selftests/mm: include strings.h for ffsl
Date: Mon,  8 Apr 2024 14:58:34 +0200
Message-ID: <20240408125316.856470077@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/mm/vm_util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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



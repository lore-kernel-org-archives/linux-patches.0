Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BA3268688;
	Tue,  8 Apr 2025 11:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112798; cv=none; b=DviA4yzGYmek3ylqs5zY8BGe8Mawpn4okHNYCyDeqK4EMikf6x3OlDzAS/DqgpEm6zlyD9m1aogJmhPHWPP1g6LiVXjY4s8BLb7i6xdW9ZOjlyVAJnSzmKDuz3J2DNUpghfjo/ilyheKRuF0tGzcpfjzLFcf9kB8jnW8ckg7Yac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112798; c=relaxed/simple;
	bh=izesR2EV1SBKhjp9gGA9QBoaP0+QQ+IPWEnzzK0Iz1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DM+Rb/7+VS623naQ6OPxQF01XcG6HbZodfLBiXmpPSwvwvGRqAkWjumz8spWINglerUgfuiqM+Gich0uD6giTYRb9r8HTLFQ8LXrYNJpp2lCUA0T9g9WnmOKZO3BmdYLuA4PHa3Wm92IhOqqjI3Vs67ra7u9MzzYcL9zyEXlg3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HX34O+VQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HX34O+VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8C4C4CEE5;
	Tue,  8 Apr 2025 11:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112798;
	bh=izesR2EV1SBKhjp9gGA9QBoaP0+QQ+IPWEnzzK0Iz1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HX34O+VQ7NdM7RcqwcMVqrh+BwfTjM8MFETcI7Z7g+JpJuo+fzyhcpIXc+h08JzPc
	 tgcvpd7numQWIfbxjDLe7PCozNsCBBXFr8pMEdKXAIxfiZMK/P6X5zAOatE64kqFhY
	 YypCarJj32XuRlZIc91pETpsjNLK8G9EbgycNxw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/279] perf units: Fix insufficient array space
Date: Tue,  8 Apr 2025 12:49:43 +0200
Message-ID: <20250408104831.735113733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cf67629f7f637fb988228abdb3aae46d0c1748fe ]

No need to specify the array size, let the compiler figure that out.

This addresses this compiler warning that was noticed while build
testing on fedora rawhide:

  31    15.81 fedora:rawhide                : FAIL gcc version 15.0.1 20250225 (Red Hat 15.0.1-0) (GCC)
    util/units.c: In function 'unit_number__scnprintf':
    util/units.c:67:24: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-initialization]
       67 |         char unit[4] = "BKMG";
          |                        ^~~~~~
    cc1: all warnings being treated as errors

Fixes: 9808143ba2e54818 ("perf tools: Add unit_number__scnprintf function")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250310194534.265487-3-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/units.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/units.c b/tools/perf/util/units.c
index 32c39cfe209b3..4c6a86e1cb54b 100644
--- a/tools/perf/util/units.c
+++ b/tools/perf/util/units.c
@@ -64,7 +64,7 @@ unsigned long convert_unit(unsigned long value, char *unit)
 
 int unit_number__scnprintf(char *buf, size_t size, u64 n)
 {
-	char unit[4] = "BKMG";
+	char unit[] = "BKMG";
 	int i = 0;
 
 	while (((n / 1024) > 1) && (i < 3)) {
-- 
2.39.5




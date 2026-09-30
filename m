Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318B74F93CC;
	Wed, 30 Sep 2026 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783009; cv=none; b=g1BwhRQ5Z32xI32oS1ZCYF7B5HX9hfkIbmLzz5nU3kyL/xalEUnjI5rjxNi9Cz/2hRpL7buimYb+JCN/UAuLMB1jGSfR3cFaM0IAl9tvZlTGwcGnBUjMEdmRKcwEOWXZMUlbIeU/Gp+y/+1ymvyXM/Y9QDcyJD3nlZ1KBfFt0e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783009; c=relaxed/simple;
	bh=sC4+khawGz7LIEBlSBPRJm0Wgs1NenYMvcu5s+PPW54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfrU1ZqqPFbKWIRdt58U8I7MtHBPFPzUtKt+OSNv/u5TDz1RKPyt0MKu/CS924dQelRmeqTkFScCDvPhlsxI56YtRQLEb4C/+ZAq4Yhiq4kD8x0c9Wq9J/WZMwpvTNSd+e3Ini4yFvCxDxwJCCtmkJ4vmEBJ2xsz/y8aAwb0fZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFgwJqjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFgwJqjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0087C1F00893;
	Wed, 30 Sep 2026 15:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783004;
	bh=Fonyg0nqYMSae+n/kMfmVHAPK6ltO+Emy9USRmTNxjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFgwJqjYKtXZjHJeCLop+6/cWkmlASUqq7k7dAL/NKlrgtqsqDu3zoxoq7iZSr6mR
	 Vn5loE3oXJaybOcNaq1Zo9NiMA3AaXmmu9NQ1TzSytaVNAoXJmDl0Gzybez05GipdX
	 x+KUAFNTL3aBJcNIRCckwmiQ7e538GJF6OB6uWIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/595] powerpc/kexec_file: Use inclusive range checks in add_usable_mem()
Date: Wed, 30 Sep 2026 17:22:18 +0200
Message-ID: <20260930152352.986393388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c6755be4838d6ccd641effbcdc3d917b82631ff9 ]

add_usable_mem() adds usable memory ranges for the kdump kernel.

The ranges are inclusive, but the partial overlap check uses exclusive
comparisons. This skips ranges with base == loc_end or end == loc_base.
Use inclusive comparisons instead.

Fixes: 7c64e21a1c5a ("powerpc/kexec_file: Restrict memory usage of kdump kernel")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260809162403.18142-2-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 9b4fdb47b9ba6..61d8d143331dc 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -478,7 +478,7 @@ static int add_usable_mem(struct umem_info *um_info, u64 base, u64 end)
 		loc_end = um_info->ranges[i].end;
 		if (loc_base >= base && loc_end <= end)
 			add = true;
-		else if (base < loc_end && end > loc_base) {
+		else if (base <= loc_end && end >= loc_base) {
 			if (loc_base < base)
 				loc_base = base;
 			if (loc_end > end)
-- 
2.53.0




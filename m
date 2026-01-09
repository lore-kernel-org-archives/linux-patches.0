Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23C335BDBB;
	Fri,  9 Jan 2026 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963051; cv=none; b=Q3yrwx2+ejnAiFKcBhmZfuF/0BrHkFQwhE5+weE7l3knOA7xilskQ/Jz4hUvz7bozHfJDZbP8e2wmkWajY5+23FaUCzgIfYB23+sBSaaq+rKbKCRlk3mpN3D+Gejh/P/2dayKXmwI8B+Ij1AcNluLYKK9QhukbmC/RJTjzJdP0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963051; c=relaxed/simple;
	bh=zzGLm+xVdohk4uXTuFsLz620iyF/UXUYajfBUpUp/3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2BBALUecj6ILPZe7Itk1yu6XfVjMNAoDLas/ByNs9weXxUFKFYSNn20oneUjpYH4UdwbD+xstdfonFqNypRqgpfjx+J4Z/SIHNkvErB/wnTpCktM/OJXvSE8P9sXyoCs0TBzEWU2WqW5HEG+8NRkD9+HoB+zg5mFZ7D77z9s68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmtAr9gC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmtAr9gC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF8DC16AAE;
	Fri,  9 Jan 2026 12:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963050;
	bh=zzGLm+xVdohk4uXTuFsLz620iyF/UXUYajfBUpUp/3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmtAr9gCKmBDAsZNVxQigL5gf5bCIir7033jetFLgzvG4+c1jFWQT+c99e+gLbEeF
	 2gCGooB5Ib5hgYeoQ2KXAnWsIsEOGnP438kGyTbrxSUYaDCxcvTmZSjKzQwt67t9KK
	 Uiu87EIbmKRGvbcs0xD+nbLCaq22usGUO1jklejM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 579/634] powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
Date: Fri,  9 Jan 2026 12:44:17 +0100
Message-ID: <20260109112139.398599935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 0da2ba35c0d532ca0fe7af698b17d74c4d084b9a ]

Let's properly adjust BALLOON_MIGRATE like the other drivers.

Note that the INFLATE/DEFLATE events are triggered from the core when
enqueueing/dequeueing pages.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251021100606.148294-3-david@redhat.com
Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/cmm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -532,6 +532,7 @@ static int cmm_migratepage(struct balloo
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 	balloon_page_insert(b_dev_info, newpage);
+	__count_vm_event(BALLOON_MIGRATE);
 	b_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 



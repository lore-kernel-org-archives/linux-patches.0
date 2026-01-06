Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759DF2F9998;
	Tue,  6 Jan 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722210; cv=none; b=OUWz4cYYoENqNHr6wu9ENBTcXjGmhY96XHPX33d/yx4WZfhylJBwNuLW7KUaZ1UaO092NJ0ATIgTey3zAmNxp79xnIlK7YVZjRSnhes9aeFiFacpe8lFGYc0hQ7NtMFensbKU4ld9irMml2idUxU9PRiVGYCzeGrSyO+ITbPxoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722210; c=relaxed/simple;
	bh=+KfqX7EmozrYj0wWKy8LetnQ0uJXy3XDR1Bd6krtp8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNTlcUfU44o3uFF145xhfbXnCxTS3aJ1YGKPGqbA1FhEpQhq+rrSFt6DPP45NzCK/Zhw59dVTS3Uza+sFrtUbg55xszjE9AP631NPaHuK35e1qihNV4iEZVmtBVjCfBglMU72XpmqbPEcbFIml1MspmLZRvZ4lAXaLviIV7YOuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePrqrNGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePrqrNGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93ABC16AAE;
	Tue,  6 Jan 2026 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722210;
	bh=+KfqX7EmozrYj0wWKy8LetnQ0uJXy3XDR1Bd6krtp8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePrqrNGgBUudXCuaiWRuZKDAQxj8YEjP3NXLhfdt9lmpgU+ps62j4298+74Mj7cJ4
	 h0jFdoqjA8rJkcZKkLlaYf+kl/jqulhlgmFTdGFCfXDrElcBDIqHy7EH5cx50Cnogl
	 bTdMqM8JRqAPd71sfjK+SX2Yys817iTdak6ySBxE=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 163/312] powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
Date: Tue,  6 Jan 2026 18:03:57 +0100
Message-ID: <20260106170553.732893803@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 0da2ba35c0d532ca0fe7af698b17d74c4d084b9a upstream.

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
 



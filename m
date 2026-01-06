Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBB917BCA;
	Tue,  6 Jan 2026 17:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720959; cv=none; b=d1Q3hlNaJ4YqyWamP4Wwak+YPDx/MZC5rxoFfVAAOVgpzjLk72kOI0xr0idLIjOtqaMVKwHdNJleU60LA9w2y61SKKOM//iYnxiJn6Qw1HHbQ18m19mZIsqPC2VZBgrMfh1nJFEH0YieurbMj5x1uzMAJXQLkwqaof7LvZ42E6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720959; c=relaxed/simple;
	bh=s3P2digO9xtmQwWQoOCb+MOKEYduQmmfSjge6GYi2Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk63nBHX99IXrQVMVQ/Tv9scDHzWX9sg2IUArJlEfzOr12hfLloxcZkKr+HccLE0sEbJYKeYlYZDAmGodOrQVHzTUUBakd0+SqSjzA19heZgh5F1ZmfmIIEssJxqvcews99z6LqoEd46UL8CZhhdgF7062K3OSAmr2zk77WOYSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzHFbN4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzHFbN4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8118C116C6;
	Tue,  6 Jan 2026 17:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720959;
	bh=s3P2digO9xtmQwWQoOCb+MOKEYduQmmfSjge6GYi2Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzHFbN4lS7/DplJVgth30HVjQwxx+uo6N2AFTHWyVBfO0N89xxggmXb9QA5Vnc7q2
	 0Z0XEvYwhSbJbTHljvAAJaE1C5L2ZYx8W+ypugRP0rxuYwqMmo+7grMXpehFf1AUAO
	 ORW94oTeNx90ByPuB0ORTRAYJrGov6RgAlA+kG0A=
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
Subject: [PATCH 6.12 394/567] powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
Date: Tue,  6 Jan 2026 18:02:56 +0100
Message-ID: <20260106170505.915829730@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit fc6bcf9ac4de76f5e7bcd020b3c0a86faff3f2d5 upstream.

Patch series "powerpc/pseries/cmm: two smaller fixes".

Two smaller fixes identified while doing a bigger rework.


This patch (of 2):

We always have to initialize the balloon_dev_info, even when compaction is
not configured in: otherwise the containing list and the lock are left
uninitialized.

Likely not many such configs exist in practice, but let's CC stable to
be sure.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251021100606.148294-1-david@redhat.com
Link: https://lkml.kernel.org/r/20251021100606.148294-2-david@redhat.com
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
 arch/powerpc/platforms/pseries/cmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -550,7 +550,6 @@ static int cmm_migratepage(struct balloo
 
 static void cmm_balloon_compaction_init(void)
 {
-	balloon_devinfo_init(&b_dev_info);
 	b_dev_info.migratepage = cmm_migratepage;
 }
 #else /* CONFIG_BALLOON_COMPACTION */
@@ -572,6 +571,7 @@ static int cmm_init(void)
 	if (!firmware_has_feature(FW_FEATURE_CMO) && !simulate)
 		return -EOPNOTSUPP;
 
+	balloon_devinfo_init(&b_dev_info);
 	cmm_balloon_compaction_init();
 
 	rc = register_oom_notifier(&cmm_oom_nb);



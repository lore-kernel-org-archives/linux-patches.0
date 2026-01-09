Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1864A35F8D6;
	Fri,  9 Jan 2026 12:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962736; cv=none; b=tGTjpEALVlPRHfDlizlFjW8BlZDN+pcLEBRkrGQFkn7Xo0P8uz/ue5DqiVwc0/ydhavMYt5n4h18+pzomE+Ot31zscrziVdRiYnCp9Y608GhwnCEtTPayKBL6M39Pu5ebxzZpYsI3qIdd2gyPNtNx5Jpo9yBUBBL4K9e5i5nGzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962736; c=relaxed/simple;
	bh=RUkf/F5MrdMsJM8YJ39WHDezS9L3mns61ZqkUFutpkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtQUt4R1Fnttvks4B5ByLATBwsxnR7SpN3tk1nH28tymM+kFsSKWxoD9SjPDVA0fGq1ZjvQSVGh/qMSazlhRPTG0Y2eUgc7sHmLQQ8bDeCvPvJ4IDW8H9bQf7urO1j2H1zjaPX/ECLQvgaqq0JJqdr94VU9VT8lqP2DjfnxKIdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1TmoH4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1TmoH4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662F8C4CEF1;
	Fri,  9 Jan 2026 12:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962735;
	bh=RUkf/F5MrdMsJM8YJ39WHDezS9L3mns61ZqkUFutpkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1TmoH4J2qxS+/iCi3kavDweWnioSeKOzML/E3+GVp0VgkWZGeSoj/TfcMMFohODX
	 41L2BSu/13OGQ1zTPE6UxYT7JtWhZDmdWl7Nv0kT94YBdhue37NEwdi4Pf+J/qgr55
	 fAvcif1aLlM7tnrtTCKc9g4CZbI8HeQcaN+M2B8o=
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
Subject: [PATCH 6.1 470/634] powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
Date: Fri,  9 Jan 2026 12:42:28 +0100
Message-ID: <20260109112135.235539102@linuxfoundation.org>
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



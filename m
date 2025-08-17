Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE0E27453
	for <patches@lists.linux.dev>; Sun, 17 Aug 2025 17:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755451013; cv=pass; b=XNRP8JAwe7PnWGbhOZQgb1JcX+1EUz7sSUXMAoRgDj4KUowqveGKpfq+Bxfj8DaGwumvQc+vF2dQGtErdG5uyb7YO5CAcpS8vNCpMEelY1Un7QeaNcp8vcCTxE7g0N59FTioIVvodVMPucM/tsgJpOktG4jnYGzlxA3ikf7Wu4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755451013; c=relaxed/simple;
	bh=DFENPDrdvhTqknN0Ak5FVfUbewUmvbG5vZYeLGWN2gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTyUsO6AMTycDItFG3VF98Wzem0kPizVK+nCbySTzcFnI6EYKjoLBLyFpJsf+S1DVidmEITE5Lf24dPJ+COy+dSbtgdWivlC7ghqi4sepRS83D6/RMe8U9ns1RXtYqu5YrauQhb2pwI6UE/qZpo7b+6Qsg8vAVRw1eCu4wypnXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=FkPHdA0i; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="FkPHdA0i"
ARC-Seal: i=1; a=rsa-sha256; t=1755450941; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=M1Am64Z5pgGjRFoFecAF83ZyO9mAGXFpgOj5m4FklMikkhDyQGaITzaV2PHExqNmE3/P9htD2y+t10KW9UCxqskMXxwtaJM6o/qfN/yqJBvv02LBI6Qsrm2ZzH6PnJl7M3o20ZWP8yvC4zgCLbuPfZlMa8YzkzjRET629rfY4gM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755450941; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9ts2SrHiyLk7Hg0T85/W7enZ++zVoyJjA1mZGExTh7o=; 
	b=SXoj5XLpkGPt7qNEwvxFQIeV8Cohj15ikPtneXpNI+3kZmE+fo8+9dq4rJjMUJK42dHFai7wVhaq1ca640t4LFUzl9DhGii6sCVq9yHjCHYj5phvb0GAACmSetr4btp7cmTR+7qO7F0hYgUtE/cLhhRlBhbdC2qvtbUUJzBzIRk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755450941;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=9ts2SrHiyLk7Hg0T85/W7enZ++zVoyJjA1mZGExTh7o=;
	b=FkPHdA0i0u+Dxlf5b/4n+rNVaMnoF5a1FTEoiWNqq/gKW9aQb4Q5w7vpDLZQIjAy
	2iqQVFFvDQONeJitL/x1iKzgb2fbzvp2O4t8BWa9okkm5RQaMEgm2FKB5vWwukDw4O1
	pvhADG1fP3LTfxV7ksp9XWH23ntQp5587NawnMHo=
Received: by mx.zohomail.com with SMTPS id 1755450939796201.5019314887586;
	Sun, 17 Aug 2025 10:15:39 -0700 (PDT)
From: Askar Safin <safinaskar@zohomail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	cyphar@cyphar.com,
	Ian Kent <raven@themaw.net>
Cc: linux-fsdevel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	autofs mailing list <autofs@vger.kernel.org>,
	patches@lists.linux.dev
Subject: [PATCH 3/4] vfs: fs/namei.c: move cross-device check to __traverse_mounts
Date: Sun, 17 Aug 2025 17:15:12 +0000
Message-ID: <20250817171513.259291-4-safinaskar@zohomail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250817171513.259291-1-safinaskar@zohomail.com>
References: <20250817171513.259291-1-safinaskar@zohomail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: rr08011227dbafd6d8f666ec4bc4e3e1c50000ee000477926bc6629324a85fa3015e105618875594a8a36ecd:zu080112272dfca12ba25c56c7ce81901900004bfa194b494507dd2b16a083e1a25f6c644d7470b19d6c0f14:rf0801122c030a246fb233640dbf9be7460000edb927c34e27957ec899c48cc993eb0dea5de6f01eb63541273891b6df39:ZohoMail
X-ZohoMailClient: External

This is preparation to RESOLVE_NO_XDEV fix in following commits.
Also this commit makes LOOKUP_NO_XDEV logic more clear: now we
immediately fail with EXDEV on first mount crossing
instead of waiting for very end.

No functional change intended

Signed-off-by: Askar Safin <safinaskar@zohomail.com>
---
 fs/namei.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 00f79559e135..6f43f96f506d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1489,6 +1489,10 @@ static int __traverse_mounts(struct path *path, unsigned flags, bool *jumped,
 				// here we know it's positive
 				flags = path->dentry->d_flags;
 				need_mntput = true;
+				if (unlikely(lookup_flags & LOOKUP_NO_XDEV)) {
+					ret = -EXDEV;
+					break;
+				}
 				continue;
 			}
 		}
@@ -1518,7 +1522,6 @@ static inline int traverse_mounts(struct path *path, bool *jumped,
 				  int *count, unsigned lookup_flags)
 {
 	unsigned flags = smp_load_acquire(&path->dentry->d_flags);
-	int ret;
 
 	/* fastpath */
 	if (likely(!(flags & DCACHE_MANAGED_DENTRY))) {
@@ -1528,10 +1531,7 @@ static inline int traverse_mounts(struct path *path, bool *jumped,
 		return 0;
 	}
 
-	ret = __traverse_mounts(path, flags, jumped, count, lookup_flags);
-	if (*jumped && unlikely(lookup_flags & LOOKUP_NO_XDEV))
-		return -EXDEV;
-	return ret;
+	return __traverse_mounts(path, flags, jumped, count, lookup_flags);
 }
 
 int follow_down_one(struct path *path)
-- 
2.47.2


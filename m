Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BEA27453
	for <patches@lists.linux.dev>; Sun, 17 Aug 2025 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755451039; cv=pass; b=ONRd0sLxwrjzgeo3t9w9QEx91fQxiTiDJgK/IhbBs7LTEWCmf8HNIW5V0GW0iWmdz+dNGiGU66a1p981hLVlpbIPXuPlbx/B6AKdO17uyMiTFm3VDim6KCHJhreliJn2wICkiAEk8SbEzu91girOa6jhwgUT4MOsXoFkTDAeC+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755451039; c=relaxed/simple;
	bh=HTY6mxRt7CvQVTxSwniLarCT73LpSjEDqAQHRYxqRqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdyp5woD0uYR9DIuJ27cMp8Yf9oWL5PJ/MmuAztsQvESg3RyP2Mcf9DIwJBzkCnEXxTAvv9F2LCcMwSU360HkXRnI/SrYyPs2deLQPvHKmamhf0iHv887JTPIYJkN+hCCDlFVcKqCH+AKLmZR7oArd9gr+z5bWBGLkppPmo9qOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=DsGWWPvW; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="DsGWWPvW"
ARC-Seal: i=1; a=rsa-sha256; t=1755450945; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=XBPquWpFGbbzWET9Xi4sJC2WacPLveDIRRlhdnuqspYEibZS4DAoGIUbiChMAZzcyxg9xuEsh/Wu+YYshCPh42Wu+znvDeoXwld0LjaSa89UTgTKI8TI7c7ez18JuUTglICNBNeUDDrq5SKsAqOfaKKq0EUeGTCOoUIm3lDAK1w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755450945; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+nuy8/umsRRPhsUFh/Z3fSSaZ0diS5+LQeMmU9vNT6U=; 
	b=N4h3A2Z67uKzdjOLuJdnEXdoit13isjhDFj+5AP3FU7tm98WqLnl3S9t8CoBap7+IM/vhn1qUcLmVcCk+SgTwu3U3OYetpnxLX5QCI7NmwKXpnfwCWjduLVQIx4JlPkZXugJcwPfYIDzyH3ughCECDE2KdFaIyFPuxNJ2+YOo88=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755450945;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=+nuy8/umsRRPhsUFh/Z3fSSaZ0diS5+LQeMmU9vNT6U=;
	b=DsGWWPvWcaNxEoddqCkrlQRnNB7XyaVdXpZiRrl3pC2enSrLe8Wa8qoUuc2obDpf
	75437B7rakqEKNxkTPnCHB3nyP5KUdX6kXtqVfH0HdVptuVC7NhwruKvftXExLcsFEJ
	F3fPUFjZjSdE4pTNh+Wuzz+KngNC/0fl1o8kJoY0=
Received: by mx.zohomail.com with SMTPS id 1755450942663826.9513242233704;
	Sun, 17 Aug 2025 10:15:42 -0700 (PDT)
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
Subject: [PATCH 4/4] vfs: fs/namei.c: if RESOLVE_NO_XDEV passed to openat2, don't *trigger* automounts
Date: Sun, 17 Aug 2025 17:15:13 +0000
Message-ID: <20250817171513.259291-5-safinaskar@zohomail.com>
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
Feedback-ID: rr08011227378b5ffb619131665c797f83000054a0d632d5530949be5b8c8d94223ed7577cb562031dbfaafb:zu080112279c2644b3d910616bdad88cd8000019f50545593e26ed6c9ef44afef22243ed6d85979f27adcd67:rf0801122c1e17da0906842ede7b6e99d900008def6eef5e0b9b1193adf547336861c6f3a3e4a88899a6e685d734a4ca96:ZohoMail
X-ZohoMailClient: External

openat2 had a bug: if we pass RESOLVE_NO_XDEV, then openat2
doesn't traverse through automounts, but may still trigger them.
(See the link for full bug report with reproducer.)

This commit fixes this bug.

Link: https://lore.kernel.org/linux-fsdevel/20250817075252.4137628-1-safinaskar@zohomail.com/
Fixes: fddb5d430ad9fa91b49b1 ("open: introduce openat2(2) syscall")
Signed-off-by: Askar Safin <safinaskar@zohomail.com>
---
 fs/namei.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 6f43f96f506d..55e2447699a4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1449,6 +1449,18 @@ static int follow_automount(struct path *path, int *count, unsigned lookup_flags
 	    dentry->d_inode)
 		return -EISDIR;
 
+	/* "if" above returned -EISDIR if we want to get automount point itself
+	 * as opposed to new mount. Getting automount point itself is, of course,
+	 * totally okay even if we have LOOKUP_NO_XDEV.
+	 *
+	 * But if we got here, then we want to get
+	 * new mount. Let's deny this if LOOKUP_NO_XDEV is specified.
+	 * If we have LOOKUP_NO_XDEV, then we want to deny not only
+	 * traversing through automounts, but also triggering them
+	 */
+	if (lookup_flags & LOOKUP_NO_XDEV)
+		return -EXDEV;
+
 	if (count && (*count)++ >= MAXSYMLINKS)
 		return -ELOOP;
 
@@ -1472,6 +1484,10 @@ static int __traverse_mounts(struct path *path, unsigned flags, bool *jumped,
 		/* Allow the filesystem to manage the transit without i_rwsem
 		 * being held. */
 		if (flags & DCACHE_MANAGE_TRANSIT) {
+			if (lookup_flags & LOOKUP_NO_XDEV) {
+				ret = -EXDEV;
+				break;
+			}
 			ret = path->dentry->d_op->d_manage(path, false);
 			flags = smp_load_acquire(&path->dentry->d_flags);
 			if (ret < 0)
-- 
2.47.2


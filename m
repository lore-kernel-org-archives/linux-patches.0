Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022442;
	b=cT5RWvhHhb5bUQMCl5LjNdvXpPSd/cP98cKWGQAYmJIiwKN182Q4OExd1V0LAGjo1SBe
	 KelhseRr7X1+G6uyqiRfTx2kciDkLdiNUZtvnwREmq8M+dlVVK/3+r4HS03sFga6hBXQF
	 HDpAnsp8ECE+BiQSIdJUy7wTUpvkFfLGlsJOqnZq+hPtTvE//C7b+xz9jZ/Z6r1H3vrQG
	 jRFG+FS7OnofILvC8EWNpa/YjI3YyYNqEYLL8sgZ9WswhKcy57ET9mlHYkRRuinzG1LG2
	 WlDokQIX4XODOpjJMnGcnGUQTOlfZAjIw/WGm9IInhtUPOzhdbjiI/a/cU3LjeY9fmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rej/gORME9ziL53Y8qrlh7t+BMtMoZLsXYHQnxy+aPw=;
	b=Wqo9J1p0pJ8F6Wbp2XJSTEeqEJxMpfu16LHpkv7imrf31+X2KZy03r1Hba8tn7bLbsUS
	 1po8QFWMU3q1ia+vrvmWPsJgIiN2PgbvKe8f5CGdGHHYlbgnoWpSWPCJ43j6Beg6hKot7
	 zT6cA56Uj29A0+cWAk6L6MFeotwY47dhCP4wGSJrWIRYHNw1wMtudj7CcjpoZyD4p6Agw
	 HTRgdJYfL3mH1g+h2Fu+3UcvUSim94aCCoGoRsFzu/XRIIvINkx/4rjAFjoORAUcARbqC
	 ODn2joOPdZJLC35F8FrFw2aGvayZu6BY1146h05G/SfMVOG3ve82eE+97MbBld47MZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7zwVLjl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A4606A31C;
	Wed, 18 Nov 2026 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7zwVLjl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F3B1F000C5;
	Wed, 18 Nov 2026 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022442;
	bh=Rej/gORME9ziL53Y8qrlh7t+BMtMoZLsXYHQnxy+aPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7zwVLjlDZBVBkk82pmYeS9Xf2OlGDTo9FbxQ6ERXIaC5SQAWRTvqK6/FOzyw5qsZ
	 Sx6YeMb96dPM5G9chrL8J6jMTYzb/SDaa9AFiQVGzPF9GnV1ehAZmpphdWlzlzRNqQ
	 /VmIjvXzhmDAFyvXvGRrr3T4POo1ZDbodbC6uJZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0015/2151] pidfs: prepare to drop exit_info pointer
Date: Wed, 18 Nov 2026 15:29:10 +0100
Message-ID: <20261118150122.198408826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit ad6e3ea683ef4086cdf3d2ec40cb3f6e62edb945 ]

There will likely be more info that we need to store in struct
pidfs_attr. We need to make sure that some of the information such as
exit info or coredump info that consists of multiple bits is either
available completely or not at all, but never partially. Currently we
use a pointer that we assign to. That doesn't scale. We can't waste a
pointer for each mulit-part information struct we want to expose. Use a
bitmask instead.

Link: https://patch.msgid.link/20251028-work-coredump-signal-v1-6-ca449b7b7aa0@kernel.org
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 172658cf6009 ("pidfs: don't let PIDFD_GET_INFO miss a reaped task")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 4341492b91e12..d2afc85b9df37 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -49,7 +49,12 @@ struct pidfs_exit_info {
 	__u32 coredump_mask;
 };
 
+enum pidfs_attr_mask_bits {
+	PIDFS_ATTR_BIT_EXIT	= 0,
+};
+
 struct pidfs_attr {
+	unsigned long attr_mask;
 	struct simple_xattrs *xattrs;
 	struct pidfs_exit_info __pei;
 	struct pidfs_exit_info *exit_info;
@@ -325,8 +330,8 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 
 	attr = READ_ONCE(pid->attr);
 	if (mask & PIDFD_INFO_EXIT) {
-		exit_info = READ_ONCE(attr->exit_info);
-		if (exit_info) {
+		if (test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask)) {
+			smp_rmb();
 			kinfo.mask |= PIDFD_INFO_EXIT;
 #ifdef CONFIG_CGROUPS
 			kinfo.cgroupid = exit_info->cgroupid;
@@ -681,7 +686,8 @@ void pidfs_exit(struct task_struct *tsk)
 	exit_info->exit_code = tsk->exit_code;
 
 	/* Ensure that PIDFD_GET_INFO sees either all or nothing. */
-	smp_store_release(&attr->exit_info, &attr->__pei);
+	smp_wmb();
+	set_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask);
 }
 
 #ifdef CONFIG_COREDUMP
-- 
2.53.0




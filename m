Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058769;
	b=S0YXHAmyBVhlAyVjGgxTu9LYnJkfzGlzSSEgeuK79CSM5rjyv+zr6fxOUwCVe90wgAOV
	 QR46FF4/fdgN8qydlRWIrcJnttFWpwfuME6T06F5CkZzErbPoE7WAYEbMXEFV7wlvJEW8
	 a6+umb3tu6EEJUJ3eFcwNFI5r1K12p/nEHzz0hbwPpocegTeczkXSUH0RhPj6gsGOrDu0
	 xWz6IbGeOIP8sNT2XEX4qLJMi/Ro5G1PdNr99cd769WA8TJifQhn1rsmPHwfTvJ+atgzK
	 frCvILbUbgxjSPhYhmli+Znl9X4iNTqutxGzlP4V9lHF6Ksdn9uf99eSV/Da7KnVKqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zWVUK+FGt4NZLr5AxnJPoKSFUg/fzJxn7zOhSpWhtpM=;
	b=k4gcwVT2EooZppdJQ/PKz4CjH1nYWgueb6uIs9JYUCStSSFd8t4o5IK9EbIohVPgpKzZ
	 qaUG176nudJ5r02jSSyysh20DtpLoHZc6uPH2H3PKrOC5G09fW4og7osroaO6El9HjL3d
	 zvgM5YQBpE1TLPL9UnZI9Og7fbTJETJOct3S8JhgSVPk95mtOCaF3vFnyLvg+aqRCHf3a
	 u3xEOY9tBaYQM6q+nRIww0g678xZMCOtzE+dIJX38GuEuku2EvvZ6ketrsM3PLhqJU4+0
	 HtepkvoCF5OVMbsWeu3+jvydQ2DNQ0xQjXULkkA96Gcevbt7iH+RvpzsJ5nOMPtPsug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILqKPLAu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ECA606A320;
	Thu, 19 Nov 2026 03:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILqKPLAu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337A01F000C4;
	Thu, 19 Nov 2026 03:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058769;
	bh=zWVUK+FGt4NZLr5AxnJPoKSFUg/fzJxn7zOhSpWhtpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILqKPLAuGbHE/899gKv5EN9k1cPNN1W0U5T1Mlwi8jC/apdWrkzg2zN6f7Xn4FBrP
	 NSBwdSjj5yHr/rONWqni/6QD+f7kVLDseHLqbFyq57hEDLLj1EWO4XY+Oi61U7eZJr
	 JowKdr1u5ul9RAm+bEDlPUfWQRBYRClAoOGd83yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0603/1848] mount: refuse setns() with a shared fs_struct again
Date: Wed, 18 Nov 2026 15:44:01 +0100
Message-ID: <20261118145940.554832857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 948e604aca8af30490accf7d46d44814ffa26f80 ]

mntns_install() refuses to switch the mount namespace of a task that
shares its fs_struct, since root and cwd of the others would move to a
namespace they are not in.  It looks at nsset->fs for that.  If more
than the mount namespace is asked for, that is a private copy made by
prepare_nsset(), which has one user by definition; commit_nsset() then
writes root and cwd of the copy to the fs_struct of the task.

A thread of a process with two threads, pidfd of a task in another
mount namespace:

	setns(pidfd, CLONE_NEWNS)			-EINVAL
	setns(pidfd, CLONE_NEWNS | CLONE_NEWUTS)	0

and after the second call the other thread, still in the old mount
namespace, has lost its cwd (/tmp became /) and sees the mounts of the
other namespace under /.

Look at the fs_struct that is going to be changed.  The second call then
fails with -EINVAL like the first one.

Fixes: 303cc571d107 ("nsproxy: attach to namespaces via pidfds")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index fe908cf52986e..8f7f40e3be955 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4259,7 +4259,7 @@ static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 	if (is_anon_ns(mnt_ns))
 		return -EINVAL;
 
-	if (fs->users != 1)
+	if (current->fs->users != 1)
 		return -EINVAL;
 
 	get_mnt_ns(mnt_ns);
-- 
2.53.0




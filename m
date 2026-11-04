Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831076;
	b=aU4vftymscy9nF2WtVAqBi4Rrb2ZODSYwpLh01ormfz7HpSxddp9XoF+uWs32EMsWRyI
	 yg0UPse/igHKK5DwRl4fe10BjiCwdYx3Lyx7+x8TZtrU+BkoSWUYzDOsxeEb559pYmlBb
	 KBcEE3eJsJl7D+Zg8sFKwwMJ/W7YcGwnRo4WA5zpBtlvuA3+YWS+5cpxE6u53OMrzCF0n
	 rS7RjmeVCJghQnIgGA2bTF8IDnJeiOwweOO4b2AJvEhcRXhl1Pjq/jmeOLSZO3bY4RKv7
	 ILqVS4wXTcCbn9QmG83amtPCRVFPzwJxQpEQOphvyBD+PdZQuXUSzhFpKhE9FxEW38w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f8rdjvKdvslN61XtqCB/xEXwqIbZXyS7i2Q2O3JWLio=;
	b=jia7txYWkbf7gSOkdpJ+ldNhzx4upDLS/HghnxBgOIn3vSl6MVv5UGGp6VD5r9IoIpP3
	 XnVX3cSYwvFaNrU3pmwa9Xc7L/bFLI2uOqQ4olJsYsI8KozbZcpZQDuo+KJ9McYT8bQmE
	 5SqC6f0oS8CpnaV6ni9S5uRfnGxbRnz8MTJWpMHHtdCB3IVFH5xQ26pLBirAlX+b+EbHC
	 OuY7ICBhdKG42qJZI/EWGW5qYGdDv/hJLvVB+19Kvev8BHgq8e3NuKwsShifLRVZ7LfMW
	 APFOkW/5ngnh0BbVjdLV5XOt6oDweGx6Gctx1PSNH/gy2j66TGMKVr0aGBaFtNmDfgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sxckl51r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFCC606A32C;
	Wed,  4 Nov 2026 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sxckl51r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAD51F00919;
	Wed,  4 Nov 2026 22:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831076;
	bh=f8rdjvKdvslN61XtqCB/xEXwqIbZXyS7i2Q2O3JWLio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sxckl51rWwR9039zvmEEcZAYfYr+QAhvKKyTMTJLvzrzv56Jw671Eg3Wds0mDLWu5
	 j7Zgj19I3PRUhl/LdjxRVoZTPQBHr3CKGYy+cwFIazi+f+7dskKH4c6XWnm9Dgwf+j
	 +qdyQ/MQDLfP5MZtgaWH8VrL3KdqBKP2iY42Z6+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0491/1005] docs: update the unmount propagation rule
Date: Wed,  4 Nov 2026 16:03:44 -0500
Message-ID: <20261104211057.721344050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

[ Upstream commit 3f5dc09141a7bfe286620a6869d1d70ffe32d6b8 ]

Section 5f still describes the rule propagate_umount() used before
commit f0d0ba19985d ("Rewrite of propagate_umount()"). It states that a
mount that receives the unmount by propagation is left alone as soon as
it has any submount. That's not true anymore.

A propagated unmount unmounts a mount with sub-mounts as long as every
sub-mount gets unmounted together with it. This is the case when the
sub-mounts are unmounted by the same propagation. Only a sub-mount that
cannot be unmounted keeps its parent mounted.

The section also only describes a single mount without sub-mounts. But
lazy unmounts take a tree and every mount of the tree propagates its
unmount from its parent mount.

Link: https://patch.msgid.link/20260923-work-mount-fixes-v1-8-f424cf8d3242@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/sharedsubtree.rst | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/sharedsubtree.rst b/Documentation/filesystems/sharedsubtree.rst
index 8b7dc91590837..8bae6d9a7e047 100644
--- a/Documentation/filesystems/sharedsubtree.rst
+++ b/Documentation/filesystems/sharedsubtree.rst
@@ -564,8 +564,8 @@ f) Unmount semantics
    where 'A' is a mount mounted on mount 'B' at dentry 'b'.
 
    If mount 'B' is shared, then all most-recently-mounted mounts at dentry
-   'b' on mounts that receive propagation from mount 'B' and does not have
-   sub-mounts within them are unmounted.
+   'b' on mounts that receive propagation from mount 'B' are unmounted as
+   well, if every mount below them is also unmounted.
 
    Example: Let's say 'B1', 'B2', 'B3' are shared mounts that propagate to
    each other.
@@ -584,10 +584,18 @@ f) Unmount semantics
 
    So all 'C1', 'C2' and 'C3' should be unmounted.
 
-   If any of 'C2' or 'C3' has some child mounts, then that mount is not
-   unmounted, but all other mounts are unmounted. However if 'C1' is told
-   to be unmounted and 'C1' has some sub-mounts, the umount operation is
-   failed entirely.
+   If any of 'C2' or 'C3' has a child mount that cannot be unmounted
+   then that mount is not unmounted. But all other mounts are unmounted.
+   A child mount that is itself unmounted by the same unmount
+   propagation does not keep its parent mounted. However if 'C1' is
+   supposed to be unmounted and 'C1' has some sub-mounts, the unmount
+   fails.
+
+   A lazy umount (MNT_DETACH) takes a whole tree. Every mount of the
+   tree then propagates its unmount from its own parent as described
+   above, so the mounts that receive propagation lose the corresponding
+   trees as well. Documentation/filesystems/propagate_umount.txt has the
+   precise rules, including the ones for locked mounts.
 
 g) Clone Namespace
 
-- 
2.53.0




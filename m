Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035052;
	b=ktddz1dK2q6eQQ3TQ8WO8dcPl8CKrlWJZElkwlJfGBmqY66yCIWT9I4fGH1dNkxqKXU9
	 0Q+RuhVR3bXBmm9Uj508HaAyCxTZIkko9VMSqTKGJmKU0rxEvkcwTZ58plsLH7SzA2t4b
	 LNMvMuBLsKJwfSpq+ngni5LFAKvbdQBTVXocgULkG8xXaVu++qF+C4FowcoCsFqwCNc4H
	 u8b9oqZ+p+IERRBFbrFsQPN/j9xuwa3i8wLf4n9QbE9x2+iAwurkm1C+NjTul829l0cSh
	 u9ggQuSFVSUrmTUZcTbi5xP0S8FohHmhWtwm0ci3+STCMx0z9sWbZf7ENCe8sQo1/Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ks8P+FOyBZkUJsexUTyNs1/UDDrRjJ5V7D33oE62hw=;
	b=2ZJOrjb52t14pKcW1PkfjOZqxjOaMnbplj4HP0eFQVm4HXMzpti5vSE3ANMe5HBgDWND
	 CS2o9kwN1jZc2OsJBsdzyBPctTAfN6nDbNF2bWIdrDZSS1lAivjsdCy8CJcu3AZu7S5H/
	 b9FPduMT6M5WjzC0wPCWAaY7iUqSP78CE/Rkv56ihRabvNsA5Y0TlLwiUlN/a6WR5j3Ni
	 pDh3uVnOsKNG5OJisdW57cPVM51VYkFF6nVy2wlLRaUn+RLKRnpKRdoOWZevMV+5SMrMb
	 ESBVQGv9QeuZDRnqXodSFc1JnHLUx4HcdP446OBBMS+iCQC+uWficoNf4iqc7AzsgyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Tn3xm+/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B88606A31C;
	Wed, 18 Nov 2026 20:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tn3xm+/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9F11F000C4;
	Wed, 18 Nov 2026 20:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035051;
	bh=+ks8P+FOyBZkUJsexUTyNs1/UDDrRjJ5V7D33oE62hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tn3xm+/m7wcBu5wR94c9Oq4p/2AUDcYd3PdBk+M9U764BP1EzLr0woK/ToT+u7nTK
	 TRzLOSqX29Pc6cOA5dkIYPy+D9/PDMjQBpN76CIqFsfNDYXC8+b/SxdD/1CPyA87Zp
	 BqrbM9Mawq/P/F27qsDGJ4IssocPKcWh5UAU6nSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0541/3318] ipc: drop the mqueue mount with kern_unmount() on setup failure
Date: Wed, 18 Nov 2026 15:19:23 +0100
Message-ID: <20261118150333.499142859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit f0e48172a59e517e613b73f73cc35f24fd123aeb ]

mq_init_ns() creates the mqueue mount with fc_mount_longterm(), so its
->mnt_ns is MNT_NS_INTERNAL. When setting up the mqueue or ipc sysctls
or msg_init_ns() fails afterwards, create_ipc_ns() drops it with a plain
mntput(). With ->mnt_ns set that takes the fast path of
mntput_no_expire(). The count drops to zero and nothing ever kills the
mount, so the mount and the mqueue superblock are leaked.

Commit dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
added the first failure path after mq_init_ns() and never dropped the
mount. Commit 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on
sysctl setup failure") tried to fix that with a mntput() but that
doesn't help for a long-term mount.

Use kern_unmount(). free_ipc() open-codes the same thing for a namespace
that made it.

Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
Fixes: 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-5-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index b93280de1dc5c..e703b23127916 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -95,7 +95,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 fail_mq_sysctls:
 	retire_mq_sysctls(ns);
 fail_mq_mount:
-	mntput(ns->mq_mnt);
+	kern_unmount(ns->mq_mnt);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_free_inum(&ns->ns);
-- 
2.53.0




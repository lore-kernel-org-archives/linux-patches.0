Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061825;
	b=vJNDFDxRmXTTxmBGavW/aU1pMBw0MD+C1WiZvK1zNhwYYlIOLvNAEvOhdVYGmLC3ZDIq
	 igkBTfi6NjfIzb3WBPkafsid11bujbJPn8OMleWk+UwMa+BSdJOksiAnCLXMgDToVpiFO
	 whVhpMs/Da/o728tMzCK8nnjgM2nOneSYjhlsbpCQZxwyeOX4FAjfLD0R/o/ES26e9e07
	 ERSoCvBsQl+p9t8GOWK203uWQ5KtGvOipcmBFUBE5JlfYcVu+VrjfV5I7nCptLSYvjjUy
	 xO9p571PeD1Gd5YJmSDiLyZDXBOvtL+erab4drC/pIW/p42mszjMBWLjJanG6uU+GRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Zw5uc0K8sVGhs4LBpFXDWFKrUpfn6vT5YwWsVwta4w=;
	b=qNelEfhKsVls3UeJXeMcoHtw/fPvhUD1SeYPfYXAx/az/xUACHftxZ+QXIfwyrSAx8Xb
	 2rwS/IlIL4X4mqtGJt5rRoaIBfWM6RtySSbBPhiP8i2w+ae2L7o6C+s9TmjjMM2EnfYq1
	 8hwKjPADske/wR1RTvSE3bb9xUKr/sMU6yqlvi7XUeR/OcNs7eC8JUZwvVGw0q75pnOKi
	 cs3TStX3nMQmQlfy38CIng56Smb3VMiqOSGjyfOl51UZXmGSsh3VJCZUEj0Bk4Z4y/yyC
	 g006yX8U/D5f8O6NvO5icYGxWehYvIluenF9CtpUvZv3g7wRDOy+rL7BPemHSNZV44Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxukPgPT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F0C606A326;
	Sat,  7 Nov 2026 14:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxukPgPT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1201F0089F;
	Sat,  7 Nov 2026 14:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061824;
	bh=7Zw5uc0K8sVGhs4LBpFXDWFKrUpfn6vT5YwWsVwta4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxukPgPTPX2ttU69DmO13sUaqsuK8bUJLqw9rLLz2eQgQOdJNP161QExEgOz/BjZW
	 ZN5ah1zy9MnPLOOrcrbigKcfOVAr/msE5Y4Pr5QbRBMAv+8ZPBTtStmlhZ5sI3CDv0
	 oMADK40MMpFdE+WeuohkNK2wEcUTq4FanDyaz0EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zachariah Mithani (AploSec)" <zachariah@aplosai.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0847/1536] ksmbd: prevent share root removal through empty paths
Date: Sat,  7 Nov 2026 08:47:43 -0500
Message-ID: <20261107135021.338615956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9fd1fcbbf84986a7bcf601a2b90540899069d263 ]

A FileLinkInformation request can supply "/" as the new link name.
smb2_get_name() strips the trailing slash and passes an empty string to
ksmbd_vfs_kern_path_start_removing().

ksmbd_vfs_path_lookup() resolves an empty pathname as the configured share
path, without LOOKUP_BENEATH. With ReplaceIfExists set, smb2_create_link()
can therefore remove the share root from its parent before link creation
fails. An authenticated client with a writable share and DELETE access to
a file can trigger this if the share root is empty and the mapped user
has write and search permission on its parent directory.

Return -EINVAL for empty pathnames when for_remove is set, before
resolving the share path or acquiring removal resources. Ordinary lookups
continue to accept empty pathnames for opening the share root.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Cc: stable@vger.kernel.org
Reported-by: Zachariah Mithani (AploSec) <zachariah@aplosai.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Moved the empty-name guard to smb2_create_link() because the lookup helper lacks the for_remove parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9d9540ca97bc8..0ecec7bf31119 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6339,6 +6339,12 @@ static int smb2_create_link(struct ksmbd_work *work,
 	}
 
 	ksmbd_debug(SMB, "target name is %s\n", target_name);
+	/* The share root must never be removed. */
+	if (link_name[0] == '\0') {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	rc = ksmbd_vfs_kern_path_locked(work, link_name, LOOKUP_NO_SYMLINKS,
 					&parent_path, &path, 0);
 	if (rc) {
-- 
2.53.0




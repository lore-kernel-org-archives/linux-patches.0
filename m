Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829281;
	b=mTqDGGsyhWzoUiWaLcBwxnlkkGfsbU7stSjO3PVqLzTElY0CDRGh4cvZ0sOsgcQUEr6u
	 iOufXab5i2FZqwnmihAnMjHbXKNfU88Y1DxzF9m/JbmNjS06MGyd9HXkqpDcscIHbYpTQ
	 QjT+Zwre3Cjdg/4YM5YGMtc0edLVRYcC0UvMwLEXdcbXjPl6XIAgzhQj1vcEFvoeOHeqh
	 HWU11kdNHhWohbCUbbpS1Y0gxb8+P3Olnh0I1m+YYhJYM6F5CtMge9WlFGf2zdZHpg9qN
	 ls4NHJe1ZYK5PIs1r83n7EuRBxi8kKev3PIudOpBFeygv3XtPtONtpfmNm38VEhZdwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wnhbpgf9pYOWaxEmjLg8XC+2GuWdEZ5DrUmO/3gyEFo=;
	b=JVJndA67RgbbWGpkEMVhNxswuihGaTmnbVo17z5JeNkJRODK/0nllWHiVKDUFXCOudLS
	 02I3yjvk09AYtx+lWJGVph09kn5ctJr8sa02nLgemKIiZyojhR8VK/npxeXdIlfDlFEn5
	 xDLfv3SvrZKOGHr/nflY0/Qjmc2ewvvlVa4/foOl4PbnTJQbVWN7zA+N78i6Iqi8IdVZ1
	 hFtMuU3aiRNwBDbxvi8akOF1zY3e/fNUQ2TNWqMTY5iELaXC9jdUwzGdZSqKPa+4Ur9EV
	 Qi1saT9Wm4ncd0PJRzw/MS13Wruwu65u0+LYc0eqDmElx8Jtoa+5gJ1+mXEfbDMSSXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfPkNN1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD6460745A8;
	Wed,  4 Nov 2026 21:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfPkNN1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA981F000C1;
	Wed,  4 Nov 2026 21:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829281;
	bh=wnhbpgf9pYOWaxEmjLg8XC+2GuWdEZ5DrUmO/3gyEFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfPkNN1FCw2zZS1T+r6B9Q5dp+n8zTopoS9cGr0LwzlrxSLhuw4/DuZSLwNgGNVvf
	 Tu4Gdx5++4uOo/mBgeyi0lMk/tW107DLFsnyERmpf7PqZTLdSfrCk8e1MuYKJHfoA6
	 fDM3s3TcH31hCeserZChYqN3BZE1zzzuBYQYd3Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0026/1005] selftests/filesystems/overlayfs: fix set_layers_via_fds link error
Date: Wed,  4 Nov 2026 15:55:59 -0500
Message-ID: <20261104211044.291601279@linuxfoundation.org>
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

[ Upstream commit e5804b1024193c91ff2648403beda882cb4f8b6c ]

set_layers_via_fds.c calls open_tree() directly, but that wrapper is
not provided by all C libraries, so the test fails to link with
"undefined reference to open_tree" on toolchains without it.

Use sys_open_tree() from ../wrappers.h, the syscall wrapper already
used for move_mount(), fsmount() and friends here.  This is also a
prerequisite for building the new idmapped_mounts test added to this
directory.

Link: https://patch.msgid.link/20260615-work-idmapped-overlayfs-v1-8-7381632aa402@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../filesystems/overlayfs/set_layers_via_fds.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
index dc0449fa628f8..d4a645ec88636 100644
--- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
+++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
@@ -624,7 +624,7 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 
 	ASSERT_EQ(sys_move_mount(fd_tmpfs, "", -EBADF, "/set_layers_via_fds_tmpfs", MOVE_MOUNT_F_EMPTY_PATH), 0);
 
-	fd_tmp = open_tree(fd_tmpfs, "u", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	fd_tmp = sys_open_tree(fd_tmpfs, "u", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(fd_tmp, 0);
 
 	layer_fds[0] = openat(fd_tmp, "upper", O_CLOEXEC | O_DIRECTORY | O_PATH);
@@ -633,25 +633,25 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 	layer_fds[1] = openat(fd_tmp, "work", O_CLOEXEC | O_DIRECTORY | O_PATH);
 	ASSERT_GE(layer_fds[1], 0);
 
-	layer_fds[2] = open_tree(fd_tmpfs, "l1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[2] = sys_open_tree(fd_tmpfs, "l1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[2], 0);
 
-	layer_fds[3] = open_tree(fd_tmpfs, "l2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[3] = sys_open_tree(fd_tmpfs, "l2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[3], 0);
 
-	layer_fds[4] = open_tree(fd_tmpfs, "l3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[4] = sys_open_tree(fd_tmpfs, "l3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[4], 0);
 
-	layer_fds[5] = open_tree(fd_tmpfs, "l4", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[5] = sys_open_tree(fd_tmpfs, "l4", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[5], 0);
 
-	layer_fds[6] = open_tree(fd_tmpfs, "d1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[6] = sys_open_tree(fd_tmpfs, "d1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[6], 0);
 
-	layer_fds[7] = open_tree(fd_tmpfs, "d2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[7] = sys_open_tree(fd_tmpfs, "d2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[7], 0);
 
-	layer_fds[8] = open_tree(fd_tmpfs, "d3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[8] = sys_open_tree(fd_tmpfs, "d3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[8], 0);
 
 	ASSERT_EQ(close(fd_tmpfs), 0);
-- 
2.53.0




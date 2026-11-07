Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065609;
	b=OS+tYRDMaK51MWi7MdZF82HBSFrFOScrYpo9Tb6/tTEsvoO8W0Vix7FfpRs7CHQFNyBr
	 1U2/2Voqs8ccLjtnDtP7aeB6x7MyCONxjLiXyglbB8Ktry4FIzOBB7ufsXPNT/owtMQ0z
	 lgss6uUMoxEvSgGt9LqZruso/TrI4ItyqF+T4oDS7vWsR6BD7b3/1L+ePWiBsNZssmQR6
	 sS3hG7I3bbtx5JGCwv537qhCJ0KieDC3VU2yIHJ7o3pv/tJpBmH1QiHujCE9GCOdriN+2
	 MfzfkT+k99MB1UhAAO7+fQX9TD/IKAbYTVR0WCd2qe63VKEgrvMGh2URSeCJvr33xfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nEH/EIf6tk9cSveHiv4tr+sM+pss4MDRaP2dHJGN+EU=;
	b=jW9Skek0VnsRk/7R+AgFZJYdDBw7zXzHmeIKTtVODYjsWFmOa4K0UZxhLZeNuk4xTvPo
	 oosJ6O4SanGy6E/PtnZ+we+p5Zk5dJ3piK6sw3pxJpmFkP5jD0/cDwysrS3Gr/e2mSEWx
	 B4UDZAHJfn+1H3l7li7ZtsI53xdLkUk5lmJXTR+dkV1YQDAxOeB5Lt7BRcJaeBi9OIzrq
	 zg5XVaryZWT7c7rC/2UxYD0sNxfmdIQKoNy+7V0MQI0JazflGGFBEXtd1P90sKIIhhbv3
	 gWe9vnNX4luumg0yf0e6chskJoa8kBHlfZqgIy6tYpX0MRKL4+AFoyoaeolW7ZhuhSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAwsVx7I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF06F606A32C;
	Sat,  7 Nov 2026 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAwsVx7I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A72A1F0089F;
	Sat,  7 Nov 2026 15:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065608;
	bh=nEH/EIf6tk9cSveHiv4tr+sM+pss4MDRaP2dHJGN+EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAwsVx7Iv8dm3jc6dclGgqk0LJE207pjS9imtjmoS7LsuqEf1psx4QjigbQUGiPa4
	 xzVYtzVsO5let3PgyDENXFr5qtGbc9qpN+58DFde67gugLxtS1bPcX3EmdZid3YLFG
	 y60qfiwfO+7sNdorU4MphGkFDKqygOEfcGpznoC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Edvard Conrad <edvard@tuta.io>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1250/1257] fs: let backing files inherit FMODE_NONOTIFY from the user file
Date: Sat,  7 Nov 2026 08:59:06 -0500
Message-ID: <20261107135013.843339976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edvard Conrad <edvard@tuta.io>

[ Upstream commit c3d355f427cea70fbe31b49e21f1915dbf37f2e6 ]

When fanotify reports a permission event, copy_event_to_user() creates
the event fd with dentry_open_nonotify(), so that the listener's use of
that fd does not generate further events. If the event's path is on a
stacked filesystem, the stacked filesystem's ->open() opens the real
file with backing_file_open(). Since commit ebe559609d78 ("fs: get rid
of __FMODE_NONOTIFY kludge"), FMODE_NONOTIFY lives in f_mode only and
the backing file does not inherit it: it is allocated with the default
fsnotify mode, and fsnotify_open_perm_and_set_mode() raises FS_OPEN_PERM
on the real path if the backing filesystem has permission event
watchers.

Before that commit __FMODE_NONOTIFY travelled in f_flags, and overlayfs
copies the user file's f_flags into the backing open
(ovl_open_realfile()), so the backing file was exempt implicitly. Commit
bc2473c90fca ("ovl: enable fsnotify events on underlying real files")
relied on that when it dropped FMODE_NONOTIFY from OVL_OPEN_FLAGS.

The nested event is queued to the same group, from inside the
listener's read(2), and can only be answered by another reader thread
of that group. A listener holding filesystem marks on both the stacked
and the backing filesystem therefore deadlocks as soon as all of its
reader threads are inside such a read(2) at the same time, and every
other task that touches a marked filesystem queues up behind it.

Observed with a commercial anti-malware agent (16 reader threads) on an
ostree/composefs host: / is an overlayfs whose data layer is the ostree
object store on the same btrfs that holds /etc and /home, and a
systemd-sysext overlay sits on /usr. Every on-demand scan of /usr wedged
the whole machine until the group was killed. Stack of a blocked reader
thread on 7.2.7:

  fanotify_get_response
  fanotify_handle_event
  send_to_group
  fsnotify
  __fsnotify_parent
  do_dentry_open
  vfs_open
  backing_file_open
  ovl_open_realfile [overlay]
  ovl_open [overlay]
  do_dentry_open
  vfs_open
  backing_file_open
  ovl_open_realfile [overlay]
  ovl_open [overlay]
  do_dentry_open
  vfs_open
  dentry_open_nonotify
  copy_event_to_user
  fanotify_read
  vfs_read
  ksys_read

Userspace cannot avoid this: the backing open happens while the kernel
builds the fd, before the event is reported, and fid reporting is not
available for permission event classes.

Make a backing file inherit FMODE_NONOTIFY when the user file it is
opened for must not generate events. This restores the pre-6.14
behaviour for the fds that fanotify creates (and for any other
FMODE_NONOTIFY file), while ordinary opens through a stacked filesystem
keep generating events on the real path, as intended by bc2473c90fca.

Verified with a self-contained reproducer (private tmpfs lower layers, an
overlayfs over them, FAN_OPEN_PERM filesystem marks on the overlay and on
one lower layer, a child opening a file through the overlay) in a qemu
VM on this tree built with defconfig plus OVERLAY_FS, FANOTIFY and
FANOTIFY_ACCESS_PERMISSIONS: without this patch the listener's read(2)
never returns and the child's open is released only by the listener's
death; with it read(2) returns, the event is answered and the open
completes.

backing_tmpfile_open() is left alone: its only caller is
ovl_create_tmpfile(), whose user file is a regular overlayfs file.

Fixes: ebe559609d78 ("fs: get rid of __FMODE_NONOTIFY kludge")
Cc: stable@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Edvard Conrad <edvard@tuta.io>
Link: https://patch.msgid.link/P58Wrer--F-9@tuta.io
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/backing-file.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 83f0ba241fb0b..4f6b3b588f74d 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -55,6 +55,17 @@ struct file *backing_file_open(const struct file *user_file, int flags,
 	if (IS_ERR(f))
 		return f;
 
+	/*
+	 * A user file that must not generate fsnotify events (e.g. the fd
+	 * that fanotify creates for a permission event with
+	 * dentry_open_nonotify()) must not generate them through its backing
+	 * file either. Otherwise a listener watching the backing filesystem
+	 * gets a nested permission event from its own read(2), which only
+	 * another reader of the same group can answer.
+	 */
+	if (FMODE_FSNOTIFY_NONE(user_file->f_mode))
+		file_set_fsnotify_mode(f, FMODE_NONOTIFY);
+
 	path_get(user_path);
 	backing_file_set_user_path(f, user_path);
 	error = vfs_open(real_path, f);
-- 
2.53.0




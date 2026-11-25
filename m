Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619422;
	b=4XWJWc3jrAAfg3hsOyWhzAINSYvJraxkKUQLNXJANNqm/MyvU/mEQuigLNPzoS1VjvHt
	 I1xa3Jjyz4AFi6e/7vI0YLRXYnYeGa28UznyNn9WCGgZPaipAzhb5ByauGJbM4xeO5HVC
	 5eD5EYoK7z3vnpXepqKsr6F3LQGLbYd3+SfBsAvNT062jxvQqByYhp/STFO0wvzLxoVRz
	 XfJ647FutqtwFRd7ZJqcV6XoYVg07LWySjQq6CFD4K11z57gWLsXGf7waGgpTtg1C3ER2
	 zgf1ufqv6eBP7YbstYjlIsNJG2/0QHSisrUO0hnoMnSpeJ9TOlIy3oI72eEklf9kUMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5+Jpwvwanuj61rCvSeBC0h1iIVLGpRQHG42W3hJKhyY=;
	b=zN0ZoFFMiI70C0PtW8qVbfZbA/TmlVEoX8+O4VzKhZLIC97//qyxuFFqAr1ocGseU1ht
	 MMNIpy/Hdr/5P4i2w4eELYIjyFp1Yjwlcl+H5lGGKDLpnIvJyngYceEP3i/W4QOmFP6gs
	 E5iIh/EMOieqxqgdL0ChMB5KTY78cdgT4Ix0WCanTARSeGJDIQEP/dD9CsAC83hXrOQYc
	 YcHrVXzQcw70A+9RthzxOovXsX/hgjbQjEeTYU6pVEuHYiHjrPfgEMia4klQIaZnLXnY+
	 oU5rwBT0e2YTidf633usIkNNjWukyLasLF6BrMqaEC+CjaqIFotOfi2qrRfncsQ1PEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lG4nPuoB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC060606A31E;
	Wed, 25 Nov 2026 15:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lG4nPuoB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089331F000C0;
	Wed, 25 Nov 2026 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619422;
	bh=5+Jpwvwanuj61rCvSeBC0h1iIVLGpRQHG42W3hJKhyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lG4nPuoBnQR82Tx/A39ogJ8YG74EsDB+9ZEAXhdrrrbdXwIfGSfFNVIGPP1iG7EY0
	 1j5TA6MLrpG0HeVue2uGGjVc6Qnu3+fbyw9eb6NK3OhiSSzUYvVl0PQB9RJPGsWwFL
	 N3c9HeQmBfS8RdkMbH4Zc+DI2//IEQScrYwUooaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Chen Linxuan <me@black-desk.cn>
Subject: [PATCH 7.3 0589/1005] pidfd: restrict task access ioctls to the callers pid namespace
Date: Wed, 25 Nov 2026 15:32:07 +0100
Message-ID: <20261125143835.544318392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Chen Linxuan <me@black-desk.cn>

commit ee8323fdc827c580425644db605a4be776cace57 upstream.

pidfds can cross pid namespace boundaries: a task may obtain one for a
process outside of its own pid namespace hierarchy through SO_PASSPIDFD
or SO_PEERPIDFD, via SCM_RIGHTS, or through file descriptor inheritance.

The namespace ioctls gate access with a ptrace check against the
target's credentials only. That check does not account for the pid
namespace relationship between the caller and the target, so a task
inside a pid namespace can use a pidfd obtained across that boundary to
acquire namespace file descriptors of a task outside of its hierarchy.

procfs exposes the equivalent information only for tasks visible in the
reader's pid namespace, and PIDFD_GET_INFO already answers with -EREMOTE
for targets outside the caller's hierarchy. Extend that policy to the
namespace ioctls: fail with -EREMOTE unless the target is visible in the
caller's active pid namespace. Callers in ancestor pid namespaces are
unaffected.

Unlike PIDFD_GET_INFO, the visibility check is performed after the task
lookup here, so reaped targets outside of the caller's pid namespace
hierarchy answer -ESRCH instead of -EREMOTE.

Link: https://lore.kernel.org/all/CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com
Link: https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: Christian Brauner <brauner@kernel.org>
Fixes: 5b08bd408534 ("pidfs: allow retrieval of namespace file descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Linxuan <me@black-desk.cn>
Link: https://patch.msgid.link/20261027-pidfd-task-access-v1-1-d46cf0fa4ca1@black-desk.cn
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -591,6 +591,14 @@ static long pidfd_ioctl(struct file *fil
 		return -EINVAL;
 
 	/*
+	 * Require the target to be visible in the caller's pid namespace
+	 * for operations that grant access to its resources, mirroring
+	 * procfs and PIDFD_GET_INFO.
+	 */
+	if (!pid_in_current_pidns(pidfd_pid(file)))
+		return -EREMOTE;
+
+	/*
 	 * We're trying to open a file descriptor to the namespace so perform a
 	 * filesystem cred ptrace check. Hold @task's exec_update_lock for the
 	 * duration of the ptrace check and the namespace lookup so that the



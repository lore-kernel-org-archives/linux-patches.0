Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052951;
	b=VWzG09GiT/2uCDhhgetDno2p2XRSwh78KWXR2T9c0/857Zu1OxY06z0gG4ECtcPt8S1b
	 bU5wOYXhoEHZ18yNkTyeb5md/EpVyKudTNOUJKgQKcAxhEwtVsdbjNtuIGuptavxwssig
	 tElrK0+A7Rlylp4yi4feIUrQyOSn1lmym2DZCx47BDMbHCCWndmkRqpPkCodTvdEsoL2n
	 5EYzaWXVZZskfIAGwNspU14siunSd0A/je3ztaIuvi4mU08YWcyO7xn+yM2RsxM/5YW0a
	 mLs9AbwpPtuKfYpUWR+GiT2qsDgBSN1de7NUskHWBTPHZJxx/mJx121FZ8+0QpIynPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nqbXnRUuH/sI7DYipd+2MkqjtUsywy65y6sJekJrjs0=;
	b=E/LrCQfdfW9czdSI+VlX9v3luOqofr+03XqxgWYUC8f3wvSb2joME/WJyeHd1miuu7e6
	 8Z0mW/3Y9OT7AkQe6UdwiykLfbTYaGHad4/M5PQhJfonaPKjomVXb07mPHgJummdB8mFb
	 HtHN0Fdv6W4NV6fHz979B/T5oLSB5c8zWxS/5BiaspCqEp3+Mf3OkuE3/LqKdJfLeHQtp
	 FfJBNMU39LA/Dxo/J7sAW7kFZKC2VkHR5tumxb1BiWYWO8YixgKPZGoK+rupdV5+e9K/f
	 ky6q9HzTKOk1y8H/kCLXgnGAQ2biiGjO7/SnAg4ww53ibAWxph0sNqD43pAG4lSZ7bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uE0dU2U2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69131606A325;
	Thu, 19 Nov 2026 01:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uE0dU2U2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24111F000C4;
	Thu, 19 Nov 2026 01:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052951;
	bh=nqbXnRUuH/sI7DYipd+2MkqjtUsywy65y6sJekJrjs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uE0dU2U2VgB9pA1X/Ac0SdIJt9Qui65D7i8p0RuiTE+XxeRCIRMznEy05dwnLolht
	 VTNizuolSZ1e9U+k0kbY756iGsX0G81iSfekJyvANk3NBFDoWz3/avAR+WqNnjlMwQ
	 AcJ5JW2htwVE2shqO62Z6ly4raTRu2XGgGQwKO7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0747/2214] mount: refuse setns() with a shared fs_struct again
Date: Wed, 18 Nov 2026 15:40:23 +0100
Message-ID: <20261118150041.677127362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 542ac0d7cc106..776c4c065b447 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4706,7 +4706,7 @@ static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 	if (is_anon_ns(mnt_ns))
 		return -EINVAL;
 
-	if (fs->users != 1)
+	if (current->fs->users != 1)
 		return -EINVAL;
 
 	get_mnt_ns(mnt_ns);
-- 
2.53.0




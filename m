Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213535;
	b=WJkXhElftbiYEfzoR6BSDDsXy6/P4WEhaVRWX6zAnL6dQa0l/2OJPL5bS4yb70CyaA8R
	 NpOb+95nDdwzKCMSS2IzAAsIjkxNEXhS5vaYDUiw/oI+yY51QQM8+/oTZ8t44zq3NKiZ5
	 AirQgiRrhiSktj9lB81JWZvGrHCZHPPoTximhnAE40kqXShMUTi9+nl1qVJvU0qrdkeUR
	 W2CqNDdq3INXx4wTQid0FFFCPnjBWgncjiGhBcWNGq+eHwAuOsVIGaY5wo55W6Jm2Yhx6
	 Sxh2Yxihdf1bgz4garbmvWb2lfCJDYZvX4ryGg+Iuo82jTZsecW3e2SISQfYtaZtwWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RgYegk7AIiBxZMZC48GMloweGxYXiZDVOg4lcSM70eU=;
	b=22HgPPxitYlCF1y4gAa2yjHIDUJvSgvo0TEZ4UF7yA11I6xzRSi0K3K6+tz40VYZxnmX
	 ygScGhnTwXTKlIF7YmSwCrd/S8w47t8UYzwBKzDPSGa9bhZDbhs1IyJe5hlwtWJW8SLRI
	 s5vEMqFb8//i5+e+mT1Ag6Y2ib6IVH3lUo0T27z44NNtENTBQ+V2KlHWKZVY5EwmfHE7B
	 +n9WftIgrnDQndLAgexl5AK1GyHkShL9Zk+H3+39Oy2wslfUOkprZJyVkQJSk8qJ+vSO5
	 rJM+u2Qk8j5BvN5aXviBjux0SJAyn60NMoYSCJfOGRh0kW9/jfrZ7wni56NcDUtDRRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcl6AxOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C776606A323;
	Wed, 28 Oct 2026 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcl6AxOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822AF1F01829;
	Wed, 28 Oct 2026 18:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213535;
	bh=RgYegk7AIiBxZMZC48GMloweGxYXiZDVOg4lcSM70eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcl6AxOQhNYn5xUACBYaoCRudS78/AU9OshDyxjzFEVao6jiRF7EfTPpvLYA/g5oO
	 mfk45PVvUBoWO4TtbSlHc/Cnu1+jfANQF9CqgIeZpbbLu8Vw6avN5KPrImhXL3X+J9
	 9cDwdzvfXkwrR6e+Dla1+K1L4LbSlux7vKL/PO5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0541/1887] namespace: dont copy an unmounted mount tree
Date: Wed, 28 Oct 2026 17:43:57 +0100
Message-ID: <20261028170511.665807109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 8bacbf6be959973b28b691713a872c12eae69eec ]

may_copy_tree() accepts a mount whose root is an nsfs or pidfs file
before it checks whether that mount is mounted. This exception exists
for nsfs and pidfs mounts. They are part of no mount namespace so
neither check_mnt() nor is_mounted() would let them through and
bind-mounting a nsfsfd or a pidfd wouldn't work.

Problem is that exception also admits a bind mount of such a file when
it was lazily unmounted and is only kept alive by a file descriptor:

  mount --bind /proc/self/ns/net /tmp/x
  exec 3< /tmp/x
  umount -l /tmp/x
  mount --rbind /proc/self/fd/3 /tmp/y

With MS_REC or AT_RECURSIVE copy_tree() doesn't stop at the unmounted
mount. It copies every mount that stayed attached to it as well. So if
you have a bunch of overmounts over the nsfsfd or the pidfd the whole
unmounted stack is copied. That's a bug.

So refuse to walk an unmounted tree. Copying its root alone stays
possible. So a bind mount of a namespace that is gone can still be
recreated from a file descriptor on the old one. The file descriptor
pins that mount and its root and __has_locked_children() only reads the
direct children which don't leave the parent's list without
namespace_sem. The internal mounts carry MNT_NS_INTERNAL instead of NULL
and are still walked. Copying an unmounted tree recursively fails with
EINVAL.

Fixes: e149ed2b805f ("take the targets of /proc/*/ns/* symlinks to separate fs")
Fixes: ef4144ac2dec ("pidfs: allow bind-mounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-4-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: adjusted context for inline mount validation instead of may_copy_tree() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1cbab4e3c75fc..f2729ffdc5c52 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2435,6 +2435,9 @@ static struct mount *__do_loopback(struct path *old_path, int recurse)
 	if (!check_mnt(old) && old_path->dentry->d_op != &ns_dentry_operations)
 		return mnt;
 
+	if (recurse && !old->mnt_ns)
+		return ERR_PTR(-EINVAL);
+
 	if (!recurse && has_locked_children(old, old_path->dentry))
 		return mnt;
 
-- 
2.53.0




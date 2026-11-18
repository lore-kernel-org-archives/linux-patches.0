Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015738;
	b=tF8QwQRh1CRNTNcncbgsSUEJuk6XVjUTf7WKNsrK8/IytiSM5OTocKgWNiP0xfRBswBx
	 o8SSx8bD7D39jzMDqvLwGaVZ+6d3yb+fJtu4dUYv3k2x+tMK3x2KRGJyU3Hv69WxQ2g5K
	 SZqjyhTAeQlrhI7G1Ywb8Uh1dQrOXPf1oFcpxNwkwOkI6j+E+4Yis3evkd/F+smjT9d+R
	 D2sxiP2Cx7eCVG7L+T0+Orf91SkQ/cMhbAu3oWEX8p8NHVE/VyGjB29WwCf4OqQ+kIrjK
	 KroTRFMTfdvwb8N11OAZWQF9AgkXaXAdLdzKnQATp5L2K9MitumJplazLfXQaK002Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S6e3pxxI43fIQNysQfX2PyHoWHQiqMv42YKh9lFbS2c=;
	b=Gc8WA6IktDkdTpkF3bjeC6Xc5SZS2CfC9G3XOcKgz6O5LYgSkeCcghgzLCDeY3hvihwH
	 B/mlHb3JR8mJ+t4ERC5wra+IXgXyHzfC4Q6agUe35gC2nKdjGsRUFGVHSiKC6MlxmMLip
	 CGBdsx2+FssZxLZX5hiqqT/TQn4CfdXk4+ffmI3/5jND3yavedoARhtQ2z1K14KrKTr2L
	 wYOJHVAqueFaokj2yrC8TXEeJVTv02aGSLKtnGa0ZKzX3fEOVYXONmvn3P+Ud8/cOCvlz
	 UK03ZxSAfjXoT+msbyT6nY24uX7nqVgkl5xhzXF26kGiZXe0QMgwaVJsLyAXqdNaO1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qd+pps//";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB8B60A2602;
	Wed, 18 Nov 2026 15:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qd+pps//
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542B81F000C6;
	Wed, 18 Nov 2026 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015737;
	bh=S6e3pxxI43fIQNysQfX2PyHoWHQiqMv42YKh9lFbS2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qd+pps//lfrk6aKThbKY53JDmi3L5EQN9+0gdIECBrlx8nxneKr27XuWnAv17pJ/7
	 HAxjYUryHp6EpYTQJwH+hsVArAc9QaclZGg9bqE1hELXscZ+m55QZp8EMSvHE/+uzO
	 L6nVpd6GZdJd7kA4/qsIoSTbKOCNjHRRuCuj100I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0279/2651] cgroup: Return -ENODEV consistently for a dead cgroup
Date: Wed, 18 Nov 2026 15:25:19 +0100
Message-ID: <20261118150257.958436854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 22098e3b6f7260860d61523a8dc2964b40559763 ]

cgroup_kn_lock_live() returns NULL when the cgroup behind a kernfs node has
already been removed. Most callers turn that into -ENODEV, but the
cgroup.type, cgroup.max.descendants, cgroup.max.depth, cgroup.pressure,
cgroup.freeze and cgroup.kill writers return -ENOENT. The divergence is
accidental. Return -ENODEV from all of them, matching cgroup.procs and
cgroup.subtree_control.

Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: c367ce5b31ff ("cgroup: Make the offline drain interruptible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2d582603a7114..14c069fd56a0f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3791,7 +3791,7 @@ static ssize_t cgroup_type_write(struct kernfs_open_file *of, char *buf,
 	/* drain dying csses before we re-apply (threaded) subtree control */
 	cgrp = cgroup_kn_lock_live(of->kn, true);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	/* threaded can only be enabled */
 	ret = cgroup_enable_threaded(cgrp);
@@ -3834,7 +3834,7 @@ static ssize_t cgroup_max_descendants_write(struct kernfs_open_file *of,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	WRITE_ONCE(cgrp->max_descendants, descendants);
 
@@ -3877,7 +3877,7 @@ static ssize_t cgroup_max_depth_write(struct kernfs_open_file *of,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	WRITE_ONCE(cgrp->max_depth, depth);
 
@@ -4193,7 +4193,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	psi = cgroup_psi(cgrp);
 	if (psi->enabled != enable) {
@@ -4269,7 +4269,7 @@ static ssize_t cgroup_freeze_write(struct kernfs_open_file *of,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	cgroup_freeze(cgrp, freeze);
 
@@ -4331,7 +4331,7 @@ static ssize_t cgroup_kill_write(struct kernfs_open_file *of, char *buf,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	/*
 	 * Killing is a process directed operation, i.e. the whole thread-group
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481374A8A37;
	Mon, 31 Aug 2026 13:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183944; cv=none; b=GWeB0o6ve166A2gtBPDFUPc6HFp6D4iH5+dctbYxLdvx+GZsGXblndYMxfFbi2NsgrwR62vR+5V51Lfog2efvOrCNaipB35gdvkgzM73DHnMJKinC0XG+0xzMCjwimBH9uBAh7NRF+AvCdt8dT7VcNpiePztDFH/VM0HyqpaIZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183944; c=relaxed/simple;
	bh=TT+F/1AH4WCi2N1ccSs17jxS88YNy8Hy//a8Rv777kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i8k09chZbLRlDdfhSGqq/yih1O0EsjO53/78ySsVXd9LpyVvISPdGFCURQlFv1hxExAP2bGJFurZ7aI8FCJXwVgzjEPoK33L2wkLzlInpYC3zuaxhN8cQ90tZgjJeOldoB4wOe4Ixp02xLQp4V+jdm9kUjWyWQOdDd3HSRTwRss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AT4ltAiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AT4ltAiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4D91F00A3F;
	Mon, 31 Aug 2026 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183942;
	bh=NENeYrjZ5kbWMg+6Nhmv/gEaDsUYhb0bG1JCHfNhYuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AT4ltAiHzJfXJfD2K92JqWBAdLQ8Tvc4Gg3yJeTo0Mlhbp4H5+doboTgSRzFDBDtz
	 0JeTmF7X/blSFwsPi40MIk27FmRwedUvsIGgmmt1GUrM7/mH7TqRbEPXDk1i7Hkoo9
	 OGbvJhdZGQl4F7Rj4gurAgxCKeEFe8TJzmT5SyZf4LMaoogyc9Gg2YZLhXD0Dip241
	 HvEF5d6QxeZvZmLy1AUg4D7two1HBEGZxZYoN6Q6+yGvSq+7XSiMO2ieO8pUa+8e3J
	 iywiz2S7bIPo2PWa90k/Ig0VmB8yjx4NrmNwWOMMOJnrZjJVoHPxoSNxqfvZQfE7Rf
	 N+C+K2PT+cVyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] thunderbolt: Don't create multiple DMA tunnels on firmware connection manager
Date: Mon, 31 Aug 2026 09:27:02 -0400
Message-ID: <20260831133314.4125787-394-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit cf0c38ee554c3e9062408cc3a38325483d52ecd0 ]

Firmware connection manager supports only one DMA tunnel per XDomain
connection. Firmware prior Intel Titan Ridge failed the operation
directly but the same does not happen anymore on Titan Ridge and
forward. For this reason add an explicit check, and fail the operation
accordingly in the driver.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Background task results:

1. **`git log --all -S` (failed)** — The search with `--all` hung and
   produced no output; it was killed.

2. **`git log -S` without `--all` (succeeded)** — Completed in ~52s. In
   this 6.18.y tree, `icm_fr_approve_xdomain_paths` shows up at the
   `Linux 6.18-rc7` import (`ac3fd01e4c1ef`) and the bulk history point
   `19eef1d98eeda`. That confirms the ICM XDomain approve path is
   present in this tree; it doesn’t give a clean “introduced in mainline
   at commit X” answer because of how this checkout’s history is
   structured.

3. **Kernel.org subject search (succeeded, empty)** — A grep on
   torvalds/linux.git for the commit subject returned only the cgit page
   shell with no matching commits, so the patch wasn’t in mainline
   master at search time (or hadn’t landed yet).

None of this changes the earlier **YES** verdict: the buggy ICM path
exists in 6.18.43, the fix isn’t present, and the change is still
appropriate for stable.

 drivers/thunderbolt/icm.c     | 10 ++++++++++
 drivers/thunderbolt/xdomain.c | 25 +++++++++++++++++++------
 include/linux/thunderbolt.h   |  2 ++
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index f213d9174dc57..961d66c2f81db 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -587,6 +587,11 @@ static int icm_fr_approve_xdomain_paths(struct tb *tb, struct tb_xdomain *xd,
 	struct icm_fr_pkg_approve_xdomain request;
 	int ret;
 
+	if (atomic_read(&xd->ntunnels) >= 1) {
+		tb_warn(tb, "only one tunnel is supported by the firmware\n");
+		return -EOPNOTSUPP;
+	}
+
 	memset(&request, 0, sizeof(request));
 	request.hdr.code = ICM_APPROVE_XDOMAIN;
 	request.link_info = xd->depth << ICM_LINK_INFO_DEPTH_SHIFT | xd->link;
@@ -1157,6 +1162,11 @@ static int icm_tr_approve_xdomain_paths(struct tb *tb, struct tb_xdomain *xd,
 	struct icm_tr_pkg_approve_xdomain request;
 	int ret;
 
+	if (atomic_read(&xd->ntunnels) >= 1) {
+		tb_warn(tb, "only one tunnel is supported by the firmware\n");
+		return -EOPNOTSUPP;
+	}
+
 	memset(&request, 0, sizeof(request));
 	request.hdr.code = ICM_APPROVE_XDOMAIN;
 	request.route_hi = upper_32_bits(xd->route);
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 1eb149445fa05..e2c46366c8160 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -2021,6 +2021,7 @@ struct tb_xdomain *tb_xdomain_alloc(struct tb *tb, struct device *parent,
 	INIT_DELAYED_WORK(&xd->state_work, tb_xdomain_state_work);
 	INIT_DELAYED_WORK(&xd->properties_changed_work,
 			  tb_xdomain_properties_changed);
+	atomic_set(&xd->ntunnels, 0);
 
 	xd->local_uuid = kmemdup(local_uuid, sizeof(uuid_t), GFP_KERNEL);
 	if (!xd->local_uuid)
@@ -2302,9 +2303,15 @@ int tb_xdomain_enable_paths(struct tb_xdomain *xd, int transmit_path,
 			    int transmit_ring, int receive_path,
 			    int receive_ring)
 {
-	return tb_domain_approve_xdomain_paths(xd->tb, xd, transmit_path,
-					       transmit_ring, receive_path,
-					       receive_ring);
+	int ret;
+
+	ret = tb_domain_approve_xdomain_paths(xd->tb, xd, transmit_path,
+					      transmit_ring, receive_path,
+					      receive_ring);
+	if (ret)
+		return ret;
+	atomic_inc(&xd->ntunnels);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(tb_xdomain_enable_paths);
 
@@ -2327,9 +2334,15 @@ int tb_xdomain_disable_paths(struct tb_xdomain *xd, int transmit_path,
 			     int transmit_ring, int receive_path,
 			     int receive_ring)
 {
-	return tb_domain_disconnect_xdomain_paths(xd->tb, xd, transmit_path,
-						  transmit_ring, receive_path,
-						  receive_ring);
+	int ret;
+
+	ret = tb_domain_disconnect_xdomain_paths(xd->tb, xd, transmit_path,
+						 transmit_ring, receive_path,
+						 receive_ring);
+	if (ret)
+		return ret;
+	atomic_dec(&xd->ntunnels);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(tb_xdomain_disable_paths);
 
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index 7204586c10c3e..466f315f0be7b 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -230,6 +230,7 @@ enum tb_link_width {
  *				changed notification
  * @bonding_possible: True if lane bonding is possible on local side
  * @target_link_width: Target link width from the remote host
+ * @ntunnels: Keeps track of how many tunnels go through this XDomain
  * @link: Root switch link the remote domain is connected (ICM only)
  * @depth: Depth in the chain the remote domain is connected (ICM only)
  *
@@ -276,6 +277,7 @@ struct tb_xdomain {
 	int properties_changed_retries;
 	bool bonding_possible;
 	u8 target_link_width;
+	atomic_t ntunnels;
 	u8 link;
 	u8 depth;
 };
-- 
2.53.0


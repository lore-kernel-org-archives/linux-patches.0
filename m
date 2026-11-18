Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019408;
	b=p4QXWNJNNVfUe/wz+WSlQgRboxYqGwETqXWxWahZXubY56kCIvxtRWOWlTWto08pGeD2
	 WE/o8mM08mSvQYNF9yVv3n8EKP4qvjnC4dFYWkqzHvSLUL9okjahEd4G8Od3QDWcyysKP
	 L2lkTEnc2fXCJ7xoq12swgMkDsDE2xR8+jrboaRABOZ/3xI8zbjs99Zu/KeDE+HBpXAKz
	 gTrjSVNGduLrkj4VNeMbY1h8/uzYLd9tkTaA/NI0YtpFFZlEDSwTvesR7AgRJjoaGDvFE
	 6FZAGNQyWuxOAumNrNCTv8UCbYeaF3W2IukmZ57CXxeBw3GVjNaaStfNBsD3yo3Bwyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p8HB8wDpZTPE85rkdIxasqSYVDqG2gBapR/5dn1gOJo=;
	b=OI/28NCoyatPUcTnzN23O5NT8bWUDZXeHRZ8I2yLpBoidOL5nW7h05Kqo1sIXukXczK1
	 34p7/uepay/42PjLqx4PSS/7/lCfdozWmV6RRmTkyb5HAQCs4CY2pEIi3tSzucELuF7KF
	 r0GWAA+zqIJvP8gcdjtNjOnHXbbpMzLhNuOC8+iMGXJ2rgjVrtNv59mbF+USS0PlPOErc
	 0RJ0nae7RlP0/CQZ4toeLg63UR2avoyQ0YPU27XmDcMPblf6wa8rUZd2ThWKi17W9CKmi
	 7J0rTtFqxsUKIE+oE3dZtYIvt+w54YvDZ73k883VqJb0Lh1nYFPL+XdubrQOH7pdegg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoB5U4q3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631D160A261D;
	Wed, 18 Nov 2026 16:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoB5U4q3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57461F01832;
	Wed, 18 Nov 2026 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019408;
	bh=p8HB8wDpZTPE85rkdIxasqSYVDqG2gBapR/5dn1gOJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoB5U4q3ZnpdLurOg8V5Wm4i8/xs+FNojtp5PvovGOk3ws7DQK79bYfCb38EvsWJf
	 axPvOgQXokuGNhJBmcXKAQXSqfRC2XHPQh7nBcur7QIAK5IfLtKF8btPrKFwfqiOCU
	 M/mbcUQYhUveE5n+ZnIpN1X7NYgDJ1piOUCcoRO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1586/2651] fs/resctrl: Ensure default group reports tasks on monitor-only systems
Date: Wed, 18 Nov 2026 15:47:06 +0100
Message-ID: <20261118150345.014382293@linuxfoundation.org>
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

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 2c10b3fa5bdf61e344bc522e6c2e00d870ce7ab8 ]

resctrl can be mounted on a system that supports monitoring but not allocation.

On such a system reading the "tasks" file in the default group reports no
tasks, even when there are tasks assigned to the default group. This problem
occurs because the check for whether a task belongs to a CTRL_MON group is
gated by a check for whether the system supports allocation.

The resctrl_arch_alloc_capable() check in is_closid_match() breaks task
reporting for the default group on monitor-only systems so remove this check.
On systems that support allocation the check is redundant.

Fixes: e6b2fac36fcc ("x86/resctrl: Use is_closid_match() in more places")
Closes: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://patch.msgid.link/20261009193923.15498-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/resctrl/rdtgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dcbb0a964e81..6733ed174f518 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -685,7 +685,7 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
+	return (r->type == RDTCTRL_GROUP &&
 		resctrl_arch_match_closid(t, r->closid));
 }
 
-- 
2.53.0




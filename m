Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026091;
	b=Ye0APTKAdh/lPYpClMMPcbuFX7+Yt3unj6WIT4PWl68ehEy7XbC824FSzttlDGXtxeWy
	 Ai1VbdlpTvhoAenZ6nITky5Mq62JDBNA6AezIjtKlOU8KY60kvQbNGZtwxeMlQsGqvznh
	 s1tVgiBv35tCU6yzxt4xFidM6kWRasfEy4cFGfEqwUFNa/TkrIMnuG6mkkQGIF4V3MWQf
	 qmKHGgYF2N4M6KW1+ikZEApXcYwFQUi5EIcTQJWH8qtnd6lR66jOXTTa6j7pYJkDb0LNs
	 jmy0jTFOd4fRhq7175paGZ7Akeq1bPG4vWCyHGkH2borV/l4cqdE5lsrIwjE1FLtPLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W3HRqvqx7J25SMpHNlHLLXeiasAlWzcOZQn+OqEc5Xw=;
	b=HZkGDlrnbWAeEU5+z3HqVFgbjTMHV0ipLFwv6o5MHjoQD71NQ5x9tpVwXlLqf5v+sr4P
	 SELSVPwa8g+fBpPU3ggKKwSEJEDvi2ctns60IU81ygE+uURdNrsyDYaI9ojRTp3C9qmNy
	 opGLkm/uu8Q5Zrg8qFpiYJ36489B7oXuWWcjBIi6gaWK5U3tLWFDsc7XVYJdOE8PJmpoV
	 NBnzn0I81V6EO+1zbQkkag3s04m9MvmLfT/ZmiWSytx+znyzBd6U7P927pOsxYxvtwzSt
	 VVIqzPCJZcIyOF8kq/gW4p9duB4L4/k85jSV23fGxlH9n38jZ0eZEUJuJbsRasZ1rZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OiCJAce9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1223B606A320;
	Wed, 18 Nov 2026 18:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OiCJAce9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D8F1F000C4;
	Wed, 18 Nov 2026 18:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026090;
	bh=W3HRqvqx7J25SMpHNlHLLXeiasAlWzcOZQn+OqEc5Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OiCJAce95ZzRB7GkTlapbxQxmiBN5ihUNOseN7P7uWLLye/Q6vB0GkrsouBjU2nsP
	 3LpNJbknhDHZoWW+n1Dkt1veyHmqW7JKYVYvDl31ZOwuhf0iGQpHxZrcGWgCPS54Li
	 /8oDutBYe5qRHNPHT3VgGluRRwkmmpwq0bYJREQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1311/2151] fs/resctrl: Ensure default group reports tasks on monitor-only systems
Date: Wed, 18 Nov 2026 15:50:46 +0100
Message-ID: <20261118150209.857461940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index df92305f2a19b..0d39e268f4a42 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -681,7 +681,7 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
+	return (r->type == RDTCTRL_GROUP &&
 		resctrl_arch_match_closid(t, r->closid));
 }
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625316;
	b=43yk36VRmj4K5JAdeIM3FrBfNEFY+rb6Iadv9B6jA+7f/icT9OC421PxcpgmlTWrVJpT
	 UpwYpp/U6V5eKPIcn0flBfa8cQjAbbc2MouiQ2CT4VjQ4dnBLKlYC/V3+Xduq7M8Ef6uI
	 hYhOw0iGJimcRVfBPnMbs6qcBQOlyHsq+eft+e8h4ufVZve50u9rMHpuxNex7I5DJDvad
	 P6kMFgBj3A22M1wdOGH2wlYnWV8bxbaQpe+qPeDUd64DZYcTsj1jzCj9onqpOI1ReoBbT
	 xYKfQZxcZ7gjjdWAgXaFDZq9PdO+yLGXcBSLvZrXarYfzIImTUoBNCZZgC/hya7xSrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9pp9/ttHZiMDyN7kkwJ/YZzW6u353LcJ1s7sxh4oAlY=;
	b=vhU9tEenTh5CXq6UdXrezaZ6wQNLOLUwFnSooYKvpiYOjn854mEBioyPqKt1Jok923VP
	 uL3aDoQlACBFkBwncxxyqWPywnrRVfg564+mDLZQwztpfF2zl9e9TD7BIW3ng8u5mQuCr
	 pqHrEnpz30f2tehE4V4/YxzNsFubBdGSmkLL/UNlDA/ykdtXhVeTpkoGKyv/S+0dY98EA
	 vC6fb5jIOn1dY9AhZOg2j1h9kun/leqFUpU/3FUJamsCtrzmKKfRjKr9yYg9nfkMuZy5Q
	 v+WUYlkVeYaOctc/9qHi/JRN4R29Ypuz9aQB3XJP/W3lVtFifTz8sNgXBbKh+hHGLUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbOzA72h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CF7606A31E;
	Wed, 25 Nov 2026 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbOzA72h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B0D1F000C0;
	Wed, 25 Nov 2026 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625316;
	bh=9pp9/ttHZiMDyN7kkwJ/YZzW6u353LcJ1s7sxh4oAlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbOzA72hneIQzYn8Zb439mqnJuX9AnnuA5Bbq7AUD7nSix0/ARYhEScb8+DMQ0tQf
	 0T9bhMHzxLjb2sUxv46QbUJaGfNnVl4W1tD1vK4U0wu3/QKxfUjXwyrqNf/X7PfbaE
	 xcnbcA3CvHXWVe2LrOTGxA5s8zJ2Z2JQ4XF+xVeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 477/816] fs/resctrl: Ensure default group reports tasks on monitor-only systems
Date: Wed, 25 Nov 2026 15:33:45 +0100
Message-ID: <20261125143900.240368808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Changed the file path from fs/resctrl/rdtgroup.c to arch/x86/kernel/cpu/resctrl/rdtgroup.c, since resctrl hasn't been moved out of arch code yet; the one-line change itself is identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 868e260947a10..3db3af835471e 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -645,7 +645,7 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
+	return (r->type == RDTCTRL_GROUP &&
 		resctrl_arch_match_closid(t, r->closid));
 }
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AA72DF3EA;
	Tue, 21 Jul 2026 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660238; cv=none; b=D3VPqISC/PQrpw6WPU05CXBbO9xJnRCcoQhzZlYHLqVL99BoeHYmhPrlK5cH0CiVW1udI/tFhZ2qIMdTJ+qdOC17nseDpJwaLYJrPm6+fXfb1sP8fnirmSl7Li9nCnC0ElBT6dCbXEor5j6dI8VHC1TYMtP1yozPIqEmV9WlMRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660238; c=relaxed/simple;
	bh=obg+NQaQs9s1mzXSu0rZ+rY2Qunte73iqxJXp2E70AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCGlvz1NgeK3suzv+AEj/5gBtA3IKf3G6TT6pcH0Ks2Utx+wFpr7JuhE3VtkCqlythXc0uDVxlixs8CVJP/jXPPo6gr7nQhQD77tG2RIS/y++MKHUA8FWdh9t8LzlkhxRj8O5EiXmy6Jc0MkRJn7Qa3Nff8CNyXYZRIEJlWaa/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiqscD64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiqscD64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EA61F000E9;
	Tue, 21 Jul 2026 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660237;
	bh=pE7cRdE4pqjUnKnFbda90sRq3OMty/EJ9LHc7itJa5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RiqscD64eyFSRlJ/68zpjiz8APdPprkwHzILPqn8JwBeMM56n85jbyDsxuKxrGJ4F
	 QSnsFkqL6IQHnuRrQvccIRMqM44DCYdakEPC3/lvX20w0QxMS4g8NGlk/5Fsn2lBLA
	 CxboWcd+/UPIowHkxwQ0fUwQXBESSdSg2fDfpkMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0903/2077] timers/migration: Update stale @online doc to @available
Date: Tue, 21 Jul 2026 17:09:36 +0200
Message-ID: <20260721152614.116726388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

[ Upstream commit 45a13ba52c82dbec9715222c51e629e85daa37d7 ]

Commit 8312cab5ff47 ("timers/migration: Rename 'online' bit to
'available'") renamed the 'online' field of struct tmigr_cpu to
'available'. The kernel doc comment above the struct still describes the
old field name.

Update it to reflect the actual field name and use the 'available' wording
in the description.

Fixes: 8312cab5ff47 ("timers/migration: Rename 'online' bit to 'available'")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260526022106.1302279-1-zhanxusheng@xiaomi.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer_migration.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/time/timer_migration.h b/kernel/time/timer_migration.h
index 70879cde6fdd01..4c0073f3d3212e 100644
--- a/kernel/time/timer_migration.h
+++ b/kernel/time/timer_migration.h
@@ -75,15 +75,17 @@ struct tmigr_group {
 /**
  * struct tmigr_cpu - timer migration per CPU group
  * @lock:		Lock protecting the tmigr_cpu group information
- * @online:		Indicates whether the CPU is online; In deactivate path
- *			it is required to know whether the migrator in the top
- *			level group is to be set offline, while a timer is
- *			pending. Then another online CPU needs to be notified to
- *			take over the migrator role. Furthermore the information
- *			is required in CPU hotplug path as the CPU is able to go
- *			idle before the timer migration hierarchy hotplug AP is
- *			reached. During this phase, the CPU has to handle the
+ * @available:		Indicates whether the CPU is available for handling
+ *			global timers. In the deactivate path it is required to
+ *			know whether the migrator in the top level group is to
+ *			be set offline, while a timer is pending. Then another
+ *			available CPU needs to be notified to take over the
+ *			migrator role. Furthermore the information is required
+ *			in the CPU hotplug path as the CPU is able to go idle
+ *			before the timer migration hierarchy hotplug callback is
+ *			reached.  During this phase, the CPU has to handle the
  *			global timers on its own and must not act as a migrator.
+
  * @idle:		Indicates whether the CPU is idle in the timer migration
  *			hierarchy
  * @remote:		Is set when timers of the CPU are expired remotely
-- 
2.53.0




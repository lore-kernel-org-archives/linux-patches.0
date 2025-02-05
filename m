Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92595151988;
	Wed,  5 Feb 2025 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766190; cv=none; b=i63huYaOQXcV7BJxA5AZJK2tgaedG+udAg5JSx/3Cl/yY4NL9lIkiHvaCfi2lVEenETfu/pqj4cqCja+B+KgjLXzlD6tKItlRF/dZGxnWy04LLXP35TAM1H04H2yXA8sfaQYOde7T7JZa6e8I0dNKGXKFOFOwPNWzDcaPKs4iTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766190; c=relaxed/simple;
	bh=1XercFH3SZM1q0fMVBbHtXGfbrL7WP6jRWlICoUAPUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk9ifKby50BDsfiXXqRrEWwLcpFumFlQWo62flJVOKhbVa/SC86KcRGWRM0mwyRyUfu3/wC5v11PiBhSGi7kanWgmosb7t1DperHRqbLveE6xui8KSgUhBpXD6LD1jZtJzKpn1hn7NBARP+z4r6zlBtPwEdTUCZV8EgzqdiYOfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNWQgoG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNWQgoG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BC3C4CED6;
	Wed,  5 Feb 2025 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766190;
	bh=1XercFH3SZM1q0fMVBbHtXGfbrL7WP6jRWlICoUAPUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNWQgoG3SUd6eLd+F2DJxxR7RsNklrHVk8Fqn5Eoip1hpmTgEKWJBAcTpBRhFImag
	 eYOWfAIowQpJjBgxRGs1MCsJqIpH/+3A/irwmiFnfWOQOw0KIOH+mmVBNHrDiNvh9e
	 ft86a4s+ySt2KosbhRZaYUIE80Rif3sbTYsUkV/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 338/393] PM: sleep: Use bool for all 1-bit fields in struct dev_pm_info
Date: Wed,  5 Feb 2025 14:44:17 +0100
Message-ID: <20250205134433.242843565@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit b017500ab53c06441ff7d3a681484e37039b4f57 ]

For some 1-bit fields in struct dev_pm_info the data type is bool, while
for some other 1-bit fields in there it is unsigned int, and these
differences are somewhat arbitrary.

For consistency, change the data type of the latter to bool, so that all
of the 1-bit fields in struct dev_pm_info fields are bool.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3775fc538f53 ("PM: sleep: core: Synchronize runtime PM status of parents and children")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 943b553720f82..9e1c60cd60e5a 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -662,8 +662,8 @@ struct pm_subsys_data {
 
 struct dev_pm_info {
 	pm_message_t		power_state;
-	unsigned int		can_wakeup:1;
-	unsigned int		async_suspend:1;
+	bool			can_wakeup:1;
+	bool			async_suspend:1;
 	bool			in_dpm_list:1;	/* Owned by the PM core */
 	bool			is_prepared:1;	/* Owned by the PM core */
 	bool			is_suspended:1;	/* Ditto */
@@ -682,10 +682,10 @@ struct dev_pm_info {
 	bool			syscore:1;
 	bool			no_pm_callbacks:1;	/* Owned by the PM core */
 	bool			async_in_progress:1;	/* Owned by the PM core */
-	unsigned int		must_resume:1;	/* Owned by the PM core */
-	unsigned int		may_skip_resume:1;	/* Set by subsystems */
+	bool			must_resume:1;		/* Owned by the PM core */
+	bool			may_skip_resume:1;	/* Set by subsystems */
 #else
-	unsigned int		should_wakeup:1;
+	bool			should_wakeup:1;
 #endif
 #ifdef CONFIG_PM
 	struct hrtimer		suspend_timer;
@@ -696,17 +696,17 @@ struct dev_pm_info {
 	atomic_t		usage_count;
 	atomic_t		child_count;
 	unsigned int		disable_depth:3;
-	unsigned int		idle_notification:1;
-	unsigned int		request_pending:1;
-	unsigned int		deferred_resume:1;
-	unsigned int		needs_force_resume:1;
-	unsigned int		runtime_auto:1;
+	bool			idle_notification:1;
+	bool			request_pending:1;
+	bool			deferred_resume:1;
+	bool			needs_force_resume:1;
+	bool			runtime_auto:1;
 	bool			ignore_children:1;
-	unsigned int		no_callbacks:1;
-	unsigned int		irq_safe:1;
-	unsigned int		use_autosuspend:1;
-	unsigned int		timer_autosuspends:1;
-	unsigned int		memalloc_noio:1;
+	bool			no_callbacks:1;
+	bool			irq_safe:1;
+	bool			use_autosuspend:1;
+	bool			timer_autosuspends:1;
+	bool			memalloc_noio:1;
 	unsigned int		links_count;
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
-- 
2.39.5




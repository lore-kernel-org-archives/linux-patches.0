Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216187;
	b=pfRKO8eU6ENh1klSZRwMHbZw94eOw2r7GEHlScjm/GcHnTKURWp7H9kJYjk73+6UpNDf
	 sw0bzwUOJupr1tfyVtBhuaxhiFq7xxRzWijQ/lQdgsgScDtxxtsjv3kt8UexR5j6seoje
	 z+JwZWhx0cC9VDrCSN5XCoZ26I5XIGW+pJAPbUToozjsk+jPiqgDxi2W5L6TCkyFqJdqW
	 9LjbrGblEu0vKpGOpNfoC+xibmT5Gi77nGjuC7pVkeL9ecM49RR3hWTwnrJGctrJFVZJf
	 2RApbS7DIyu14o+VKaNICjR9P5LaTeJCKfihFMpCLRZ5BdcYNouS2C8ri7Pa09rfoig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EC+8sK4c8PQiEDsCxoaBw8KxasiEYKzhTIqw9XvkPQc=;
	b=bny8QliP8nCrTw078FyiGuulPCyenZriDucD4CwINFN/4A/RLSL5k66z1W7sFMERTH11
	 SnkDc98IwVpXrvoqDtSvNAFeGEW78eWmdS6n7S417taISx/9JPqCZdDuBKAMCWNzVaNQu
	 VzSboo0tkxZSOc+xadx03GYM/3bUgNG92EBHL1jcI/PohLbNMVVbCYM2hM+eDtdaVRzo6
	 uXMmuJlZ/kdQXm3eQEu3fqYJDWqnvRMH01YXtH2cgpjUEoRL4+hv1vYolGuPBY622hP11
	 1aGKtlqWt3u6kuBE5Z3pi5aH1czN8yvZolufBoH38bbhG+JD8xJp3AUaSpX3/g76bsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWyWxmgV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A151B606A31C;
	Wed, 28 Oct 2026 19:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWyWxmgV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAF71F01825;
	Wed, 28 Oct 2026 19:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216187;
	bh=EC+8sK4c8PQiEDsCxoaBw8KxasiEYKzhTIqw9XvkPQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWyWxmgVIaH0HCMv522bqtBdjiuB0KseGZqbKQuOckZauGJDfxpeb0PFgyltKiWKr
	 2NlKj2QW4MWCaSjrvIy9MihxpjTYKOWhrHFxpC2DyK6H2NyReOnG7g1mn1R/QIqDkH
	 01FTQXHXNY3YkrXZaiGEZdSWjMcL2LvUDIlXjqpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanfa Fu <quanfafu@gmail.com>,
	"Tyler Hicks (Microsoft)" <code@tyhicks.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1472/1887] apparmor: make aa_set_current_onexec return void
Date: Wed, 28 Oct 2026 17:59:28 +0100
Message-ID: <20261028170532.953432158@linuxfoundation.org>
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

From: Quanfa Fu <quanfafu@gmail.com>

[ Upstream commit 0897fcb1c1e7316375166e0a665237bce2391a09 ]

Change the return type to void since it always return 0, and no need
to do the checking in aa_set_current_onexec.

Signed-off-by: Quanfa Fu <quanfafu@gmail.com>
Reviewed-by: "Tyler Hicks (Microsoft)" <code@tyhicks.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 3f4ae5fab613 ("apparmor: fix cred UAF caused by begin_current_label_crit_section()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/domain.c       | 2 +-
 security/apparmor/include/task.h | 2 +-
 security/apparmor/task.c         | 5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index a6308d103f764..52e16e75e63fa 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1463,7 +1463,7 @@ int aa_change_profile(const char *fqname, int flags)
 		}
 
 		/* full transition will be built in exec path */
-		error = aa_set_current_onexec(target, stack);
+		aa_set_current_onexec(target, stack);
 	}
 
 	goto audit;
diff --git a/security/apparmor/include/task.h b/security/apparmor/include/task.h
index 13437d62c70f4..01717fe432c3b 100644
--- a/security/apparmor/include/task.h
+++ b/security/apparmor/include/task.h
@@ -30,7 +30,7 @@ struct aa_task_ctx {
 };
 
 int aa_replace_current_label(struct aa_label *label);
-int aa_set_current_onexec(struct aa_label *label, bool stack);
+void aa_set_current_onexec(struct aa_label *label, bool stack);
 int aa_set_current_hat(struct aa_label *label, u64 token);
 int aa_restore_previous_label(u64 cookie);
 struct aa_label *aa_get_task_label(struct task_struct *task);
diff --git a/security/apparmor/task.c b/security/apparmor/task.c
index 503dc0877fb1a..cd9d43a277314 100644
--- a/security/apparmor/task.c
+++ b/security/apparmor/task.c
@@ -93,9 +93,8 @@ int aa_replace_current_label(struct aa_label *label)
  * aa_set_current_onexec - set the tasks change_profile to happen onexec
  * @label: system label to set at exec  (MAYBE NULL to clear value)
  * @stack: whether stacking should be done
- * Returns: 0 or error on failure
  */
-int aa_set_current_onexec(struct aa_label *label, bool stack)
+void aa_set_current_onexec(struct aa_label *label, bool stack)
 {
 	struct aa_task_ctx *ctx = task_ctx(current);
 
@@ -103,8 +102,6 @@ int aa_set_current_onexec(struct aa_label *label, bool stack)
 	aa_put_label(ctx->onexec);
 	ctx->onexec = label;
 	ctx->token = stack;
-
-	return 0;
 }
 
 /**
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E71470433;
	Tue, 21 Jul 2026 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656245; cv=none; b=g5Ymm5GxG99LY5E50IHlu5ITWzsdlC7CD6z3YSgGXiBX+T54Iug6EQ8UpEdfxC6/gvi6FOqHuPAD0VdtAwpHLhsxmfOBUcwnjH6pMKqBGkWenQJFgH7TI0+eDNwCtDCUJhkdKkVKPN7q144x0pXz6JT/4JtWPATqJmTBsCZ0P7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656245; c=relaxed/simple;
	bh=VXK8Z5zwE2zwepdsCgxYPuBmWqheR9fyXQTBtAy5hs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLMckva9ZFJbIiHRDGSPm7BRdUy4e1j/qL5ZU/Kn6lxjvtB4ltM+n3XTvOjQpTBv7NkiNF9QiKidbXZ57FmmXZnjIZ/JirxbG4sfdyKB6QWvbHJKuffCF0bgTtl4Qcl257rQv9cTMIlWRJbtxq98KaGZKSipJBcvFtaTP0QVpto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq+6yngq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq+6yngq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81391F000E9;
	Tue, 21 Jul 2026 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656244;
	bh=HfOJ81Z7+pbDZiyDB8miF1qIBqbRENCu5r+IduxmBxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq+6yngqo3JC8DbXtS7cKWerY3rx46jscEjgDqAeva+s39w2n13MGSgFkiSW/xOE3
	 qdx9W8dNAJ++4ElQ2q9nu/+VwfP/hk4vjk7YsMifkxA7qyFIoF1vwrOvFEQxJMJtpq
	 +ScRTvkfHhlsaA9h5nfDtZgrHNlyrNkb+aeT/SDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0313/1611] driver core: Use system_percpu_wq instead of system_wq
Date: Tue, 21 Jul 2026 17:07:09 +0200
Message-ID: <20260721152522.119260215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit fda8355f13ea3c0f9499acdeff3024995b474948 ]

Commit 1137838865bf ("driver core: Use mod_delayed_work to prevent lost
deferred probe work") added a use of system_wq, which is deprecated in
favor of system_percpu_wq added by commit 128ea9f6ccfb ("workqueue: Add
system_percpu_wq and system_dfl_wq"). An upcoming warning in the
workqueue tree flags this with:

  workqueue: work func deferred_probe_timeout_work_func enqueued on deprecated workqueue. Use system_{percpu|dfl}_wq instead.

Switch to system_percpu_wq to clear up the warning.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Link: https://patch.msgid.link/20260601-driver-core-fix-system_wq-warning-v1-1-f9001a70ee25@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 1ba53078703e49..dabdfc088f3f63 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -328,7 +328,7 @@ void deferred_probe_extend_timeout(void)
 	 * start a new one.
 	 */
 	if (delayed_work_pending(&deferred_probe_timeout_work) &&
-	    mod_delayed_work(system_wq, &deferred_probe_timeout_work,
+	    mod_delayed_work(system_percpu_wq, &deferred_probe_timeout_work,
 			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
-- 
2.53.0




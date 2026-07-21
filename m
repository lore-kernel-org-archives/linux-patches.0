Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC22408039;
	Tue, 21 Jul 2026 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661859; cv=none; b=puvlgpnCa9IQBpI8II3Tc11enmrNVRVY8R7PXlRCepJ7eOGfHd9SNfenKKQuvlZK5RIbouYjfpZ98PbR7eX0/ymT3TkMEuM2PA6b+7x5Dt6OBnHtsV1tZ3bSaTIwGmMr6q/Ds+YO8cPfZVlGKNlqtOnxwokDpfGnGSiUO4afD1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661859; c=relaxed/simple;
	bh=8jZhAZlFIDhKPnrG2umRT1ewXhGD+n42Nzob0IfBM68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDGVSqxgFpsh+DT8A4brwNX7o/mqVQioggI9W8jK6Q0gSSX5SukfH3Eb/j5vZbJNKKSPw6hNz8QtQhxEb3vDDdxUVJYHSToxcW1DCCbOUjWIC5WfRXsBAv0IDj9tQ6pTE+zC7A6vqrn+G3LgmiFte+ljNfBVMkR24HalpBLWNEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAdbnt2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAdbnt2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90481F000E9;
	Tue, 21 Jul 2026 19:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661858;
	bh=IAxzSAMmHT6IZQeplLEpDwBrvakHkmJtVD978EX9q24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAdbnt2/Y1hUqaNOK2TA6gcopzLRNQiZj87SZnzZLBGGdKYvBN0Vldr2DRlCNvzP+
	 t+aswp6015qOGOh582vAMsIqoof3a60xuArmjUhkp/CKVvxVdZa5EzQfLdbupp7osP
	 bU2iYk7ypeYDGBznodQqy7dGsUg8B3vxJbRkCivU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0223/1276] driver core: Use system_percpu_wq instead of system_wq
Date: Tue, 21 Jul 2026 17:11:06 +0200
Message-ID: <20260721152451.079992296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a694549c59a7e2..e2eda04bba0d0f 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -327,7 +327,7 @@ void deferred_probe_extend_timeout(void)
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




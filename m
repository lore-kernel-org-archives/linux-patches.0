Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB2714E2F9;
	Wed,  3 Apr 2024 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712166966; cv=none; b=GZk/TWImPJNgc+i/Kw4AsE7G9qDy009tdj6XGb+48CexIgsLXGdL5PfELrjWlGQ78BgaFy2JmbRIrcVIMqWGOfCRlIz8dGDdLLAyiOQbZNoWRNthzHKBI+3yo3gAhpjZYAeUfd+9xpz8p7LY6v5UZ5fpWrkePEP9JC2tk5qsksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712166966; c=relaxed/simple;
	bh=F6hMKdnqXA8S0wcqysR5Ci8gbkFt3VQ5s3RCPgVuG64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBYsaZSdemk+A4jEe2SAZQUVtrspiN5wdJMj+R8VBNI8zjJZNGbtFg3TyEFtvHVFWKeXf1T4GpiG5LkNVXHrebhzturKElQg5F6N2YIZV3P68ZY+gWYi9E2oJmkwizCm4T8+gsr70ikGzwQ9NS20BBghjhQgL1j+1qCuMUxeIlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyD3e4wC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyD3e4wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DCCC433C7;
	Wed,  3 Apr 2024 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712166966;
	bh=F6hMKdnqXA8S0wcqysR5Ci8gbkFt3VQ5s3RCPgVuG64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyD3e4wCcABOvn1lDJMovJjZTf9afwvU8x8xqgeZLXQXxJmqGGGve8FdkcIwL6Gq+
	 WFkOOZwq2AXOcyX9xMuZuinZqR2Q78fHJ/lEzoMEyK+97BzjgluQGwTZUPDgs4wRgn
	 mIRejXlMG/VoeqWkKBxauGZta+mVPDTxUParlb9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Tejun Heo <tj@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Audra Mitchell <audra@redhat.com>
Subject: [PATCH 6.8 11/11] Revert "workqueue.c: Increase workqueue name length"
Date: Wed,  3 Apr 2024 19:55:50 +0200
Message-ID: <20240403175126.132802692@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403175125.754099419@linuxfoundation.org>
References: <20240403175125.754099419@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 43f0cec175f92c7a01e43d5d6f276262670a97ed which is commit
31c89007285d365aa36f71d8fb0701581c770a27 upstream.

The workqueue patches backported to 6.8.y caused some reported
regressions, so revert them for now.

Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Tejun Heo <tj@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Audra Mitchell <audra@redhat.com>
Link: https://lore.kernel.org/all/ce4c2f67-c298-48a0-87a3-f933d646c73b@leemhuis.info/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -108,7 +108,7 @@ enum {
 	RESCUER_NICE_LEVEL	= MIN_NICE,
 	HIGHPRI_NICE_LEVEL	= MIN_NICE,
 
-	WQ_NAME_LEN		= 32,
+	WQ_NAME_LEN		= 24,
 };
 
 /*
@@ -4666,7 +4666,6 @@ struct workqueue_struct *alloc_workqueue
 	va_list args;
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
-	int len;
 
 	/*
 	 * Unbound && max_active == 1 used to imply ordered, which is no longer
@@ -4693,12 +4692,9 @@ struct workqueue_struct *alloc_workqueue
 	}
 
 	va_start(args, max_active);
-	len = vsnprintf(wq->name, sizeof(wq->name), fmt, args);
+	vsnprintf(wq->name, sizeof(wq->name), fmt, args);
 	va_end(args);
 
-	if (len >= WQ_NAME_LEN)
-		pr_warn_once("workqueue: name exceeds WQ_NAME_LEN. Truncating to: %s\n", wq->name);
-
 	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 



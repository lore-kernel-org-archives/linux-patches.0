Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC4719E96D;
	Wed,  4 Feb 2026 15:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219276; cv=none; b=A6xyaX+Zx4Bx4er4EzQQX4PSt0ZLj57azuJp9BbFo3qQbyuBtkIIYjGSb/alLNMssJZ+NYBI4NyFqj28p+dYDT9LHaPfbKDl5R5UnxXmRjg9Awib/iNdBbGyy8aOJECiF0ldY0J7ql601CwnOJmllqS137x/Hsg3HIh0tHMbqOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219276; c=relaxed/simple;
	bh=cBZE5Sw4tbmaapWC1/ZpPp/iPNYHm4UmjRYFwuPIB+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFnOhhaFC4TXmqZ7Y45lzq7MmSm9VG3dP0916C5CCqXTOwtwcWXNfLfyPu9yTH+IwgYHpfGjsoLwm2LNrNABDhmzjfDvzzl6SmxPWUSHgwamCGL74qse3VxRjY+sSTw3JHXJFnIY2lOzqVr5yF3A7VWAcfp5Ad6UO9RBJ+4WR0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGI+3kBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGI+3kBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E647FC4CEF7;
	Wed,  4 Feb 2026 15:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219276;
	bh=cBZE5Sw4tbmaapWC1/ZpPp/iPNYHm4UmjRYFwuPIB+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGI+3kBZT7hxMnXSuIYH7pTnWIQnFLoGVqKvZVk2hP1Dt/aUmUohsQZ+WeWb25giJ
	 ZO/mx2XNU03fdUl9mAAidp/kMbWlXpO0YQF5zal9IxJgt7voFcy20wFww021Ra9vdr
	 V2bXIBzl0syFQETL79A6/nnNSHpXH2rbVzrwJUjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 6.18 119/122] net/sched: act_ife: convert comma to semicolon
Date: Wed,  4 Feb 2026 15:41:41 +0100
Message-ID: <20260204143856.132414382@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

commit 205305c028ad986d0649b8b100bab6032dcd1bb5 upstream.

Replace comma between expressions with semicolons.

Using a ',' in place of a ';' can have unintended side effects.
Although that is not the case here, it is seems best to use ';'
unless ',' is intended.

Found by inspection.
No functional change intended.
Compile tested only.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20251112072709.73755-1-nichen@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ife.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -649,9 +649,9 @@ static int tcf_ife_dump(struct sk_buff *
 
 	memset(&opt, 0, sizeof(opt));
 
-	opt.index = ife->tcf_index,
-	opt.refcnt = refcount_read(&ife->tcf_refcnt) - ref,
-	opt.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind,
+	opt.index = ife->tcf_index;
+	opt.refcnt = refcount_read(&ife->tcf_refcnt) - ref;
+	opt.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind;
 
 	spin_lock_bh(&ife->tcf_lock);
 	opt.action = ife->tcf_action;



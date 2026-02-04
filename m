Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F9B42AA9;
	Wed,  4 Feb 2026 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218842; cv=none; b=lAGgVu/EkrnTKHHhQklpOBppXYlosJlr3sRhYmHMBYX9AkuDSinxe0D5K8ksxiUu59ULmrvTkATXHsaQw94imFQvBlYLoCYZDMx/TbCGHVUFT+lhGduy6YJ6CQJftK1osBFG3JiEHSvdYHxGyanv2PhfPTOeAULCvnQel7yTo3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218842; c=relaxed/simple;
	bh=2t1v+p3szBmlHaVoIVQKnPdFmRnN4bC/ywdBOgbVRaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfQ4scKYP75B+Au3ci3RkJM4EnMqPqHAHvEzvhgUGaLcloNbB/ttP3XPxXBD086gmwHgbPUq5IUh1iSLQyFVHAuXqFdjdwnPAI8ljWjp9oOZA7iCLv+pLE7ShDJrs7fBgzhjUbP5W7UIlHDJ4eNV0q14q3q7GFZy3CKhajnkERA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJn2IxV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJn2IxV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58802C4CEF7;
	Wed,  4 Feb 2026 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218841;
	bh=2t1v+p3szBmlHaVoIVQKnPdFmRnN4bC/ywdBOgbVRaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJn2IxV1h49XkZlrm1r9AaoNkojiezX+u0N5qEQdIIqa9DkPpVs5qXpZ097RX7f5r
	 Y9nKISO8wyJ4e/Y7hEHul7u2g7SOoDVs0OJYeXwPVLYeLvsrwFkXSKf+UHxDvNXYFO
	 D3xoflejRVejFVwDbRxGd+tjF/Z7CktW9j0Ej4h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 6.12 77/87] net/sched: act_ife: convert comma to semicolon
Date: Wed,  4 Feb 2026 15:41:15 +0100
Message-ID: <20260204143849.692579808@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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



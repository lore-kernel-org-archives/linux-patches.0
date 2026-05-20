Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027293EBF35;
	Wed, 20 May 2026 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297058; cv=none; b=la1I/qM3FTfmVwvYWM4mukht3viajf6OV4iorCydGLFZ7XA2YNGxNP2dcv5Vvuj8QsVgaQA04ZSi0EVilgHXsCCM4pzMgepBzj0M+UF9Vo4prBlzNMWNk+efcyCbE1RnCY9GORFoB59q4ffh4YEYqiFkoBdiw+fnu+VBqHW/cRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297058; c=relaxed/simple;
	bh=38CPggoUmgdV7D1L+0fNSKfnsRQQfOwUdHBwyGpzNpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pul7GT7UEhkqN4miQ4eDZ6BWO64xIvKbKiE12J7C3iJBmp5LlRS8Z9AwTP90i+RodcJ1vdPU0UenfTg/qTKVmopFD6GZyB42c85ROoWyOnhNmFTXUA9UtRAc4XY2GM64icuhPyOqCrEOlgiRVW4z9g4AuNCubtPDAGVLyZvYlo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMd6tnQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMd6tnQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA491F000E9;
	Wed, 20 May 2026 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297056;
	bh=9jIIHhFRocGjP7JCw82ujwjJpK0WkblItj4ECRXJhl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMd6tnQCgSVmDPo4UQgxxZ8Xaqe1BiYxH5QtWmLGOZg3McK0MPLiyiQ0rWiFDAijB
	 n5w4KyqyWJ7cRPl74r9rvsJx/kdkxuYxQS0PFBLAxkj1N5g2AO2fjm38LLi/qzjZWe
	 ZPMpLAbSoT9F2k0Us2acAz1m43qFU2aIy2BC34nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1033/1146] net/sched: cls_flower: revert unintended changes
Date: Wed, 20 May 2026 18:21:23 +0200
Message-ID: <20260520162211.605999815@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 1e01abec856593e02cd69fd95b784c10dd46880c ]

While applying the blamed commit 4ca07b9239bd ("net: mctp i2c: check
length before marking flow active"), I unintentionally included
unrelated and unacceptable changes.

Revert them.

Fixes: 4ca07b9239bd ("net: mctp i2c: check length before marking flow active")
Reported-by: Jeremy Kerr <jk@codeconstruct.com.au>
Closes: https://lore.kernel.org/netdev/bd8704fe0bd53e278add5cde4873256656623e2e.camel@codeconstruct.com.au/
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/043026a53ff84da88b17648c4b0d17f0331749cb.1777447863.git.pabeni@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index dd6727691cff5..26070c892305d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -560,7 +560,6 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       struct netlink_ext_ack *extack)
 {
 	struct cls_fl_head *head = fl_head_dereference(tp);
-	struct fl_flow_mask *mask;
 
 	*last = false;
 
@@ -577,12 +576,11 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 	list_del_rcu(&f->list);
 	spin_unlock(&tp->lock);
 
-	mask = f->mask;
+	*last = fl_mask_put(head, f->mask);
 	if (!tc_skip_hw(f->flags))
 		fl_hw_destroy_filter(tp, f, rtnl_held, extack);
 	tcf_unbind_filter(tp, &f->res);
 	__fl_put(f);
-	*last = fl_mask_put(head, mask);
 
 	return 0;
 }
-- 
2.53.0




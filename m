Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515EB379EF5;
	Thu, 17 Sep 2026 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658742; cv=none; b=b23m149kaycC+F3cI6rlOUhXPFyQpuxDBotXAxV21XtMx0ZAyBxhi52JTz8bDxWIvkEh5/7iKJ/bkt+qFg23PxiBKLySx0wMteBzhO/WxUdnf/RLQdXLRQtjyfVr5J/ZHTKW06jPTSeHD0GQAQLMB9f2xvhRht/eFxeEcOdNjSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658742; c=relaxed/simple;
	bh=3ddFDVO7Sgk340r615EizXH4LcQ2xE93sb+vcimJPyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4X8jzQRZR49SlI+BNXY8kQ4mcsULLw4QnJs/MCfXShz276NJ9IUq/nY5/1JFPqAjuUkh5Zemh3UXw2189UbqIhpXP2LAaI+l1U6+YDAtuo2Kh68nngcUllPVscbsv4f+by35QAVIpoa14C9+sV4wTnV5GiuSeEq5wFCNCkGpuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkmnV/wb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkmnV/wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FAF1F008A3;
	Thu, 17 Sep 2026 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658728;
	bh=JmF5jOlhW6WU+kieB68Gkcw9ACNyFkkkMsQ8R3Qgo3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkmnV/wbamMww0CY8ZkrKWwFmijrSkEhi4Ug5gGK3FlDKQv9xykdxQSXaZp1nFkys
	 b89MA+Tv9RQGsdGj7hbjTOVlr4Q48MpWEMNUrPLlYjeTJpEIVj/xzsc60vQsyZJlGi
	 6EFFEk09CWUEXvQ51W5TqHF6j5LXu4PaaFc4hT4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 020/733] sched_ext: Fix nonexistent field in sched-ext.rst example
Date: Thu, 17 Sep 2026 16:05:28 +0100
Message-ID: <20260917151351.188385999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Luo <luoliang@kylinos.cn>

[ Upstream commit 4fb8d6379d2c7ceecb2b3e111954d29089d59492 ]

The ops.exit() example in sched-ext.rst reads ei->type, but
struct scx_exit_info has never had a type field - the exit reason is
exposed as ei->kind since the struct was introduced. A scheduler
written following the example fails to compile with

    error: no member named 'type' in 'struct scx_exit_info'

Use ei->kind.

Fixes: fa48e8d2c7b5 ("sched_ext: Documentation: scheduler: Document extensible scheduler class")
Signed-off-by: Liang Luo <luoliang@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/scheduler/sched-ext.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/scheduler/sched-ext.rst b/Documentation/scheduler/sched-ext.rst
index 2771ea4cc14af..96ff66c91ceb2 100644
--- a/Documentation/scheduler/sched-ext.rst
+++ b/Documentation/scheduler/sched-ext.rst
@@ -229,7 +229,7 @@ optional. The following modified excerpt is from
 
     void BPF_STRUCT_OPS(simple_exit, struct scx_exit_info *ei)
     {
-            exit_type = ei->type;
+            exit_type = ei->kind;
     }
 
     SEC(".struct_ops")
-- 
2.53.0




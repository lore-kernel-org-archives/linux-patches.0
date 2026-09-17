Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7854FD795;
	Thu, 17 Sep 2026 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668697; cv=none; b=GQqQqsH3OHDGnS87QlGTOmhcWhpGTNYhPI2iVnl/PE/s4KaJH+1zCQxnmwZkGEEZmWhuhrdBk/S6tJDyeR4x6M9+plVtx75mm4fUYKtbJ4nJcGBqj3vOQezpGNIa3SAY3XWdUyquNBva3zinhTMX0JrZVoto56ChxDh9mM6V1Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668697; c=relaxed/simple;
	bh=idPOatgbF8k+vJwfEB03lIBHEqcHIP1soIwvUvVTjGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3tJ57SrYr/frRXmMOVF9zKzCOw837xi07dOYQZSiVW6Kyv70eYUSi2kvyZ2uXLEcP3Vhy9noCesqaq/FnSr6EwDorL4xd7xaW9RdcjM1gwTsEovIRAZKHzEA5NU8lms2DfbyVqJtczHDF7QYDWRq1/F5YnEVetnvt1uM84edgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFUvOLO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFUvOLO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D711F000FF;
	Thu, 17 Sep 2026 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668696;
	bh=jFOTwvf0y04RDDsfb50ptScdI9Onkxqk7Z+E5DvLd0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFUvOLO/8B1nS9IkzqhHTzblCG+QFm3xkWPm1qg5FqqA59JBDD9za60D1c9SzyimZ
	 Nomps36BThOKC4XjxKiaL/HdbHpg5xViiUU/aOjROEKfDoWwoabA319/B3hbcGSWVi
	 UdN8bxLD4Ta6ku+Y9swF7yZGacDQx8pD5EgQ54YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0509/1102] sched_ext: Fix nonexistent field in sched-ext.rst example
Date: Thu, 17 Sep 2026 16:07:32 +0100
Message-ID: <20260917151552.520740776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 7b59bbd2e5642..f963ff7988a1f 100644
--- a/Documentation/scheduler/sched-ext.rst
+++ b/Documentation/scheduler/sched-ext.rst
@@ -180,7 +180,7 @@ optional. The following modified excerpt is from
 
     void BPF_STRUCT_OPS(simple_exit, struct scx_exit_info *ei)
     {
-            exit_type = ei->type;
+            exit_type = ei->kind;
     }
 
     SEC(".struct_ops")
-- 
2.53.0




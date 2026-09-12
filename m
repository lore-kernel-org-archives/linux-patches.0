Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E612DECC2;
	Sat, 12 Sep 2026 07:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198808; cv=none; b=PT74RIEt7ew/Yt/Oq/y98o6i04Ux4DLOYFSetrCxLrsBhzy4GbR1YaBFK3UMH4mooGNvtAwCHSCTf84jHaUh/ehFViaOtK+Ob1859nU4A+hj2OsNTk9hDOfr9671ODWlRuJBq42uDfl7bGGZ0I8maScoH/cXOXzWphJLdhVM8ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198808; c=relaxed/simple;
	bh=TiGX7wNET5Tz6vqh4/ftjVsupPxrkLFv7eHXxAC7V1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmGTck2Tdjy+yQV9jXVRZBK/kSAYXBaP9wKdvQVQIt9kkd2JJV0z70nzUqJbK7kRR8edSb7/xa6PONSYosbdD8/DcRVMBoZBar0bKNB/RMtfZwd9hohHUVIWl0pm/P6pNmxykKu/idxzJgU+RaNtTOwnBCrBUwf3fJUIXdsfvLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PB/PueRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PB/PueRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742F31F00893;
	Sat, 12 Sep 2026 07:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198806;
	bh=ZjhiWOhHoEM8bDfQjL2GQOZMO7Q2tmwD4+JATRSW1Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PB/PueRZr6k5sZJQ9F+5cjf36sqSLY4SWxdmPs+LNFpIkdqCpnb/c9CdK82Zy6as+
	 MKxjdFd3wMtf+knCprCF5ktgMOpC14ALNOuiwMBK1XsT7Y+f/TSri7Hsyo1L/iLIyP
	 3rYN3wW9Tug3KfDO/N37YN5ct9bay2z34OujJl+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0413/1815] tools/sched_ext: scx_qmap: Fix stale API name in comment
Date: Sat, 12 Sep 2026 08:36:03 +0200
Message-ID: <20260912065658.586562479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

[ Upstream commit 35f9cbbacb671e587c84e992e7b0098c39e895a4 ]

The comment above dispatch_highpri() still references
scx_bpf_dispatch[_vtime]_from_dsq(), which was renamed to
scx_bpf_dsq_move[_vtime]() in v6.13 to unload the overloaded
"dispatch" verb. The code below already uses the new names; only the
comment was left behind during the rename.

Fixes: 5cbb302880f5 ("sched_ext: Rename scx_bpf_dispatch[_vtime]_from_dsq*() -> scx_bpf_dsq_move[_vtime]*()")
Signed-off-by: Liang Luo <luoliang@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_qmap.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_qmap.bpf.c b/tools/sched_ext/scx_qmap.bpf.c
index 0beac1abc5877..fd5883d01d723 100644
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -495,7 +495,7 @@ static void update_core_sched_head_seq(struct task_struct *p)
  * moving them to HIGHPRI_DSQ and then consuming them first. This makes minor
  * difference only when dsp_batch is larger than 1.
  *
- * scx_bpf_dispatch[_vtime]_from_dsq() are allowed both from ops.dispatch() and
+ * scx_bpf_dsq_move[_vtime]() are allowed both from ops.dispatch() and
  * non-rq-lock holding BPF programs. As demonstration, this function is called
  * from qmap_dispatch() and monitor_timerfn().
  */
-- 
2.53.0




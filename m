Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA3F14E2F9;
	Wed,  3 Apr 2024 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167007; cv=none; b=OGKxg6o9FpW8ide9rzRIkt++DhX9oEh/GmWg0efOCrjxXdWXQfeb2S4SJxSxW/edXW56c2m/tXSimSGtP2sRvRGUMVR76Hx+URkOtw8eH6ku/Yg9Iz/JWq79JGJsbIQGBFyLfXO2pLE9nnhyWzZgC2UuKvb7m6tiNAmcKqdP4hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167007; c=relaxed/simple;
	bh=3GrpkoRSXPqc8yeXtfNSpiSU3HuGxT+e9mYG/Zow4WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPTLA5YeuzXoCSGK4ktZwjmj9WSsqzLSqo7QcAUDzoOk7zj2ZDCFB4jPMhUXFlURQUCeLJ8nOXkAazzSDx5AY70XcIm/pahnDWkXc8iie5iA6vDQpWt1GgR9ApGfeRbGdvzoCjyC/JCx614l8LhcEoSoDWrtVEo/1WVB1wqrSaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Rg2f3Ys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Rg2f3Ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D928C43394;
	Wed,  3 Apr 2024 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712167007;
	bh=3GrpkoRSXPqc8yeXtfNSpiSU3HuGxT+e9mYG/Zow4WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Rg2f3YsRuggjjOdkyp2BiauqeVQMwsL3x6gl7T8lyJc+QvhzvWY0JTLoeFpPfyU7
	 KHOaP/AKUK89TMbmLmawhb0GECNqyDrVQ4NYmspIAK3OqrqvSUVhRu4OcWdSbyqfn2
	 U/Y/4SAbhslDoEbWEj2nF+upBKyq63Vf6bQ3aAYo=
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
Subject: [PATCH 6.6 02/11] Revert "workqueue: Dont call cpumask_test_cpu() with -1 CPU in wq_update_node_max_active()"
Date: Wed,  3 Apr 2024 19:55:51 +0200
Message-ID: <20240403175126.919810055@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403175126.839589571@linuxfoundation.org>
References: <20240403175126.839589571@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 7df62b8cca38aa452b508b477b16544cba615084 which is
commit 15930da42f8981dc42c19038042947b475b19f47 upstream.

The workqueue patches backported to 6.6.y caused some reported
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
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1500,7 +1500,7 @@ static void wq_update_node_max_active(st
 
 	lockdep_assert_held(&wq->mutex);
 
-	if (off_cpu >= 0 && !cpumask_test_cpu(off_cpu, effective))
+	if (!cpumask_test_cpu(off_cpu, effective))
 		off_cpu = -1;
 
 	total_cpus = cpumask_weight_and(effective, cpu_online_mask);



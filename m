Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15C9152DE1;
	Wed,  3 Apr 2024 17:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712166963; cv=none; b=XOvZG1fEIFyfkcN8JuRSyj8Fo7QcLptrXIiE0dl+hplFTctYHTUbqcLQpNJRGqvxBcE+EiQaViefK6vczDf+rfoyF1Vi+DknID2BoiagLXSuovEYufFwwSmz2tBGn59Eu2VL12Tq8bSm2HN4XY6A/5W+mjmG0FEb6dNC4P+LC8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712166963; c=relaxed/simple;
	bh=0E6K4sJbYRr46UIYuK7bOo/c9/pqyiwy8AyeY4wYDkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJmHsNPqP6G7RAITqAx8WcKeo38XbQpI5k8uRHp8DxNVoxjguXsLWVdQJrw3eBtlfhLO1orKLCaV7zvRtVGwiqGsqxEfjY0Yz2d/7CXtABZ/sx8Y6XJgwsiMvbJRSzmYbX0xNRowtakzMOUmLYz1vV0gCRN0WCCsASoUAs1e9NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCwf4vek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCwf4vek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE46C433C7;
	Wed,  3 Apr 2024 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712166963;
	bh=0E6K4sJbYRr46UIYuK7bOo/c9/pqyiwy8AyeY4wYDkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCwf4vekE/JB5xLtAjlrxM0okECqimVDNm8tY1XHosdIPSfZH600AC2PioRSozUNz
	 2X0ugTnbzWTnt7v3HfqDoSS6ruS9O3DItAxgW3x0oTkuJAME87H17Q0JMCkreCTlhZ
	 WQQDoajXHxI4vpt9fzAUdEjdh0YBKvjtN7LbXbWQ=
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
Subject: [PATCH 6.8 02/11] Revert "workqueue: Dont call cpumask_test_cpu() with -1 CPU in wq_update_node_max_active()"
Date: Wed,  3 Apr 2024 19:55:41 +0200
Message-ID: <20240403175125.844735323@linuxfoundation.org>
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

This reverts commit 9fc557d489f8163c1aabcb89114b8eba960f4097 which is commit
15930da42f8981dc42c19038042947b475b19f47 upstream.

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
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1506,7 +1506,7 @@ static void wq_update_node_max_active(st
 
 	lockdep_assert_held(&wq->mutex);
 
-	if (off_cpu >= 0 && !cpumask_test_cpu(off_cpu, effective))
+	if (!cpumask_test_cpu(off_cpu, effective))
 		off_cpu = -1;
 
 	total_cpus = cpumask_weight_and(effective, cpu_online_mask);



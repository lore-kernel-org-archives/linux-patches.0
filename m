Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E327A433CB;
	Wed,  3 Apr 2024 17:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712166998; cv=none; b=GVwM5dmDiPTc14DnyjfFvFVw/0RFHHS1s7jRy1UYlOm2oqhiZsgxlGztoa37ecLH/Rs7iHBn84nLY29Q4nSUXdPuq5rS+FjBPuIAONWo7dW88B+4pyjisqYjwhllXKgfFU6FLZ//oj7casbIaLfXrLE8L6PTkLi4guTvmPEG0co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712166998; c=relaxed/simple;
	bh=sYYWcpBIrmCa1ZSmB4h4Gvf8c/ITLDUolncS5ib8q5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZfaqAemPt7LU+bQXqUIZ233/rhILJMnOSRWTtU0eYS9AvxbPg6TsWz0PPSSFl2coPmi7uOiZNtzNWRvd9ROTIIlLMI5ZvAzGTiv/YusJd3Mp4S1LoqKFkq41qvYI8lukw8OYsIyMldGW+z6pAfWRt6oUy8HszOvFYvNkdiIq9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdGeyDNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdGeyDNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02746C433F1;
	Wed,  3 Apr 2024 17:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712166997;
	bh=sYYWcpBIrmCa1ZSmB4h4Gvf8c/ITLDUolncS5ib8q5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdGeyDNGFsZ0J0HegeMe7iqbC+TuIggTjiLKpZieLa0IK2zmFQnbSMDn0CmY+3mYI
	 tfAIysRnIgp8Y0aRTyUIStf6wxKosHlM+3iBvtl/0X+/c6U9GkNc9OMtewpWNhql9V
	 dNywoLgwRrvRdN2Kn8ok+5E44s2qPGmrVeMFLELs=
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
Subject: [PATCH 6.8 01/11] Revert "workqueue: Shorten events_freezable_power_efficient name"
Date: Wed,  3 Apr 2024 19:55:40 +0200
Message-ID: <20240403175125.807427157@linuxfoundation.org>
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

This reverts commit fb89c8fa412f6caa34316c140e861bd3c4d7e83a which is
commit 8318d6a6362f5903edb4c904a8dd447e59be4ad1 upstream

The workqueue patches backported to 6.8.y caused some reported
regressions, so revert them for now.

Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Tejun Heo <tj@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/all/ce4c2f67-c298-48a0-87a3-f933d646c73b@leemhuis.info/
Cc: Audra Mitchell <audra@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7186,7 +7186,7 @@ void __init workqueue_init_early(void)
 					      WQ_FREEZABLE, 0);
 	system_power_efficient_wq = alloc_workqueue("events_power_efficient",
 					      WQ_POWER_EFFICIENT, 0);
-	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_pwr_efficient",
+	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_power_efficient",
 					      WQ_FREEZABLE | WQ_POWER_EFFICIENT,
 					      0);
 	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||



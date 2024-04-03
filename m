Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E3E154429;
	Wed,  3 Apr 2024 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167038; cv=none; b=Z2zU0nfaupLvK0q0C1aFlDghARmdieGU6nPyWdaCkqgYvLSnAJR11EMphpd+5++M8eBRLCDobJGs3kV1O+oPSLGEQiwQYVXsyHR6KjzWNw+KX8orr3Jacnm+AcBY1KDOsRUfiRLkYV7O/CHIhOcobXL3xb/xRpGzgFKzPEXFYtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167038; c=relaxed/simple;
	bh=WNJZ5yoiDQqncHuK3ryCd8D+B9x8jk3fHMrAxa0ISHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHo6BPkb+7+xUBEngkWY2sxuBxBCdv3XtnjkecVn8YmYlbUsgnTN4VWDZXrr7Bf7yiSjOpdMnb2w924e4iheseNyKQnnC61VBUTjn8gkZa3IBGAoLw1MGmyi4PC7OTuctL/kpqns+AJqtNcH4px3h88fH2trRQoZQWM7LukuRxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZvdhn2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZvdhn2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CD9C433C7;
	Wed,  3 Apr 2024 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712167037;
	bh=WNJZ5yoiDQqncHuK3ryCd8D+B9x8jk3fHMrAxa0ISHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZvdhn2RvsufcyLBXDglNuSIc+IkqNkqbhbROe9iEvBn2GXa/VDzw5fLMz/XHiDDZ
	 lg7/r0MbTEWmIPfyj/e9gGs64MJAbynhMThXY+4trjjzPEMvvHJS+1Yh9KVrMRhEqD
	 CN4Ng7LP+92RcD+4KKqqQWn2CzjAeM1e0jovo8VA=
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
Subject: [PATCH 6.6 01/11] Revert "workqueue: Shorten events_freezable_power_efficient name"
Date: Wed,  3 Apr 2024 19:55:50 +0200
Message-ID: <20240403175126.884958823@linuxfoundation.org>
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

This reverts commit 8b934390272d50ae0e7e320617437a03e5712baa which is
commit 8318d6a6362f5903edb4c904a8dd447e59be4ad1 upstream.

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
@@ -7109,7 +7109,7 @@ void __init workqueue_init_early(void)
 					      WQ_FREEZABLE, 0);
 	system_power_efficient_wq = alloc_workqueue("events_power_efficient",
 					      WQ_POWER_EFFICIENT, 0);
-	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_pwr_efficient",
+	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_power_efficient",
 					      WQ_FREEZABLE | WQ_POWER_EFFICIENT,
 					      0);
 	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||



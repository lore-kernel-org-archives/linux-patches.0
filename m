Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1930423A71;
	Tue, 31 Mar 2026 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974907; cv=none; b=JtMWtEf0O+wZ1StY3U+BJUDGsvcpkqmIDv3rLooEl3McO3K+BxyF9fMA4fDWW5Jn5F53gj3eLUN20AkKm6NNABbr6Qtgq817ed1yd4nmDGvqqHPLZlbg8dJGmF+ZvX7fcpPXJLLCanRlMuKI6TkR34hPqNh7sH+chNxMb4O5JT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974907; c=relaxed/simple;
	bh=GCH9TQdlqWyfhVRS1dxHQOzhMujjENiSjHASxeJzE9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJcTYCNaU28KNlg4apQ7dd+oQ5rjCm5RVmKIsODGBBQ13ZK4wHTHstTs/tDHi9S9ICENt3ZycaaSRC7RqUzLuby35sySI3tZDi8rZ80EqYwatHK3MsQE7jnoNKEtURvRy2Bxwpv1/662b1gE89DjOgo+RPj+h16/pvnSzCpqCtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VylIfAN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VylIfAN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BD2C19423;
	Tue, 31 Mar 2026 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974907;
	bh=GCH9TQdlqWyfhVRS1dxHQOzhMujjENiSjHASxeJzE9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VylIfAN3XW6PGp9fYCI6mLalFu3leUh+iHqv0WqJGy6C/F8xJHzswrxvcHFUI+U62
	 IX10WmDtnH2HbqpF6sGDeAWdcsgGaMEarR5m736EODldAcYYXPXxD5SGnGKLngIlDM
	 Aty6SwfdQ/75G6WXLdGQL8WAGTbA8hhVpJGZIjEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 058/342] drm/ttm/tests: Fix build failure on PREEMPT_RT
Date: Tue, 31 Mar 2026 18:18:11 +0200
Message-ID: <20260331161801.031559153@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit a58d487fb1a52579d3c37544ea371da78ed70c45 ]

Fix a compile error in the kunit tests when CONFIG_PREEMPT_RT is
enabled, and the normal mutex is converted into a rtmutex.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602261547.3bM6yVAS-lkp@intel.com/
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://patch.msgid.link/20260304085616.1216961-1-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/tests/ttm_bo_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
index d468f83220720..f3103307b5df9 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
@@ -222,13 +222,13 @@ static void ttm_bo_reserve_interrupted(struct kunit *test)
 		KUNIT_FAIL(test, "Couldn't create ttm bo reserve task\n");
 
 	/* Take a lock so the threaded reserve has to wait */
-	mutex_lock(&bo->base.resv->lock.base);
+	dma_resv_lock(bo->base.resv, NULL);
 
 	wake_up_process(task);
 	msleep(20);
 	err = kthread_stop(task);
 
-	mutex_unlock(&bo->base.resv->lock.base);
+	dma_resv_unlock(bo->base.resv);
 
 	KUNIT_ASSERT_EQ(test, err, -ERESTARTSYS);
 }
-- 
2.51.0




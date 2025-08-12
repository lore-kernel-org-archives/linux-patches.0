Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3373217F35;
	Tue, 12 Aug 2025 19:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026751; cv=none; b=GL0aIIxCEyQTbiXkHcrSKOBzM5WIt0KimEp/hZxVo/oLHs3Zym6FTgjsScOdByS/pJlhaac3yPyG6l1PI92hol7e0mRVf2ZXJU5eak+jLkDqXk+LvN3u3qGTQ4AF6cHXk9TuHfkmm6WaTbPsh6ZMCFF74wMXDXnnLuvcoxRGk1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026751; c=relaxed/simple;
	bh=IK12dY+mWZmt0o7FAo11rBVPC95dbaX4Zkkc9VPRUy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scq8hNWHU9+REZc0BnfXssH6bz4LOlFh42FxQycrUZ4VyKSicGALLJDhXZBalIfYuS3sGMjX0mAW9k4vDqZku1WjjziJLohly2PI1ynTc5D2+wQc+vIeaghIZKGavIuEE2LAGunFPgMEUqqdJV6M1Oue1XNskZ39ShYG32E30oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUon3kBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUon3kBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01098C4CEF0;
	Tue, 12 Aug 2025 19:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026751;
	bh=IK12dY+mWZmt0o7FAo11rBVPC95dbaX4Zkkc9VPRUy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUon3kBSZALJOVcUfTLi5PAxph14iLMLlYkLPcH93m0LH/XAVTLmuwMaldtQu6sER
	 Oqjo48OHbJ3tvMhElTqHyXyMXeaU7q5+9VVdd2K5oxs0SUB8yBfI2C5FMu7xfcPJJY
	 HzcTO6JAb4jFn07Z1NNCkoZJ1BkmnclsmKHfYcVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 429/480] nvmet: exit debugfs after discovery subsystem exits
Date: Tue, 12 Aug 2025 19:50:37 +0200
Message-ID: <20250812174415.096581825@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit 80f21806b8e34ae1e24c0fc6a0f0dfd9b055e130 ]

Commit 528589947c180 ("nvmet: initialize discovery subsys after debugfs
is initialized") changed nvmet_init() to initialize nvme discovery after
"nvmet" debugfs directory is initialized. The change broke nvmet_exit()
because discovery subsystem now depends on debugfs. Debugfs should be
destroyed after discovery subsystem. Fix nvmet_exit() to do that.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/CAHj4cs96AfFQpyDKF_MdfJsnOEo=2V7dQgqjFv+k3t7H-=yGhA@mail.gmail.com/
Fixes: 528589947c180 ("nvmet: initialize discovery subsys after debugfs is initialized")
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Link: https://lore.kernel.org/r/20250807053507.2794335-1-mkhalfella@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 82d0a0fdf912..90abc5c01377 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1938,8 +1938,8 @@ static int __init nvmet_init(void)
 static void __exit nvmet_exit(void)
 {
 	nvmet_exit_configfs();
-	nvmet_exit_debugfs();
 	nvmet_exit_discovery();
+	nvmet_exit_debugfs();
 	ida_destroy(&cntlid_ida);
 	destroy_workqueue(nvmet_wq);
 	destroy_workqueue(buffered_io_wq);
-- 
2.39.5




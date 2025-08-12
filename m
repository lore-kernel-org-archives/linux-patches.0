Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D0826FA77;
	Tue, 12 Aug 2025 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025211; cv=none; b=TJp4jknavqvaJtHeSdUOpyJufWNWmh/d+3quzkgywMf/HhqALOBeBOMD7Ff1q+4H3yL7zKLKXGnBaOkuALyHiQT032XAz5y6LjuZmgpxPSy3uMbHEo6jyPMwpQA/JEUb5HoQyXkVKcaHkpJJCeK5ohOea/10qwGEolgWZjhfHCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025211; c=relaxed/simple;
	bh=Tj2r89svtQ2dpqBeTuy4A/qaWnPlYsQeMPfwJBBUd9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R263cRtKS2T5tWFVBOslyz63i3yu8M/Ssu0q6xaALozN6XngTZZwtnFmvZKNVJUYDA0wCy5gXZmN+Xi6NW118kmil/jVLThJf0XuVNPqxstx12WwVeH06PaFLR8rxTymKJbTNQzmRzcppkGtWNJVgYSagU5bDrPllSLachE7TMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/zn5ae5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/zn5ae5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418BFC4CEF0;
	Tue, 12 Aug 2025 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025210;
	bh=Tj2r89svtQ2dpqBeTuy4A/qaWnPlYsQeMPfwJBBUd9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/zn5ae5dXTy/e+RarHFSmLRuS37NiGa2GECZ3kcUxpkeLx6S3XSwZ04lk5lZwwof
	 vCLuOlHIMJgEWTKBeml5ctewEeKRgYvERmAZYkSvnCXjK9ZA0PfF6/gpzeVtl4cKr8
	 11yTr/qb2GXRSDeZFk8LhFCifDSNDNB2gazOx1uw=
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
Subject: [PATCH 6.16 568/627] nvmet: exit debugfs after discovery subsystem exits
Date: Tue, 12 Aug 2025 19:34:23 +0200
Message-ID: <20250812173453.488806688@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index b6247e4afc9c..491df044635f 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1994,8 +1994,8 @@ static int __init nvmet_init(void)
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




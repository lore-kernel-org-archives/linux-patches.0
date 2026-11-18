Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034476;
	b=L6HlKzW7vqZHYTVQmaQ5kb5p/CDXdxJeqkMZFgjCBJiyUbraNCU0ShykyOejegON6nF1
	 ufGAXUz3VY8CQevOx6lu6h9e9YQzEcl5bXTzUTPjQkcn8S3FPsM4sRAyOP1MeYrydzw2i
	 8i+QW7RmhGnQ/Uzw17wcBM5jedfeSUEbGlsrQcSnmYcYPxxVUQZQNkPktOPRbdYSKiPVl
	 d32P+WwlLqMAgQgMjqfANJqzqDP/ZzT6F2zLgqgKf0G+YLhfjhVH2vsfinTNxh3jI2/1/
	 K/xPIHoklIzlpatkTr79pH0zlpqTdxL2cdxzyscHKQA2FsEF7+JNkgIpmleFtbDY1QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8FS6xk0DRzKkozviASIpdbfs5s+jOeTO4oaK09xF8dg=;
	b=yb2Hosl0wHIw8idfkpPzuL3qLOl9pBqxfsa84+GC6anpgDt333ARh1VvsXBV4s1+60Cg
	 ZMkIE9jba4PnBooizh/zR4GO9tzMZ1ihB1dhxzWJUzPYmsxd5kgL0fs6oHqtLWmuR6YaD
	 p80lwttCvWIUKQtHSzsFYuIBippcTxTkcxoUramYVrbeFNhjFsV4PyWPAghKH+5SWf1Ne
	 7T6lw3ojvqmzb9G1+CMS83JSB6DkbuH2fRkK0+59wS9TTKUZiqaVN9qxdJBuF3MT9gXYT
	 eN+DO79s1MMoj4nEfsS51Xv+YWcROPtAGYDqzB3IQXGNHIlqmGp0k+TJ2b/JVcnCn/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqH4jx37;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E38A606A325;
	Wed, 18 Nov 2026 20:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqH4jx37
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59641F000C4;
	Wed, 18 Nov 2026 20:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034476;
	bh=8FS6xk0DRzKkozviASIpdbfs5s+jOeTO4oaK09xF8dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqH4jx37op/fnDNXu3ASVzM8Q2nJAWqZvzE6ZpaeQQC/J3BWOZo3RLbW0EG6DHNZQ
	 nfx6uz69EKp1PNX0PerE8bB0kW8KSAb0tlUVDbVO3UKuzGSi0UABGpwrZkcuaAriq7
	 F0PTwO52VFyAFQCYDk8mANpCyh/hFcc77tj+p8qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0336/3318] nvme-fc: do not warn on controller removal race
Date: Wed, 18 Nov 2026 15:15:58 +0100
Message-ID: <20261118150326.039120565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 62b70e6c87121ae5b79ca20c3a5b005590336ec5 ]

In nvme_fc_reconnect_or_delete(), the system attempts to remove
the controller when reconnect limits are reached by calling
nvme_delete_ctrl(). This call is currently wrapped in a WARN_ON().

If a user concurrently deletes the controller via sysfs, the
controller's state may have already transitioned out of the
CONNECTING state. When this happens, nvme_delete_ctrl() correctly
rejects the operation and returns -EBUSY. Because of the WARN_ON()
wrapper, this race condition triggers an unnecessary kernel warning
stack trace.

Remove the WARN_ON() macro around nvme_delete_ctrl();
this allows the system to safely ignore the -EBUSY return value
if the controller is already being deleted.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 75a7a372ffd83..506802d39a245 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3319,7 +3319,7 @@ nvme_fc_reconnect_or_delete(struct nvme_fc_ctrl *ctrl, int status)
 				ctrl->cnum, min_t(int, portptr->dev_loss_tmo,
 					(ctrl->ctrl.opts->max_reconnects *
 					 ctrl->ctrl.opts->reconnect_delay)));
-		WARN_ON(nvme_delete_ctrl(&ctrl->ctrl));
+		nvme_delete_ctrl(&ctrl->ctrl);
 	}
 }
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035662;
	b=YHOSsl1vWgeCe+xUFJvLPP+khlTh1mji/xwzXuhCgdFYegBXQ6s05cdq0N9h1qwBlsxB
	 rX0KYbKw4AZwyNDgrAbXRlrZX/15Gp/46Zc2OCehtebj3d1xMaH4sl8WvL6AHLcU+tbY9
	 miu36KLPGLjbJoO5GWb5n758UQL3lS+spUz3nfuJ3soVwwh6uftFu1F5z0GEXw9L/8iwV
	 zD7oxz9Ehft8T3mJBXPk47qsYf+ohnL3sxgM1V6XzE2WHpnWaVYT01ps/K2e1CXirGVp/
	 iPgpYzLmVBq9mX7IyKuwdiX1zJrJuTiToepHVHA3Rb5LYEmB1ACGePceK4Abk7zJU3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vtEiJOcjlALoWp4ak0KE86zYsgwNPMErOr2kRmHfdL0=;
	b=OP3U3/rIaZoJfPFUo5Yfm4/0u/QW838ewq2Ep+M45T0LMFo29PMFu8QMGo4VD7uLi+Mt
	 BTH1m/NXeyYp3efbU2WeAgchOTIcd3gVWR3sMDhS7OXdiFSRv3+mLN05G7Tnt34s+CxOn
	 0Cs5klnLjHYYDLzDT2wbOzI3CMAKiaO6j02VHSX0yUBRRI7cCYLf7noReM8ad4hmQcfd2
	 hAiJy49rKnX0U4OC/AsXg1RcUC4knwte834Dtji90u0FCnRmZjwFR/iJPaIPtdoMYIVuM
	 nORuJ0zAaezz7b0RMzXKYWqnw7D+XvTkJuqFoJuVTRE7pCEZxtY0EWsmAgPj9hUg5Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQyzaH36;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73E6606A325;
	Wed, 18 Nov 2026 21:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQyzaH36
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5681F000C4;
	Wed, 18 Nov 2026 21:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035662;
	bh=vtEiJOcjlALoWp4ak0KE86zYsgwNPMErOr2kRmHfdL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQyzaH36VPQwhxyvspNO8X1gmvZbm9oskd1Q/YxfyGy9vPM3PGcVH0mW3WPNqN25U
	 V1pkcdWqZvRM7rc+G4CN9oHd2eruaeda9AL10n0a4vgzW57goenS5WtCuyKXvRT7V/
	 UZAllnQWObDi5hRMQ6z+7sAU1tMWymU+st877HxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0782/3318] nvmet: replace use of system_wq with system_percpu_wq
Date: Wed, 18 Nov 2026 15:23:24 +0100
Message-ID: <20261118150342.289938389@linuxfoundation.org>
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

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit 3d553be6d295b6cca8fd35cb673fd13934ac4cbc ]

This patch continues the effort to refactor workqueue APIs, which has begun
with the changes introducing new workqueues and a new alloc_workqueue flag:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The point of the refactoring is to eventually alter the default behavior of
workqueues to become unbound by default so that their workload placement is
optimized by the scheduler.

Before that to happen, workqueue users must be converted to the better named
new workqueues with no intended behaviour changes:

   system_wq -> system_percpu_wq
   system_unbound_wq -> system_dfl_wq

This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
removed in the future.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 53f6efe00cea ("nvmet-auth: serialize access to DH-HMAC-CHAP state to fix UAF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c        | 2 +-
 drivers/nvme/target/fabrics-cmd-auth.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index c974beefa766b..32f01c00dc416 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -993,7 +993,7 @@ void nvmet_execute_keep_alive(struct nvmet_req *req)
 
 	pr_debug("ctrl %d update keep-alive timer for %d secs\n",
 		ctrl->cntlid, ctrl->kato);
-	mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
+	mod_delayed_work(system_percpu_wq, &ctrl->ka_work, ctrl->kato * HZ);
 out:
 	nvmet_req_complete(req, status);
 }
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 25a3a927ae231..8d97ced8b1d19 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -360,7 +360,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2) {
 		unsigned long auth_expire_secs = ctrl->kato ? ctrl->kato : 120;
 
-		mod_delayed_work(system_wq, &req->sq->auth_expired_work,
+		mod_delayed_work(system_percpu_wq, &req->sq->auth_expired_work,
 				 auth_expire_secs * HZ);
 		goto complete;
 	}
-- 
2.53.0




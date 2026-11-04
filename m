Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831047;
	b=YJ724k1dsGJej/LfpzZUDYnJNC5JbYLT6E7abfdEsr7g+a8L8x0da8D8/KDRbvrBC7i6
	 PjoYDoIR0s64T6US2oK1YmDbxGB4YhJaHJmQaUCJooRWd3IYlzJnVtcZgbIFEFPwAfDaJ
	 XeQdcybeFmDTGlAJp+YDPONG2PZ/Uq/l427uCM51aWsc6c7xECBBGQenxxw+k/jdjghgo
	 Hiwna+0/ebM5KG8y45FRslSf5j9RgfyzMTh+Bo8uOcWAgjCX0NJQthG74//5QyDW3sfhH
	 Yf+lOrNEqHkAimLxgyk8kcR7mrpmIo1Mau9Fzgb0N74ZybTINInyhGBPLmGY5IVjoQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lfpsfT6uZwtjvLSgpEPJ/woNCUPqR6T3y8kegcExsjs=;
	b=Cf0LomB6Vf6mtbYnRqP8CRemUVMdqdfIy48u8cLS7aE9cor6XlY6RmD4vdnzEnpbD+tx
	 fPKrzMdwhadpzVPGyh+aGjFwE1TgRIBnSRC0jrzt1ZoirTPeCFaR/EJzWUCmQV1pVUvMN
	 JqWIyQyvjrl1TWQkTQlzG92fcRKbNE+guDItWQvhE81Q01csUlsy66v4kp0bP9hzbhjU0
	 wuEpwRTR6IYYQzhmxIerOF26PMwehVhqP3jzIILSqVglTMXTBebJU/88SQa3Dawna728P
	 s1ZaDJaAVms84ZT12CV1wgaBp8KwK8NyE/J8inrNnJRKNFM7I5VrKkOUCoGoNQW7G4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n/pW2HZs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9B9606A843;
	Wed,  4 Nov 2026 22:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n/pW2HZs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE11D1F0093A;
	Wed,  4 Nov 2026 22:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831047;
	bh=lfpsfT6uZwtjvLSgpEPJ/woNCUPqR6T3y8kegcExsjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/pW2HZsEl1fZ4zSXnK1Xp2tmDP+Jhr62TrjOJ4X5DwbauhtlJcoFHK83vnV942k3
	 2SPdKNg/SX71EnYjBZBZ9WV9f4cR81ewdPGSy8bqN0eq0IL6LiJ75pKbVSNQMrHq2b
	 zyAKNki3zfvzGL2gVVrWLRaPdCZtDaRZjWCAT1vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0479/1005] nvme-fc: do not warn on controller removal race
Date: Wed,  4 Nov 2026 16:03:32 -0500
Message-ID: <20261104211057.409331132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fc7aa3fc6c2b5..186d1beecf32b 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3334,7 +3334,7 @@ nvme_fc_reconnect_or_delete(struct nvme_fc_ctrl *ctrl, int status)
 				ctrl->cnum, min_t(int, portptr->dev_loss_tmo,
 					(ctrl->ctrl.opts->max_reconnects *
 					 ctrl->ctrl.opts->reconnect_delay)));
-		WARN_ON(nvme_delete_ctrl(&ctrl->ctrl));
+		nvme_delete_ctrl(&ctrl->ctrl);
 	}
 }
 
-- 
2.53.0




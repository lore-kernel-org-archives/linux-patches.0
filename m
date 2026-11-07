Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061081;
	b=kSbZhIVZ/iM2w7U1t6YeYw4Kh/UX76YWijdvTXd4gfp+j1bTwC3fO700EzoP6Wy/h/CN
	 hNV3QblQyXmqgkl1NNwyrvDJmfl67I6tBvEDtkPzxtZYH5E2FPbNtLe9hqGhrL2+I+LHr
	 z261nRG5FlZfJGkk4rXTHNkrtjiPNqVkVymiuTfg/yXyh1yhRfg53l96SFU3e2MlpGZEr
	 8Lr8wMlQZoDKM9jd0f9kMjy3m/JFYixKfgIxvaKdtql+GggsoJpqJ7RnVL4p7d0DWrnM7
	 L69hQhU0Jwr5wn+jOxsXirYOAwOKDtlBZ1xH5eesx7F2DGL//X2/09m1moStUaZuIFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gmcCETdGS5v4b4NO+/i9g/86bXjM2hrXfAgzmpil1SM=;
	b=NY3H23pShet8Mt5j2H+vQzEw5usDvc95I6qXmRpLfknp2nz8vNUwjxem/f6hujVRFad/
	 9Br6o0f0o51L8orQ5Rx73C1G/9IOjBZ0/Oo7qMa+1aulZAj5jhhwDbXyU6xv6FRcMtu7T
	 MwVvOeH87fTQaXi0YEtArkua8uZNOZWCyWi4ku705F2vfAUqWSvuRTKm15lmR8cj+oLaz
	 fQSAUQkbd0z5pxRyOQ6OaC5RHpIG7q4iSpJnB5PEg5dfbD3aZeWbA9MIGzwW7r0RzHLVa
	 4Yd4uhA497iInO34Rtlj3MHw21QWFg6MneFKUzBv1ZV8LO54oyfbwNfNNqdcBExGOCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTgkbPD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2747C6083619;
	Sat,  7 Nov 2026 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTgkbPD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75DD1F008BC;
	Sat,  7 Nov 2026 14:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061081;
	bh=gmcCETdGS5v4b4NO+/i9g/86bXjM2hrXfAgzmpil1SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTgkbPD0qxbuuNCtQG7MvVMr9sIQ8nLjMXZikUcRiUZCDz2VhigT539ArLz/Q/Pas
	 e1w61uDRADzs6p8qAx9HI4XnsGYtb7WSWgA0bpTCtrR7e2dgQqSpYgWJlPUTmoVQ5m
	 iUAARZs9frpCutyHuCzoOwYpwosQ7PwrfmsWe1t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0404/1536] nvme-fc: do not warn on controller removal race
Date: Sat,  7 Nov 2026 08:40:20 -0500
Message-ID: <20261107135008.929826713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f2c785d1f62a..7eb566c6fc557 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3328,7 +3328,7 @@ nvme_fc_reconnect_or_delete(struct nvme_fc_ctrl *ctrl, int status)
 				ctrl->cnum, min_t(int, portptr->dev_loss_tmo,
 					(ctrl->ctrl.opts->max_reconnects *
 					 ctrl->ctrl.opts->reconnect_delay)));
-		WARN_ON(nvme_delete_ctrl(&ctrl->ctrl));
+		nvme_delete_ctrl(&ctrl->ctrl);
 	}
 }
 
-- 
2.53.0




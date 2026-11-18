Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057621;
	b=IpB+4Y2J3eQUQEFg8yZvQgbqUvqZ2F+DV0kHam+Y5fTxqhXIaD3Cgc84uizF0LRMnRQx
	 ru0XK1mP/j6TuvHK4Det/cT80SZ2PlJCiobqyceam8Bk0QWY0F9CPL/N0AQWzj5aWHnJV
	 AsLfSHfY7U3UKcMX4TFBr8pvuXzqyX5eEM+b3JorY3CRSXlNMQFk+OGVd7M2n7PnKf6z+
	 Ivyi7ZCS6ODYiscMhx1UfIyONgzeDGE8WBVUk+t275fB7p+/79kbUG5V7MWwuboGnWq3w
	 OZ2CoCKq7MXadd4g9I2rqUyPVH7noJuOOxxmnHKlMNBMQWHg3/y0ozQ3jDWyJnMFy1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SpMpZ1Ef6UQUOlIcyzOoniOJIK7LBsVQ2oSFqFylN/8=;
	b=mr8NVtZLzXBKBYK+d3rTM7HtCcbvNzUqvStinig0vhAr9D2/CMgozTug2Bqn71CZNt9K
	 ScO0ek0xFQ+5ULYVjFKfRIKqzz4SL6SI3K3Q4McPCxa60Chx+g8azEVZRqFMyVxV8SUB+
	 U3SVsPyb+k9nO5f1xFL78uzyGmMwckL2mFAXse0qVOinXnnmapUuNFTIVsVgS1TB9IfVZ
	 AGskyq1UI7Yix73pKiHJKDPZdfg/5aB4J7tPJuF9ILArt+pPJLUT/AJQITvmSKOg13Tuc
	 LkftxegHC5R2Q7W8Ly247fu1had3tIWS57SgyUE6OiPWNiJ95v9dhE7+2HqRcr6aqlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxpsaGG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AF0606A33E;
	Thu, 19 Nov 2026 03:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxpsaGG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F6A1F000C4;
	Thu, 19 Nov 2026 03:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057621;
	bh=SpMpZ1Ef6UQUOlIcyzOoniOJIK7LBsVQ2oSFqFylN/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxpsaGG8ZWtCHqv0b3TBQ2Z3jyCR9bpAVXZgUTIbbzky0iJGETIlBxIQlLd/zy7Rt
	 FVY0VhEuE2/oAyF2OWtf7ygVsDlWB4ZYqZmTVUWRQxjNb0cW5FvzEYo5SykW1MEuqK
	 kP9BoqykFUR9RncUegWEPCzRhnMbu1MMII7nKJYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0195/1848] nvme-fc: do not warn on controller removal race
Date: Wed, 18 Nov 2026 15:37:13 +0100
Message-ID: <20261118145919.960249544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b561a7be98e3c..29171d4ca2a69 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3315,7 +3315,7 @@ nvme_fc_reconnect_or_delete(struct nvme_fc_ctrl *ctrl, int status)
 				ctrl->cnum, min_t(int, portptr->dev_loss_tmo,
 					(ctrl->ctrl.opts->max_reconnects *
 					 ctrl->ctrl.opts->reconnect_delay)));
-		WARN_ON(nvme_delete_ctrl(&ctrl->ctrl));
+		nvme_delete_ctrl(&ctrl->ctrl);
 	}
 }
 
-- 
2.53.0




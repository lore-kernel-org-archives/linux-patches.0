Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038965;
	b=kFiuf+FyjeodhGRUZJHPqDgO0dK5Z/d7nSsSW/kB1eRNJEp2zkK7Ppj1qiwSNDwiQQ2L
	 URvIJTFbY1SI6lJO4Gqdh9btnivz1QxrLYgOut1ezv6QWlsHIzIXD+ype8NZb3QWLwiQb
	 wcPxUHhrMFPjcXAS7cuH/a8loHJp0a1+RyWUloGGAUGCnaMgO6RFq/5i3z5bUQlx9O8SN
	 0ipsu4h721CyNBjY1FLwd5a9VOSi2jfzvIQWF8JP9JV2lL/FMP7P1RnPb6IZ+SOCqKmXM
	 /pNXlBVqLOX4tCdE4Zhh97LDzuvDV8xBpf3hRTj/mGBbtzhCksJnSKgUOsVwEOeWsEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nxn0szylI3g9hVTUpO0ViGLlMYodsySnOV4d1JMspX4=;
	b=WwlIEO4bKu5njN9RiUyeLtqTQrGNntGGJz9tCi+Xog//8x8Q+3BM5vxW7T2H3ut5SB2U
	 NpBm/xgn+NGJ3KqxemogOd2iRPtvgFHPMHw0LFgB5J7MYxqenBeC0x/dQfd/bQ3yj4zZ3
	 lPUjzv5/CxLMSEE2eE2ZvP1LsfInzzovRtIj0t3Z0ExB0AUpC2gvCpbLMVEUNVwJUITNZ
	 0U56O0qYfdFnpHYPKo1fQ9ynDpvT0hKyS8fVPcXBYN4XLeCkV+fTw2ek/wKP7t8ZQ5OaP
	 hba35oEdu06/S2lcSrD3WzxD0TRHvSR/H7UtXb+X1hY/s7hVPVXY+7SCTL/tH2rOupQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nK2wHTss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7C3606A320;
	Wed, 18 Nov 2026 21:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nK2wHTss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AD61F000C4;
	Wed, 18 Nov 2026 21:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038965;
	bh=Nxn0szylI3g9hVTUpO0ViGLlMYodsySnOV4d1JMspX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nK2wHTsswgEmn6pd3IaHuHZ5tSdAuTStgduEqdz4r+OEHsQb7W7eVDvFtz+akCKOS
	 eJ6ek6VaKRsRyNjEFmE4tYw7vfWw1t6CE84DzZl2nKObjv1ZK7dDjv8Y0zVcrJ4u0l
	 pNzcMf0X11p6Wq8v9Kp/RtWtR7FNTwS/eG76M+ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1932/3318] nvme: unregister when pr_register() is given a zero new key
Date: Wed, 18 Nov 2026 15:42:34 +0100
Message-ID: <20261118150419.994565358@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit a9d431124fb2e58215daf0299d6fcf47bbc2d6b1 ]

The block layer PR API defines a zero new_key in pr_register() as
unregistering old_key. nvme_pr_register() sends Replace Reservation
Key with a zero NRKEY instead. The host stays registered with key 0,
and its next registration with another key fails with Reservation
Conflict.

The pNFS SCSI layout client unregisters this way at umount. A later
mount cannot register and sends all I/O through the metadata server.

Send Unregister Reservation Key when new_key is zero.

Fixes: 1d277a637a71 ("NVMe: Add persistent reservation ops")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ sashal: changed old_key and new_key references to old and new to match the existing parameter names ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 566a04290e550..a6e563adb7017 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -133,7 +133,12 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
 
-	cdw10 = old ? 2 : 0;
+	if (!new)
+		cdw10 = NVME_PR_REGISTER_ACT_UNREG;
+	else if (old)
+		cdw10 = NVME_PR_REGISTER_ACT_REPLACE;
+	else
+		cdw10 = NVME_PR_REGISTER_ACT_REG;
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
 	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
-- 
2.53.0




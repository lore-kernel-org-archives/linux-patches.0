Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214264;
	b=vgtbpptqsrfUrTD1jQPhV2pBUwFuULwYEjuHOPkSdmS5ZinZXuzFMso1og8qgxiYfBhW
	 p381Pzc0hh964USqtHZGb+HO4zITorXWv9KHXlOFHxMVaYhjmKVw6wsA2cNS7ZRNZBojO
	 D4YyBmv2JTQEkAQNtWS2F0niOUZZ+DzdPc66Rvdpi9xMwDYsyy2WtkCuhLsNFWv9RQFCd
	 lsfY+uYJ6U1bnVGYOs3MW6HIu8fvpvob4EoSNEz/IS85ZB1Y1rY5fG8gCoov4ktkAHHYf
	 6kd8fY4QQXVITCqgxlXxUTvmNETzpVYj0FCsBCvcrxexyzU+TMcv17yloR2gZ9N0itg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r1jBvln5+faqnBd6fcaADcVLVh0q4/FsxcvbZmXGNPc=;
	b=NJ8zwg/7wGkdb8odsA5MfJFh+BIoZvaxDvK7NFE/m8+Qzb34wPgdUgQnsNNM/hWzuuxR
	 MOqEvzfhJdqCbZiPnrHq5f6XjiQnQ6pmnGfp45oe11dxh8MAHKIHYoNUYInfwL9FRgfzD
	 aMsL9aomV1t3qCArRggnwee6ISmY+lEywI7Q9ZEgbGjkaTbPBsx3nfpFOTMcdmlxXBqzS
	 rwZJW+vnKhKx+2V+b1I8v3Mob1GGxqPXJpfgPCqmbM64ynd35PnbX50rvcX5Y42orb/ni
	 PZwZwTBB7TjfTd9PgtxweIneev0/8niMckg7NOBC+0ApJe6BWU8jul30gpDoV06rG7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Auzc9j0k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF2D60A2634;
	Wed, 28 Oct 2026 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Auzc9j0k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272FE1F01825;
	Wed, 28 Oct 2026 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214263;
	bh=r1jBvln5+faqnBd6fcaADcVLVh0q4/FsxcvbZmXGNPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Auzc9j0kRq/Je2NCYY/r6u0gNrWAU7F8KI5iHsb4fYnBZjR3fOWodkCDzbVui3ExI
	 3/ma3MlihGKsbXtiOc+fMxY1D2FYIo53nJhuKwiZnll5pSnwMgzft5NH9zMes44Q+g
	 J4y7UP8g7vw52l3vhHQJIYDOdiAHM2uDxxXw6YXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0796/1887] ublk: santizize the arguments from userspace when adding a device
Date: Wed, 28 Oct 2026 17:48:12 +0100
Message-ID: <20261028170517.545866021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronnie Sahlberg <rsahlberg@whamcloud.com>

[ Upstream commit 8c8472855884355caf3d8e0c50adf825f83454b2 ]

Sanity check the values for queue depth and number of queues
we get from userspace when adding a device.

Signed-off-by: Ronnie Sahlberg <rsahlberg@whamcloud.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Fixes: 62fe99cef94a ("ublk: add read()/write() support for ublk char device")
Link: https://lore.kernel.org/r/20250619021031.181340-1-ronniesahlberg@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c41bb08efb12c..538827b68d881 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1697,6 +1697,10 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 	ublk_dump_dev_info(&info);
+
+	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH)
+		return -EINVAL;
+
 	if (header->dev_id != info.dev_id) {
 		pr_warn("%s: dev id not match %u %u\n",
 			__func__, header->dev_id, info.dev_id);
-- 
2.53.0




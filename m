Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585486;
	b=B5WtdC3ER/QgbizIShfYb8vOc5qJqTSVkl8ojQPgoCARjiTE1XtddQa8ke+pQlI2KumF
	 Dt7Ahs8EQc7PG9nZXiJ1Xbhd4Z3B8Ixb1amUa+pmH/WM712QA867m6O52FCzPyXa1Rwa6
	 ES9u0qIuWAAQVqCE/fyie3TeklSjmp6sFbb2Kxqp0ty2Tw0PWiBMIxkNXhqe+iVkQMLJq
	 kI7j8cLK9ItqkfNrGIZUQP8J4SkeJiScBufd9EPTzvUW3zebxVbnRBF36ZOlN2GsKXbOt
	 +gXmylLLAoAys3vlZIBvt1coANcqPuN2dmrVBeM9iz7wJnKeh7INNmp7W7+d9oP7aow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6DRvswLZBDbB09t2r42eEuwPiypCW01X/ZwSf/wuN8M=;
	b=2vlsd9Ztdzg5czZyiO+0ipj0u1VHztU2auaIdNCOnJ135TvWCfgDZkYjGJw7fGOjFPmY
	 zbMg//8NjQsp7J4WdQmoKXIrx/8zATXCqccSplbwnd+FTVLpmevrJeezhgRAIyzboamJb
	 8j1gU+jWBlVczPj4vLqaKV3t9l9DQBhheQOVvVb2xi0j/T4NkHGFQstT1MSRqJxi0kxgX
	 ZgoDMxPQ9OHug1DCsZ+vRaBAoLwOOSIo2/ySiLOuI6lim+f3VyEdbHrIAZJ0XiFp2gW5A
	 xwLZ+99fUJqy6h0Kwc7dWTFvaJh0vN/dgKxtyThOZUBpwyvZ0hQ1MI60ipRx7tFcF0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GE3qtPWj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C70606EBAC;
	Fri, 13 Nov 2026 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GE3qtPWj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7851F000C8;
	Fri, 13 Nov 2026 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585486;
	bh=6DRvswLZBDbB09t2r42eEuwPiypCW01X/ZwSf/wuN8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GE3qtPWjA5TMhddkhOcPIE53Xuz8f6cXLeKilVzMJkvEDVIYBiouz2+cZd5FlYik0
	 mWfPlTLq/hAurU9t6PBZyAsWmKECAWJRs5nqOcNbkuma+LNRNFvewPljPW2bWw/Qzk
	 XnPBlv7Giu2ugO6Ll6iZfun7m9Lu4TT1vzpSLw0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 100/507] scsi: bsg: Report io_uring data copyback failures
Date: Fri, 13 Nov 2026 10:46:44 -0500
Message-ID: <20261113153757.581285441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Wang <x-professor@outlook.com>

[ Upstream commit ffb7b533a47906b96166eec4b7eaa4199b7a7462 ]

scsi_bsg_uring_task_cb() discards the result of blk_rq_unmap_user(). For a
data-in command that uses a bounce buffer, the task work can therefore post
a CQE with res == 0 despite a copyback failure.

Use the unmap result as the CQE status. A later sense-buffer copy failure
continues to take precedence.

On x86_64, a raw BSG INQUIRY into an unaligned anonymous PROT_NONE mapping
posted a CQE with res == 0 in 20/20 runs before this change and res ==
-EFAULT in 20/20 runs afterward. Writable controls succeeded in 20/20 runs
on both kernels.

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Reviewed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/0b35d2d46bf8ff9f2dbba83ae093d17351e950e9.1792772194.git.x-professor@outlook.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 37393a8dedd84..e4a65d7a23742 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -41,7 +41,7 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 	u8 sense_len_wr = 0;
 
 	if (pdu->bio)
-		blk_rq_unmap_user(pdu->bio);
+		ret = blk_rq_unmap_user(pdu->bio);
 
 	if (scsi_status_is_check_condition(scmd->result)) {
 		driver_status = DRIVER_SENSE;
-- 
2.53.0




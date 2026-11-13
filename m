Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585748;
	b=A9tKmDMrtOKqpLeb9jA0Vgx9345iBn7mZY7QnkHdDI4h/T4aauSCWy4ACqjEfhOeAwTu
	 esyqYeUvVEns9R6fkJRqcvFzskKKNSmlNuYTNR7sMWNAEU1Da78obAVhUu/WrgQAWF/JR
	 MLejI3vGWe48ptuRN9ZzzvHIhRN1L5yS2zN9l1SpzJr46WjVsa8ltpSyhDQ6FqOMZNU9o
	 7O/SkSVaecXf+GfoTvHMuYOV+IwDvv3wbM3PvHMLhMhLYetmuJwXAYmPjoUd/wx2BFo9j
	 mCMJ6TBRDRnOZbLwryO5p7oIFzDdXzc3F+BCmHWwFiDF5L+piZ/xcuLXsdazEnlHW4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6nHQbvynqoryoK5tHEJBC4MM8wavmeN0ftl9BNh7rgs=;
	b=xHZtxEm1p65xbGF5vCrC3R+rCY/bQ5qZJ2JEh8VjjriCmX2yRpEbq5e7pPBUX430MNh+
	 kvSZEpnMOQov2sR/amqi3HCbSDlS0r57Dio9m9BiPh4JdWoR1ck80VsLsoZFwupVpX/8q
	 3A9vQmXZjobnPy3HCWwkwvSXSOoxrLhAYODrE615gJBwTtJN7a1CI0k72b/R4WYWSZFjB
	 fa8vIP0pP5iIBJo7YAYU1ndWYNZMDZYHZ/aGy3svQngjegJIv/3GgvN9IPkASh/eRWHqQ
	 /woxE4p8PXafr9x07PKRm2WaV8kGHdJFWvSducgjn2EbZ+H09LujeeGKmi78gUcqb0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ku14Wd/V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1746606A336;
	Fri, 13 Nov 2026 16:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ku14Wd/V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6931F000C4;
	Fri, 13 Nov 2026 16:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585748;
	bh=6nHQbvynqoryoK5tHEJBC4MM8wavmeN0ftl9BNh7rgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ku14Wd/V2eaKRcrduz2iRpOPEp3XRIDI6enaNaxdbVCWz7fm42UsT7wJSHWLC+i4a
	 m1HsSuO6NljRTFu0C4fSEHLai+V6wRdl8HkThLgHW5irnRFL4+t3822R9TN3j5QsI9
	 qM6+JaDdLtnloAEInpn2iX4criamb3YzUx6pQgmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 345/507] ublk: add missing DEL_DEV_ASYNC to unprivileged permission check
Date: Fri, 13 Nov 2026 10:50:49 -0500
Message-ID: <20261113153807.090767426@linuxfoundation.org>
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

From: Yitang Yang <yi1tang.yang@gmail.com>

[ Upstream commit e6ac1da6a53c5f670bf09e60a2500d15be68d2fc ]

ublk_ctrl_uring_cmd_permission() is missing the UBLK_CMD_DEL_DEV_ASYNC
case, causing the command to always return -EINVAL for unprivileged
ublk devices. Fix it by adding the missing case.

Fixes: 13fe8e6825e4 ("ublk: add UBLK_CMD_DEL_DEV_ASYNC")
Cc: stable@vger.kernel.org
Signed-off-by: Yitang Yang <yi1tang.yang@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260901142438.237586-1-yi1tang.yang@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 1ef01ce18f4f0..959e6594013a8 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -5833,6 +5833,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 	case UBLK_CMD_STOP_DEV:
 	case UBLK_CMD_ADD_DEV:
 	case UBLK_CMD_DEL_DEV:
+	case UBLK_CMD_DEL_DEV_ASYNC:
 	case UBLK_CMD_SET_PARAMS:
 	case UBLK_CMD_START_USER_RECOVERY:
 	case UBLK_CMD_END_USER_RECOVERY:
-- 
2.53.0




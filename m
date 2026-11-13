Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591250;
	b=jbZ9aPVpXk5y6bYbJT/fBDxLqdtPljRV7xx/tPpoRzkQ/zqcDuEm+rsy8Xm07KwLcrlc
	 AeHXOceBzJh+Ci/o5zM2uzS0cj+qcMXO9vzJpB1R6UY1au2+NEKnxXUUAE0uu+AkmlrdT
	 tVoj+VAszNLy5/aEjxQVmFQQk0D89b+MmW+/whlcPTpkoXgNFZ4cejf2Tkfk9aTrQXUne
	 7qGStwJMr0LsxGvzp9tFzjsteBbrL2fHW9504aVKL6xLMCV8H4IimiR5hGSMfQPx1Mwnm
	 w1dQ7t076gpTzbadA3LPvAXXOYqpZdjJx/RSsVUuGVRAYkS1PGm2vTxEGMG3DgzyRiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eI/pDu2LpE/r+6Fpqko1ENXlN1ZR6h4DW5OJkbaDm+U=;
	b=oVoUz6gmaQ6VdIHlJbNpCJY1NdCO4fAN1R3SKxZt+MLYN2EEr3y639HzgKpAAP+oy2Aq
	 5gQF5TjDgU0IbWmDt3THh3/5uLOeFadNYpsJZRBmmR4RHxJTJTSNm2bL9GZVN9o5/TCZ+
	 3epsgdOt9kCp8ckRy92Hse5xHNp2aGudC+5EMfF6FS0mufZYpUKi0hYwNNIKxEQo9mkKS
	 i6advb2xQJvd3T/1v8hOPuQc0JuxMo+f2jyQAc274mxPSwCZ7wb/81C44Ro/sdWTYBJFU
	 z+8A/prIMCdwDMNKu6vTNZDf6tkUZL0uMncLk3yvRKebRIS7vKluNZEUBXLEfXcXIDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b1SH4WG+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC90660A262A;
	Fri, 13 Nov 2026 17:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b1SH4WG+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FAA1F000C4;
	Fri, 13 Nov 2026 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591250;
	bh=eI/pDu2LpE/r+6Fpqko1ENXlN1ZR6h4DW5OJkbaDm+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1SH4WG+/IVl/5Rx4F5/KD6cmY14AaCsvv1v3KGqxWDWzViRQol8WaLJndEOIEcR3
	 HhlHrQXfG/x7SRArUoN1IM1mS+MBwFU8UUKOm57iC7EOGE1nU3etcBCbNn4kePxwNY
	 ASc+xvbhO6j70PfJ/PByTGwRgAdBmnuhRIceJIb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/670] ublk: add missing DEL_DEV_ASYNC to unprivileged permission check
Date: Fri, 13 Nov 2026 10:48:23 -0500
Message-ID: <20261113153823.341394433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 085a4d624659f..3e7c3b1f0b8a1 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3037,6 +3037,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 	case UBLK_CMD_STOP_DEV:
 	case UBLK_CMD_ADD_DEV:
 	case UBLK_CMD_DEL_DEV:
+	case UBLK_CMD_DEL_DEV_ASYNC:
 	case UBLK_CMD_SET_PARAMS:
 	case UBLK_CMD_START_USER_RECOVERY:
 	case UBLK_CMD_END_USER_RECOVERY:
-- 
2.53.0




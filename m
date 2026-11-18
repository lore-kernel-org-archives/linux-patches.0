Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055296;
	b=Wf/XuYX259Q1Gbzs10zEQNhQybav7wovQUJEfnn8jSe5I2BgNwjbm1Wf8cQrZ17vXMS6
	 EbtqAp4v6wBH894egq7QRQyQ3PpWa80tiAIgiu/wTQHJ2los7ozD+HeTxT85il6lWsF0j
	 FWlCpZlWdQud3qZ9XOpV6mCChFoIZNWdNzFMFzcLr3s1HolPaqo9b/f+EYWxsfOW5yofJ
	 viEohSoZ3yaQ4N0Kv0YOUVs64w07MWuTnnQgsBspQPIbRlRg9M3qIpUccQzeEhKwY45rS
	 yd64llu5UT+eX1kkEcCLTB6WDSAxCPaxhk96+vEx/ftPTKiPQfhAJjNynN8zn4SCuCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PgdYYT3sOWwBn/5WA3Y8YnyISvIPtHckcPcIfLXRDsI=;
	b=LgXq1qyZr60KuRm+P3HmrjxTeCjIkTx6I8memKaONWa2giVpUZLda2gl49dmsn8YBTmU
	 BS6fxxIBlcIOsH/eZ/5sIVeJWvsM+gYfh5w5GDI2uElY9VL/eGuuBXGVEVUCr48ZM9j2B
	 8qnU86AhPKL4nLEs0t1bE6pd/nWj3ycrEYbZUOrGPqjj+wP5LL3PlTXx/fIU6QVnQ/BZK
	 c94L03M5HERskZscxX+Hoqh0s1+iBuzt8cPnul5JeignAjp9KkurlkG1pWtArFqw3AZLg
	 dss9QRqL7Vx7yYac0KPGk4sntSqYWXZlTEvmIPp4iFqDJVBZiwjr15jINx1i/wHFkSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDNSYpt8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01F606A330;
	Thu, 19 Nov 2026 02:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDNSYpt8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D721F000C4;
	Thu, 19 Nov 2026 02:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055296;
	bh=PgdYYT3sOWwBn/5WA3Y8YnyISvIPtHckcPcIfLXRDsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDNSYpt8w7IX1EMycfOBCALF+v0CzQHxnZkWVkqY5rKnZUvt8ue5NG+AmEbq+25RN
	 aETveLdHi/2PXgafIl7c74BOBp6WHb+erq3T7LS/OqC+C+6rTbEXuuvUneNsZxtk5A
	 6izP7pQJp7Gz0ttVrs6s/CQz4UduBzIU8eJqtHu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1579/2214] swim: Remove redundant RELAX actions
Date: Wed, 18 Nov 2026 15:54:15 +0100
Message-ID: <20261118150115.193479562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 04cb277e6841b55b950b42063fe11501b5d1676a ]

Wherever we have a swim_select() or swim_readbit() call there is an
implicit RELAX. That means the caller doesn't have to do it. Remove the
redundant code.

BTW, Inside Macintosh says, "Be sure [...] that CA0 and CA1 are set high
before changing SEL." Hence the RELAX found in swim_select(). The SwimIII
driver in mkLinux also has that. But the swim3.c driver in Linux is odd:
it scatters RELAX actions around as though SEL was not actually under its
control... In anycase, swim.c really does control SEL so there's no need
for that here.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/08ab67c2780c9107b87a1ece8b5f9cb54a8cea70.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b736189c93c9 ("swim: Deduplicate polling loops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index f4fbe195cbc09..adde8dc537259 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -336,7 +336,6 @@ static inline void swim_motor(struct swim __iomem *base,
 		swim_action(base, MOTOR_ON);
 
 		for (i = 0; i < 2*HZ; i++) {
-			swim_select(base, RELAX);
 			if (swim_readbit(base, MOTOR_ON))
 				break;
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -344,7 +343,7 @@ static inline void swim_motor(struct swim __iomem *base,
 		}
 	} else if (action == OFF) {
 		swim_action(base, MOTOR_OFF);
-		swim_select(base, RELAX);
+		swim_write(base, phase, RELAX | PHASE_PIN_DIR);
 	}
 }
 
@@ -355,13 +354,11 @@ static inline void swim_eject(struct swim __iomem *base)
 	swim_action(base, EJECT);
 
 	for (i = 0; i < 2*HZ; i++) {
-		swim_select(base, RELAX);
 		if (!swim_readbit(base, DISK_IN))
 			break;
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(1);
 	}
-	swim_select(base, RELAX);
 }
 
 static inline void swim_head(struct swim __iomem *base, enum head head)
@@ -385,7 +382,6 @@ static inline int swim_step(struct swim __iomem *base)
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(1);
 
-		swim_select(base, RELAX);
 		if (!swim_readbit(base, STEP))
 			return 0;
 	}
@@ -399,8 +395,6 @@ static inline int swim_track00(struct swim __iomem *base)
 	swim_action(base, SEEK_NEGATIVE);
 
 	for (try = 0; try < 100; try++) {
-
-		swim_select(base, RELAX);
 		msleep(3);
 
 		if (swim_readbit(base, TRACK_ZERO))
-- 
2.53.0




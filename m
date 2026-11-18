Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048526;
	b=riY01yPJZDWlmm7YzKbKCgDJEhQbduVNLXE43KTxZFcVVNEC/R6bXT0yzoy376hLJJn1
	 1hzJ9BvJnvi1bRSWLuJbImiWHcd4TKgZI94AJSi0b+NfKfVFwpOOU42WIGmqdwcbpI/Bn
	 9EC1Nvya7LFXZtGndu/Q/3zQTGfYAU4rP9QyF6iE8/z+vYGE+Ubm3dS7Vrb8DKrXlecaL
	 rmH0Xb+Oky5JoetIoecetQVW3Q8LstHrlCjAw+4yXor6BM0sIOhdGO8tzLe5B5hf/t8ws
	 sQCPWo8cj8doO7Av2DDM7S8hd5Uu+kS39TBrpdCPBMQR3MTzPOywG5dmCmDczj/xMwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M92GFHrKrDMQhCD74sf+kOE8/wgxgl7zuveWMX8AP5I=;
	b=XvRb6jsza3zmsvuTwtfFehssGrEVmcXbnZzelr41NpHrWV0yPDKtl1fRooIq3jlBONTi
	 XxsLoZ300aiyGWZWxSj4U04LGy+ZA2upZkDJpVms+6VPmuf8r6AUOnE9tDH07lO4oRi/n
	 J2L8VU+055L9XL7JcYh8TiHA/5mV0+7nhYviaCi3iJH8yxzNq44JPV4aE1BxyI9JFyuiT
	 YBHQ+4rlGd6569qEuVsZ07CAA03Qe/mPt5IIaAvqmZF0pYcmWGW9qQdXTkOUPA+Bk0/Ti
	 XlJNSx3I8lmBEScho3wb/Ej+rXiwDGDRlu4tw+99PIq9naSHPCMgub7VA+VN3tXR0nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gioWOW16;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15997606A325;
	Thu, 19 Nov 2026 00:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gioWOW16
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B2D1F000C4;
	Thu, 19 Nov 2026 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048525;
	bh=M92GFHrKrDMQhCD74sf+kOE8/wgxgl7zuveWMX8AP5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gioWOW16MJlyyQuCLGaDsxy82APSaCFKQQvtlKswPI99tpG1V6GK0FeorEVqCeQpj
	 xR1sq0284Mh+BxEQ4xte1MVno5iGSN6IP01NOrNLpbkp2VdwCBaB+XGSqfrm2qs+hg
	 0l7n+Jh85lR9hm96+1YUVbhCI2+AOE7/VzF80Eds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2025/2857] swim: Remove redundant RELAX actions
Date: Wed, 18 Nov 2026 15:50:59 +0100
Message-ID: <20261118150314.319258170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 3e9789f8a17b4..db0dca5f07ee1 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -337,7 +337,6 @@ static inline void swim_motor(struct swim __iomem *base,
 		swim_action(base, MOTOR_ON);
 
 		for (i = 0; i < 2*HZ; i++) {
-			swim_select(base, RELAX);
 			if (swim_readbit(base, MOTOR_ON))
 				break;
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -345,7 +344,7 @@ static inline void swim_motor(struct swim __iomem *base,
 		}
 	} else if (action == OFF) {
 		swim_action(base, MOTOR_OFF);
-		swim_select(base, RELAX);
+		swim_write(base, phase, RELAX | PHASE_PIN_DIR);
 	}
 }
 
@@ -356,13 +355,11 @@ static inline void swim_eject(struct swim __iomem *base)
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
@@ -386,7 +383,6 @@ static inline int swim_step(struct swim __iomem *base)
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(1);
 
-		swim_select(base, RELAX);
 		if (!swim_readbit(base, STEP))
 			return 0;
 	}
@@ -400,8 +396,6 @@ static inline int swim_track00(struct swim __iomem *base)
 	swim_action(base, SEEK_NEGATIVE);
 
 	for (try = 0; try < 100; try++) {
-
-		swim_select(base, RELAX);
 		msleep(3);
 
 		if (swim_readbit(base, TRACK_ZERO))
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040177;
	b=V+iiu+pG+qQgBMVj2YWwxZJmExniJLQGmrDFzlGljXtFWC4nPCSN4DMbEfrLGXZO6N/P
	 rqXFARZpZDHPYwcuTvVTMHqWOHptZHw03vuc9IYML6jmZbcBSMGeGIh1kuumjkoVxVIiP
	 m1ENAk8zFvUHePQqIbfE5z/5poXh+ZSfGetghNM5/uafTYSdPVMBWUpI1eHcSPgIXpBWJ
	 QEHOPFZvp5EjxnDdC9yDVUPIgHxmtxlTe1hytIaLPG2enuVnrPpypSdcEyKwczRHZ7bP/
	 h88XWi/iMxwgk3h4isgP61b9HL0V3CPZWmYYlSoFoadumw5/wSr0LGQppTRZt2e2+og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vw0VHSSNFbYoQLnQGcojfr2HjxgIiWG/ubH8TEriFP4=;
	b=L9+X9fp67Ih981YozTI2BymvFO0dTJjSfAu2V3G6QX3LcTMpTjs6HcSpEhHv8Ae40OJ7
	 KaG/I1MJXoZATI/ts+n+IwwC5Np94dPfVTTrbhRSEyetHOdJRyB+O4h2uVB2Gn4SY67MY
	 Emrm3buBp+qCAQmwiCq2Kz9rNn/IP/zrxKEuV15qyVqH5mLc+hMhe7qayNNqEdusGktd/
	 eWCtGP7Z68JKp/lPlLqhVzJ3/NPFcP6Ig2tdS9HQ7Y63s+Q4MOmYeIuhRAbyfffLIVgdb
	 1t9nqzF+jvCxtn3XLrrB606nLN5psoumIglvbiyEyEY+HagBTfSJIVjdD5IORR1SRAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQbKL8w+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35E6606A32A;
	Wed, 18 Nov 2026 22:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQbKL8w+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4A31F000C4;
	Wed, 18 Nov 2026 22:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040176;
	bh=Vw0VHSSNFbYoQLnQGcojfr2HjxgIiWG/ubH8TEriFP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQbKL8w+8UgSWRoB0sOKwseoGgCUWvYl/qi9rO4qMKEh3hsmo8rWrW5Rvpdh72oWj
	 CvrKTREU6LcWkWZKMeO65kBep2mP1mZdnpxASA2iwXGvg0L2X2kwuLLA+CEZ7zaNii
	 T6OibSZlUdNZgTfdbkUoEaprsbngSyLZr5vqVVMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2322/3318] swim: Remove redundant RELAX actions
Date: Wed, 18 Nov 2026 15:49:04 +0100
Message-ID: <20261118150431.332689134@linuxfoundation.org>
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
index 4fe51dbb9d047..ddb85cae76062 100644
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




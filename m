Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024238;
	b=gnHHc1avi/v4nOg3KxnIZ3F2F6ZbNcHCW3Dlqrnt3w4S6UtF8hOHCYBgaoZqXQ+u5TRh
	 +aD6vBM40XQCjyVrPT9VPyAdaEJ1hLPRarlht34n1A5LQTHh6puF5jrZlintiONy/iNNj
	 LHEOAPdbpwgXiXr/HYteO/tvKliLOYNVahHr0Z3zhY7kVn1nZPOGZu7vubvqKE3nPzNKh
	 eyatx8fr2KRg89lUMZfb1vGE5UFtcd79aqxpDUSOKgvWRFIxvtip0Y3BsCwvwzrZreKhB
	 9eggVjWajBcNM8X8ntE7a+/pX1TZ+m5pMjRle0RBz69AnTHel+K2r6PKTA2WXmWYWng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UyDpI4KWRkJBRQFS4W1lWBlWtYV73aQBl5+x2zSbX0k=;
	b=RbewWGAY/M7UISct45u2pXtVdFx4YXx4+gNkiPPGgiOLLUjElia1VsB5yb5QHL9ZnVYh
	 Kvrl7qEXYSMZFG3exTu7I2q2R4alEO6lccyEVnHbNTSfJY0LI/+LWpJt8+Judflj3OYVp
	 UcVSB7WB6R3G/lMAFBQxWJAAoV/xwY39dGWY2FSMR7kehcKByDwZzGGUPKWW/WjEArfuL
	 uf9G3iXsv7xcxQVNNFEbSldCivddYq1xrskkXg0OzXsGDkE8uSVVxdCJigEv+nPG9kXFL
	 KqJe6iMXrHUgJuILH+hV3er12IvKb6PBhQnSLRqG4A47nmaH82LuzDwuXW4oqDS7K+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJsw0GaQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0312C606A31C;
	Wed, 18 Nov 2026 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJsw0GaQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D4E1F000C4;
	Wed, 18 Nov 2026 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024237;
	bh=UyDpI4KWRkJBRQFS4W1lWBlWtYV73aQBl5+x2zSbX0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJsw0GaQVzhVMup3wHIw5SKg0dsSimGQO7Eov3wg128FRWPxh22L9kO2MO56IIlfw
	 u2xTrFt7HR4nrz3n7V4hgSG508G/sdfoSsevIOCj/t7HyMQqv55i8on+AfO9vyPu1u
	 WGOLbXsh4AVcTlZ+FQkKaAU4WAnmDCOZ8YP0qbHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0647/2151] swim: Remove redundant RELAX actions
Date: Wed, 18 Nov 2026 15:39:42 +0100
Message-ID: <20261118150145.422090615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cbf564dc23323..237ed93fb0af4 100644
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




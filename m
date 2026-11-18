Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016971;
	b=A+6y8vcAwg6o60Reyo7Hkc8scigjrTc73l9BKKsAelaS5sh8KyHADmXcCpFrIch8uRc0
	 nwjnIjTbHvgPioIwuG8AEmpbk4W4Nj2JmDcMgyQMshd65lE37Io6th56tg7qHmf5NAX1i
	 ya9lZI6SzP6o6CV36+VApfMaaopodJvjzXVpQyVwfBsj8Brbi3ygiid2PaoyQniDyK3v1
	 pu4CWObOGjWZjzhvr6bM+AvR/lv02tO68qRuvUuXJW2NkU99j1flTRuqgCe+JJMkE6uK6
	 pOoLLR/5pDXt0FGHC293YvJTvfOooN1r7UqpOcMe0cKkWBU77pZvUQcspkL5kcrWaIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M4JWqwkAxe5ny6GlemAl/hoOxjOjlDv0tBfEvJXNBk4=;
	b=yj+FbJo0GlG6iYYWxZkY79Dahiac1/6rvtIfJmpJgmroWHDwNax6iSRtLRc+uoTsV49O
	 YEdH/J5JWid8DqctImjVZdBRLTDA2+9MI2fFkGzKX9mRIZPlR1O79dlib7cjeNqPNZs7T
	 maWqKxUNWmR98MDuMgiGY6ZLJTgIZLjSGTRMRj6cIJfOwLloqDQh93PcPnZzPXlzdOyel
	 i9kQXRi/5IO4afXX+XiHBfo0NENczkHGw9dtnvuskwD3gzhiJQ5zRjTdkeEo/xixStmdD
	 M3aGL7xJHPqJM0h8z5fatCalEF4cxxupqBbit2KcYV9i3Rn3SyVHpXXrYWcdYTCauZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4d0zX0A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA20606A325;
	Wed, 18 Nov 2026 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4d0zX0A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220891F000C4;
	Wed, 18 Nov 2026 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016971;
	bh=M4JWqwkAxe5ny6GlemAl/hoOxjOjlDv0tBfEvJXNBk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4d0zX0A5Uevg0xzSq5rOFpXmMgkHELo5553xr9G1TEcz8HrmD90i3pGZcOPz84ve
	 4/BQQV7VqLFZnEtt5aZnJ8HJSlN+z3z5Hxgt4woqb8YNCtkjoNwY7cc32uE4dGkjGD
	 6ZvuNxfknG9EYLjPY4ianegUPyGYml0z9KiguwuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0718/2651] swim: Remove redundant RELAX actions
Date: Wed, 18 Nov 2026 15:32:38 +0100
Message-ID: <20261118150313.726147167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index c3fbcf377d1ff..ea46639455053 100644
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




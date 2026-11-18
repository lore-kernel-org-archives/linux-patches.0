Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052844;
	b=HBSzn1KnQZWKlvbYwoqgl14n2r9VuzauBpNKsolACRZd3Jpk/L5qiyhWWdbT5yF/Ilxh
	 fEglxc2cCJtK5XOGA2y/kmwadE0jNshZ6mOV2rWf/cTm5auQelQ3PNLt/ME1gV6PBaMbp
	 tKeBqqJtR5SnlTaw2RpzGTT64lagBG4d8FID/UMD/Fy4d/nj2pnU3MZMqtByaBHDEfmuV
	 /Atl/Yu86eAydUQdqrbgY02j1cE0ZPMZiEJsXvzn+RGTFBpXFu7KBFsQDMOskecSeiGWI
	 jZS7/QeLlYLkEKJZewYxCxh33ForlJLx6XbkLEYCoeqBtedp0oVjovPhRFqFDuDL2pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zBmUW7G4wgAFSUe1NzYFFfbJGCgzKowlbEAPpXT5lec=;
	b=uDZDMIfsUFedVv1EXwtGeMu1Xsawv45moCNokBKybanQqjVlkXmdCMYtKR84OMrpRfnq
	 5r0a70gbd9fQU66QAhSqVmC2hrVwREy7b6eBDgm4vNVhSuTdMnVyHM6pWc7sAcYPXz3bH
	 aNnTZpZ+eJeQ1h3phbgPtq7Ka47swzE59Xhw6NsqKJOLfvyp5lITsnGcqX9zMPiTOm1oN
	 PoJZS6CGu/gwVKBy0SPSP1u+2hv9WqxFwzq2hRdEsoer973/+/T+3d9VV/MlZgUmHuedU
	 pEvqNns1kUGqzIUuUCgUODkE6s2bbZ+raqSiqT9FJN60RfrWnMPF4gvztGmsHTyoUAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csRWqokY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F75606A31C;
	Thu, 19 Nov 2026 01:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csRWqokY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CA41F000C4;
	Thu, 19 Nov 2026 01:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052844;
	bh=zBmUW7G4wgAFSUe1NzYFFfbJGCgzKowlbEAPpXT5lec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csRWqokYL3o9vrL1WaTzAdtpTC0WPn14a2Yr2YzzneXUfoSqvKWUJwPV21e+Sh0HC
	 RCMmA/WZZqbfGsKXgo7CgNxOQOh4m71HiSjmmGmKq/q9NcxJx/CPve7EHyx+rE6CIW
	 V0k3IzfeQk8C6y2uQmyNIJPFBaj/N99MMzUGNWEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0708/2214] timers/itimer: Keep a nonzero value at CPU timer expiry
Date: Wed, 18 Nov 2026 15:39:44 +0100
Message-ID: <20261118150040.119244876@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit ef60f61208a30eb5b941b707debdf04517271b4f ]

get_cpu_itimer() returns a zero remaining time when the sampled CPU time
is exactly equal to the nonzero expiry. This makes an armed ITIMER_VIRTUAL
or ITIMER_PROF timer appear disarmed.

The cputime cleanup replaced cputime_le(), which implements <=, with <.
Restore the inclusive comparison so the equality case returns TICK_NSEC,
like the overdue case and set_process_cpu_timer().

Fixes: 648616343cdb ("[S390] cputime: add sparse checking and cleanup")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020223957.87842-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/itimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index dc5b1d92e2466..677b67812fee3 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -60,7 +60,7 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 		thread_group_sample_cputime(tsk, samples);
 		t = samples[clock_id];
 
-		if (val < t)
+		if (val <= t)
 			/* about to fire */
 			val = TICK_NSEC;
 		else
-- 
2.53.0




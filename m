Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058733;
	b=pvjqqvIaOgaU0h/IA+FhU/zETwT2SZRGit8Bk6/+DsQgm1yXHl2ricVacB54taZsNZ8Z
	 jMDc+c2yi8ZKbsQ6M1/eXfKpKLgzGCHYxzPv85J3MgdAz/tzf5uVgEXKRFPKAdVYysbKi
	 S7FQONE9RQlFfNF3RGdDyCIFOFORrEdspQx1yBr1oD6nExBDGJMVmCgRC0c2TObFISjVg
	 A1/IevH8yOuJvSPRXU+Xizow4EzyY3ZsMikasQesJmtnMcriNUKmGYXsb79xpwokkydVG
	 tcTyZotBmqbTSg8oYHpmVPYnSL83fqSkDw9966JMPGaThEKYsxqfhdS/UEEMwqNL2xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FSWnTwsPfgBytLE1PTfkXc6bie/WoEsHlbQMTNE+aPU=;
	b=s8LVR2/ZgYJSBHEfB13ELstlFfIhqv1nQkPo/UR6CN4JNPQfoWxBSYJCm0x+tCl0VPLq
	 pwKOA1SI5tm16MKDjvYBtfSySF5DAeCO2XFxBVxDra6KTRnhgK6zJr0kNT5l3ZS+D9E/T
	 8qkINdHyUbyBiuM+Au4QZXia76dTDXHJ0oxpNEIYBEPQyF3dZtWxdfyZjv/IVZLm6A7io
	 NHfVecAs6Q3W2RP1lKiuTzRCvmZTkY5vwNp4CVkkSQ+ytaf0Hdeb3/6DbFl6P+j0UbtNo
	 dtaIzZ2d0AsM1ajtG+eQp1PweaYm6au61QO7YtPYdm/IPidHYGRF9e7EBAO5G+UPTxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCXvfaqk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6F1606A31C;
	Thu, 19 Nov 2026 03:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCXvfaqk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461C41F000C5;
	Thu, 19 Nov 2026 03:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058733;
	bh=FSWnTwsPfgBytLE1PTfkXc6bie/WoEsHlbQMTNE+aPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCXvfaqkqquiLhN+B7kwnDBgbwCZiwIOT1CGfRXugH7Qk46efQkf0PX24IeeHxR58
	 zShqAdDz5IHt0Yyggmru2rYCUgz4ip4L+kTsAFoYg2MF1HQZfSffClR+An4cX4P1HH
	 3kRgb2q7hNc3sYuVjz2Lj8xI14NY7rcPX7oBpSTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0574/1848] timers/itimer: Keep a nonzero value at CPU timer expiry
Date: Wed, 18 Nov 2026 15:43:32 +0100
Message-ID: <20261118145939.135318483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037588;
	b=SvUcfqPlteJEv9XZioqDcSTYcZZU5eopLbDeFMKb9BwiNjWJMTwjgDhE8JM6QIASohT4
	 J2CNFtdEYMkeUkPU8LUkGvS5zqxfkxbdqiLtQDxspb3CbJqu3dnWQJSgn8OCNE0SRR0lH
	 32nhvrvmQ366CNovF4/M8WpxBMY+kCIMNYsKpdjece4tcDuec6VA/q9gLxYwRLLbScAn2
	 hhtzry+Wyvz1VBvL1qQZay7kiRp0GYkrEwI5IcTCaFR25sg1dQ/Nzsz/31Ji8XHEy9Xat
	 vqJTRWkCzp5CM8oCc8F0S/UGqTwDu1+QfjXnOZ5X/xANb3FBTsq6s+kvFm0L5+SV22g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7f8gyw6ZgUZ+6In1UH9WWAMJf5G969Fo/PwAHfkDlEc=;
	b=FQRt6Z4FEMuEoziIVgBJkFqPznPl2euRI+CIEqHhb8dlbWvyiQOAiY2UlwkgRKw4u8+t
	 Ra1aX0Z9D6V4YuWqn21A184q7Zk5dPbwwQtNUrlEJeMmVuJSsGIZ4LipsNcRtlBlQTzRG
	 T+DV37JAwZ/hJkqrPiaAROhOYxrJ1qmXjukMihzAfvqbKOyDIz1u1iDC77WWfpWULHMP+
	 ZFJ7oeIAhglNMwfwT+IX48GOowerF5CVG0M9/9I7k83+0Gu4R7h4yD1Auzk7W0bcBrkQ1
	 WiYFfyO2y1PGBDSavQadmJDKiTW+nTB59bgHQNTCy8f469hhWhcNOzHA//AEHVBvcBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cd1jGaIO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E684606A31C;
	Wed, 18 Nov 2026 21:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cd1jGaIO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC60B1F000C4;
	Wed, 18 Nov 2026 21:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037588;
	bh=7f8gyw6ZgUZ+6In1UH9WWAMJf5G969Fo/PwAHfkDlEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cd1jGaIO5wuIatAqmikyUkaNMM1GX6lMElG7pQkCtC0opcSTqfJ7yyIBric9x/JWd
	 XJJj/y5KWvT2jfEWjKUcCs8Ba6VhmdhXvtE5g5StORiaDvJisuMzCqoWquEEunzZ7x
	 WBTR3zsu2Vtjjz6T3lGbN4bczpUyC24P4ozZhhvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1450/3318] drm/v3d: Initialize timedout_batches when running a CSD job
Date: Wed, 18 Nov 2026 15:34:32 +0100
Message-ID: <20261118150404.354574292@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Maria Casanova Crespo <jmcasanova@igalia.com>

[ Upstream commit 0afdbdd5b1af729108de8f893d179c3b99eac29d ]

v3d_csd_job_timedout() decides whether a compute job made progress by
comparing CSD_CURRENT_CFG4, the number of batches the dispatcher still
has to start, against the value saved at the previous timeout. That
saved value is never initialized, so it is zero on the first timeout.

On V3D 7.1.6 and later, CFG4 counts down to zero once the dispatcher has
started the last batch, but the dispatch keeps running until the batches
in flight complete. If the first timeout fires in that window, the
handler sees no change and resets the GPU while the job is about to
complete. For example, this happens with long dispatches that only keep a
single supergroup in flight.

Initialize timedout_batches to the value programmed in CFG4 when the job
is started. The register does not return to it once a batch has started:
it counts down to zero on V3D 7.1.6 and later (CFG4 holds the number of
batches), and to 0xffffffff on V3D 4.2 (CFG4 holds the number of batches
minus one).

Cc: stable@vger.kernel.org
Fixes: d223f98f0209 ("drm/v3d: Add support for compute shader dispatch.")
Signed-off-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20261101125619.2465064-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 8048910113303..cc2fff270630e 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -260,6 +260,8 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 		dma_fence_put(job->base.irq_fence);
 	job->base.irq_fence = dma_fence_get(fence);
 
+	job->timedout_batches = job->args.cfg[4];
+
 	trace_v3d_submit_csd(dev, to_v3d_fence(fence)->seqno);
 
 	v3d_switch_perfmon(v3d, &job->base);
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059035;
	b=cxzmQux3kq31nITowy5d+tdjVZeVjZNZglUe7W3U5yFbjayLE6LM2OKXstVmKHU5AGIZ
	 mXXuaTWqSpHPmnh2zM5yROPsT7YldyupNtmpudm4UAfCGOFYqJRjjoDozkzEtpgQPai20
	 0Z1G56aUP0byOuuDYYxuxpUY1hQvLdw+BizJ8eVlPyEe2Uh7Kao4g57as34uqliTvrV2d
	 pMFhMILlPzPw7m917clCoXr1PztGBCB3GzkIj7qSNapU9tlodEr2fPQAm81ELbACmZDRo
	 7MNFBQ69vC2QL3yH3qtt495ZM3zgvpeGXUjc0YYlCd13EPt5DQN1SUIkaVQ5CxRwG4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=asdgZdyVr2bQajDGCnOhymVjtYbl66QsogYsFelCskY=;
	b=q3kNOuwXJfrORgWc04iQu7f3kr2TcvF6Atlpc7PNCn9VwzxjFNDI7MPSMZLW7V+CJfJm
	 PV7oxVGGGS8GcTZYRalasP3Ovx+LOi3gM50ln0At11HmFggJqazB7yLbO8zwIA/mTiA78
	 fSj8d+0L8cHOI7X5htMyArLVCs1WvTTTcWzg0nzmNKkz4gP9UwEaa7XP0lnnXjAu2h5lv
	 +ktFN3ANkXRf4hymXyqHJLiAcKmPQ3s1jvTbybxD8IR+QHutQtNr7O4Jl6sxXJtdjgR+N
	 TP1pA6imkVyFRhXAOiWkgtiYQ/IyTtzjI4soPTTa5yqXPVYVnUEAuPUkXQPCmvkxKcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvWzedJq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF8B606A31C;
	Thu, 19 Nov 2026 03:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvWzedJq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19DB1F000C4;
	Thu, 19 Nov 2026 03:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059035;
	bh=asdgZdyVr2bQajDGCnOhymVjtYbl66QsogYsFelCskY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvWzedJqtqd8O4vGSNFrq9IKXjhj1TadcjENLBbjjzMZ/wVjgkGpl69LNn2x2wkZ3
	 AanlN9El2/kWJvF60c5p7YILfToWAcSOxC07Q5aoANxX0/0rs20HC17VTwVTkFfy3A
	 KrSP8F011uzipzIvYfRNyGwfpLtW+Xg1QFc3d0QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0697/1848] drm/v3d: Initialize timedout_batches when running a CSD job
Date: Wed, 18 Nov 2026 15:45:35 +0100
Message-ID: <20261118145945.064501152@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 310fefac46c2a..badc39d6f6210 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -245,6 +245,8 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 		dma_fence_put(job->base.irq_fence);
 	job->base.irq_fence = dma_fence_get(fence);
 
+	job->timedout_batches = job->args.cfg[4];
+
 	trace_v3d_submit_csd(dev, to_v3d_fence(fence)->seqno);
 
 	for (i = 1; i <= 6; i++)
-- 
2.53.0




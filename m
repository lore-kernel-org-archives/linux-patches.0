Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215156;
	b=SP8d1efDFN2uJlKEOTAExZZe9JVIMYcHoYVkcZArd3fjkkIvD1V/fOvqB3Gzq3v+Ya3F
	 zmkqtnA29crpDFjEXRYRvaXerp9v6jXePvG6Mm3ySMqZ5AUufQFoaAqi4Ge41yC1qoaWP
	 atCN1lNHv1vhrFkgn6um0QehKoiS1DvVtycfEs/UBYrMMX4aJ3kCy1cCeitzw3AP7pSSN
	 6qKhb8Ix/7J6taceBHAdMd7RqGsvmi7n479Bunt+sizU9tpxgW8TYVNQf97fyb6FrGI9T
	 sVrknQqTg/MBdMhZej6Y5nnuJhADI3HYurfa6DYmoEKS5nBTcryjtm09ogHCdMqSjRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=52S9HXsy9R9k0OWEAt6qrIHUyUZLcxZyBHKTCzLnNeo=;
	b=3Ot7MEnbfNrf3wXLrEMBEeW+K03ILUE9QcMKHhq8K4qf/5SIxzB6gyvmZWVKryMdHbC9
	 xKR18LhVxKZT5LsOq3qWkubwxS1pcnxTPG4WE45dx1B50oVTYtgmUqjkfndowxXYd5zkL
	 Nvmd5UE5JcuZW2TaFqMKopKzCEBQ3niwhmgDyJmxc9efVO8zzb2aHSMTpKNON0XFWnQRB
	 +pOzhWlW9jGJa5AJjp/hjaJRfU86RjW1cu5mRhe6otlwaD72FgXqkmRmcML98A2q/r/Ru
	 m/AtxSCbrvaUbTIL9Ucq2BAHRKkZ+8SXFzKjTeVxAjDBIq5URE4DqdyJuqQaWGIixWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WqZ/I5zf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3904B606A31A;
	Wed, 28 Oct 2026 19:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqZ/I5zf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8991C1F01825;
	Wed, 28 Oct 2026 19:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215156;
	bh=52S9HXsy9R9k0OWEAt6qrIHUyUZLcxZyBHKTCzLnNeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqZ/I5zf75HV+hlYdR6ZdxY9E7bzjlr74IF81QTSvT3LzijtU+jvigCV9hccBvCt2
	 QDe6OCKjifHRKk63mQ7OU4uBmav0oMB/msgF9sSEwa3dKGDUy5+wT9eExWWHpjyg4A
	 +j5wxEYusDwOgIEV4W1brFoaNQSYmzbDCm63+QAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1112/1887] drm/msm: always recover the gpu
Date: Wed, 28 Oct 2026 17:53:28 +0100
Message-ID: <20261028170524.709660396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

[ Upstream commit 01a0d6cd7032e9993feea19fadb03ef9d5b488f2 ]

Previously, in case there was no more work to do, recover worker
wouldn't trigger recovery and would instead rely on the gpu going to
sleep and then resuming when more work is submitted.

Recover_worker will first increment the fence of the hung ring so, if
there's only one job submitted to a ring and that causes an hang, it
will early out.

There's no guarantee that the gpu will suspend and resume before more
work is submitted and if the gpu is in a hung state it will stay in that
state and probably trigger a timeout again.

Just stop checking and always recover the gpu.

Signed-off-by: Anna Maniscalco <anna.maniscalco2000@gmail.com>
Cc: stable@vger.kernel.org
Patchwork: https://patchwork.freedesktop.org/patch/704066/
Message-ID: <20260210-recovery_suspend_fix-v1-1-00ed9013da04@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index f280c8f13dd49..55cbebe7a1681 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -421,25 +421,23 @@ static void recover_worker(struct kthread_work *work)
 		msm_update_fence(ring->fctx, fence);
 	}
 
-	if (msm_gpu_active(gpu)) {
-		gpu->funcs->recover(gpu);
+	gpu->funcs->recover(gpu);
 
-		/* retire completed submits, plus the one that hung: */
-		retire_submits(gpu);
+	/* retire completed submits, plus the one that hung: */
+	retire_submits(gpu);
 
-		/*
-		 * Replay all remaining submits starting with highest priority
-		 * ring
-		 */
-		for (i = 0; i < gpu->nr_rings; i++) {
-			struct msm_ringbuffer *ring = gpu->rb[i];
-			unsigned long flags;
+	/*
+	 * Replay all remaining submits starting with highest priority
+	 * ring
+	 */
+	for (i = 0; i < gpu->nr_rings; i++) {
+		struct msm_ringbuffer *ring = gpu->rb[i];
+		unsigned long flags;
 
-			spin_lock_irqsave(&ring->submit_lock, flags);
-			list_for_each_entry(submit, &ring->submits, node)
-				gpu->funcs->submit(gpu, submit);
-			spin_unlock_irqrestore(&ring->submit_lock, flags);
-		}
+		spin_lock_irqsave(&ring->submit_lock, flags);
+		list_for_each_entry(submit, &ring->submits, node)
+			gpu->funcs->submit(gpu, submit);
+		spin_unlock_irqrestore(&ring->submit_lock, flags);
 	}
 
 	pm_runtime_put(&gpu->pdev->dev);
-- 
2.53.0




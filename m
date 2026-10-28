Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214621;
	b=EUsN7Ml+tKjWjbGyqnWyyJqzqEm5cqU/+HDav8JoKs09KK76h8OaZcP5QnjsbnBT20Cm
	 EgB8leWgZdSddmOc1HDAcxLYxKMOqyd2t+l5cHu61QhRNVNv1ZJPHU4rHuiCmSQ0+YY6w
	 bH0i2S8yOCyqAK2wXtuT4ucLjkgjG/XFN6X3rbOJy4Bv6M7VygKc1eFlrQ1LUE0szveVs
	 3yOEBRD0J2M+yL4Nr1v1EYHC87CFWtN/Ro45TEopXDdI31Bc0GomTN05J+ZY9cCJLlGGJ
	 eEfjR8Nh667+lhrZCvQgWJC15EebvKabd6F06wQe+LPdw9IQeUoj7JIdSS+xo4utFBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4mUZUhRObitl6a8Ox24eo0f83bM3aHK7ZB+nqtL4N6o=;
	b=jUB4x8eINC0a7dvyCnOr5g6dwsLa5t0xO42NnWDhNi4RmO8TuFZF3v8Eqsn6Nm4NCafv
	 dSOeh47JdJBhYCPiaRyG2QuTCEoliY3jdUP67iWbOW7dzdnHpXcTw9+ECHmSqwlbmbNE7
	 JYMwo+Diz02YGBzwSIURQZ4ySEkSdpUbgKsHRfmuHsAMv5ctNtHbM3FH74W+3EqCJBG+A
	 MueqhSsssUnf9gZgm2zutfSKs94gU4fu+KPnKXcVZ+WcX5xKLJne+khJktsw24td+39nQ
	 tNUvgfDIxEZzSz4D/moeBD/6f5N/i/DJHMqe55E29+0qcgqz+FntKS7Uu7lgaQaF7pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MxF7rpbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3051260A2605;
	Wed, 28 Oct 2026 19:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MxF7rpbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8535F1F01825;
	Wed, 28 Oct 2026 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214621;
	bh=4mUZUhRObitl6a8Ox24eo0f83bM3aHK7ZB+nqtL4N6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxF7rpbhdMmXCQiz7IIO04UXnHzGKCYmHJbZbMgcgks7jlT+guEQ7YpEbsUGq1LYj
	 EiImaKA3gecg4a5bQOFFQuPXHu+jYqFmezwf5K3W4F7lFEZzcif3jE5OEkCgeugkCr
	 /CbnladFJEprXkx93q6nvmtz4t1i8cQgB8MMPN9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0923/1887] drm/msm: Recover HW before retire hung submit
Date: Wed, 28 Oct 2026 17:50:19 +0100
Message-ID: <20261028170520.419476912@linuxfoundation.org>
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

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit b303e1d52811de7d1bcf793560754d4df68d4a1c ]

During recovery, it is not safe to retire the hung submit before we
recover the GPU. Retiring the submit triggers BO free and that can
result in GPU pagefaults since the GPU may be actively accessing those
BOs.

To fix this, retire the submits after gpu recovery is complete in
recover_worker().

Fixes: 1a370be9ac51 ("drm/msm: restart queued submits after hang")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730655/
Message-ID: <20260605-assorted-fixes-june-v1-2-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 9385419a78dbf..f280c8f13dd49 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -422,11 +422,11 @@ static void recover_worker(struct kthread_work *work)
 	}
 
 	if (msm_gpu_active(gpu)) {
+		gpu->funcs->recover(gpu);
+
 		/* retire completed submits, plus the one that hung: */
 		retire_submits(gpu);
 
-		gpu->funcs->recover(gpu);
-
 		/*
 		 * Replay all remaining submits starting with highest priority
 		 * ring
-- 
2.53.0




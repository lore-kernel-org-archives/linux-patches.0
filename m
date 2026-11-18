Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042975;
	b=tZNH0S0gHK1wJqffoq/a3JSydVGGmfFAAD/tRmpNYO7Hq5DFA+CeAz+gmx2Gc91Z2ctN
	 6Rtaho2vaspAMJpXR9pMuCogXAr6yLPW0rF9HVyycxY2rVQzfTUR3G31FdWlj8glP2Efn
	 7qYvdUJ3lfU9g8ixMQzfMT4b2FczxEprf4iqsSNRujz1iQLHfRwbJmyL7iOWs/6epy3q7
	 WsbaNEuVdHfd4zDSA6FkhxcT6Sp9u5EFqM1zN1Xg79mTejBqxENiwEQIfp5FcywU9A7FK
	 rzOoe8SUEEKVf5qELGKJMif9zkl6j5HJjvpicd1BJauUJMs7AqX0gKEN7y8mjXLK2oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5XXoVB4ocnXo3Xi8nKllxkEHNlJJYkrNE/2aRp6ELY=;
	b=z6Q8PQRR2eDla6CGYb20nQ2khUWsZ/6fP07yi9pW4/kMsLCF+G4rw1Sik5D0vDuwC42n
	 f8QiC0oGOQvheIKtDy1qu1f/cg0/f+ZxEhR/iz/f80+iXIvoc5fqoE2J0V9SaKKRRJKjG
	 j6KWUYEG93qtnLStI+eNbaCS0H9VibXW5wt6VK8kbr8ysMqT3R2yC8SDL8FMtozQlEuRJ
	 fWS9sscqwXQcqy2tCBA0pFHRvP7gwMeCGHJzXc8E+z6UuFo78ucQwdJ15rMaigl1zqg45
	 AJS7rkryqXALEwlGtKWYU0AitlQPGaiALvJDvTbT5UUm1cjPwRnHgc82h5B7P/sz57w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tJmEW+H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631E5606A31C;
	Wed, 18 Nov 2026 23:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tJmEW+H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80A91F000C4;
	Wed, 18 Nov 2026 23:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042975;
	bh=s5XXoVB4ocnXo3Xi8nKllxkEHNlJJYkrNE/2aRp6ELY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tJmEW+HfSfGmykRiTg92MJ3TVG/3MLrzUTjjLswOm/AA9CRbfmFqhgyb/pnUWqSW
	 1ufC8+6Fru3ar8ehK6RAPU+TKTzACt2q1k9m4SrVn/kS9N433l21XPJJrfettdqCrD
	 hrJyeT75foeVqy3m220w00rQGZgh1ZRIT9j084GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0045/2857] drm/amdkfd: add sanity check in svm_range_is_valid
Date: Wed, 18 Nov 2026 15:17:59 +0100
Message-ID: <20261118150202.951902579@linuxfoundation.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit aa7e29cf9a37092cf5057a612ee09f28df20258f ]

to prevent svm range to be overflow or underflow.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 6555a15e016ec..e60ab76d3e6f6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3160,7 +3160,13 @@ svm_range_is_valid(struct kfd_process *p, uint64_t start, uint64_t size)
 	unsigned long start_unchg = start;
 
 	start <<= PAGE_SHIFT;
-	end = start + (size << PAGE_SHIFT);
+
+	if (size == 0)
+		return -EINVAL;
+
+	if (check_add_overflow(start, size << PAGE_SHIFT, &end))
+		return -EOVERFLOW;
+
 	do {
 		vma = find_vma(p->mm, start);
 		if (!vma || start < vma->vm_start ||
-- 
2.53.0




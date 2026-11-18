Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033558;
	b=J5xAfXmzjtxa2w4BP3uW+VWFfHSIoRUyaafFAkFyzZcNQKJnnp7ZKMUOddE0ude7HIYB
	 sBhdYDARBcRPJXvpIQuGI1+yjRX+xZeiAYxQnrpTog0mxmxvlvRAIMHeQr5tIvl/KF6no
	 5Ds3FZfYDJkA66V5coD5dRQoyMpa9Rnk4Unf1i1mkJlRItBvHxWd0CCVVkjgur9J9QwnA
	 opjlgP4ZNTAAaaeFfJFUZZ2V/Uf42FrRehLz4mG5qAPgCVY80mDrlFQRYC+oMUAbVeV6N
	 AjjWdsY6bKykCnoCuukhHNdxTweNRRVS595pC54bhofkFYk3cNSACeR6TaYPDXUpHGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vRJXeBhXGNdzll9vOQHnRlnSiGFaGqHtKNph1eXOSmY=;
	b=XOy7TEcgIr5uUcQat8d0bzabCFSpEqtot6xXh4CFNAeL/dmzeaKMe2YEV4dufn6G6CCg
	 riNnc/oXCEumOn6Zn6iivc/LpSMeY/TvovQOkIpnGTdKPXMGIrqRWYa8Lvk+nmKqWrR5/
	 rWkr0UpuflStPWwc+eP8rdtaUK4Z3AfYHb5YNjirjV5nsX6D38NOYJKHl2taLZErxqnbS
	 uRu8hZj5mK3DgxXoIwMzpzJOKxAHlkJFV5O13gJEyHEJqK7G8uQl+WyM/pganc9e1rfAH
	 v5UpivqBaxuVGKmJHLA6wpmNaJrxCIKXSunVoWCup+gwyc55buGHktnBDVEos9zW9Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gklz9OpK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ACB606A32A;
	Wed, 18 Nov 2026 20:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gklz9OpK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A4E1F000C4;
	Wed, 18 Nov 2026 20:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033558;
	bh=vRJXeBhXGNdzll9vOQHnRlnSiGFaGqHtKNph1eXOSmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gklz9OpKy8UW2Wx22S8G1e0MSULSuNXfmTL4USkP1hi85G7eoq6MY83M3EJ+eAsLV
	 C3v9Alxr+T8rUH6hDoFFLqY/t1nmz/PRfLNMN57YeWxn8fDRh9ZaIg5ksMRwDYbIMD
	 PVqCUrmCZbD4VQW9KWNzfivyiQJFRBd2KuZJn9GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0056/3318] drm/amdkfd: add sanity check in svm_range_is_valid
Date: Wed, 18 Nov 2026 15:11:18 +0100
Message-ID: <20261118150315.626927809@linuxfoundation.org>
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
index dc4d6bd4a7d00..006ba258e683f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3319,7 +3319,13 @@ svm_range_is_valid(struct kfd_process *p, uint64_t start, uint64_t size)
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
 		vma = vma_lookup(p->mm, start);
 		if (!vma || (vma->vm_flags & device_vma))
-- 
2.53.0




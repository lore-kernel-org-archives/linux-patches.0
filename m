Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208346;
	b=Y6ZYo7Chm2MFOAVpXRT2wg8Yeiyd1byEPiFfO8WG3lQnkrHFzWXdDqhEIq67RZ33jsNH
	 pAxQYbQI8oiL/ScCR1EvQQUYuOHZMrE/UKeFbVjR4LoJ3C1agckmHrg1/rMn6BvZ8Jc9G
	 D0g4ggWAlOcs5jSeasAbSXEJp/JLFfnT/hVR9fj2Nxf0QS/YV4YvtXNAJZw95qxd5nIC+
	 Dx9hLrpkQ5OHSySs9ok/jYtqTRRilLbKqL50XobRZRghywJx8qE+4vQPApeRg+W2VYgzx
	 evufU81T2wWVoubHy7cuAENXGnVLYMJ0JRDLJ94FS3HZN1J08Ut2s8T4CmlWbvwvIOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLi/rT/SQvOMgROLWLKhkdz3Z9N+KiNPoybKGTt+egg=;
	b=RaQMHsU2UdICUAptr3bAEecCYz+eLOdJDkQC7V4l5Zs25FCdQMy7wU4L+zEFkQjdNdgd
	 OiGs5ak2MD58yTWH780ocnqEN+xFPSoAXbMt+ZvBFv8WjCIT7D/a2I5DuIsH2l4mH3K2O
	 /eF6aVVsgfGai4IUfdBCGNy+qufLSE0NfzhPDQEkShiOQyXstpGOS+FNgx8btLy/sOfQX
	 +BwObyWWyfYOD+JKhNJNPblFLaMgYksujS1KA/P0aqrxo0L+Yp+ZHtEtTE0hhvU3H9Blt
	 z1O+fR6OskrS/lsu6vXAIVypIoq9+a+NqwGwxbO1f9Bc2V+BHC6lM+aTsluZEKZPZ0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hy1apd6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104C3606A31F;
	Wed, 28 Oct 2026 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hy1apd6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F711F01825;
	Wed, 28 Oct 2026 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208345;
	bh=eLi/rT/SQvOMgROLWLKhkdz3Z9N+KiNPoybKGTt+egg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hy1apd6uS98O97KgH2KOsuuYwltx8/M0IJVd6FKKDVHAblxhF+v+rgL9cGRRHKsBL
	 gk7GB9qlz5NQ1AZc14lMztWr+D/sbHcjKG2PF3FAjWOp1DYP1sAyXH67+GCwXz1zVj
	 LeLX0lpeitt+dg2dYGYtjvjCssXxVkXB3Plu33Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/516] KVM: s390: Fix length check __import_wp_info()
Date: Wed, 28 Oct 2026 17:53:58 +0100
Message-ID: <20261028170005.555309527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

[ Upstream commit 4c07680a467e2f7697245bcd11691bffb2a6f0ed ]

struct kvm_hw_breakpoint::len is a __u64 that is fully controlled by user
space. This is then assigned to wp_info->len, which is an int. The bounds
check is done on the truncated value while the allocation uses the
untruncated one:

	wp_info->len = bp_data->len;
	[...]
	if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
		return -EINVAL;

	wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL_ACCOUNT);

Use the validated value for the allocation as intended. Without this
fix userspace can trigger >4GB allocations which will fail and result
in a WARN due to MAX_PAGE_ORDER.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-9-borntraeger@linux.ibm.com>
[ Retained GFP_KERNEL instead of upstream GFP_KERNEL_ACCOUNT in the kmalloc() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/guestdbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
index a0d3a1c6cc409..38f9296b7055b 100644
--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -184,7 +184,7 @@ static int __import_wp_info(struct kvm_vcpu *vcpu,
 	if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
 		return -EINVAL;
 
-	wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL);
+	wp_info->old_data = kmalloc(wp_info->len, GFP_KERNEL);
 	if (!wp_info->old_data)
 		return -ENOMEM;
 	/* try to backup the original value */
-- 
2.53.0




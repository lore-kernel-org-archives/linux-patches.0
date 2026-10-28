Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210424;
	b=sGSJJfvP/PgTXji1/H6zOTJ1dwS2vFDufeTDa4BlK9oaILrLMMR1F9haQpdNZlf/0Y8I
	 O6ucOi1+ekBNq/eImYXGeE5E0W4IMdJAhf9BvlDtPEJ6MXhn5taF065ngeCEMpMSiHtbh
	 LpWCfFn6PuoJ+Rb+PlLH6ys5e6dG5R3ICHqbaRwWpa7hLrdhH7Og4R8nc0ZC9NEWbqGA3
	 CsaimOoIFi8K7g90MzmZILn1AqGwMppUEZGd0swVFkYEySJmO0iS6PGGx9aR6QqEyp9Ei
	 hntWwRm23p0xSTAiq6QW0KCdQHwL+lTKQ7kCuPOCVT9ZUExeYfxfT8LuRFRnCCd64iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=waoIFj2vPsOn4pp1JnO5wNz8HH7R2mFPebl7ojTfwcY=;
	b=u6RrP3HmnK5ter4mymtrS8/45Jh2Z9dE/R+W0K7CrCUOd7FDLoI8Y1QHOL2UBf/age4G
	 VCMo2P01QgJsLz0bxgruvE1Edm3VNl9TC9bx3geJIrtmdj5pf5LCcJQiigC9e/BKCUJm/
	 00eUh0KH1uSyroRvabRpYixVYTA7TnIGJlTd68qOym9DDT0je8tNBbPvGrPXoJlNQv0rK
	 Cq4h+ZmHH2P/lyNmPkmAIqgpODD8ubDJzL5ehWU8pUtxTbFHnR7ptpQpSi4tVj4N3vonN
	 XZxBh8dz9FdFfTSWHnlx/0rEJIYQZaRwJsuuiCMqAx9g94LPQnpZtOPmVNgP0K2ydDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EVqIU5ca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4218606A322;
	Wed, 28 Oct 2026 18:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EVqIU5ca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD6D1F01828;
	Wed, 28 Oct 2026 18:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210423;
	bh=waoIFj2vPsOn4pp1JnO5wNz8HH7R2mFPebl7ojTfwcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVqIU5ca6DiynUmqquokbklEW3/hI6Spm7SBslI+fk6YlGLLHDVMbe99JrujvcwJz
	 B55U1nkSWkrBh+LpWvz4ZPLrTK37GZ96Y0VWMx2IblJRcv9OWBdCDJ1mXn7fXQBw8a
	 HQZlA6nAOMnwuDghie9Q72fR69eVxJp3vyi7p38I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/571] KVM: s390: Zero initialize data structures for inject_pfault_token
Date: Wed, 28 Oct 2026 17:52:48 +0100
Message-ID: <20261028170008.525105175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

[ Upstream commit 4e2c7f7cbc27418f9a290399b986c1b85ff93b90 ]

__kvm_inject_pfault_token() only sets .type and .u.ext.ext_params2 of
the on-stack struct kvm_s390_irq but the full ext substructure is copied
into the cpu local variable on inject. ext_params and pad contain stale
stack values.

Interrupt delivery only uses ext_params2, so nothing leaks to the guest,
but a host user can use the migration ioctls to get to the data.

Fix by zero-initializing the irq struct.
Do the same for the inti data structure.

Fixes: 383d0b050106 ("KVM: s390: handle pending local interrupts via bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-3-borntraeger@linux.ibm.com>
[ Adjusted context for missing inti_mem and ret declarations in __kvm_inject_pfault_token(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cc7da8d840615..4af4d45e65d48 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3985,8 +3985,8 @@ long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable)
 static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
 				      unsigned long token)
 {
-	struct kvm_s390_interrupt inti;
-	struct kvm_s390_irq irq;
+	struct kvm_s390_interrupt inti = {};
+	struct kvm_s390_irq irq = {};
 
 	if (start_token) {
 		irq.u.ext.ext_params2 = token;
-- 
2.53.0




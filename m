Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212101;
	b=4JF4PTIYd17PZOi6Bwl8wLFv5EmeFD+1wtibE9TwErdAI0Xv0ROrVKu3JdQqXaqZG+JL
	 Mw9kFaMF5KoH2J0aIIeomL6HEETYtdz1wvIbHb/neFaTdBsGyyX/DjVwL1q5Qn8YhvZTO
	 ExbroI8BA5jB6H7GKV3JRK7i5n7QV7tOKDu80uL+WVc/5V0wn/cu9HNwtDdUe8keLqmyJ
	 arhZrBq/4u//Dbmb6EBj4X/JD06PHO0NEsbIRfmgrdBBSEVZzbFXGCPy3Z/46HOZQDzKH
	 Tb3I0MaU7Lria0+/lNyHIMBRJ0SGjdC5ZU9SP4enk+4VY2xu95WXX8mTtOsPe4jKexA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kXpiX08ZsOsbwQGo8AVUP6KvvqwwW4qfCyqmhNHPwng=;
	b=IyNSPmhdfVIeIqVvDwOplVnYnZeoYk0PPcUb0YgtM7Gr7BuzWmJ3uDAHBKParel1NrKz
	 +Rffrefbcf04C+ern9CRwBx583hyreuFR7C/3qLiw+wrQW9iie+J9R54i4SCfMiCRaml7
	 1auhoywi7cmwL3baqip8QeOYRyM9Tz6pQRno/mfcxINk3mVmgaUewMaLlhrwtVQKLxzad
	 Nh/H3TinjD+ch3Ohrxes3iwlzT/Wm2A//grCp0WDlGB0b6VeQ8+5DBK33c07vHS8uBN0D
	 Ug3eeT1goJ36mwfkiV1lPCHa3ZcYon2/hyANsFiVVFu9SyZ1rV4YdS3xv7G2nGQjl5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIqJXzYR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D2D606A31A;
	Wed, 28 Oct 2026 18:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIqJXzYR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B2A1F01825;
	Wed, 28 Oct 2026 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212101;
	bh=kXpiX08ZsOsbwQGo8AVUP6KvvqwwW4qfCyqmhNHPwng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIqJXzYRvNztsDIde+mYuHakpodoIpkQyxZ/vi3aXrngJf2DwB5cwnkB+SzDexTU0
	 9g0UyEVIWxpXk6Htma/nNl+/DQVxTQJNHj/XAxyEavYaBCesuLuXpptQ+d91zWsXBS
	 vH1vvzcEI0fYgsgIGP4IzJSZBip+0Q/Db6yWkFCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0038/1887] KVM: s390: Zero initialize data structures for inject_pfault_token
Date: Wed, 28 Oct 2026 17:35:34 +0100
Message-ID: <20261028170500.091628819@linuxfoundation.org>
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
index c7b4c0d37c87b..9b9d8d37bcc41 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4430,8 +4430,8 @@ long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable)
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217311;
	b=B3LAZtS1gOokJEJixQSS8fAgERSP833zr7sOpJLzdZa04KlEXxNQOmgQ3SieqNKpKIS6
	 aBr5rIASc387fviMEqSl926sJ7Hn5njc6DeohTTQsvSjKOqcwdsEB302nHUNYlASWWdxm
	 /yHJE3Lv1A09cFySJfZBCkUHe5q+z0rIvcc6tn+Lv1JArLPwCNB6wuaqd/ClpH2qF5sS7
	 nfuEot9P4wCoUSzWRsJARn4DkKj+xcrQGr+PeYojasZOfKQgNyymj9DgMHIKiLaNED5E5
	 jaIixsEHVs0J7YZ/PONdgQ0KjYSePXEFcPxAX0INySVypXiU5rA62JN1kPQz+qk1wJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BnppxMIm+s7wHqLJ2k+ItiSJ4m4XNXlJOdtniAfzX5g=;
	b=BGMRG0zbihypq07AyL39fWlus8lKPRTWncuwBFeNqFsaWsnOsV6LefdVNZi33hgNps2R
	 wUlVFQeBzL5aC06categh58+Ng9UtMoIqifwpnm5vXHwsl4buE4NHKl0ufNmn1qLYKmlF
	 YOAIvqoQebpJcQncSJ9Qd5UXs8veSoTuIueCEEUOinvBwNelHM/UMepiwIRcKiHyO5RBo
	 Zn9ofAe7ptAqbR2e7rcGO1xFiInnpWBZAEoE2FdRy/EXyI8JhZVhebTKL/bwA5Ip4zpzm
	 C5/gUgmsROG9UbtiXAh1UhdL77thYupPhN9OcW/TFvcKhNsKn7J+gawUCkUlgrKR3Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDsmfpLr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C72606A31C;
	Wed, 28 Oct 2026 19:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDsmfpLr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56011F01825;
	Wed, 28 Oct 2026 19:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217311;
	bh=BnppxMIm+s7wHqLJ2k+ItiSJ4m4XNXlJOdtniAfzX5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDsmfpLr7vihi3EkpDGzr8yqoyrpUhUUuO7LlJRU8lQKGxFrXA/FIlTcMUEdUzIbl
	 hhspPSL3wA6ptyjW8+OShipPqZ4q6VYCJ44ne4Kps9jqLxUmz1dmOEX26X+1Yry1C3
	 xzpon3KMiEIYEutG8/slggv6PYXMTiR3cD8l6k7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1860/1887] KVM: SEV: Drop FOLL_WRITE for encrypted region registration
Date: Wed, 28 Oct 2026 18:05:56 +0100
Message-ID: <20261028170541.778822011@linuxfoundation.org>
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

From: Pankaj Gupta <pankaj.gupta@amd.com>

[ Upstream commit ee1a586dd1fa2f245b3b753a3e44d9263a49240b ]

When pinning SEV guest memory, drop FOLL_WRITE and rely on FOLL_LONGTERM
to break CoW, as *KVM* doesn't actually to the memory using the GUP'd
pages.  Omitting FOLL_WRITE fixes a regression when using file-backed guest
memory that was introduced when KVM (correctly) added FOLL_LONG (e.g. to
ensure anonymous memory is migrated out of MIGRATE_CMA/ZONE_MOVABLE before
a long term pin).

Unfortunately, as of commits:

  8ac268436e6d ("mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed mappings")
  a6e79df92e4a ("mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings")

GUP uses FOLL_LONGTERM as a canary of sorts to detect pins that are likely
to be problematic, and disallows WRITE+LONGTERM pins for file-backed memory.
As a result, backing SEV+ guests with file-backed memory, e.g. virtio-pmem,
fails due to the disallowed FOLL_LONGTERM+FOLL_WRITE combination.

Note, in the past, FOLL_WRITE was required to trigger CoW unsharing, to
prevent replacing the page in the (primary MMU's) page tables during a
later write fault after already having pinned a (shared) page in
MAP_PRIVATE mappings.  FOLL_LONGTERM does that nowadays, even without
FOLL_WRITE (see gup_must_unshare()).

Fixes: 7e066cb9b71a ("KVM: SEV: Use long-term pin when registering encrypted memory regions")
Cc: stable@vger.kernel.org
Suggested-by: "David Hildenbrand (Arm)" <david@kernel.org>
Link: https://lore.kernel.org/all/ad784f05-b36c-4e91-9f17-4c5b826735d0@kernel.org/
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Link: https://patch.msgid.link/20260715063626.65899-1-pankaj.gupta@amd.com
[sean: massage changelog, add comment about CoW unsharing]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0c182fd09fa60..52592ebc156d5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1972,8 +1972,12 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 	if (!region)
 		return -ENOMEM;
 
+	/*
+	 * Do NOT specify FOLL_WRITE, as KVM isn't using the pinned pages to
+	 * write memory, and FOLL_LONGTERM itself triggers CoW unshare.
+	 */
 	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
-				       FOLL_WRITE | FOLL_LONGTERM);
+				       FOLL_LONGTERM);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
 		goto e_free;
-- 
2.53.0




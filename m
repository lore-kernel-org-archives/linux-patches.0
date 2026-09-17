Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944403B14A2;
	Thu, 17 Sep 2026 18:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671541; cv=none; b=nijt/LWt3TvrPMP/EVJ3a7LhvP+M1jZTPZwC1m6O8f+DZfaJjd50+aFR6s4fgd6kApwx1eAe6AN0D3eVqAZpWSse7XeNMf6HOgXaSDK1NfTIlERXr+d0w50HRrFO7cLnYcRX+G7+IpxJKZCx1gBKdTzl4tkiBx9ADlO9bNcTVJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671541; c=relaxed/simple;
	bh=pM+Tey1srRiTJuC744dU6deOaDGxADUjFuHIJVMyjMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt6fY0OVP8FJb/Qdrzg6NjJfYsvIVbOx9blJj/6vTexnjr3ZFlqUInwa4Y14nvG3J7kF8g45cER7Jq52pNGf/k7hMmUgDvaQ8xtCs6+IP4oU5H5a/K190kqz8fAR2QRu2IkMNXuc4ynvaxeBMozRKS0p3hHhxNFoHJiPvfRihyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyAODBbO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyAODBbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1491F000FF;
	Thu, 17 Sep 2026 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671540;
	bh=jTDYOVJ54uZ7iAvleOEdrx2tWuucFqKRxYzGiHoaZ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyAODBbOFOemeAy2VbRvfiZfte89xFPzlmmzAtlCAYkrySUoNhtBqUg/jbkuTBiDx
	 2zf/2GMRoOcRH1sWhwQSf8rDZpzBxIG8//w30laekn8+0AxJV51PpitbkyhzJcMILq
	 7+PuB9Ja9huflv4pNzxZV0shr6oUla9CIXWqHvkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0962/1102] KVM: SEV: Make it more obvious when KVM is writing back the current PSC index
Date: Thu, 17 Sep 2026 16:15:05 +0100
Message-ID: <20260917151604.820011395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 17d62e0b157f262dd8c7586cb882ece72a5b10c2 ]

Increment the guest-visible "cur_entry" index outside of the for-loop
when processing Page State Change entries, and add a comment to make it
more obvious which code is operating on trusted data, and which code is
touching guest-accessible data.

No functional change intended.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-12-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20260529183549.1104619-12-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 0060569e4f18 ("KVM: SEV: Extract loading of guest-provided VMSA to a separate helper")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3821,7 +3821,7 @@ next_range:
 	}
 
 	/* Find the start of the next range which needs processing. */
-	for (idx = idx_start; idx <= idx_end; idx++, hdr->cur_entry++) {
+	for (idx = idx_start; idx <= idx_end; idx++) {
 		entry_start = READ_ONCE(entries[idx]);
 
 		gfn = entry_start.gfn;
@@ -3848,6 +3848,14 @@ next_range:
 
 		if (npages)
 			break;
+
+		/*
+		 * Increment the guest-visible index to communicate the current
+		 * entry back to the guest, e.g. in case of failure.  No need
+		 * for READ_ONCE() as KVM doesn't consume the field, i.e. a
+		 * misbehaving guest can only break itself.
+		 */
+		hdr->cur_entry++;
 	}
 
 	if (idx > idx_end) {



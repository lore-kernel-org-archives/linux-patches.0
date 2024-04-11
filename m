Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443F4145FF0;
	Thu, 11 Apr 2024 10:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830868; cv=none; b=UlMebL8bwQDGGLSmK6hC58aKnbKilf/uqxezczTh4+oMCeTfJAJW7NuPk4tMnCIIPIxn8jqbL1BDoji077O5r7mTaN6u1dCD2kcaiBe/hiTA90e2De4tPT4PNR/NAkkGmr5HWCu9OyWx2vWaWVEPXG/ZK51XvvAqrNdvUHTvr1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830868; c=relaxed/simple;
	bh=rvU0X+qAb9wgG1+a3Hs9zW22W+TmgWV+2iDZ5LDQdWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/nDAG//qx4WEAmw/XjCxNzO5EEim4rAso5zoL9zxp4Riyq3TPqrFFe8rw8nS2CmjTf181kpmV/k3kwNEOvapt7lFOJMo67lPnvJ54TdqbUUMo2IbTWHUEJQQN7lA2YRfPye4hEed1H4hNIITF4ibr8BsaFS2DwCNJ+etAaSkqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vj1TEZ/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vj1TEZ/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD29C43390;
	Thu, 11 Apr 2024 10:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830868;
	bh=rvU0X+qAb9wgG1+a3Hs9zW22W+TmgWV+2iDZ5LDQdWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vj1TEZ/MTmpg/FuoWxc2zqCsRCvQ+d8En3daD7qSZvw702YKq779+mQNg3Ds52xNr
	 Txm3d3ZIoZ6EY0U+WAavQwwcnAt/8sejDHQZlr8IiMgAwb1/BP5zyhlSft00Vv2reI
	 eRpxh9dkfQllXxrXdrsqdrD5wJjkbNQrjvBflnFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Russ Anderson <rja@hpe.com>,
	Steve Wahl <steve.wahl@hpe.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.4 144/215] Revert "x86/mm/ident_map: Use gbpages only where full GB page should be mapped."
Date: Thu, 11 Apr 2024 11:55:53 +0200
Message-ID: <20240411095429.218977420@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

commit c567f2948f57bdc03ed03403ae0234085f376b7d upstream.

This reverts commit d794734c9bbfe22f86686dc2909c25f5ffe1a572.

While the original change tries to fix a bug, it also unintentionally broke
existing systems, see the regressions reported at:

  https://lore.kernel.org/all/3a1b9909-45ac-4f97-ad68-d16ef1ce99db@pavinjoseph.com/

Since d794734c9bbf was also marked for -stable, let's back it out before
causing more damage.

Note that due to another upstream change the revert was not 100% automatic:

  0a845e0f6348 mm/treewide: replace pud_large() with pud_leaf()

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Russ Anderson <rja@hpe.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/3a1b9909-45ac-4f97-ad68-d16ef1ce99db@pavinjoseph.com/
Fixes: d794734c9bbf ("x86/mm/ident_map: Use gbpages only where full GB page should be mapped.")
Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/ident_map.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -26,31 +26,18 @@ static int ident_pud_init(struct x86_map
 	for (; addr < end; addr = next) {
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
-		bool use_gbpage;
 
 		next = (addr & PUD_MASK) + PUD_SIZE;
 		if (next > end)
 			next = end;
 
-		/* if this is already a gbpage, this portion is already mapped */
-		if (pud_large(*pud))
-			continue;
-
-		/* Is using a gbpage allowed? */
-		use_gbpage = info->direct_gbpages;
-
-		/* Don't use gbpage if it maps more than the requested region. */
-		/* at the begining: */
-		use_gbpage &= ((addr & ~PUD_MASK) == 0);
-		/* ... or at the end: */
-		use_gbpage &= ((next & ~PUD_MASK) == 0);
-
-		/* Never overwrite existing mappings */
-		use_gbpage &= !pud_present(*pud);
-
-		if (use_gbpage) {
+		if (info->direct_gbpages) {
 			pud_t pudval;
 
+			if (pud_present(*pud))
+				continue;
+
+			addr &= PUD_MASK;
 			pudval = __pud((addr - info->offset) | info->page_flag);
 			set_pud(pud, pudval);
 			continue;



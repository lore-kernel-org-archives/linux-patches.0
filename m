Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022652;
	b=Jt8rQiIOF0Q6dN4oSESmOZvTV+3NwArALswqioaCc6Pv+OhviU4gzmtnpR0GMpAR40pm
	 ALZ5YqbUHtvY+u4XW+Q+WH0ysI/8jYjhZUZ6yOv4UIiJLBT41vUkf9kuRAhBnoQAolgXR
	 ZoIWCiGJn9cBTdHZ3tHIzNqai6ibuh7y501NE/xunQr5hTLirDYO3Vzl+HJsNJablqUJ/
	 UQqUr0IZQ0vcUfYHqYIuICxknf+ffOHXg6ZF6aHjNGoYxaslGfnaun9qXahQPLOe5nui5
	 qN2b59odZsjWGmhq139siASKEapKDPo+iENIopxE3xn2tvTzQSifBbXdSO7SvlB1EvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ViJa3js2CgwMTLQgjhNIsgV8iu+29kX2et/CgtnSdb0=;
	b=uPGMyvX0oSy5Hx6FaoKJ0HbwBwmwH6Ypvku6pRcy3Gb+tm3vP1gDPpO/jdISnUS6jIh3
	 VsGFYwE+HWRxyORMpW6CFm3AYkK/QCV52/4D9ru7IcnAHv3JbPI8YGGue9dRpsqr/xam7
	 1iur6US7tWrnSxmOlR11fxbkzdR8CIjjxAnrEmNJqf8YPe35U1GfGvuZs4vr5utP+PEMv
	 nP+hSsmUEPTZOl6RCku7DVA7UADaDhzr4r9TtnsltfLkA6mAqT8dJpM46qx3z6+Z6/HZ1
	 SEeXZeK9rdbXkeH1lpKU7Rjx0dzIiIrqb5jfF5Mrygr+PiEAfH807DyOC2CqIuhSveg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUsN61cJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE62606A31C;
	Wed, 18 Nov 2026 17:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUsN61cJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381CB1F000C5;
	Wed, 18 Nov 2026 17:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022652;
	bh=ViJa3js2CgwMTLQgjhNIsgV8iu+29kX2et/CgtnSdb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUsN61cJ6sZdfP9yIrNwSsLdbW79Ni8SoqnG+woqYPIHvadaO05PqmUZg3X5Pp6XV
	 +2xQxlpLlntyRyC/8mnJjNT68PmSdFCKEWTo/lcIrgKa24ftt4GxLsreyHzWivFCuS
	 Sk/+sCR4k9Kmvl28pOcp/vqesRjwqQVj52YwI60I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0087/2151] mm/vma: dont leak the charge for stack growth
Date: Wed, 18 Nov 2026 15:30:22 +0100
Message-ID: <20261118150124.967070424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit b1ee87802111156e27557e82acc31fa7dfc76e2a ]

acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
This can happen for read-only or MAP_NORESERVE mappings created with
MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
Committed_AS.

Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
Unaccounted growth skips the overcommit check while remaining subject
to the other stack-growth limits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-44-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced vma_test() using VMA_ACCOUNT_BIT with the equivalent vma->vm_flags & VM_ACCOUNT check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index e7914cd6d901d..d4146631eb3fe 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3089,7 +3089,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if ((vma->vm_flags & VM_ACCOUNT) &&
+	    security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	return 0;
-- 
2.53.0




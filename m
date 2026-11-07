Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064448;
	b=yS2jUks47lwzguBdmiE5Cja/GO0GBEwR642oR7HoRzjuPfPFQyfqCziAY7+UsH/H8Rjg
	 IvF45/MSzme4w322vS+tXxjVeMPKtiC83SvwP0XtyQ7kMpj9zcHsW+kUIm8RFVyWYN/Pi
	 9kia8G1CY1RhjRlJGXmJagfgPosfFwTuF031PSxWuD+6aXaFmcCs0RUX9oLnshbo4GwY8
	 R7KzrJA3RhpSPsJ3p+xQjOsaH2dY/CArREgYgGBIqAZzKlKXokb2ljmrbUnHrUwlvimb1
	 PAlwrE4IefPS6VaxFyppL596zy6u2uOT8QrAeHMkOSUqT9xlXkh+8iJvBq1CGHb4GnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+9DIBgZWWD20EKrjXOBh/TBz/Q7zQ8aJghf0mjuETUY=;
	b=MTIEj7jBtvI0rRKf2yPOmB3mKt79EWNJTBx/4mpBu+taT31zUJKcFoYnlymFV0gXdhv3
	 lmx0Y+T2y3ouPaJMGfdviWmEL88dG9ShdvBcdHXu2jbeoja273LXqsDZ+WtnMO8RHAyTC
	 hlDgBedevt0jwmP3WICnFlIFVOmBWBuUV7d6X0PFL0dMcoh8KjSz8rXY1XXbRaT+Zz/rl
	 4yZa96SSE99mY6sR2UpTV9Lw8Y+L0RD1drZVQmw3ucl9MxW5p4+qt33EfCKVjnxE9uuaY
	 HqVHLtA1peHzYo3aymdZt2DlxrNPaUVuUnF5rbLCvVHIhkPOcm8wfxIcmgScJrRpxBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cm24k/5F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8706082BC2;
	Sat,  7 Nov 2026 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cm24k/5F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ABB1F008A2;
	Sat,  7 Nov 2026 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064447;
	bh=+9DIBgZWWD20EKrjXOBh/TBz/Q7zQ8aJghf0mjuETUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cm24k/5FxOskFi4+yXLTNLmQdO1L5rDAkno2gYDhqFsaNXIW83zswsVeb5nSRSwEg
	 RJTQdgsV9urOT3F2Iq6S3yhdyvb1aQFtRoYY2DhMdj5APJxo9vokv0o71l/0Xd2G9Y
	 uGQqnokcGzWPneiTDJNxZ+7ev/Q9vGijyKzs+o/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0491/1257] mm/ksm: mark migration stores with WRITE_ONCE()
Date: Sat,  7 Nov 2026 08:46:27 -0500
Message-ID: <20261107134953.001213353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit d3863210464f69c18615cbe400d48a6e53e770d4 ]

ksm_get_folio() deliberately samples stable_node->kpfn and folio->mapping
without taking the folio lock because the KSM folio may be migrated
concurrently.  folio_migrate_ksm() updates the same state using plain
assignments.

The reader can load the old kpfn, then the migrator can store the new
kpfn, execute smp_wmb(), and clear the old folio's mapping before the
reader checks that mapping.  Thus the initial kpfn load can overlap its
update and the subsequent mapping load can overlap the clear, with no
common lock.  This leaves marked READ_ONCE() accesses racing with plain
stores.

The kernel reported:

  BUG: KCSAN: data-race in folio_migrate_ksm / ksm_get_folio

  read (marked) to 0xffff8ce401421330 of 8 bytes by task 48 on cpu 3:
   ksm_get_folio+0x7f/0x2a0
   ksm_scan_thread+0x1635/0x3330
   kthread+0x1af/0x1f0

  write to 0xffff8ce401421330 of 8 bytes by task 102 on cpu 1:
   folio_migrate_ksm+0x6a/0xd0
   folio_migrate_flags+0x193/0x420
   __migrate_folio.isra.0+0x162/0x1a0
   migrate_folio+0x4c/0x70
   move_to_new_folio+0xd6/0x170

Use WRITE_ONCE() for both stores to pair them with the existing lockless
reads.  This preserves the existing smp_wmb()/smp_rmb() migration protocol
and control flow while preventing compiler transformations of the shared
accesses.

Link: https://lore.kernel.org/20260824112433.191301-1-nicoyip.dev@gmail.com
Fixes: c8d6553b9580 ("ksm: make KSM page migration possible")
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Xu Xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e09980..fe42c17490b89 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1115,7 +1115,8 @@ static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
 	VM_WARN_ON_FOLIO(folio_test_anon(folio) && PageAnonExclusive(&folio->page), folio);
-	folio->mapping = (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM);
+	WRITE_ONCE(folio->mapping,
+		   (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM));
 }
 
 #ifdef CONFIG_SYSFS
@@ -3316,7 +3317,7 @@ void folio_migrate_ksm(struct folio *newfolio, struct folio *folio)
 	stable_node = folio_stable_node(folio);
 	if (stable_node) {
 		VM_BUG_ON_FOLIO(stable_node->kpfn != folio_pfn(folio), folio);
-		stable_node->kpfn = folio_pfn(newfolio);
+		WRITE_ONCE(stable_node->kpfn, folio_pfn(newfolio));
 		/*
 		 * newfolio->mapping was set in advance; now we need smp_wmb()
 		 * to make sure that the new stable_node->kpfn is visible
-- 
2.53.0




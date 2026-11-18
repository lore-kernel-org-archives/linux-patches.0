Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059480;
	b=PihqNrzcDmj+zD0YfQjhsuZHJ5/QUY2IRlxirBDL+RFy2Lgj2YIcKM/nJWoowh+X5NVX
	 tak5AExUnpsAxYNEWCfLJr+bfx7Kxny343uggBj9q4TIfMIb6Pruca+bilspe/hMzWJAU
	 yN2FzvbafDMIVvs7AWiMyR8XL/X69k3SVx1YwAc1dcQnQzf9slbzs0Gntl/n/LrOLlUYR
	 cZTKCvGw+s55mKvMJTOasMSTMRj5vDNgt0IDbhri56nFyMOpTX70xvoiXEF2eOERKAxgp
	 F4qBHo6cJhRD/SovdBg6DyUdzwCXYPyVZeS+HD+7XNSrX1f+S/gZzfouB9aOk4ASfvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rhez0v4a2kVofIXYDXh6snA3qlRJuBaEMIN2q6Yk/Rs=;
	b=iYKopbKy0RB7C1kxytfP1EK7o1100AlVEutVkAld/YpEJd9LzJSbV66if1n+uSxc3t0z
	 rgqOTicXARITqoFAXIIyj9rJkfiBguAt0xBhwtyZmcuSyNvdHZtq1fGWDGbtF4w7WIi28
	 +nrbjh3DK7X6GVi7z1fDjx54nZKJwFCxMUwSFIrlVLOX2aR2UnZNHV27AAcNiAA/Ym9Ry
	 5nl4+dD5RYMXX72xZD3E+ibYF6oL4s7o8pwTJ+WIXuvbaBZYoEDAwyTeTzN8yI1pVHXf6
	 AV5BZusq/4iLqDo3DW2k38tQcI1ecV+qUklUK5sJvMEiza+REAtxmgzyXWK6hT69uKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qX5JTeAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8590606A32A;
	Thu, 19 Nov 2026 03:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qX5JTeAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3D81F000C4;
	Thu, 19 Nov 2026 03:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059480;
	bh=rhez0v4a2kVofIXYDXh6snA3qlRJuBaEMIN2q6Yk/Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qX5JTeARQXNS6Uos8QZsPKz4X4eIPeDJt6byAGDixqauX4Af1bAmjMLovnAvkcj2U
	 tH2mlxdDKWzKBK+ryJoaFrf6Mjor8/bYWofgU0/EWa8g+AswpDKATQCwRsZ/qD7m4F
	 dCqHmY8TezN63z/RnUR32csePAyG3lYEHLI/E2L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0858/1848] mm/madvise: fix data loss from MADV_FREE on a KSM page
Date: Wed, 18 Nov 2026 15:48:16 +0100
Message-ID: <20261118145952.441001034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 22d043c1da48d6c7274f9dd900714b6d58b7b9c6 ]

MADV_FREE can clear the dirty flag of a singly mapped KSM folio. The
folio remains in the stable tree and can gain new mappings without being
dirtied again. Once marked lazyfree, reclaim can discard data that those
mappings still need.

KSM always marks a folio dirty when converting it to a KSM folio in
try_to_merge_one_page(). Marking a folio lazyfree clears PG_swapbacked
but leaves PG_dirty unchanged. Preserving PG_dirty makes reclaim restore
PG_swapbacked instead of discarding the folio. This also protects folios
that were already lazyfree when KSM converted them.

Skip KSM folios before clearing their dirty flag, checking under the
folio lock to serialize with KSM conversion.

Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Xu Xin <xu.xin@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-34-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: adapted folio-based KSM handling to page-based APIs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index ad33cdbf27a88..5aea93718eec2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -649,6 +649,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		if (PageSwapCache(page) || PageDirty(page)) {
 			if (!trylock_page(page))
 				continue;
+			/*
+			 * KSM pages can gain new mappings at any time, so we must
+			 * not clear their dirty flag.
+			 */
+			if (PageKsm(page)) {
+				unlock_page(page);
+				continue;
+			}
+
 			/*
 			 * If page is shared with others, we couldn't clear
 			 * PG_dirty of the page.
-- 
2.53.0




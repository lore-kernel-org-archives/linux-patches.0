Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF7240315F;
	Tue, 21 Jul 2026 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654508; cv=none; b=Q4++TNQnA0to1r/aFC/eK9JR80YidXzbsgV7NugPChXDlAO/DvaBrrxC9KGG3rdG+TIBQNV9BAJuwjU6sbbmGQqdtQF02vrugMYFFTEqVJyyp8hk23dEjjrFznP0pxhrJvMXeji24rp+mP+5aiMGBSsOpQRMnS9jFj4ay1Xjh7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654508; c=relaxed/simple;
	bh=boaxoTwnDMImp0wOicHV+BmderuTmcp/gh6Tn1imXPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W50vjU4wVNB52iRGZ2FBr7s2YCoLqr+K8fG7sfiBJfSlDZM/NL+8oBmJO7DuiwSR7EhMiSGJj81uqtE3Q5O+dfXlKZk9+jNPI6+i9XzktVV8TLiT4FGZ50oXHfL5mdu8y8GPMKDivD9zSpm+LHO+tP59CL2/AIPS0Abke68MXBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOBzRxlW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOBzRxlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7271F000E9;
	Tue, 21 Jul 2026 17:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654507;
	bh=KwZe6WsSmXw82dfulnThlcjUAf/QS+bCCaZ4bZ5F5F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOBzRxlWFZPnlKsTVMxM2kbSdnLRK9CcVQvUWnFEKhPA/n6yvYkA6chB0fyoF9E7N
	 jFialaxgxHO8n+hsUsa0I8fvyZidCS+NGX9FOQVzPyvZbKs+GLNDw7mnpF0g4Abziw
	 71I5tKP23z5V0HA1ltqYe21bzJRW4jvAfhqMT+Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1731/2077] fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
Date: Tue, 21 Jul 2026 17:23:24 +0200
Message-ID: <20260721152633.577358619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dev Jain <dev.jain@arm.com>

commit cd1fc0e3c1f67c0c31dfc215e5d9b771133dedc0 upstream.

Patch series "mm/hmm: A fix and a selftest", v3.

Patch 1 fixes a stale warning present from the time when only migration
softleaf entries were supported at the PMD level.

Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
for PMD device-private entries.


This patch (of 2):

pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
entry.  This became false once device-private entries at the PMD level
were added.

Therefore, remove the stale migration-only assertion.

Link: https://lore.kernel.org/20260604055308.1947679-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260604055308.1947679-2-dev.jain@arm.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2042,7 +2042,6 @@ static int pagemap_pmd_range_thp(pmd_t *
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
 		page = softleaf_to_page(entry);
 	}
 



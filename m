Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C90255E43;
	Sat, 17 Oct 2026 18:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260313; cv=none; b=rUDZsWYZvpc+x0K2qVFKhijFlFXAp0k+wTeCnvAJP7ss4lBqHNqrNd0XArZ+4vfObPLb7JbmXCU0zsYYwngr874heiKqc1aNdWTYAcn0Rs5KExDBgiHGhY6uN040DlNrQDbtAflaZ1IPsFWLeysivj424coB3LIxkpO0hw7HSrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260313; c=relaxed/simple;
	bh=F1cYRq73EWctWRQzQsgyh2fPBBZhfEP68+nJlKvnh0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1MGtG12S9Qe0hvIRfmQ2QTnSxOVoIqbh/uIGMF8Nyn1ms/vpnXcrZPjLDuQRtRBn3iFL6LRWzpA1qI5H8zJ82L4mZhKeNZGlr32/haqT4HqUnNMrB2lvwW8WkprWD40ju7kNKOjqJMb/dF6d0qajWHgg/KXdqkpymfvADSs938=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhZgZFlV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhZgZFlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A7F1F000C4;
	Sat, 17 Oct 2026 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260311;
	bh=flaunfpspmb2VTWcSEMlvB6Q37cnGTusg1c1OxYs9BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhZgZFlVriX9ey+QY6hF2pPuiR7la7VjJc6Sx5Qp6fKf4Z2to0vL5c1A0rkoi4CTb
	 DoHBVAE9P0jieAOD6uIN0sqSwI8EEOAq0/gj+ptyFysy5oa6R8LGMZLsc/v9MDCujE
	 c/VsknIdBHGJHVAPiccbMK235IyqjvbA9br+/ryY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Israel Batista <linux@israelbatista.dev.br>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Omar Sandoval <osandov@osandov.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1496/1674] mm: change type of state in struct memory_block
Date: Sat, 17 Oct 2026 18:02:48 +0200
Message-ID: <20261017160509.540515826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Israel Batista <linux@israelbatista.dev.br>

[ Upstream commit 8bc7ba3d265d6ee698de4b1941b7e8f7d91a0562 ]

The state of a memory block should be restricted to values specified in
the documentation of the memory hotplug API.  However, since the state
field in the memory_block struct was defined as an unsigned long, this
restriction was not enforced at compile time.

With the introduction of the enum memory_block_state, it is now possible
to incorporate the desired semantics in the field declaration and enforce
these restrictions at compile time.

[akpm@linux-foundation.org: fix whitespace, per Randy]
Link: https://lkml.kernel.org/r/20251029195617.2210700-3-linux@israelbatista.dev.br
Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2ebce860bdd7 ("mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/memory.c  | 2 +-
 include/linux/memory.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 468ef9b3983cf..2858a2165d960 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -160,7 +160,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 		break;
 	default:
 		WARN_ON(1);
-		return sysfs_emit(buf, "ERROR-UNKNOWN-%ld\n", mem->state);
+		return sysfs_emit(buf, "ERROR-UNKNOWN-%d\n", mem->state);
 	}
 
 	return sysfs_emit(buf, "%s\n", output);
diff --git a/include/linux/memory.h b/include/linux/memory.h
index f53cfdaaaa416..1028d42406cce 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -66,7 +66,7 @@ struct memory_group {
 
 struct memory_block {
 	unsigned long start_section_nr;
-	unsigned long state;		/* serialized by the dev->lock */
+	enum memory_block_state state;	/* serialized by the dev->lock */
 	int online_type;		/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
-- 
2.53.0




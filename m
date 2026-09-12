Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B59343893;
	Sat, 12 Sep 2026 12:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214925; cv=none; b=Jmllei7ECbartlIRHsd+iJ43Sfy+2rU/QcdKGRywoGokc93IUA9n3nDF+bNtsJCRvefCR2xl00VTStDbxVUjmg8AeIkyzd62rkUd1PEwQoy1D60mi+qIGPNa4dCb2YzFB/Neuwlquk/lOqdlANuNDeNp/EhNW7E9LsVOOjPJ1TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214925; c=relaxed/simple;
	bh=prw6j+jRUrm+WNEL6fgM+iA776Ct0Tl/+Br4yu1/ROU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBm7+Gsp/akbbZGHcltP6nXISkPE5TYU0A3krBPV+rzFCeyzvrH4MhLt4is5sQpHspmOKV4JnXrOagGhwYUHBujJmCxSCqn9x8GO1z4saKkMJyG/0Q42X8JMxJe998vPkVSswG8L1kd4JRF671p6bDPX22FqQxo56CBxbcLmf7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfr4Vf/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfr4Vf/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0311F000FF;
	Sat, 12 Sep 2026 12:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214923;
	bh=D0jdebfc3IApuQxIZpCUXZvK3J1Tvy/BAPDTplv6reM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yfr4Vf/rAMix/zPf8HU3CMocQsZvm/i/pkh3a/DrmufEWOH7/UQoWtOofR/Gc/bmZ
	 KUKjVVca24q8yUbqHRvun7rHu8O9CrFx38sfYO3irD78U2Uo4EF0KL/zEUmS6UFss1
	 q1/30gUd9QUh6z2aEGxLWkomTfdZKGVFS5X7F4AQ=
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
Subject: [PATCH 6.12 0383/1376] mm: change type of state in struct memory_block
Date: Sat, 12 Sep 2026 08:46:49 +0200
Message-ID: <20260912065616.083045000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 354bf9fd857d4..cd1e6e15bb719 100644
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
index 4b9be8afdc849..a334f1382b21d 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -78,7 +78,7 @@ enum memory_block_state {
 
 struct memory_block {
 	unsigned long start_section_nr;
-	unsigned long state;		/* serialized by the dev->lock */
+	enum memory_block_state state;	/* serialized by the dev->lock */
 	int online_type;		/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
-- 
2.53.0




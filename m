Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059414;
	b=gIFtwxHs5crFkvoY7Qpx/wPqEf3+iNcdXDGHMCIZgs7E2F1dUGW1CLa0aJ8eMBLnvtV6
	 ThEv7w7x8t2k6cc2vy3MtqakTiC9UWHdUp2CNDe/JV+BuUNVsucaag08im6BY1xSJ4lYf
	 /jj7kblmGnXzD10OBiCXFRYLA0tHB1aVrvmO3lWzApX4SZqdqZS3EsxtKsJm7h6xUXvB3
	 j8nn4dVH5QO4oVFFxrZLBCY9hBkBkLJCt7hrgBudLLNZWK5CQ9OYvCFZECAeFklmYCA4V
	 L4+Z52c8kmzxgVavE1ZZI2jKvdAhHpGQ2lV8o2UfO1ew26UePgH9OpgCSGrXlfHf7YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4b+z1/yWKBBch1W8QEdgCtoZQXe05prLiE/BedWFdvw=;
	b=OHNpAcbUJ9qHp/4bB2Jc5aNFzPbj8uAfS991t86Ev5x7d+QFlLuyEOC0r63m3knu9gph
	 03Xkrtnoql31k3UocvpsYSve2X4iaYa9y5n5em7dHwixd82itwGU2jnRP76mja5K65eL/
	 NtXN2fkpVRsqcFbHp3/RA2iCuHY82lHymyRLeejRrphFe78lK88YCAkW3p9ACxsRt4AqJ
	 N/LXzmpLn7t0xVFR+JVYTVh2eXKONq6y3dzeCVUblzxlJqz+kra1U6iiJCiMhz+Cg8bOe
	 I9vrv5N8HNc2UQwgXhOmgGlejBLBJRkMA65rJUIlINLp3ZIHDYdZvpR88QUmpM13SoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdAWIk8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578DF60A2609;
	Thu, 19 Nov 2026 03:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdAWIk8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5051F000C5;
	Thu, 19 Nov 2026 03:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059414;
	bh=4b+z1/yWKBBch1W8QEdgCtoZQXe05prLiE/BedWFdvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdAWIk8C4T8V+00ahTbe7+JFsntLhEEwIWwMmm0mssNxKNacHIuUSn7ZwpPaiKTOX
	 zEwyFvK/JQM80QJyJABzYRsC0AEoo1/3U1hhvLYXhDzTlK6OAkfAUcvo9ZT3iMlZFO
	 AJVIf8+0WuVjgDjmi8qkanUdYVrVh1MfuL0OKVlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0832/1848] xen/gntdev: prevent private mappings from becoming writable
Date: Wed, 18 Nov 2026 15:47:50 +0100
Message-ID: <20261118145951.522506252@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit 2176dea8d8c19cb43a9b3651bfa1cb21eab1b31a ]

gntdev_mmap() rejects writable private (non-shared) mappings of foreign
grant pages, because a private writable mapping takes the COW path on
pages that have no proper struct-page backing.  However, VM_MAYWRITE is
left set, so userspace can map the grant read-only and then upgrade the
mapping to writable with mprotect(), hitting the same COW path the
check was written to prevent.

Clear VM_MAYWRITE for private mappings, as i915 does for its read-only
objects and as fixed in drm/vc4 (CVE-2026-68445) and drm/panthor
(CVE-2024-53071) and ptp: vmclock (commit
a5edadbae57e2298a56cf7a4e774a027905a331f).

Fixes: ab31523c2fcac ("xen/gntdev: allow usermode to map granted pages")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

Message-ID: <20260819084217.1577-1-suruurism@gmail.com>
[ sashal: Replaced unavailable vm_flags_clear(vma, VM_MAYWRITE) with vma->vm_flags &= ~VM_MAYWRITE. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 06511e67fa520..8af9c86e0fd99 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1064,6 +1064,13 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	if ((vma->vm_flags & VM_WRITE) && !(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
+	/*
+	 * Private mappings of foreign grant pages must never become
+	 * writable: they would take the COW path on granted pages.
+	 */
+	if (!(vma->vm_flags & VM_SHARED))
+		vma->vm_flags &= ~VM_MAYWRITE;
+
 	pr_debug("map %d+%d at %lx (pgoff %lx)\n",
 		 index, count, vma->vm_start, vma->vm_pgoff);
 
-- 
2.53.0




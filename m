Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064617;
	b=wNi4dmHcVWxaHC/xMgIh+Gb7WqCm4K7bGTnrGUEtD8OTFBdCI2maxoTxIgsvpmZTlI+4
	 WyVbhnZy39kVEuXUzD8W38/KolPMWuASlAabehQcSMn45MG00O/lga1hHrXiJpHjwWOMZ
	 bFe3KbeBlfHu+bsce7/5IvCndjbLAq5G+6uevNdXO13vzJ34UczGoACgoHnrp0WpO1Ic6
	 Z6/m0s8j/O5eU6UpgerYAwjnGp/nV1eQRBCRgEaJSEo0cqCQTjiYt4hjWoyOl19Bl/PVH
	 ROGX0lZZs4e8b3CI+xUXQnDRG2frnWlDn8R0Yj0pk6MPZxkKZ8Tj6ubwbNq9ZgAoc4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nw8763Ueenrb+3yn6P62mrlipIJKVtZmA12fmE9MIWM=;
	b=udW+RbP5iyDj10u6Rn38rVcIa8G061Nbagmo8GoaPIiJ9rLIoP1PXaV33q7JfBnc7Fav
	 ehBiUFUMcHxYA5r29mpjyC0FNE7NxsNkmaI/HycBi+IjdWNvP2yBqG1qkAC7Y9tvrV5x6
	 fpJ5KiY4kVqljATUHDmNiyQf8i4l0EvtUPGzvXF5gyDZlNp77Raq3k6ZqSPUaMQkHHkWB
	 OqUJwtdACN0CA1Zm9PhXxR3Iugs+dDhscUAij9jdWOD05FQSlvM6TjZM0/YSzrlZj2ydS
	 JIprRsAOzYlNLJ17mhcF1jl8wfgjpaj84YGLDTmypnN865YQW9Gzv7tOr+Aaxu28hGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XzLnZz8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7294C606C006;
	Sat,  7 Nov 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XzLnZz8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAED1F0089F;
	Sat,  7 Nov 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064617;
	bh=Nw8763Ueenrb+3yn6P62mrlipIJKVtZmA12fmE9MIWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XzLnZz8xM3VKwf66sXwL6VrF0TA+u3FGpkDFVtScwIaLGX5VGNCqv9DnAwy0xIjPJ
	 IEOtdeRHbKG9LmvtA9fP31yYy0ZEGDKHRoq8mkjUc4b3vnavtOAM/VHKPQsQoyOo1w
	 TNk0VCOqbvegSm5gqoqHC3MUW3CCSM5qlJESbCKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0589/1257] xen/gntdev: prevent private mappings from becoming writable
Date: Sat,  7 Nov 2026 08:48:05 -0500
Message-ID: <20261107134955.608609438@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 1dcc4675580ed..b71f5bae25b63 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1066,6 +1066,13 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	if ((vma->vm_flags & VM_WRITE) && !(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
+	/*
+	 * Private mappings of foreign grant pages must never become
+	 * writable: they would take the COW path on granted pages.
+	 */
+	if (!(vma->vm_flags & VM_SHARED))
+		vm_flags_clear(vma, VM_MAYWRITE);
+
 	pr_debug("map %d+%d at %lx (pgoff %lx)\n",
 		 index, count, vma->vm_start, vma->vm_pgoff);
 
-- 
2.53.0




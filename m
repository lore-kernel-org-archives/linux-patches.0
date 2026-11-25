Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617876;
	b=ycTyGy+/6wBah458lDXSikmc6T47XF4itWkQ1bZO66cVMhNJR3qNazCbBtHT3D35S7He
	 DXa6vxytizKj/LGS9wquJgZCNk+kPFtJSXTPJhe/iX8HAZGNlITunCPjzB47TOGYeDdm8
	 HzwEzedHZrG2rwEKhzGdpQQyAvXGqibX0MAhFmFM2gndmjTH6z6CLD3T+3n8tT7T/GpuM
	 ONalZOPznY41l/PHCRDgo4u5jUbXD0FWEXtsyObUQQvfOLvgt+VzD/UdmiDw2YjfeKvJl
	 rPgHeUXrLI6cMhvMxERREfN67q/NKLiV+TtcRCHsRjwHeJZPYzI7RwmYlwu94vETGdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qywySnV8b5yfaXvd1HFcQrCJ9qDC2i6zb8/RDYWe9XY=;
	b=vnBC2AZ6k4G/ymK0pHxFmqdNC7gFODhueCnafsLFBfvUvl9UUXDu5fFkkrmxYfO75TG3
	 2tFK257Q0LoKEpYwSLIDUoKNUywEybbDMNnEtksSA94xPcb13XgscOuXd5ZZ4x/NWSiYI
	 Ixlzjv2j+zY5qlMtizfIOF6rNm4XPJWbODwCdgEs83nLYqNhhoykEf+YKTUuOd/xYvRKg
	 oZsnCjAzO8M+g7Duo2s702BTh1QgU96yDpPj0/8qtCuM87vDKFINea50a4F8NcEeIsS6L
	 xZRo5DtkKbqgrNQWZ2QigcYX3/ggDvyratGjLgLHRP+zZxCGqL8atlzGm5rh0MfYUgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6kH8aMP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCB1606A32C;
	Wed, 25 Nov 2026 14:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6kH8aMP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559DA1F000C4;
	Wed, 25 Nov 2026 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617875;
	bh=qywySnV8b5yfaXvd1HFcQrCJ9qDC2i6zb8/RDYWe9XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6kH8aMPccXCfx31bgaUCitP39Yue3ZaC76GpSG+Ni9hMSRBu9IyN2PrTbpVPK5sZ
	 0dVKb6N+M1Ur3K60EuSxYpkgwEffFqf8MuRjsAUc/vGCi/32a+0DIGuiSC4/1yjkva
	 SvaSo2J0q6VqLCzSyZgSWhw89OXTqRKyEGHyzpmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0102/1005] bpf: Refuse an arena mmap() longer than max_entries pages
Date: Wed, 25 Nov 2026 15:24:00 +0100
Message-ID: <20261125143824.134700316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 1e01345b87f13c354687360cb81ed2a521ff2b13 ]

arena_map_alloc() puts max_entries free pages in the range tree of an
arena. But the arena kfuncs check their arguments against user_vm_start and
user_vm_end. Without map_extra, arena_map_mmap() takes both from the first
vma. This vma can be up to 4 GiB long. Then arena_free_pages() also marks
pages as free that were never in the range tree. Thus max_entries does not
limit the memory of the arena, but these pages are inside kern_vm.

Refuse an mmap() longer than max_entries pages with -E2BIG. With map_extra
this limit exists already. libbpf always maps max_entries pages. Replace
both SZ_4G checks with this limit, because it is at most 4 GiB.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-6-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 607768ef4bb5f..8b0892e19b198 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -634,7 +634,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 
 	if (pgoff)
 		return -EINVAL;
-	if (len > SZ_4G)
+	if (len > (u64)map->max_entries * PAGE_SIZE)
 		return -E2BIG;
 
 	/* if user_vm_start was specified at arena creation time */
@@ -682,7 +682,7 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 		return -EBUSY;
 
 	/* Earlier checks should prevent this */
-	if (WARN_ON_ONCE(vma->vm_end - vma->vm_start > SZ_4G || vma->vm_pgoff))
+	if (WARN_ON_ONCE(vma_pages(vma) > map->max_entries || vma->vm_pgoff))
 		return -EFAULT;
 
 	if (remember_vma(arena, vma))
-- 
2.53.0




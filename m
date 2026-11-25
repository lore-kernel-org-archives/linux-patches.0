Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621224;
	b=ncQ9Xr5UzTrArM8kAdnH4rf6acZ27gqKMLLlJlFh2Cfdie/LJsZ/ezCgtFIpLqJhzEoF
	 LCQfr54QwASUjNBI8CLAGruTEaeCJ23ztcGf3AyI3EUW1uwmoCgPKfYyt+Qb+XQPJ4waI
	 8yvLoBg6/uBA6px0vyn/wvLGA4BSu+XV0nOnKKhfBkY/c2IcPJkAQko9jrZgJWYQDlK/e
	 26OhUvI3IStRk2tMWeJMnsms8d3kg0omO+FqYntZtpJAtYQC7yjs6K1lczSbya/weG+af
	 snILXWfIsLYhAj/C0UvD+wl5t08XlHu2M43kHnLsnkgHNFeRx2wspXGIm3ugR+k08aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SypibDFQJGGNITdoA83gJCk7gh8HgGl4kZejbQAJuMY=;
	b=UWb6WrTLIPeEKJ1pce7Y6clSDbBtk/3VzjCVNdF76siQ1l0FXr1oYQ6vN4NZp2FhZyFZ
	 FI6jVrseNE3Vo3SO0wn6I35sWNYSKNJkW4XROJ7cOfIhp7PJ/cS8Dc4SJ6um+Pl94p2YN
	 cvGBhsLyb2tlkYqJVeeILjewHwaafbC9Gw/MeUTfwDaWIFvTGucV9e7VaKRImpec/Kk9v
	 /eI2GvfcIJ1DjJg8sEIaX2+kiC7szusuFht7ykOEURoQl2hXGSHxMjn/bkGqdu8I2GLZs
	 pNfBL7FKreWguPWrnhTlt6diHq/Ox6fEIZuraBKfSE3/nWzfX5TPdyi0uZGhf6PQARA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thxyQeVN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A4260A2635;
	Wed, 25 Nov 2026 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thxyQeVN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE60B1F000EB;
	Wed, 25 Nov 2026 15:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621224;
	bh=SypibDFQJGGNITdoA83gJCk7gh8HgGl4kZejbQAJuMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thxyQeVNTvcZjnd7ta4hIraR+w8W1/8dauB+YCTbsLnXdimC0+cdNl4S/cYcC759H
	 wX7NA/2+VWlpbOUaULYSX6DJ88gwDthNIjNlVpscLHuJsF6dcvnNAOHRCXexUVpWHO
	 M/I+/TwQHAtiAhd/wdmG/xyzzf7gqkCak7JJqNes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/990] bpf: Remove the WARN from arena_get_unmapped_area()
Date: Wed, 25 Nov 2026 15:24:42 +0100
Message-ID: <20261125143824.780246008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 15dedd4b259289bffb8a5485b81722fdaebac71a ]

The user range of an arena must not cross a 4 GiB boundary. Thus
arena_get_unmapped_area() asks the mm for 2 * len bytes and rounds the
result up if necessary. If user_vm_start is not 0, addr must be equal to
it. A WARN_ON_ONCE() assumes that the mm returns addr. But addr is only a
hint without MAP_FIXED, and the mm can return a different range that
crosses a boundary. This is not a kernel bug.

Remove the WARN_ON_ONCE() and its -EFAULT. arena_map_mmap() already
compares vm_start with user_vm_start under arena->lock. If the rounded
result is user_vm_start, mmap() succeeds. If not, it returns -EBUSY.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-7-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index b3c70596c576e..3d3bad292bad0 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -354,9 +354,6 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 		return -EINVAL;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
 		return ret;
-	if (WARN_ON_ONCE(arena->user_vm_start))
-		/* checks at map creation time should prevent this */
-		return -EFAULT;
 	return round_up(ret, SZ_4G);
 }
 
-- 
2.53.0




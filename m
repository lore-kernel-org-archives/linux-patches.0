Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621158;
	b=IJr4NMXl1rkFoy51nfqMb9paxY5IdTUYXY0eschG7DntlYJgSRGUi/jFSfw+H5xFctch
	 Bg38n3LcKKLgQrCFx7s5xeyl+NEDEIyCEOeexqCdvS8uf0GRVenRzElq3Sx07d38cK1iC
	 UU/mL1ozLLkfIJBzudqa5Xje+tcRboXp7b6jFIJPuQT4c9JoDZlaelN6NwoRxzBw6hyoU
	 88VmXnNJQ6tLKl1GRVpYrX6Knk1U0QE/A0/K8VZs1LRCxlMm8L1l9EeJeA/MRKszEAYFI
	 xmj+2FNKd7oTkfB9O06z5HmPb9HuUV+4A5KagS65HVB5c/NGP6DKaRvWt3xK0o79xPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Lu+2G5g977EOlrBz/BzaiJbc7EZjWxNBZbmTDUuMSQ=;
	b=uz6Bs3VwH3VQ9bTxT9e6tlu/tUjYReeqs6jQhH0G+BzpWSJlDFoJdcAO2emlVRYmFPVE
	 r7x+4xcyDCjkkTVhpwS9sttghDoC+7bul1dA7vVOkNLHgWf3IaDVJ+3JQgCc1/LWeb4mv
	 EC2/Jn2mZPOWxvMHtbMUmv4wqy889HbDpfOxi++HNLDzoFM3SA8NNfUtQGDrpRrY6s2Jm
	 EiAln3/rwPnAlW8MqRicIfrfA3vqmu1dJfF7MAWHG/5GMwQtEdjzPfWwWFdEY+DuGLM40
	 nj9vXvpS/QZ8TTlH/jB2sFpDnqUa9kb52mSCF1gj3aRRswBbx9/J6sVLrCESy4B4OWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfMeuMlY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C24D606A32C;
	Wed, 25 Nov 2026 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfMeuMlY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93C61F0093C;
	Wed, 25 Nov 2026 15:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621158;
	bh=1Lu+2G5g977EOlrBz/BzaiJbc7EZjWxNBZbmTDUuMSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfMeuMlYI5XqQlTeDMyf0jnURXPgA56bZiCPvqw5tUd35i/DFnpkwREHeftyQ2Eko
	 blelnbTWO8D7P43S9iO9bFF32a7eqZsymfy0q7IiTEoKoU72s+Xr0Z7/CT6mgBnTxc
	 f0dZHvpi81+I8gAr39yHwCwE3vwG7EqVV7LFS190=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/990] bpf: Refuse to map an arena at address 0
Date: Wed, 25 Nov 2026 15:24:40 +0100
Message-ID: <20261125143824.735046260@linuxfoundation.org>
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

[ Upstream commit ca580b034380fa9a69cc973637d1859ec4f5b344 ]

The first mmap() of an arena sets user_vm_start and user_vm_end. Each
subsequent mmap() must use the same range. The value 0 in user_vm_start
means that the range is not set, but a mapping can start at address 0. Then
arena_map_mmap() does not check vm_start and sets user_vm_start again. The
range tree counts pages from user_vm_start. With a new user_vm_start it
reports allocated pages as free, and apply_range_set_cb() fails with
-EBUSY.

An arena at address 0 is not useful, because the verifier rejects all progs
that refer to it. Return -EINVAL from arena_get_unmapped_area(). It runs
before mmap() removes the old mappings in the range.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-4-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 51227c8d2b1e4..d1f0a7222d941 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -349,6 +349,9 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 	ret = mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags);
 	if (IS_ERR_VALUE(ret))
 		return ret;
+	if (!ret)
+		/* user_vm_start == 0 means that the user range is not set yet */
+		return -EINVAL;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
 		return ret;
 	if (WARN_ON_ONCE(arena->user_vm_start))
-- 
2.53.0




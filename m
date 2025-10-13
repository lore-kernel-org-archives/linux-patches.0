Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA793320393;
	Mon, 13 Oct 2025 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370239; cv=none; b=QA8a5/CKO8LpKsvDTdZBoeAyeVnf5mmMD4+KLiWwGsZpGw+uOYr10fbU+pHvLTV9AL3jXWfq2i1+OiDqgWZ0n9sP5yK8NdQ0OQDHDIUL3neP6afUUw64IQxndrQ5fl65yPh1gmB+R2QO7Scn+f1Npx1xFBbR42m2FXW3/P01s/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370239; c=relaxed/simple;
	bh=3AWumxtydUPH+tg9BQxpwgXtcxu2jWfEQRnUXnDQ0V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWY8n7udH1DOGCl+HaAPoLq3fEb+wp6AQYZqkgTl1cfDp2Suwdq8YVW7ri6X+ihCW9UKx3TSQpLyU914DPqGe7Zz7vWHybx7S8HkXjZxMNVWYx3pz3UYXRl8fJozP/lv2asGtyElGOUSag2S5YynBo3+iTkF9kdI0ag/Lg0vGl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBVI2Spg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBVI2Spg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8CDC116B1;
	Mon, 13 Oct 2025 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370239;
	bh=3AWumxtydUPH+tg9BQxpwgXtcxu2jWfEQRnUXnDQ0V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBVI2Spg3PcP5iIwhgqvI8SYWWvw+F59ZWBq/HltJ9HdP2TS0IRa4ejkrfcCcLsGF
	 spTtZm0gLi2qKF2h2Et/Lo4dp3bGsht0LWJq4kC6/FFXNVpw0mcwtZWsN1jD/FBS+o
	 pHbhqIYRpIbNqcp0p1fmApFzJ6gzve3c5TzFyQiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 528/563] LoongArch: BPF: Remove duplicated bpf_flush_icache()
Date: Mon, 13 Oct 2025 16:46:29 +0200
Message-ID: <20251013144430.438194109@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit b0f50dc09bf008b2e581d5e6ad570d325725881c upstream.

The bpf_flush_icache() is called by bpf_arch_text_copy() already. So
remove it. This has been done in arm64 and riscv.

Cc: stable@vger.kernel.org
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1770,7 +1770,6 @@ int arch_prepare_bpf_trampoline(struct b
 		goto out;
 	}
 
-	bpf_flush_icache(ro_image, ro_image_end);
 out:
 	kvfree(image);
 	return ret < 0 ? ret : size;



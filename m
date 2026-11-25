Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621809;
	b=HA4YwzqUUAVZELUJqm7XljCSIwEFF6ROVf+IpXechz4ZeIbtmwdkxSfnXRJ0lK1HWA9x
	 y3Krmvt6LgXmCxbS8n5KHFodiJT0Ckt/x09Rc6Sqn0JECRGm7dXzkWMIfp4Yf0Bn+MuBi
	 W92ah0bOHn9NuTMg5Tl/3Px9XmoaJRf805lVPXoifDB5FGT0G55KCs3NHPIOlx30ilalE
	 4o9U5728yxa9fEuv8d6zXdgdc0Uh4AMovZ4F9qoytsONMnfXj186khW1ieZzXs5IryPWD
	 g9WYOHd5GxRSTeTxj4ksuiQBgsGx/ZSQWPqQiiG227E/2EhU6GvCY3LW2BojvClXvEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8N3ZGG93CHVUh+vyk6rkVNi5tY2iR4gG9itL3+Sjck=;
	b=zqxXGAOnv4KSC8IscdkJGDprcxmF1WezGXIGLkncBI/rELAOdaZcjvIzraWBx7lK3Aq5
	 JU0gfjIP7I0QkecM3iC+lr6xHCelNo3rt7gD/dySovML2nlUQxNvhnMOk/Ul/Lm2OHQ64
	 sjYRJx7XT4F6KflV7Wkh598kjIR+/VnBmhGWzUsxpaWDra+6/UAR7zA3vip4JjswpquC3
	 vqiCRW7LDp/hBtJi6AZJROdCfPWDlUcMvcL44ZNNqILztoUI5V0YZLruq1o3sgRS2a5pt
	 VlH+wkk340LOmtcdjH/mRs4K83Y1w5TqFn7xh0fF0OSBGu9BUgcL+j6YUdaT6a53O2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiihOWnU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB685606A681;
	Wed, 25 Nov 2026 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiihOWnU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DE11F000C6;
	Wed, 25 Nov 2026 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621808;
	bh=F8N3ZGG93CHVUh+vyk6rkVNi5tY2iR4gG9itL3+Sjck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiihOWnUKKXm1hbmOPfNUrnu2iU7cKN4CiPHhkMMTpIPAPPneB/i98ueLSSgKjXMM
	 t3EYZC5wu2jVeFdsZTdU1OvqSsWAyGOexR7y1NzctWYa03Cf/CixmopVKDvIyWSCBc
	 h30m6Ksbo0V7zLXCWeAA4k9Gqa90SOZBS9Sxs/RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 341/990] kho: check fdt_phys in is_kho_boot()
Date: Wed, 25 Nov 2026 15:28:28 +0100
Message-ID: <20261125143830.079242898@linuxfoundation.org>
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

From: Greg Thelen <gthelen@google.com>

[ Upstream commit 58c5852ca96c58cdfdb9646870b217fc54d06a97 ]

is_kho_boot() is called early in boot before the linear memory map is
initialized, so calling phys_to_virt() via kho_get_fdt() there is
invalid.

On arm64 (and similarly in upcoming riscv64 support), this triggers
BUG_ONs in debug builds, such as:

  kernel BUG at ./arch/arm64/include/asm/memory.h:377!
  Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
  Call trace:
   is_kho_boot+0x2c/0x38 (P)
   efi_init+0x94/0xf8
   setup_arch+0xf0/0x240
   start_kernel+0x84/0x490
   __primary_switched+0x88/0x98

Use kho_in.fdt_phys in is_kho_boot() directly instead of translating it
to a virtual address.

Fixes: d6d511639185 ("kexec: introduce is_kho_boot()")
Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20261023054518.3258350-1-gthelen@google.com
[Pasha: massaged the changelog]
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index bedf88f3cefe5..e36f23286e7b8 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1204,7 +1204,7 @@ static const void *kho_get_fdt(void)
  */
 bool is_kho_boot(void)
 {
-	return !!kho_get_fdt();
+	return !!kho_in.fdt_phys;
 }
 EXPORT_SYMBOL_GPL(is_kho_boot);
 
-- 
2.53.0




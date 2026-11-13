Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585625;
	b=VjnSPlrO8eXI5ZAM3xaWwhlVMlKAe0O99rMQQn+sEinNtqsfcnYwbSO5FZevIPIx1XQB
	 ThoxKg4g3pVpxXvc8j9i97nRjT+snebOorp9o4nD3L4mLVqLoGCdwnRtnbNX7wrKwbsOI
	 3g0uJqFqqBcLOz6K29FlQXCB1sgYNc1YoMVAdaZSczVB+vRce/nP/BPsEm5T//wuGHl1U
	 RhTuzOUz+gaex0dhx+RyPhQ7KbuH5iM1w6Ko2LnSZOxNX+VOBC7LBWokiHBTOthqnnNIg
	 Mvx20+/0PpPAPiUozaVtID33d8JtdJzLntfbGKoYUJu64BbxoRKdVFfWb6jQx8dWTog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApbwrTU0eUOMa4r/Cwh8GIAkTtSESEcHx6DAP9pVCEM=;
	b=R4hyj/uTsqBpwLo8j5P1EH7kAT8PzYIrIE7gz3P4iAViXDRfKms7zkh7Yjcbu1JN8s3u
	 CKhO5PcazpVCbpGoIojhqNgpftXPD9hR2Yl7lSBbRbHhJ4Uz+o8aDzqUE9G6kH6Strb1N
	 YvCQLsI2dxqzt2v0zkqDdKZAQTYXbaL5noZwHeIYE5jfwuy3bf9jjNIxN52tmmoo7Zqvn
	 Jh6AgEORUB6PGGw7Jespig132B476H6ebeuxjCx4NilljBdBx4fcgPdHsmKNqSoPW/cWL
	 HgcVl+6m4UQxoMkZVvOz4mCsRsnJ5hOsQ8zh2DLbgknO+INE2VheKvh1t2up2nWndpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IBBOmrnV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214FA6070FC6;
	Fri, 13 Nov 2026 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IBBOmrnV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2661F000C4;
	Fri, 13 Nov 2026 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585625;
	bh=ApbwrTU0eUOMa4r/Cwh8GIAkTtSESEcHx6DAP9pVCEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBBOmrnVqG94me9fMfZlAdpVygO6+aDBlcS5mO1GPWRAqRP8Hn8lQIPoM0cx6YpiE
	 hUZFzomcnmhwqqfoLLAglJKeOL4/MUJksOD/in381xIqO1Vthmlc2bjuvpBvyosUNb
	 jNUIxIHg5Wcvd6nL9AJwnsFSr5u8RAboDxoMrMGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel test robot <lkp@intel.com>,
	Bradley Morgan <brads@mainlining.org>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 247/507] openrisc: export __mulsi3 for modules
Date: Fri, 13 Nov 2026 10:49:11 -0500
Message-ID: <20261113153802.944093431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Andrew Morton <akpm@linux-foundation.org>

[ Upstream commit 8ff981aa283a0ce516c2dc65a48a185ed336c657 ]

OpenRISC configurations without hardware multiplication fail to build
modules which contain compiler-generated calls to __mulsi3.  The failure
is widespread, affecting filesystems, drivers and KUnit tests at modpost.

When CONFIG_OPENRISC_HAVE_INST_MUL is disabled, the architecture Makefile
passes -msoft-mul to GCC.  The multiplication helper is supplied by the
libgcc archive linked into vmlinux, but or32_ksyms.c does not export it.
Built-in callers can therefore link while module callers cannot resolve
the symbol.

Export __mulsi3 alongside the other compiler-generated helpers.

The omission predates 7c3f4d699f34 ("resource, kunit: stop selecting
GET_FREE_REGION"), which the robot identified when reporting an additional
failing module.  It was already present in the initial OpenRISC export
list.

Fixes: 616257669e1a ("OpenRISC: Miscellaneous")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/or32_ksyms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/kernel/or32_ksyms.c b/arch/openrisc/kernel/or32_ksyms.c
index 84a937a64e2a7..5aabef30ca09c 100644
--- a/arch/openrisc/kernel/or32_ksyms.c
+++ b/arch/openrisc/kernel/or32_ksyms.c
@@ -35,6 +35,7 @@ DECLARE_EXPORT(__divsi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__modsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ashrdi3);
 DECLARE_EXPORT(__ashldi3);
 DECLARE_EXPORT(__lshrdi3);
-- 
2.53.0




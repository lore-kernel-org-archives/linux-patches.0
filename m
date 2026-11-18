Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053410;
	b=Dwxf6UOEoBqEuEyPjQID4uGbkfu/nrFtzI5Ex1i+daBMm9UG4gmipKc1744DKNTAZYER
	 p+TQ4E0Nysy7dGsbo5BdHawFXL4I9wSx79HG91UBsIDnIkWqUbZv/dRhtHG5UBNnuJVJo
	 vK7atePcJYUoUEZ2u4MHpt9ku1qmDiWXjO+Gi1a8kdU9KqRYetVBPL4JHTkOlvJ4Ucv3G
	 G0duKRUqKrNwgbzJq2270j4TQODNa5CgpV5AntWDz7WepHW66fPP9+2QeOXJDH9oGJuzY
	 Sb6JwbrzRFjlm8mcMXQ7+yU7t+QvcjuR4wKrjVKetD5HGf5mxrqz6hc/DQOSwP5cNkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kRqS8nn7duaDNq4UQLD0XOF6rkiuIsZGTqx+h1AwqFw=;
	b=Sg54q8GFwvPLvaPtgS65vTkQKEqBAYlW4s4XleklKR4mxL1ABY/P2ogOWMBHDk2yEuzD
	 wXaYMBgwzfA9rbFGqGont1anh71FsK8GmYe7+npXJXDgYRFvZqnRb5FsW8j+QTUMxqkZB
	 vXp9hWAnGMdJ7Xm75PmFYUOp5D1+ly8J8PTlafS0I/3TGxyfx7VljwWy3n2hiBlbq0dNF
	 JhKkaVmGo6mhIQEqnHTvomPTmtqjUy6fY/GLzgS7JiZdnzmDd4acOjOAF2MUE6iaR/ajg
	 tJf1w2PChmgSsOjuHS+3uV9OJdlpgyLpdQ2TA52qt/Cl6GrrK0cDzGb3XjAbW+Rmmrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=liCCOJ3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641A3606A31C;
	Thu, 19 Nov 2026 01:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=liCCOJ3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6721F000C4;
	Thu, 19 Nov 2026 01:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053410;
	bh=kRqS8nn7duaDNq4UQLD0XOF6rkiuIsZGTqx+h1AwqFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=liCCOJ3ku3mKBUACnwLMy/Sv4uiY17aSWl+tioMywKLoTSmPdSO/1q3qDFPFqigpS
	 aD6M66eVysVprUAQDh1UtUTktHSyrr7frYBZn6V1LxJw3kr6rEP635mMC7Wi5mP2G1
	 Xvd56Sh/IBLRUWCUVcM1trzMG803dti9fjLXftuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0910/2214] arm64: mm: validate /dev/mem mmap ranges without overflow
Date: Wed, 18 Nov 2026 15:43:06 +0100
Message-ID: <20261118150048.734844781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Gongyi <zhaogongyi@bytedance.com>

[ Upstream commit b0958b1397fb5ffdb995c0ccc74349841929c08d ]

An arm64 syzkaller reproducer creates a FUSE character device with
major:minor 1:1, so opening it uses the /dev/mem file operations. It
maps one page from offset 0xfffffffffffff000 at user address zero.
The next openat() with a NULL pathname triggers a synchronous external
abort (SEA, ESR 0x96000010) in strncpy_from_user() via do_getname(),
panicking the kernel.

valid_mmap_phys_addr_range() checks the exclusive end by adding the
mapping size to the starting address. For this offset, the sum wraps
to zero and passes the PHYS_MASK test, allowing an out-of-range PFN to
reach remap_pfn_range(). The inclusive-end overflow check in
mmap_mem_prepare() does not catch it because the end is ULONG_MAX.

Reject starting PFNs outside PHYS_MASK and compare the inclusive length
against the remaining physical range without overflowing. This also
allows mappings that end exactly at PHYS_MASK, which the old check
incorrectly rejects.

Fixes: 1d18c47c735e ("arm64: MMU fault handling and page table management")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
[catalin.marinas@arm.com: changed the check to look more like __access_ok()]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 77ada00280d93..8f55d3af7e07b 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -38,7 +38,9 @@ int valid_phys_addr_range(phys_addr_t addr, size_t size)
  */
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 {
-	return !(((pfn << PAGE_SHIFT) + size) & ~PHYS_MASK);
+	const phys_addr_t limit = PHYS_MASK + 1;
+
+	return size <= limit && pfn <= (limit - size) >> PAGE_SHIFT;
 }
 
 static int __init adjust_protection_map(void)
-- 
2.53.0




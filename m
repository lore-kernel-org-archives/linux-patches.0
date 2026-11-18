Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059146;
	b=D0KD1gTWoajmNccAiCpnAWko4gwLAK2CUSjVn9aeyGgyYFVYpRSDvaDj5kGItUXRiKnK
	 owlWNlcLUkqtsq+soxukmWFEfreIHktkIs+F1woSpqGL8JIBh3ztmyukwc6vSakXtroKO
	 wJu+kz+zSQdUZMcIrwPkjS1R6j1ybAF1JkR/4/HHxmJJoc+tVPv7GrY2EPwCrDz9vI9rb
	 DYet3Ie1qZ3BOJGeWw864ZIb5zU1Eb+9QlzXvJ/ZsO45YEXK0IjAhKi2q6yeNhLBonunF
	 N6Oik+tyw/xeWWcDXSbQHmGQr6h9WYRv6iJgi/k3cKmCIBbEy5CIwceAqr7U6XrqSnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aKSB1bmb8tpHGBevjU+PHtf5Lcko010nVJytctQMaUY=;
	b=ZWwFM4lSLoftcWyHTOJGS8YQviDDrnQogamBTuVI6zHIA3P+11/aWU9bMXoaDX1rnhaY
	 exHXb0BA1k/ox57qSEGZ1L6EYnc0YKlD49q0E54kEW4r2SyY24msWIVqr5OWsNu8FDAZI
	 MTWsD9omG7DEQsSLn4M7zRA9otbUR+NtbA0w7BbDhVYVPoaIazs9qKiwkcQbPMhic+9Fy
	 kMOg1xaKNYOu4PsN+1uiwIxhofMmNqUiPGdMv3on6N9cV9hBV3CGqYQW6EGD1SQIGYakd
	 E4BvD/0PrO7bi4QzG9hcKn7JvZSNUECzayRNt2pxRlvFpTvwyQUb3QTOcGY5dOJ7/6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lyxKjdvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3EA606A325;
	Thu, 19 Nov 2026 03:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lyxKjdvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDBF1F000C4;
	Thu, 19 Nov 2026 03:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059145;
	bh=aKSB1bmb8tpHGBevjU+PHtf5Lcko010nVJytctQMaUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lyxKjdvvIDNSjHOhr6FcVLx4jN84j3zBoODtf6EgfsMCpMNzTekmHIp8oT8wX615W
	 JkfKTHOIV/IFmuMi+dbLkzU7TDnHcIhUDR6YoYojIpgDPGg2GsD65GnZFgEsIjHhzd
	 F2E+2q83C3g+GL8Cp/fnqi3OFkpB6F3XNoAn+q2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0737/1848] arm64: mm: validate /dev/mem mmap ranges without overflow
Date: Wed, 18 Nov 2026 15:46:15 +0100
Message-ID: <20261118145947.185172905@linuxfoundation.org>
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
index 3028bacbc4e9c..0e908fd345d7c 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -45,7 +45,9 @@ int valid_phys_addr_range(phys_addr_t addr, size_t size)
  */
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 {
-	return !(((pfn << PAGE_SHIFT) + size) & ~PHYS_MASK);
+	const phys_addr_t limit = PHYS_MASK + 1;
+
+	return size <= limit && pfn <= (limit - size) >> PAGE_SHIFT;
 }
 
 #ifdef CONFIG_STRICT_DEVMEM
-- 
2.53.0




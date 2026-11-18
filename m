Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055202;
	b=EDqNwn1H5QTng2W7qakGRodrmzb4u1HOj+KoxzGx2HltYmeJaj4NRfRQDcXOzXo9HLAc
	 2QpnZ+xD43el00yYlKACd3PaY7wgGNf5jV/8IiKN8PW/lV3aT8is6BukPNRAx2BkLd3Rr
	 3Ou/mHhONgWmDtV4zt91jsTrDDn11hb0xEXrF4gfWHiHqOvNv4VHkyXw9pKD6fcZQ/092
	 vG9xskiG8lO6it9l7sxzNQpLSlc3U5NYAOwu397fA88In8B/KzTww7NIjXLIB7Mj4VXNa
	 9bm6YrBkuZblUsDbTpLoCB8d/UW6ojE8NIQrbrL2pz8k8HazCJLGTd52t08rHu5QK4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KKs9+WVr6k61ZcK9Np/08jY6WwIWcCVylkl26WHKQD0=;
	b=CDU+lz9X+TCs7G8XlkssScYimNd8N+EQjpbHbzh3axXfJo7NKNG3GOlGcekTLcLuu5pi
	 F1YsV/w2T7wU70NCzQ4vzC40YiIEkLBjQozab3Z35dKkCpxHC5ZdHEqKTOjPctn1b0Sqb
	 AMOc8C409LFgA/kdmno7RdbsOqPa8XXRl8HUg7dqZkIEIoyxyIQwkXvq5Addr7QWmvTYZ
	 224kxIuKlinP/YYcIuRVdtWYjDXi+KmetPBTNGNA+4BraqpZnLEh5FgN7rPeqzb20zlbz
	 Dfcw7W+NzZswa4iIzLzwRWjV9VBkkFopQ9qg4/Zk/rQNsmvUcgewbH7My62GmsdvnjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnRMRnTG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87522606A31C;
	Thu, 19 Nov 2026 02:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnRMRnTG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CB01F000C5;
	Thu, 19 Nov 2026 02:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055202;
	bh=KKs9+WVr6k61ZcK9Np/08jY6WwIWcCVylkl26WHKQD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnRMRnTG+Vi5fWO1oFfPiPFq0/tcM32zvpIoVEh/TMykGtLEltTHGvKoHgs5N8vXE
	 GoTCa9feHhh3byl8qbotl0x37h1E01bNREMox5bdx0U4MxW4fLUMEmvaCmJqnwdeHu
	 QTzBj1Xgsmjiy2Bfs1GWX2p0wb4wSpNdAOxE7Q4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1545/2214] pstore: reject persistent RAM zones too small for the buffer header
Date: Wed, 18 Nov 2026 15:53:41 +0100
Message-ID: <20261118150113.940493396@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 1b30df8662ac85a6759be4332f3bec7e3cb28efc ]

persistent_ram_buffer_map() computes

	prz->buffer_size = size - sizeof(struct persistent_ram_buffer);

without checking that size is large enough to hold the header.  A
ramoops zone configured with a tiny size (e.g. ramoops.pmsg_size=1)
underflows buffer_size to a huge value, which defeats every bounds
check in persistent_ram_write() and persistent_ram_write_user(); a
write to /dev/pmsg0 then copies user data far past the end of the zone
and corrupts kernel memory.

Reject zones that are not larger than the buffer header.

Fixes: 404a6043385de ("staging: android: persistent_ram: handle reserving and mapping memory")
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260921202317.70595-3-parri.andrea@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 8a86b9928503d..2d89725929d27 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -507,6 +507,12 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 	prz->paddr = start;
 	prz->size = size;
 
+	if (size <= sizeof(struct persistent_ram_buffer)) {
+		pr_err("%s: persistent ram zone too small (%#llx bytes)\n",
+		       prz->label, (unsigned long long)size);
+		return -EINVAL;
+	}
+
 	if (pfn_valid(start >> PAGE_SHIFT))
 		prz->vaddr = persistent_ram_vmap(start, size, memtype);
 	else
-- 
2.53.0




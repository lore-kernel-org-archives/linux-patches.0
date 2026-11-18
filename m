Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060789;
	b=DxqFc6Ug8PLyZfPEUHRc14wb13rxmYIj5ytOHb6U1dcp+Vy/e6USoGKl++MkJFKRUeF5
	 T81ZsQxwz1JSi6r9R8QCSB58POt6PYxha4YCCF8aEXcw0hTCerBofzmaqx8BdSKSzZ6uC
	 17BmnM1nWE6jHHM4jDABPBLZJ+jXgJs7NvKisM6dxmx92ibPmql+VWXOO9j+Ybkw08TeS
	 Ai1FFZZ8LgBPez723at2qq4YZC+8fEow89h0O/03Zca214TMa1CMPRKM24VJoWdM3pkB3
	 VLgvvZ3Ws74wT8zEIzkjHH9TIJjfFQ3nvWj4wH75Ke/DfzFBgbVXPM3oYXcHB3NwHCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gyTb8qW/PRPI1UtdJ83zhJxKmkEdy7n45VEvMbw6JWE=;
	b=mhCNsAoMhvCBeV4qBYMUkYPVvWwKyBBvSM3HDYs0B/akzB+77S8OlGoUFNnAEdkwg4FO
	 kcxzl1ueQEk6EvaeNsMWNgr9VqhVl4lLabVUwCS+VlYTlUhQYblL0P8U1UOZTwCh9fo6H
	 B9qcQ1XIRtSTEd8ZMvTvwqAovWa2uLrdsNf2O6diKlu+Q8ZXYe59zubHAQo2Vo9qkv8dw
	 HRS23PEY3pyGEzsSsjq4dJHPBpTfgIcqVgUCgpA0HuFw/Ygf2tbC9BwRj+rVvbkEtZBMk
	 N5CZveapOdGpCqFLZoRm6x4ZckT0XE7TGYaEjzpsSQoFbM0H+ySZy/2c4ZjIm7uLVTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zO5fcDAJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400F0606A32C;
	Thu, 19 Nov 2026 03:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zO5fcDAJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956EC1F000C4;
	Thu, 19 Nov 2026 03:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060789;
	bh=gyTb8qW/PRPI1UtdJ83zhJxKmkEdy7n45VEvMbw6JWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zO5fcDAJQvHf6W0jd3OSPY47Hr1BSGa65wpJzqgnmRS9TifbQo8f2JO7ruaQDWQTH
	 Trg87W4M8lR4/4ORn8OyHlfXH7L0EFyDYlkrauAgvDOlfFS5U0E7k8RSWFfim4b/k1
	 BUU0br3d8ITG4cxP7VwvAFdJnSt2e5uTUeAUhuYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1288/1848] pstore: reject persistent RAM zones too small for the buffer header
Date: Wed, 18 Nov 2026 15:55:26 +0100
Message-ID: <20261118150013.496623961@linuxfoundation.org>
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
index 80bf449a695a7..b2c81e4a749f0 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -493,6 +493,12 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
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




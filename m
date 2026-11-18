Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048440;
	b=PlZHpf0ENwmV/G6rKDJPb00sIQq699jZaNX8twDR0Ss5vJ/PVGe9p0gBbLtYeevf1R3T
	 d/P/s7eYsQZj/3cjKZ8zIt3gaWLQrl5If99jzETGrYuydEBYWD1PPCNM1jiH0zN2y2Osh
	 zQEt58fVmyD8WUMRJ7ZvDoFqwKwocfjj5S2fEh6ofdWHZH/gfLHIqGlpvDFag5HkkSsSU
	 boebeNhYzgZTCSD6pKq38JtPwfhlk1/DVj6o9UAsYmUOffXLYt9myT2upl1c/FeRfAzYC
	 i6za09kAKyOQEDy0sQn5wKTL5psogaKvavg3bC3EQjR1YMtzZ1or+7WF8CYP69N0WRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ezYvf3a4Id0tFy1nNA+2UQUtwTEbO0CPEp/EMlfc2kY=;
	b=T3PT4kXHaVuCCLKKcba7v1CdBCnB/MP6tci1J00YcaAnsRoVd/goYF64PV48EggsGWuD
	 6/M5xMNpxzOBhJ5rx+EixiUlzJPbyo10lRr6UR50k4QLenZUtqdfdi+Wjyb0DjzkIZxus
	 aj8Gm5hcRWXWjhgTjtJYaw9gZOvSESc+D9t3naxLonVzBEGNoY3XGN5ybA8bhPy8Pidar
	 CVANAxSKrv12GpgpcTCqiMhMjo1fSaKXEsf2H/vBcvpTt9EQ26+hhiJs0lfN1vgY1qhXm
	 w0TEGXHzwIrfiJync9B/GURz2HSQ0ppvxKy5vjih4RUXY/cX8E5fVlEFSDuohgJFksg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQUDVOAg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205E060A2621;
	Thu, 19 Nov 2026 00:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQUDVOAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B431F000C9;
	Thu, 19 Nov 2026 00:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048440;
	bh=ezYvf3a4Id0tFy1nNA+2UQUtwTEbO0CPEp/EMlfc2kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQUDVOAgi5MhtsysGVcHtcZmOPzVMov0jKM6+/yK93Ky7rgvGb5Vic8wSYKJHOGXs
	 zkiE47LIsZNO6fYvbUNyxi7vwhqKEHf9zpDEgMMpqquw+8P7uwWV881XushgmpsHTA
	 KhimpY5v0wzB0VXtcSlsMq64On55+bfAuUXvdrrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1988/2857] pstore: reject persistent RAM zones too small for the buffer header
Date: Wed, 18 Nov 2026 15:50:22 +0100
Message-ID: <20261118150312.955093484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed86e173f8cfc..0c455c2725abb 100644
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618583;
	b=C/dGYmQAHjS4SNZLPTxgs4QPJ/E8uG4fLS3j4j7t0ZLlj/Yhyd5aFyp10uAJJrwkCdXE
	 V611uYy8N3Lbhind2XtKulX+EkrJ3FX3fmfbnbGumAo/zHRdr3zCuPsGExjblmc6BjF3I
	 ceiNcjOGrFm4aFzja4HrmyoTQ+F6kRoNypTPFcunBi3xshFFh7sWiWN2pAhldrsTuuCHS
	 CsQKvWVMQRIWVcY5VUzUGqDc7ep3bjOvfrXOmO3xZp1Ut4d3swm3zudkGTbSFI20pZ8po
	 Hqjx7GrARqFqHVs0u4rBQqlx6/Ruba3AvTZsbyGO8gL9kl52zqdigVWKgW5i1Y/H2Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/EcmE73oUVogz6Dyt9a4wtXJQsSgEPtXYRojTD9v6Wo=;
	b=PgbVKu5ffv8zXMiz+5PMvwUs/mW9yNK+h7u5RYeH6DYNfHJ9iAM/Is0mSlkrOdLdZWIn
	 q5eHr2hG/b+pep3mFJr5z/0ajrWdmqACFOYiKZJeIL6Zw1z3HXn42YwGvqeVasJUK/ujk
	 L2UGd7IY2WRUIFPMNJV0FdAHgc4k0C6G3B0ouq3Qt7AHoOaDDmJtrliTRqFBRfxtxdfPe
	 BRL+nd6aexmKU6jQcMZKm7/oYSw2XV/wXKI4PX2V3hYls2keJ/5HOvw1/w+ihCwYAjxum
	 1oVNI5r4A6lv0DXKPO+O/x5Dzc1zlq+3cqTzkkXMy+cr3PeZO8gpRgH678yvCyx4eQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/gWPwg7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF69606A321;
	Wed, 25 Nov 2026 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/gWPwg7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2629B1F000C6;
	Wed, 25 Nov 2026 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618582;
	bh=/EcmE73oUVogz6Dyt9a4wtXJQsSgEPtXYRojTD9v6Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/gWPwg7f0lBrX4SyVMWaNlfao4KlrGoCk0iy+PwkohWox09qWN3Dyfwhs56jRM47
	 oqNsnLeSKIIv2xp1hCw7qrnFkj8zJNUuoxYy9HPH0hVqqshS3l6N7qUgcxcrohPFhy
	 RgUkFlbwsDfisIfcMR9z6aN80ag/AHjykU6/nwn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0326/1005] MIPS: Alchemy: Save the Ethernet address before reusing PROM memory
Date: Wed, 25 Nov 2026 15:27:44 +0100
Message-ID: <20261125143829.369725410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 792ac17faa0503448f3ef85b49f16456ac54ab84 ]

Alchemy keeps pointers into the firmware environment and looks up ethaddr
when initializing the Ethernet devices. By that point, memory allocation
can have overwritten the environment, causing prom_getenv() to pass an
invalid pointer to strchr() and panic during boot.

On the MTX-1, the struct page layout change in 9ddb3c14afba reduces struct
page from 40 to 32 bytes and exposes this unreserved firmware memory.
Bisection and boot tests confirmed that the parent boots while the change
reproduces the panic.

Parse the Ethernet address during prom_init(), before registering RAM
with memblock, and keep the six bytes in kernel-owned init data. Return
the saved address during device initialization, preserving the existing
YAMON formats and command-line fallback without reserving a fixed
low-memory region.

Fixes: b93ddc4f9156 ("mips: Reserve memory for the kernel image resources")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/alchemy/common/prom.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/mips/alchemy/common/prom.c b/arch/mips/alchemy/common/prom.c
index 20d30f6265cdc..c4aefeb788715 100644
--- a/arch/mips/alchemy/common/prom.c
+++ b/arch/mips/alchemy/common/prom.c
@@ -46,6 +46,11 @@ int prom_argc;
 char **prom_argv;
 char **prom_envp;
 
+static char prom_ethaddr[6] __initdata;
+static bool prom_ethaddr_valid __initdata;
+
+static void __init prom_init_ethernet_addr(void);
+
 void __init prom_init_cmdline(void)
 {
 	int i;
@@ -95,6 +100,9 @@ void __init prom_init(void)
 	if (!memsize_str || kstrtoul(memsize_str, 0, &memsize))
 		memsize = SZ_64M; /* minimum memsize is 64MB RAM */
 
+	/* Save the MAC before the allocator can reuse the PROM environment. */
+	prom_init_ethernet_addr();
+
 	memblock_add(0, memsize);
 }
 
@@ -125,7 +133,7 @@ static inline void str2eaddr(unsigned char *ea, unsigned char *str)
 	}
 }
 
-int __init prom_get_ethernet_addr(char *ethernet_addr)
+static void __init prom_init_ethernet_addr(void)
 {
 	char *ethaddr_str;
 
@@ -135,12 +143,21 @@ int __init prom_get_ethernet_addr(char *ethernet_addr)
 		/* Check command line */
 		ethaddr_str = strstr(arcs_cmdline, "ethaddr=");
 		if (!ethaddr_str)
-			return -1;
+			return;
 
 		ethaddr_str += strlen("ethaddr=");
 	}
 
-	str2eaddr(ethernet_addr, ethaddr_str);
+	str2eaddr(prom_ethaddr, ethaddr_str);
+	prom_ethaddr_valid = true;
+}
+
+int __init prom_get_ethernet_addr(char *ethernet_addr)
+{
+	if (!prom_ethaddr_valid)
+		return -1;
+
+	memcpy(ethernet_addr, prom_ethaddr, sizeof(prom_ethaddr));
 
 	return 0;
 }
-- 
2.53.0




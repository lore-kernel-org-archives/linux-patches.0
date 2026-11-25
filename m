Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621667;
	b=X29fTVuUV1pPj0Kla+5XVjsGraUTMs1Wtj2RbEukKAzuqF83RSRSo7e2lfcFzeFIyaOJ
	 Hm6aZ68E/jwd6CnHn9nck8LT26bd44tSG81Ajwg1y4F4sEiFvVfcJoEEKrcv5ksXrOneY
	 07kT5c84l+oAw/uORfhVv8stZC48y/7Ph4n5ZyNussPleuT749PdxUBuHjzUHWoJbWDeI
	 9sQwBAm8E5obGqpNUuXSvhPTtLgjRm/4MOUu9581+XtIex8KOG0BhxCvn3ImOyP6iHdgO
	 NLdovTILbcb0TUrQ9dt1Mhd3c40oFeDXjvZLZleKQYOF6wE1FNgwg0BIzAfcdV5JBZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+MEJhgyC7FVWU84o+dvv0yg8V2BtHbMGeiIjrGj6R9c=;
	b=m3bofOsIhASNVjVPAFK23HlZN3AYmYZ6Oep41jp+4OlrJuFHptX3vQg0MxoGij6aQgER
	 Lr5chQ3upKRyoFc7FJVbyJitNRcMNlS5iXEFFbK8lTdcVBzWywzp24ik+aSHu408vjcrS
	 pHeNpqY1kK0rK3+zCCIwPUdUilJqp148LOnK5DYQIj3iOiFcK32SwLyWGoUCweoR9Na6L
	 DdpBzrSSbRW9qITS/sJ+muT+U0/YmaVvQLCB278GjORjH4WLxJvEH7I5Pl/aPAduIhEF0
	 /iPxoePn37kRKR6qm3oHilE9RCycGI9bXDQwQZxpfZKyEXbLB6VRp6E2IvS5mHup2bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYdF2YEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BC5606A681;
	Wed, 25 Nov 2026 15:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYdF2YEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF531F000D0;
	Wed, 25 Nov 2026 15:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621667;
	bh=+MEJhgyC7FVWU84o+dvv0yg8V2BtHbMGeiIjrGj6R9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYdF2YEzrYAa0EM/ZeTYo+eSWv4HXXFlJNnAeHpfx98LLxcuykpFahFFWwbpbyiw1
	 vxzi1A9nxWDPYmh6nieqBsVTJ6zeTbQzqwFHCTP73mZOp/89trdyXuuhvbfqPx+CDR
	 dIberaQT1Fyq19/7YmR/eQiLfCvwfuIui5cD5YEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 296/990] MIPS: Alchemy: Save the Ethernet address before reusing PROM memory
Date: Wed, 25 Nov 2026 15:27:43 +0100
Message-ID: <20261125143829.025827302@linuxfoundation.org>
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




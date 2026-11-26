Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704349;
	b=ejZT8BE9oB8ucxB8kGxre3vZtbm70a0+GUquJRVYqtmouVX5/p7189Sob9IDDq1aYhpP
	 QNMZ8YX5+v9nLMGD+vhbeJ6AQwdpHNV35aKSCOqngEHOogXsNQR3iXzAwjpuK1xWY/CEp
	 3a2a0p905rPRrM5jMWzmjrDeqSL2ct/OT/ejfkie7yXeIk55Ib6+eGdHhU8o3U8fPiJnV
	 8wmhzUBeM0SJukXr8cpG2vmQR6hvbY3VQ0h/R3dEMjS3O84+9Z8hmUpgqXqClIZ+p7AOw
	 LAlt3dmy3Jz4Q3Q7J3jj2dbCx7GyINsiQQGkXlTkSQPDxbYv+mO8j63biE+OcBlI4jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rYfmHDlqT463vmzjJHlPfAvFPbjsU6qG6dX77iPDLM=;
	b=SNDdWaGjsmf+lAGCOwJofRym1hVJZa8GWOq049pRm7XC3iWNa8mpqdgb5eOkYU+7Xnmp
	 xedaiRsLVefInEUxMJ+MMnwraQ6LiUYKHaJQmJyTuU3XayvYfHIRjBN91ocmkVdeqbWZY
	 rBqsKMlt1Y8/79VBXJtJjEa3E+K9FGGseigbIvboAu3cbo7IYqJE8GiLHtPPNjbmr1p6i
	 vL4PSsDFEPje8pfB/XrwG9/HJyGBta2O3tOxFWqX4wCpaznoNhcELzxSJ6oIvGumQlNCs
	 1Lva23uLoSYt3xL6rro7p8nWKuxFU68kBAV4ywxFwpHDqszTgOT/zTETCH5IFHu8hrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c8T7O8Is;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CBD606A31C;
	Thu, 26 Nov 2026 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c8T7O8Is
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0AB1F000C0;
	Thu, 26 Nov 2026 14:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704348;
	bh=/rYfmHDlqT463vmzjJHlPfAvFPbjsU6qG6dX77iPDLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8T7O8Is/MPhEbJ/FBDjj2Fdw3ZLT/Le7AIGTlRtd2/Dy3aLbS03+1gx0X3HmTRWR
	 +t4kCgab0ouOq7fQDFPeDowTV6iX5XLv1R0fRlhjUxuuthdJQdFZuZfBGeNRc8I9a2
	 7QUrVQv/A+BxeUezXb5W/VhyMoNaP/DVnrgjLzLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/265] MIPS: Alchemy: Save the Ethernet address before reusing PROM memory
Date: Thu, 26 Nov 2026 15:37:01 +0100
Message-ID: <20261126143611.378139824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index d910c0a64de95..7033e680fe34c 100644
--- a/arch/mips/alchemy/common/prom.c
+++ b/arch/mips/alchemy/common/prom.c
@@ -45,6 +45,11 @@ int prom_argc;
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
@@ -94,6 +99,9 @@ void __init prom_init(void)
 	if (!memsize_str || kstrtoul(memsize_str, 0, &memsize))
 		memsize = SZ_64M; /* minimum memsize is 64MB RAM */
 
+	/* Save the MAC before the allocator can reuse the PROM environment. */
+	prom_init_ethernet_addr();
+
 	memblock_add(0, memsize);
 }
 
@@ -124,7 +132,7 @@ static inline void str2eaddr(unsigned char *ea, unsigned char *str)
 	}
 }
 
-int __init prom_get_ethernet_addr(char *ethernet_addr)
+static void __init prom_init_ethernet_addr(void)
 {
 	char *ethaddr_str;
 
@@ -134,12 +142,21 @@ int __init prom_get_ethernet_addr(char *ethernet_addr)
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




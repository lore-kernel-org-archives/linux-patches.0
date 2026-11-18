Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059340;
	b=DcDYDS58iAGfvZFm2icxzMfEEpdJy3ufthDtCcvo7c3ixGRySRkLQR0Eqw3fmgCnOIeO
	 RvWDnCqZhYj5RLvQMjhruWQlnAGLFbvlMSk2rDvAnmkumlVUrasudCjbjHwLxiq3hvqrz
	 TXbMv1hVv8CqjYmINvItuIwrcVyCSQsQfCm6PcmbMZ1xu1SL6aaYZovz/Ip35fyHqW0SZ
	 +qCctR3GeVBgL7ERPyi0qIqtwwVATu8VVYzHmIe5XdPbbGKrgCqEG/hy/4rKmMyUlkFSe
	 NUxkAmhLeLc/BuV8Yj8com9zcH8z6lGyf0Jn8gyKS1wEdfprIHqAPtBVA68oEILBUbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ltfbzXUoqEewUSzdFG7d1jbXiitC17NjAmwSim/tpog=;
	b=nGQ3Y9Fx6G86vR5bw2nKrOYwidc1mfoFAh6CcxJ9RaIGZPy44F419s+ZE57w8tZ4KduQ
	 q4Gj/O4uFSN2baZ3jbsLQxISvUWgI78rbiVrt4FDGnxDRicFlUoayc4Q01hK1iIO++KP4
	 DU98baLqllyiDDr7AAr0RbxRDUU0J24LjamNSm2FX9tGN1H2R9fN2iz5cSeT2qMRTRY1p
	 npqU7enRSCJCdDNKmGjxJZll4f4W8cb0DEAgiIAn7xA1mbnGt4iK42d8qWaXCHcTqTHOt
	 VcjAsrBoyzYAjGa+BG+N59DGKgsU5U7B4pGs4xsr0Lg9QWWzjuA2tYqFuM2BUmZIl0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeX6xwIF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DA8606A326;
	Thu, 19 Nov 2026 03:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeX6xwIF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225451F000C4;
	Thu, 19 Nov 2026 03:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059339;
	bh=ltfbzXUoqEewUSzdFG7d1jbXiitC17NjAmwSim/tpog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeX6xwIFFi3O1UwtJIhEGwfBJTuBrBCz2i8SmwmyUcJfduDT0Tnb3tyfUYeX4oPIL
	 4NMO1/NFdxHmhKFifASausyT7z92jsxE0PnadT6Ymo6OCu1xWmT5EAvkaDmb4JBcIR
	 TMq+yjbOo4rcwV5YwrFLSvXynJjKLE/lv1HZ3OKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Burton <ross.burton@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Rob Herring <robh@kernel.org>,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0807/1848] of/fdt: Ignore disabled memory nodes
Date: Wed, 18 Nov 2026 15:47:25 +0100
Message-ID: <20261118145950.111260284@linuxfoundation.org>
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

From: Andre Przywara <andre.przywara@arm.com>

commit df5cd369876114f91f9ae60658fea80acfb15890 upstream.

When we boot a machine using a devicetree, the generic DT code goes
through all nodes with a 'device_type = "memory"' property, and collects
all memory banks mentioned there. However it does not check for the
status property, so any nodes which are explicitly "disabled" will still
be added as a memblock.
This ends up badly for QEMU, when booting with secure firmware on
arm/arm64 machines, because QEMU adds a node describing secure-only
memory:
===================
	secram@e000000 {
		secure-status = "okay";
		status = "disabled";
		reg = <0x00 0xe000000 0x00 0x1000000>;
		device_type = "memory";
	};
===================

The kernel will eventually use that memory block (which is located below
the main DRAM bank), but accesses to that will be answered with an
SError:
===================
[    0.000000] Internal error: synchronous external abort: 96000050 [#1] PREEMPT SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.18.0-rc6-00014-g10c8acb8b679 #524
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : new_slab+0x190/0x340
[    0.000000] lr : new_slab+0x184/0x340
[    0.000000] sp : ffff80000a4b3d10
....
==================
The actual crash location and call stack will be somewhat random, and
depend on the specific allocation of that physical memory range.

As the DT spec[1] explicitly mentions standard properties, add a simple
check to skip over disabled memory nodes, so that we only use memory
that is meant for non-secure code to use.

That fixes booting a QEMU arm64 VM with EL3 enabled ("secure=on"), when
not using UEFI. In this case the QEMU generated DT will be handed on
to the kernel, which will see the secram node.
This issue is reproducible when using TF-A together with U-Boot as
firmware, then booting with the "booti" command.

When using U-Boot as an UEFI provider, the code there [2] explicitly
filters for disabled nodes when generating the UEFI memory map, so we
are safe.
EDK/2 only reads the first bank of the first DT memory node [3] to learn
about memory, so we got lucky there.

[1] https://github.com/devicetree-org/devicetree-specification/blob/main/source/chapter3-devicenodes.rst#memory-node (after the table)
[2] https://source.denx.de/u-boot/u-boot/-/blob/master/lib/fdtdec.c#L1061-1063
[3] https://github.com/tianocore/edk2/blob/master/ArmVirtPkg/PrePi/FdtParser.c

Reported-by: Ross Burton <ross.burton@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220517101410.3493781-1-andre.przywara@arm.com
[ Georgiy: 5.10 lacks commit 1f012283e936 ("of/fdt: Rework
  early_init_dt_scan_memory() to call directly"), so the function still
  handles one node per of_scan_flat_dt() call: return 0 instead of
  continue and use initial_boot_params instead of the local fdt. ]
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 384510d0200cd..753a2344cfaf7 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1000,6 +1000,9 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 	if (type == NULL || strcmp(type, "memory") != 0)
 		return 0;
 
+	if (!of_fdt_device_is_available(initial_boot_params, node))
+		return 0;
+
 	reg = of_get_flat_dt_prop(node, "linux,usable-memory", &l);
 	if (reg == NULL)
 		reg = of_get_flat_dt_prop(node, "reg", &l);
-- 
2.53.0




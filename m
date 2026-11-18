Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015224;
	b=b4Ya/j1LTWNjTzkQXmNofBRiHUSkAaYElUmz/4Ch5yeQyj+uZ3k/SgHkuiQ0lQxuWZtT
	 ZDeL4Fzwla4JgXtzIAenY9n7oeYA9s0dU8lq2/qnndEaA6Xh9JPXrchvwN7aB0Zxlb4Pt
	 IaX2CdUHC1j+rqlRGMSiINjeTwyu1usGVSop2arfoqlTHacvp+Op/bmscL61K9jJ611oj
	 gqmCUaq7AgGJLInYIvFQtGybhMfh4+jYXrzGsymSETnzvbhJXMPB7vpCvXhfiIvS8uA42
	 C+sTr53a0ODT2uBcI+YEsPGYjOEur/xgnh7u/9rOXBNyeCFOngKTfWXMAgdqoMLZhUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ec93S9N7qkbX95rofOqbJLXwSR0J8zQZs9nx9nTyfDA=;
	b=zVjDrhE7kW+qALRasIxkLn2/J/JI0BShsfawU0RdcJuEunC7So8MvgOJRshqzO14PrLG
	 a36ej7kK1umvDamX6voutoKBsZVtSEUxlhnq0HbJWUH3FG3OOk/af3moYC4sfas2ysurW
	 R5XhpT76TKjAMDLpUv41+OOGPfZwiXtSh464uZlUCEuBmwPepYfZgtQ3zlKwxCRAxB8F8
	 baHfEDmOjM5wsF+8H2rk3R3hF36WJGFaRXwlww/44vVvp8sJHHAYVZzoHbad6Xctl0QOR
	 yzeVMMdlnSyvmytd+VJXTPJrhV6/7wRx45wcnsTXtuXMKMEiV1yLFEDM14D/onbkY7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=krkE+ESr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16488606A337;
	Wed, 18 Nov 2026 15:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=krkE+ESr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E5A1F000CA;
	Wed, 18 Nov 2026 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015223;
	bh=Ec93S9N7qkbX95rofOqbJLXwSR0J8zQZs9nx9nTyfDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krkE+ESrlSqrLXwiv7GI9xzf4wIGP6LVQlCqmHKZbfKi2lybDiHl1600Ukn4s/9bD
	 RYsAScW2oZdnUTSQZyxd9zvVRO+kQdNVPOF0d6um1v4LL/8m3xediOWUWIcDlrJlFR
	 vzhebCPWQ+LV+RuZB34H473uYkXWcTdp054Z5htM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0097/2651] ata: pata_parport: Fix use-after-free in new_device_store
Date: Wed, 18 Nov 2026 15:22:17 +0100
Message-ID: <20261118150251.391296883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit bd46a0b22933fb45f4ff009fa4a3836124df34b3 ]

The function new_device_store() calls driver_find() without any
protection against concurrent driver unregistration. This can lead
to a use-after-free (UAF) when a driver is unloaded (via rmmod)
in parallel with a new device addition via sysfs.

The race window exists because driver_find() returns a pointer to
the driver's private data, but does not increase its reference
count. The caller is responsible for ensuring the driver remains
valid, but new_device_store() did not hold any lock or reference
during the lookup and subsequent use.

Concurrently, pata_parport_unregister_driver() releases the
pi_mutex before calling driver_unregister(), allowing new_device_store
to proceed with a stale pointer after the driver has been freed.

Fix this by expanding the critical section protected by pi_mutex
in both functions:

- In new_device_store(): acquire pi_mutex before calling driver_find(),
  and keep it held until all uses of the found driver pointer are
  completed.
- In pata_parport_unregister_driver(): hold pi_mutex throughout the
  entire unregistration process, including the driver_unregister()
  call, so that no concurrent lookup can see a partially removed
  driver.

Thread A (new_device_store)       | Thread B (pata_parport_unregister_driver)
  driver_find("ate")              |
                                  |   mutex_lock(&pi_mutex)
                                  |   idr_remove(&protocols, id)
                                  |   mutex_unlock(&pi_mutex)
                                  |   driver_unregister(&pr->driver)
                                  |   (frees driver_private)
  /* continues using stale driv */|
  -> UAF!                         |

Logs:
BUG: KASAN: slab-use-after-free in driver_find+0xd0/0xd4
Read of size 8 at addr ffffff9f970dc690 by task sh/4737
Call trace:
 show_stack+0x14/0x1c (C)
 dump_stack_lvl+0x70/0x84
 print_report+0xf4/0x5a4
 kasan_report+0xa0/0xe4
 __asan_report_load8_noabort+0x18/0x20
 driver_find+0xd0/0xd4
 new_device_store+0x140/0x30c [pata_parport]
 bus_attr_store+0x5c/0x94
 sysfs_kf_write+0x1c4/0x25c
 ...

Allocated by task 4734:
 kasan_save_stack+0x28/0x4c
 kasan_save_track+0x1c/0x34
 kasan_save_alloc_info+0x3c/0x4c
 __kasan_kmalloc+0x98/0xac
 __kmalloc_cache_noprof+0x158/0x3cc
 bus_add_driver+0x70/0x4d8
 driver_register+0xf0/0x3b0
 pata_parport_register_driver+0xb8/0x1c4 [pata_parport]
 0xffffffc07f5ce014
 do_one_initcall+0xb8/0x36c
 do_init_module+0x230/0x6d4
 ...

Freed by task 4737:
 kasan_save_stack+0x28/0x4c
 kasan_save_track+0x1c/0x34
 kasan_save_free_info+0x48/0x8c
 __kasan_slab_free+0x5c/0x84
 kfree+0x174/0x3e0
 driver_release+0x1c/0x7c
 kobject_put+0x178/0x47c
 driver_find+0x78/0xd4
 new_device_store+0x140/0x30c [pata_parport]
 bus_attr_store+0x5c/0x94
 sysfs_kf_write+0x1c4/0x25c
 ...

Fixes: 246a1c4c6b7f ("ata: pata_parport: add driver (PARIDE replacement)")
Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/lkml/20260728024015.2014674-1-shuangpeng.kernel@gmail.com/
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/77dad1184ebd0e1e7ea541d4207568f8bc5ec01f.1785381141.git.xiaopei01@kylinos.cn
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_parport/pata_parport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_parport/pata_parport.c b/drivers/ata/pata_parport/pata_parport.c
index 40baeac594a9f..cf81a6128f552 100644
--- a/drivers/ata/pata_parport/pata_parport.c
+++ b/drivers/ata/pata_parport/pata_parport.c
@@ -618,8 +618,9 @@ void pata_parport_unregister_driver(struct pi_protocol *pr)
 			break;
 	}
 	idr_remove(&protocols, id);
-	mutex_unlock(&pi_mutex);
 	driver_unregister(&pr->driver);
+	mutex_unlock(&pi_mutex);
+
 }
 EXPORT_SYMBOL_GPL(pata_parport_unregister_driver);
 
@@ -646,18 +647,18 @@ static ssize_t new_device_store(const struct bus_type *bus, const char *buf, siz
 		port_wanted = -1;
 	}
 
+	mutex_lock(&pi_mutex);
 	drv = driver_find(protocol, &pata_parport_bus_type);
 	if (!drv) {
 		if (strcmp(protocol, "auto")) {
 			pr_err("protocol %s not found\n", protocol);
+			mutex_unlock(&pi_mutex);
 			return -EINVAL;
 		}
 		pr_wanted = NULL;
 	} else {
 		pr_wanted = container_of(drv, struct pi_protocol, driver);
 	}
-
-	mutex_lock(&pi_mutex);
 	/* walk all parports */
 	idr_for_each_entry(&parport_list, parport, port_num) {
 		if (port_num == port_wanted || port_wanted == -1) {
-- 
2.53.0




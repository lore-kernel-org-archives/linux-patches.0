Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028891;
	b=KcxEgAcrbLHas6HgKnXUb7QX3z0DPLbKpBvaxwBLoPxh9XI+A5lfYblpg+nDfOpb7S4z
	 AoIVMfr1wGPv2a5NALI3ekhDA43LqqlGXr4xeF2llI7Uk5MNHbGnYZcYu0VKuypF6tsIp
	 jfOnfkmc1JVdlX65a1z47RJynXTojdJNm8z4eE9U+gKyaCwpu0PxLzeSMvgmOSlvTY9+L
	 muN1BttqtVQjl6OP/GS7AJkW+UQ8S2PGws87eD+xqQzVlCrgFLdNnVucJIf3m3JZ27qEf
	 /tqzr/26s68Js5VwmB3AAexxSrR2jGPw6Wf+DiTAqyBm/dFSTD4srbVY2OQfCJTJ4aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UM10mFYRCON0NnYTEVVxn8hnDvOHAycHU4B22pRiZsQ=;
	b=U5dv1HF29Oc5oSJ1OhQYgQU8qvm/r6v35XlpFGLGpHXtq2FEpUe2hLYUwhxcVsYmEj6G
	 evYGKVfEmm2xdNGdPQgqeguwuVPReRlb6xvkDT1c+c5vEqJew3SD1YNMMvkayjK4lvlx8
	 YpjF4KyWVpdQfdINSVOdnuSzUiJwiZ4T8rd2uxTVEYUA5j3qmJnN15hElgKWDeeSdQnsv
	 86Xw1995GFnUbJmwxOArMn2QW2+v5D6EJWPaP78mPFgdD+nyAxVogbr5yrXwEnwmZPFUU
	 1ISq/INLdD+jz8w5N4ZIVf7X099P+Qjfn8gUiEc/GM4SOUgqxEP25Gla5/28TNeAp9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmQWMA8P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6D760A260B;
	Wed, 18 Nov 2026 19:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmQWMA8P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FA61F000C4;
	Wed, 18 Nov 2026 19:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028891;
	bh=UM10mFYRCON0NnYTEVVxn8hnDvOHAycHU4B22pRiZsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmQWMA8PFCZg4Z1EC/h4XG25GQs8Nd2tMEZ4kPFnLohGekykF3LTSzpq71kRun1O4
	 X3j8ijIqibuHF9vilO4yPjiZHKmgGvTjafH84VuIUuyL0wNzzmf2CxOvOvXbvW+UIB
	 voxCWYakRQMWSZvuKeEZqH3c0qBJCJILQ7OLwB+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0154/1756] ata: pata_parport: Fix use-after-free in new_device_store
Date: Wed, 18 Nov 2026 15:38:01 +0100
Message-ID: <20261118150014.263533443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 22bd3ff6b7ae8..5c6651621dfbe 100644
--- a/drivers/ata/pata_parport/pata_parport.c
+++ b/drivers/ata/pata_parport/pata_parport.c
@@ -626,8 +626,9 @@ void pata_parport_unregister_driver(struct pi_protocol *pr)
 			break;
 	}
 	idr_remove(&protocols, id);
-	mutex_unlock(&pi_mutex);
 	driver_unregister(&pr->driver);
+	mutex_unlock(&pi_mutex);
+
 }
 EXPORT_SYMBOL_GPL(pata_parport_unregister_driver);
 
@@ -654,18 +655,18 @@ static ssize_t new_device_store(const struct bus_type *bus, const char *buf, siz
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




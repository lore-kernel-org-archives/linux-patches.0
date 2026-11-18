Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043613;
	b=j7jAvNlcZoYN0eetyEuvSAaaiYLqxR5PERnc1JCJHZ4h8YTJk9Ivm3pEadB93fW2YzpH
	 2x7pw8Bxq5zQQQt1W9Y4xGaA9iCC1aurT8R1wQGBwkldOfikvYZUkgx00kAnJv//AQiVP
	 qEpZAJDhFWzc7fxFJzH1z3Vh+5PuP+a5BjVRgQp6gnVmz01Qq3daTtGAnYj1gZelUCkCn
	 W7JLubAZigt8e+02glxAF9zNjTqrBsVV39mX3CSFpCRsDpYEt2sbOXbD4g9Nw6M1O+DJ3
	 uhojT6liVgTCuK4biW477y4aoo+S2TlN26REqtdKSeN76P7Ph0c3AEUqDe87fShxZBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A5Yk9G5wQiXJ3ctZDNXDWy4ng/y6JnYBRV6Gkqi+WpM=;
	b=roGTXSq8sIhJFwvn5b/h0PXkqzFdptb2sLn/9E5pNFBul9cc5/7QysKXQgOAq4NPjxUj
	 YJKWgNmekZpaO5aQTkHbMOIDVUihwAx91VpYxkW6sH6WvURBIJcCPI6dNZHPY/vy2XUOY
	 fizgrIM+zhpcCLFsH32kj6BrkfcUZfco91ROZ/sj5mir3DEKeVBXtM7VWOrRgUypv/mRY
	 Bf1oexNZSNXJgP0j6UtnKff+1R8nOuNU/+vmltkCR5aVlC8Wh3ZR7YmsKpZn7c9xGpg+h
	 tdttJsBYm7ww9r+grSFh2TDmrmVbAFfoYWxewNSFRknVP7sS52+fB6pKnMw8HS+Hj9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/BEfIJn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC66606A330;
	Wed, 18 Nov 2026 23:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/BEfIJn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C36E1F000C5;
	Wed, 18 Nov 2026 23:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043613;
	bh=A5Yk9G5wQiXJ3ctZDNXDWy4ng/y6JnYBRV6Gkqi+WpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/BEfIJn1aaF1MHPVG2kyS8fwMr4Eka+3AJJm53LWEuj0zf8UVc1CCyDWe61pCJeG
	 iXXME4pkUDYIBn3w2QJtrK3vICJx0LQVFyiDR5KeW/XW/218idyngH9DB6gWqU1PII
	 et4vdpH0osHNOSIj5IyNcwSz9lVyViVvf7vQL8RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Narsimhulu Musini <nmusini@cisco.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0271/2857] scsi: snic: Fix SCSI host leak on workqueue allocation failure
Date: Wed, 18 Nov 2026 15:21:45 +0100
Message-ID: <20261118150211.185645222@linuxfoundation.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 12e67eb89eb2b9516685c744d3f7de0a2d1bd701 ]

In snic_add_host(), if scsi_add_host() succeeds but
alloc_ordered_workqueue() fails, the function returns -ENOMEM with
shost->work_q left as NULL. The caller's error path then calls
snic_del_host(), which returns early when !shost->work_q without calling
scsi_remove_host(). The Scsi_Host remains registered in sysfs as a zombie
device even after the probe has failed. This causes:

 - The leaked host remains visible in /sys/class/scsi_host/ after probe
   failure, with state "running".

 - Subsequent SCSI host numbering is permanently shifted (the leaked host
   ID from ida_alloc() is never reclaimed).

 - Memory leak: the Scsi_Host allocation can never be freed because
   device_add() took a reference that can only be released by device_del()
   inside scsi_remove_host().

Fix by adding scsi_remove_host() in the workqueue allocation failure path
inside snic_add_host(), undoing the successful scsi_add_host() before
returning the error. This is cleaner than modifying snic_del_host() because
snic_del_host() is called from a shared error label that also serves paths
where snic_add_host() was never invoked.

Reproducer (requires no real SNIC hardware):

 - Build CONFIG_SCSI_SNIC=y (built-in)

 - Add snic.test_mode=1 snic.inject_wq_fail=1 to kernel cmdline

 - Boot with a PCI device matching the snic driver (e.g. QEMU edu device,
   PCI ID 0x1234:0x11e8, temporarily added to the driver's PCI ID table)

Before the fix:

  # /sys/class/scsi_host/ contains a zombie host0:
  $ cat /sys/class/scsi_host/host0/proc_name
  snic_scsi
  $ cat /sys/class/scsi_host/host0/state
  running
  # ata_piix gets host1, host2 (host0 stuck):
  scsi host1: ata_piix
  scsi host2: ata_piix

After the fix:

  # host0 is properly freed and reused by ata_piix:
  scsi host0: ata_piix
  scsi host1: ata_piix
  # No zombie host in /sys/class/scsi_host/

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Acked-by: Narsimhulu Musini <nmusini@cisco.com>
Link: https://patch.msgid.link/20260727073438.209673-1-chenchangcheng@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/snic/snic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 174f7811fe509..fbc8252b4eebe 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -306,6 +306,7 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
 	if (!shost->work_q) {
 		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
 
+		scsi_remove_host(shost);
 		ret = -ENOMEM;
 	}
 
-- 
2.53.0




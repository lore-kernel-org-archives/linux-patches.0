Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057596;
	b=a5mnQCfDnfMSqg4A3tGRDukQkgtgMZ7I+1KjJpjLi3Wk3xYqFcTmaTHCnDnY9sHIsehY
	 tMmtJkwg1EnQY7+hDmdofMLKcutJ5k034SIDdkWZb+9ZB13xMvRPKRGe2EV9vYAbMueEZ
	 g9FyZ1XUJMy0jAPAr5BSALlSksX6BtBV2drrKLLdeQ9das/gTamiUgfAlWZjINwM3lj78
	 MtCfolK2mo2tauLJJ3WPdMkgvyAJalRl3dawVlIr7p/mOQLguajBDU7GUFVcviIE5HRQa
	 kKWGRkUYuM9ImZPI/N9nTC5zR+E3lp+q4fm2A9ErHtPGIzNYRq27lBoWXXJieZs9W7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ognP7ZhHkT76X9CVrk5nmV2LZoHU82yhXApVajfE+vI=;
	b=CoyLw70uZga0FZ+YyhTSvfCz6wMkW/D3RhOkpC+BMYyp8NUxWdkEjk+0f1GvZHYIkY6F
	 499ONOhppkgFrb3f+29jykoLQ5mdEqNzH73L4ikRiThlO+qlV2liRqj3bR8UzeOENtbFQ
	 SqIycJXSJ/Aj+X1w2yR+LG/xCq4wAHU5BAT9au1NW98KggDzp+JxOiWjrui8U/WYx/rsg
	 NERjDjCghAbc6/wru3PZLTD+Fx95NdFq4ThJwlLkSBXh6jHxeFEyTdJ8uigE4Cj81FLgK
	 uDBr+tLEF/PFcIRVVuLjbWjyVIdI6EH2kFyxa4kUTfBshHaKylZD5X+O7x2pWYCISXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sY9gXDDt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF37606A337;
	Thu, 19 Nov 2026 03:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sY9gXDDt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D041F000C4;
	Thu, 19 Nov 2026 03:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057596;
	bh=ognP7ZhHkT76X9CVrk5nmV2LZoHU82yhXApVajfE+vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sY9gXDDtPPedAAInSh1wxmLQ2u1CgAGwQNSIrERZkt9TnLXoudnJXnLmnUziyFixW
	 nxRpSVoRHTSjU2BqpEv2my+3b1zW9t7qRPysNKydvalsL2j/+6FX6ESS9c0MEJRnQB
	 1NyCHsP9kNfQLEO1ghoSbnkKQhTzNrwjyaD0udZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Narsimhulu Musini <nmusini@cisco.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0187/1848] scsi: snic: Fix SCSI host leak on workqueue allocation failure
Date: Wed, 18 Nov 2026 15:37:05 +0100
Message-ID: <20261118145919.490892569@linuxfoundation.org>
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
index 14f4ce665e584..31df534b08c88 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -320,6 +320,7 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
 	if (!shost->work_q) {
 		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
 
+		scsi_remove_host(shost);
 		ret = -ENOMEM;
 	}
 
-- 
2.53.0




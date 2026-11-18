Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031552;
	b=Ip3vLHa5BHNluEK4vrbRUOu6DLJCO+5aZYRxJwGjxFI2u0X2Q7sjxW47SWKyp3CRROn9
	 leLZD0gyfeZOK8libvaeL4pshGBxsG9uzw5uhfGrjMaLn2Rb0o+/yymTFpKa1vKbS1dRT
	 dKXu87nvI4XxxpatVOVeeNfrK9XomyWrh6g2yRuBhtLPa+l/OqIdMaSmgAZm8K+FEEkvJ
	 dmBNfrurblcbDV9Tgg76rpcutfU9e9K9mRad+FZnBE7Uklx9WXYBZwGp+gWLMbRHdYl3r
	 pZDg4JOwUqqjn0inWpmE0wT/Pwto5QBdIJzKLVtjSlFiPVqF7InBgcFcgguJ9R4THcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ASsvJma+UsQlIX5da/g9tSKb/LM7XEuNWyxqMPcn8mU=;
	b=yld/WsSjVgsZW8xUJLx1Ob/tTHBkAyX6/CHGl7KMTW5XJanPwFTUBYZ3VdbXr98b5QYO
	 GgK8GA/2IHZO2nfgNZoSX8Av4/3GSid266WxQF1z197nS4KzDpFV00i9YD98GZhyORLdY
	 vH/Pv2dS8YvXhBxml9l+PAb6WL2Ai9gGBK8pkSQkmLxgGCe3ltepZ/XZRvJXkVMiBOv7d
	 KdwzYY15c4IkzGD5ePtW0ot6KOZ2IIus2esDn72SvAV5cv7a5WxEJimTWpdFTNHeRLEmn
	 zAEqo5UeQx7MKOQbB+bd3B7QTw7nIaSbrjRx512sr5Perz73Gsr7/alR41gwqrEmwWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfDg9ylJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FFC606A320;
	Wed, 18 Nov 2026 19:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfDg9ylJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D45F1F000C4;
	Wed, 18 Nov 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031551;
	bh=ASsvJma+UsQlIX5da/g9tSKb/LM7XEuNWyxqMPcn8mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfDg9ylJvbjdBymrBPvH8+/GoDiZtCsY7mDltAK5AoX3sHxeVL/6SIlBU9doY4X+N
	 rVpBvjGwx3k8vwlb4VscEbbZ591IMGMYJODl6hPTyN9m2p2F+AWU3077HpYziGcTBK
	 eByVm1oah2aM1T0knFimZtiWhqoOYan5Luy3k528=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1061/1756] ACPI: PCI: pci_link: clear driver_data before free
Date: Wed, 18 Nov 2026 15:53:08 +0100
Message-ID: <20261118150052.499655414@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 691c33289b4d7a50b6fe1e03918bfbc21d4641c5 ]

acpi_pci_link_remove() frees the link object without clearing the ACPI
device's driver_data pointer. The ACPI device survives hot-removal and
can later be retrieved by acpi_fetch_acpi_dev(), leaving callers with a
dangling pointer.

Clear driver_data before freeing the link.

Fixes: db89b4f0dbab ("ACPI: catch calls of acpi_driver_data on pointer of wrong type")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260925155846.2381956-1-yaojiale02@163.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index ce022799e1b33..51e8d23df8cc3 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -780,6 +780,7 @@ static void acpi_pci_link_remove(struct acpi_device *device)
 	list_del(&link->list);
 	mutex_unlock(&acpi_link_lock);
 
+	device->driver_data = NULL;
 	kfree(link);
 }
 
-- 
2.53.0




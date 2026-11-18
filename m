Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061465;
	b=wyIYv03ePEjx4j63nLjRb4DVAaHFXiKl8fJnFZJur/dT+RnbZo/M45ZcUTQz3L7Oo4MJ
	 bc2dY3aTuls4HlBKmVR3jjTcXfQYgj/cxP6zgxdhms7r9+pnBInHec4hyqNqIMGePZEf8
	 VsvpFDzRKJS9rBHwoZYw8AXRZpzmFMwTJgD4ZWNONCORzUYol1Lm07C6Hbl4mdnuLxR2S
	 1XlALY0Qjo0ovKHI3uiaGpfbqfkzEQvteLU8w2OLRU8V8tAOsNI7vrXsqTEhPeJt3qA6h
	 7vzMD0QwZgKLJj81Qw5Hn71ADKlLDfKESDWS6cNDNfCEV3zHRWNzsUOaZ88spNLiJhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0zJTbJWt7gwFEUob6G9I84SW42a64VGxQ0OSbbW7jqo=;
	b=ewaZvGiPrs8cDx11a6PrAr59eS/tLm5/H1vRbqme3smhP8eiiBUxhaKZfcpsEYsNlvA7
	 KyPoEDGJqlLx71IXS7HY+Ee+/M410JENZuKY4JXyhZ5wBrMKDGyBUPMh7G3ciOP5m0zcz
	 xuT/2bggG7EjSYpejVIMuscUeQ3/I4s+Q4G3aGCFbYbjWEEvNjK0lLU/l8iH35RjxaxRQ
	 zR36N418ezmvrEmusRI+eoAkPzQkU6LxxX76XQa7UGfpybD+G4plTUlb9mhQmhlQZT9o7
	 LRykqs17GVpLyo68sbjoQbNnwGVs7XhjmUYPWguQclNMN1jKZ9Hf8d/In9hhcs5xo+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLSpX3Ht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22D8606A330;
	Thu, 19 Nov 2026 04:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLSpX3Ht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431661F000C4;
	Thu, 19 Nov 2026 04:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061464;
	bh=0zJTbJWt7gwFEUob6G9I84SW42a64VGxQ0OSbbW7jqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLSpX3HtF4Z9AHLka1kgXyxglzjJFNnV9yqeR1TcfbnO8rTu86GAf2cHnlln3QYiy
	 WjcBp2rirSihxqg+NAha6uGiC4PodOL66xn2A3SkQorPS1MeM20D/WYG+94KNDmKQL
	 hOduvbPx+P8nJu6MF1rKeKSccuVGlFegFJKhm6V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1563/1848] ACPI: PCI: pci_link: clear driver_data before free
Date: Wed, 18 Nov 2026 16:00:01 +0100
Message-ID: <20261118150025.028757150@linuxfoundation.org>
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
index fb4c5632a232b..71e4e4175b859 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -802,6 +802,7 @@ static void acpi_pci_link_remove(struct acpi_device *device)
 	list_del(&link->list);
 	mutex_unlock(&acpi_link_lock);
 
+	device->driver_data = NULL;
 	kfree(link);
 }
 
-- 
2.53.0




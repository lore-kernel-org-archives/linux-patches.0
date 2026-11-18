Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056040;
	b=yuWGWVA3CIzTPcx9iJLuh+9/5sQt6uQpNgCpN0JvPZXDotTKvEmDMn0EK28xhuB6SGS2
	 nCsE4VnAqTJCEwAgxAs28D0SS14ginN6J0/jTdIeFCzhULAHunjsZry3vM67ZOLRohxzr
	 RO7kHuomvUJN9aDoupGYk4uBZvVnkP+HraND2igqthuYed74FTHTcIN4hdktRe8zPdqV5
	 xpA+V4HGZCh2At4aYRchFP5Qd8L0U1ecWRdkiS7mWjGS0rL7n1INfTqvmnawkGlMvesMd
	 b/VzUYOgWju4gfelPIzwI9mq6nzKSou4W5r/XRLc2V1aicI62nc7XAS8r1gxQb9KI6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4naayZUxfqDMIAJ85UobQ2rFy9/hHybTaMJTD5b9TaM=;
	b=RCAyl/OWbMAdKgv9dKnqW/4eJp80t+EPiHqxXpj9ByvHOL9qz4c7q8dLtOpZujipdEgP
	 RhBwP6ffFkdFvhicySSaGjf5yWUiVgQkACYnM13bIzI55vTcPMpVhLb88iA07ZFGitM4X
	 T9Wb+ACxpm2xL5NARLbs6GvOiIdyNGNam/oR1x4SBpQX8K5/2AsPo04xgNa9EmC0i3VWj
	 mFhvG4rjuihBq5mECyFPY0BT5HwgLgWobkI8UJJ+pg6URVdAAOduafuELjFBcEkm/lT32
	 o4tL06ZeFEp1ztODqmjr3zX2p417qI9jdtVVTYC6i7ae8mrZ4rVU/2kDesHTS44nEJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7b8xfBR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95466606A31C;
	Thu, 19 Nov 2026 02:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7b8xfBR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1291F000C4;
	Thu, 19 Nov 2026 02:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056040;
	bh=4naayZUxfqDMIAJ85UobQ2rFy9/hHybTaMJTD5b9TaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7b8xfBRhwQUBwKzAp5VHy4UZodRDPwnqD68UTg82PjK1ZKEYe0qj4+jv3LmhXkbO
	 RQ6Bnec1myk1A5TCXBqITA1mZPv18EELLAeu47J0+j1m6J9H5pBWN7e7dfnJ+MxDA3
	 R6g44HH1MDM55GnjYgjh7DyX6eZCLgTz6w3pPsvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1845/2214] ACPI: PCI: pci_link: clear driver_data before free
Date: Wed, 18 Nov 2026 15:58:41 +0100
Message-ID: <20261118150125.215815225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cb7b900d9466c..068034ccc4445 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -782,6 +782,7 @@ static void acpi_pci_link_remove(struct acpi_device *device)
 	list_del(&link->list);
 	mutex_unlock(&acpi_link_lock);
 
+	device->driver_data = NULL;
 	kfree(link);
 }
 
-- 
2.53.0




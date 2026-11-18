Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026169;
	b=ejnmdkoVyt8q+uH8MnauzwzGdsF0dFG1xhRdGpIl3KSraCifRF6KPOvEf9/a9Hb3thyW
	 Ff8A6R7K5Wmrtd8bc27wTtZVHotcLmSxVOlTWLK/kLUoyNC++ZPZnvOA5qX9Zy3zjJBed
	 KAUSllHBHHJJBRkBeEyoP1L5DlrBSDjWb6b6Yd8PRP0rwaPQA03PXeiuXZmjwP4dOXAxO
	 WtgGXmwiWLztx+sLboAcPZrjpRVwGF8GME+CGds4UYASYpFLRPD/Pv5qIqkldsae4Ngz/
	 3/Hu06IrOnwn2Xrn3LGH6qKUVGV1+NR3HYLhWZiilpTX+MIHocJBOSkyXR69vH2aMVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C0hsIQMM4+fqy54Vu2pQ3H4A96RXVq98Ahn9kTLI+zg=;
	b=inPOn7iJGOlgSDzWA+jPR0wpSLPu3FVcFDItMdoxeFOA4ofmFft7kBuLNhLqXOMIRqFW
	 NvfyTcVIUIryEmw6SlYbvQXZ2MqbrQOkgoA3Pd6xthoGejS7vc7wgqps4FN63B6bANekZ
	 TmOPCSjDUWPx1qP65JKHVIEiBtF6LHAMRXi0jEI8zJOsBhZgU9H3BhhfxV9aD52hYQzqF
	 JzHtWWx0aWYIhr7EDTlmUyHTMqss/Lc2oxsgv3/164cw9iNRGp1jC5koPfpV3uSPsFDFa
	 I5CsOCsg8x3rt+56PSgXwLWlBTWQ1WcanlLV+bqv0bBhwRHEATIfLV/PjhvjvwpMsTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzqlQ2zU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E0F606A325;
	Wed, 18 Nov 2026 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzqlQ2zU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990241F000CA;
	Wed, 18 Nov 2026 18:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026169;
	bh=C0hsIQMM4+fqy54Vu2pQ3H4A96RXVq98Ahn9kTLI+zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzqlQ2zUo8wQKQxt1qmit971rAIrut4jCWNjYBRJI6fGDXVRNzHNe/BnE2a8T1Ek+
	 SJAqwUlZ5qCdsPsLhBWgoX6tk+FxJ/B5gi7TxZmtX493hirL5OHThQEQhzCdpyHME0
	 fmftIZ4EMUbPfzLLLEsE5TiH1HmF8gif8YUM9N5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1340/2151] ACPI: PCI: pci_link: clear driver_data before free
Date: Wed, 18 Nov 2026 15:51:15 +0100
Message-ID: <20261118150210.867339517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index bed7dc85612e3..303a1ba83bf2e 100644
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




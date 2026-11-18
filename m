Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019550;
	b=WxDUET9ANRwBQcEKi/yrLSqosouil+sa0XLb3U/ssMCEfSJrYu0UPuxd+giuIib5Gh6L
	 ZUvhOd7G+2zVSjY3XbnVSWt/y7U/bJ/pZbmn+u7IekGSXWeh4w1L189iICXHwB/UB3v1U
	 4TjjlERU8y+iBh8WolgKFxJKHoYOmrz24YRWzwg2tTAfur15su/5BF1tQrxTGO/vwsegx
	 bM+mw69CbLFiWbLa7L/9pfk82Mi6OWKy8dM5vYq7jYA2L7NTVSmrgQLQkaFx4fLKQc/2P
	 bCxvlBvIrLvAkYdQ0NVdEFxh6KloTGp6lrBvGCoKzpQi6sipKq94o5gaX4nQhPyLtSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kvcxEKoDGcYIR1Ty/uDL45ezMQlcYaRKfQp79N9WnWo=;
	b=ZSkzOwHJorhXg9UIFgcDfwh/CA+8nXJl2ANROtnJ6qUYbeTtWgSSOb+3b2q7URk5930i
	 DLX1gyV6FFWXcg495PT9imnlNVUXGCKzuOG5OSu3zKLe3+WjKjGc7XKVsihjVCgk7GrnQ
	 qYULT9ypS8gSz/JQ5TD5hzF/udY32wX9b+OguVOl56fDQmu/ooqKU6B66GY5EUgLJ80uZ
	 6Zk/WzUvffHbEadlWf//2si2NOaiFo4SmuxwFW61RuyN+aBsaTf/TRlfjFCuPK/J7ytmk
	 Jjx78tU9SXAMedOCQfskV1VE2IYtzcBAZMoQJ9dQWOYJ/hUunQkuAVrsKzsERxn8UtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mUDExV0/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB75606A7D1;
	Wed, 18 Nov 2026 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUDExV0/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FACF1F000CB;
	Wed, 18 Nov 2026 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019550;
	bh=kvcxEKoDGcYIR1Ty/uDL45ezMQlcYaRKfQp79N9WnWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUDExV0/WqG3ap84vYkWort6diqzyLGbB+jwz4og3iWeR+fZXaY1r5R/3pHbwO+ut
	 7ZG9240OxJ2HMV2vwavgQTAxzHkx7XCC0kvuEDFIcUH19Qx0+Hikhp9xhuqzTJBkBs
	 ZLLr2nU/jLznvycY28AJT3j8qbTs1a+m1VPTHMbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1636/2651] ACPI: PCI: pci_link: clear driver_data before free
Date: Wed, 18 Nov 2026 15:47:56 +0100
Message-ID: <20261118150346.734758691@linuxfoundation.org>
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
index e6ed13aee48d0..84bfcdf242ddc 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -787,6 +787,7 @@ static void acpi_pci_link_remove(struct acpi_device *device)
 	list_del(&link->list);
 	mutex_unlock(&acpi_link_lock);
 
+	device->driver_data = NULL;
 	kfree(link);
 }
 
-- 
2.53.0




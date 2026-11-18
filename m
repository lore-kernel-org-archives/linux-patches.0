Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015820;
	b=xNLG8OcI3GxP/s4kLvyEpJUTI4yIepQk9xBbGhZswoO7k/g/0ei3A76A3JDaych64vpq
	 9g0ZomGT+3HoxsUXG/byYyUBvIcXXwAHHiTHn47Lhhx5KhHwZhGSuZrAAka8tLsj7sjYe
	 1HWqum5mfkkK22sPIOeE/G8DSXvF43vov/h9ZPWr7gZNHYGXJnmlmwy2SZP4XFY3H2MXD
	 W3JgRR7jeQYFP48v1AtmgPWzR81TGv0Dqoh10gjMAXyE5bK6UmN5aIMRyj3QiLuXtJ6G0
	 9FH5Vynxg+d/CxUVqy5EVEojQ18kdjH/nhSqPPmCzzWcw3SF4ssZ/PnJX6ptYvbV1Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9av/pclYVWZGBk8omezJgIv6h1BD34mtBnG98yzoH60=;
	b=B+EzwJIkhDPAiVP3PxSqYWqKHsYf0ZHs7Ayxsbc3aeQ88f4iGId9kgNjrlweI446ptF/
	 d8d6nqHZQJpP7wbHdCD40NuKylZm2e1lcHF2sFa6kJzpXQsaUQKvyDrHeb0HJ59mpnT10
	 MgijWtZ1Fml7Zvux+P2zctxEBV3xMWmpRB32X7KGg2+iWDZS/ihmsfWZyF+PYz5FM5IAw
	 +TDTOCetxRt6QkINb6fuf0R4w+wDddh5ZFilbZrf4bziF8OgFsb0AqV8ypunEA/0fMtPi
	 KfAZBZ5QrAwr5d9SJE9pvrHTatk3NZPfS65LT2GtMqrUhSqSAn6Lv2XH/7UZa4/N8nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tjjE5F/t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113DA606A32C;
	Wed, 18 Nov 2026 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tjjE5F/t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620F51F000C4;
	Wed, 18 Nov 2026 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015819;
	bh=9av/pclYVWZGBk8omezJgIv6h1BD34mtBnG98yzoH60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjjE5F/tNLDPANPRvISQyj1qP++Vn+i14JHnn3SrKYhlC7eEh85XGp+yurAwqSXHz
	 YL+fUli26AO/gTpv8Pm/nG3FYsv/s9Z8lAPFtQreVJ4aEGVAv8INMd4lYDO6UI8DTb
	 IVZxYo8kgBsH/ZNLG4RF6Y2fc6Y4ATxsSdiCh4fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0310/2651] ACPI: glue: Rework the success message in acpi_device_notify()
Date: Wed, 18 Nov 2026 15:25:50 +0100
Message-ID: <20261118150259.050519343@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit aef7792cddcac7ab400912c2947a595401d4a7e8 ]

Using an ACPI handle in the acpi_device_notify() success message is
somewhat misleading because the "physical" device is not bound to an
ACPI namespace object in that function, but to an ACPI device object
attached to it.  Moreover, the message is outright confusing for the
"physical" devices bound to ACPI devices without ACPI namespace
objects (for example, fixed event buttons).

Address this by turning that message into a dev_dbg() one printed for
the "physical" device and mentioning the name of the ACPI companion.

Fixes: ab06eb920401 ("ACPI: scan: Register platform devices for fixed event buttons")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/2448150.ElGaqSPkdT@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index a2a394c226b3f..a47cccc4efd3f 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -394,8 +394,7 @@ void acpi_device_notify(struct device *dev)
 		adev->handler->bind(dev);
 
 done:
-	acpi_handle_debug(ACPI_HANDLE(dev), "Bound to device %s\n",
-			  dev_name(dev));
+	dev_dbg(dev, "Bound to ACPI device %s\n", acpi_dev_name(adev));
 }
 
 void acpi_device_notify_remove(struct device *dev)
-- 
2.53.0




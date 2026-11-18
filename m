Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023281;
	b=BLvB/l2CyILUBFRLeoVakwF0IJLFZXuKxkBvvT7gcEF5g3XGQz9pzfyOuSahlL8ja5R1
	 25kr4kLJQaWmnq/VKT1WxZht0m8dtZ0NQIyOM7u8ZWsfxET+u6K3XO+gbHz6xeTWxDfhT
	 5Hb1JmxuNcZj6QDV+0vABe4YfhP2eEzFm7bBDMSENhvG3u2Q7xhqFTIr/5z/07BOy7XaF
	 7oqXf6JFZ0j6Y100Q0loJat+y7AtjCVMM+At6sUyxIOMHkTXjQo203FcTUAKUS24p5ERz
	 TbNRCOPB9ohdpevVoGSXuJQ9zjTJfme5sj/4XX0qHtAkZm07pjdaRhQq5dbk3xiXWiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RxoOcPrID4vANWumBWqZrZdQmIwO9Ujpskiyy+FSrko=;
	b=LuYekyxbAWDO3o9jPThqszcwDx9Y6vBgfeQqM57bbtTU2vXSXXpCRT5kpQqVW3PqjA9B
	 yW3xPtsFxiGmmk9CFvTdBlveVFS9Tdrgy5dL87XrEuFmbfIlF+zrsUFb6H3LNDj5QUi6/
	 uz3o1v1xW2xJ2jJ07PwVcb/T5DmXdwsHvKrozKxBhceh8r5QSNGzBOmZ41QBlShbuACYA
	 ix40/lbCfaxlYcSpIBck9IooGeEMf7anvCbInoanVcqIjrb8A+lBsA+I/faafrV1gZ0MU
	 bSExkzCw2cwAiONfOebbMIETfMZ9e4+O5cfm/Bi+c7lJL6X7GpFNlzGF9CPp5sehSaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sn4fKPfj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0BA606A31C;
	Wed, 18 Nov 2026 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sn4fKPfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77771F000C4;
	Wed, 18 Nov 2026 17:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023281;
	bh=RxoOcPrID4vANWumBWqZrZdQmIwO9Ujpskiyy+FSrko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sn4fKPfjFoBNoxie/wmJbfCTEnG5kE6wdrLZFiN7P92C2LpkmboBCl423e5E/lumx
	 uibRh6CGy/S86sqM9FLlFuxZUGLSNdgd755wPLSRzhuJKIS7cU6Mn31mmd9GgLPyhm
	 NFHyAYek7XZgi1BGTI/sDdEaJjwHAWcmVwyc/0LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0313/2151] ACPI: glue: Rework the success message in acpi_device_notify()
Date: Wed, 18 Nov 2026 15:34:08 +0100
Message-ID: <20261118150133.353437236@linuxfoundation.org>
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
index 2a782ba508f7b..6c81ac1ff28e5 100644
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




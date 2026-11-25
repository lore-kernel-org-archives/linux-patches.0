Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625086;
	b=hy6Igx0oXWC+i5m5cw6uddGHN6Dv5f7Rq4GzKPY3O25/4eY/47b12XR07eKo3taL9QxJ
	 TpE09XRjHx8Z/YxvQa9okqIIaTazQ1lln33wlG4vBK3Dovk4u5Kel2U2t6TJkSd81KRuy
	 /LKV8tANx31DSmG2izqckjNaYxFn+RuuYKqtjmDDvQ2IRlC7nVEYh/p0z0ey7h+HzVDMy
	 enHXQTD3hSpx2VtYUXCLpDVQQjACP+5wN7e2ROQUt8SaxigimAIZm1jMmnYsDV1/zvF4I
	 yJU7pRma311At/s5eRkZQY42bj/FQUC2srFkbpf9h+k1Lyn4tuRMgf8FI0ZHgluU4Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FaNC4eEwMTq0E6NFdkXHTusT1x6p/UVU6Swx3r8aig4=;
	b=atZZjOvmCOl+vinc/wc98bnlp0HBJHJUnkzqsicHpomDAaa3VA/TPlH/eEFOkuFZsIK+
	 eFymPqKyYUcfm9xvnVWVd79MzG4m9deVDFTXaHGy25O/wVYHuzaXstq6M50e3T98e/MHg
	 zKH5aXPt3z1JKacCFsGYOerJFK55flWAmsMzI/USZOI8ex6Lc6Bxz2P+mnHCx9OiHX97y
	 gURC79dJWLDsCWu7Di8zdzSqkIB46+B5VmYMniz117PRCG1x3sjtInL1wstW0AcbLQ/GP
	 xCWTI5YgPqhNHzwXSd0fa5dZzjAK5QwLvK/iUtUYVu7jktix75SkOPZw0Yw3DURVYYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMZaVEjh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E6D606A327;
	Wed, 25 Nov 2026 16:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMZaVEjh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCAE1F000D4;
	Wed, 25 Nov 2026 16:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625085;
	bh=FaNC4eEwMTq0E6NFdkXHTusT1x6p/UVU6Swx3r8aig4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMZaVEjh4lGqZVMphSHo9Lc3gBRrwWe0zUKTOBmsYWTMoYbxfUrAPQ6462nTpNVHr
	 KZd8u3oWZkgsQrho7oMCGTRXM/cdqsnHyJ4vo8O3x1Xd8EcIgLRiIUfQcPKJRJt8lU
	 V9TYTlgDvlmWb1z8p0sWOYpuBItuaqptV3QaJGG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/816] ACPI: glue: Rework the success message in acpi_device_notify()
Date: Wed, 25 Nov 2026 15:32:29 +0100
Message-ID: <20261125143858.480560540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Stable-dep-of: c94619c8a5b5 ("ACPI: glue: Carry out companion lookup under bus_type_sem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 54cc709be3166..c01ebf20a9318 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -396,8 +396,7 @@ void acpi_device_notify(struct device *dev)
 		adev->handler->bind(dev);
 
 done:
-	acpi_handle_debug(ACPI_HANDLE(dev), "Bound to device %s\n",
-			  dev_name(dev));
+	dev_dbg(dev, "Bound to ACPI device %s\n", acpi_dev_name(adev));
 }
 
 void acpi_device_notify_remove(struct device *dev)
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020408;
	b=pHI9YlKhYn7HQg5NZ9rrQeX9UBe78q7xErjmpuFUfmCM1K7gOYPLUuEQk0YdB2n9sy1D
	 D95/o1rSq7PK4Nq16GiEQ30UgKElVLb8PcBjsRcla4mwZgRew9+m+/vsmNe2+4ViD76yp
	 sP9pgGF9oXm42Qufy35NJvk2oX20j6Hs26MvY2O02kQiVVnapScrp4aWlY87Vmm3VAN3X
	 JEoLEXI0o1+XV1ghSFTCpEdKEctAPEIF28B9GWf0WsfIAwKx5b/jTY3Vkuzv3y+mcLkye
	 UaN9BUm8FNsyx7VzXkrWEN1vU3rTEZiz0xO40DuYnhgt2jxMJs8o2xblj6T8eg+mgwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Tt7ATPUlkL5H4E5ZTBAg9GcwEoA2sn7rMA1kW+tjmM=;
	b=oAMeKfJv4zn3MYUOo38vp51zZ+H9xszNSewy5IZ0XPJslVaj0Jf1mUv+L/z7pJsROOLl
	 aX01kqrUo+p7UMBK/UtjDIYzItAnD7ZnF6xbIFAmnB/aYH9FC558tSGG1bMSRnzJi/gbJ
	 4B0PrlvHksRT7A6H5Wmf6i6qT5IwOwNzWdcYob1k58SuAMYfNHY9Zs42H6/8R+UtoJVPj
	 YWmRWLOfy+hGOWwj/TUkte6CqbRyM7GBjfIIibi9jQmCM7jVQlk13Znm9aAriYjjBZQxN
	 DDGA7+cDGesObPb9JqX3Gu9rZUaFLi1imohzL/0feXDnvnQBjSymn+Zo0SyBQpI3c+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeR0N685;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AE2606A335;
	Wed, 18 Nov 2026 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeR0N685
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435A71F000C4;
	Wed, 18 Nov 2026 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020407;
	bh=1Tt7ATPUlkL5H4E5ZTBAg9GcwEoA2sn7rMA1kW+tjmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeR0N6854Y0Sjz4lWLmBknMfZOJT18zM5gcxcb4VFNF5cxryg/vaUoLPYgE2E7ACE
	 ZIl4tgjKqUU72EKJqk6JVVMrp/KXFlikZjEGca8+TM63TRGxhCUScgBrZocvUKP1K9
	 PKYJTHYdo2ZrVRlpEVuiKpXX77GeME0XeiVoLcz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1941/2651] irqchip/qcom-pdc: Fix linking against QCOM_SCM firmware
Date: Wed, 18 Nov 2026 15:53:01 +0100
Message-ID: <20261118150356.500613402@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8e6b8708f925b015e2af4d77757c2fbee7da6ec8 ]

Build testing with SCM disabled or in a loadable module fails
with a link error:

s390-linux-ld: drivers/irqchip/qcom-pdc.o: in function `qcom_pdc_probe':
qcom-pdc.c:(.text+0x18b8): undefined reference to `qcom_scm_is_available'
qcom-pdc.c:(.text+0x18ce): undefined reference to `qcom_scm_io_writel'

As QCOM_SCM can already be enabled for compile testing on non-qualcomm
machines, but is always enabled on Qualcomm Arm kernels, use that
as the Kconfig dependency and remove the ||COMPILE_TEST check.

Fixes: 1b852de05f74 ("irqchip/qcom: Enable compile testing for QCOM_PDC and QCOM_MPM")
Fixes: ad01c2b2f291 ("irqchip/qcom-pdc: Configure PDC to pass through mode")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915195948.3521662-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 5a881ddfa3abe..01f8415f62fc7 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -522,7 +522,7 @@ config GOLDFISH_PIC
 
 config QCOM_PDC
 	tristate "Qualcomm PDC"
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on QCOM_SCM
 	select IRQ_DOMAIN_HIERARCHY
 	help
 	  Power Domain Controller driver to manage and configure wakeup
-- 
2.53.0




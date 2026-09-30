Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601C3348C6B;
	Wed, 30 Sep 2026 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794124; cv=none; b=lE6b5QN0mNxWqb0SgJcpPSNlsTQG/3EEyJ0Aq8TGsvJyQqrOdlf6CbTBn4BlpvPf7cM3Njo81GdN7SW8t5BY9pfyVcsktC6J24yIIl247GxwR0r9ux+KoyFYZUp+XOwKUqh059CrlYArM7qtUqoRv7Xlr3jfYOJq1O7IkDRc624=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794124; c=relaxed/simple;
	bh=eEE5RamXB+3o4+x8V8z5tdsYFu/Pc3+BiE0JYdikmOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ8frt/8uJkZbTEVvqKlRCtECYv0zQkgpHcCQGPuPQZ3Z1c65f6nPhCTWWhF2/T2zIvELYO0W0n47eU7oo5YIU1WEnfQCCuyVCS7420Ekjs1ipG7ni7PlFVMUPBkLQO8kVG+U2CqL+3PI7QAmuAVbMSNlSxj+NXo4r6A9VOkyWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0AbIF7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0AbIF7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6421F000FF;
	Wed, 30 Sep 2026 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794123;
	bh=aXtbPg6ghb7gTNldLETx54hpXS+tdrTFbA7MuG8HGBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0AbIF7myMzo87gNQmjhs9vM6RGrk1NS/mgKXJmxlnwwDcpO2V33MQFw21A2Ajzc8
	 MsbeGFlo6ZfOEPAtSGJ8YpRGZJJoTu/QucDPULvtBCVPSGb4se0Re4JcZZ1mhWezlV
	 vZL3OZ9Qie2rjA6LZqExPhR6lOsLOn0TMLkXZvq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0098/1193] usb: host: add ARCH_AIROHA in XHCI MTK dependency
Date: Wed, 30 Sep 2026 17:13:02 +0200
Message-ID: <20260930152436.413678131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit ffeaf31f05d664581aa436d9cb92b4d1d8d301ce ]

Airoha SoC use the same register map and logic of the Mediatek xHCI
driver, hence add it to the dependency list to permit compilation also
on this ARCH.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20260519164903.31258-1-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 4448d0ab06f0d..844377f0688e7 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -71,7 +71,7 @@ config USB_XHCI_HISTB
 config USB_XHCI_MTK
 	tristate "xHCI support for MediaTek SoCs"
 	select MFD_SYSCON
-	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || COMPILE_TEST
+	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || ARCH_AIROHA || COMPILE_TEST
 	help
 	  Say 'Y' to enable the support for the xHCI host controller
 	  found in MediaTek SoCs.
-- 
2.53.0




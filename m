Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D485383D8;
	Wed, 30 Sep 2026 17:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790754; cv=none; b=imLg/rbNVWm5fhHZ9w1FANtOf5d/SqI6yzSgg3klsiAejnQ6o4EKiVOJybWwtySj5Ud7dzxtDl5k7dS/yipkErBmlHWw6XhenJw5zCwO6V8GfGrysl94tFStRXjwoAUUohxVHm9U01guO3MRiKjrPfEKMAOwxgoZqasNrvhLz40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790754; c=relaxed/simple;
	bh=vA7CP54DYMlyyob6OyFPFJRCLRszZq4IGtPx5wfpzZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkEjXH/H9lw9O25rieakuS7Qh0ZFXwn8F2NQAdk1gMbs27qR8lfwoYZSWWu/SQ5Yjy4CsqgQGkuiHX82+5diCiHTPJpv0sNjh3yux0O2wGLd9JT4poBPLAkXfB1lzU4rS/f+q8pxODEP3xL7UOEjDrAABrKVpPQ6awJKKplfZWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdML/7qH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdML/7qH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008871F000FF;
	Wed, 30 Sep 2026 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790753;
	bh=qZQPuhL1M/lvfx9xVEyrh8aElDEBpXHlgOh1NjCriGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdML/7qHTIJVDxfGMNWjRjdEq3WqCrvA+ZMVWxjqQLwPgjCwQKWiZkdHAjFVsE9t6
	 6dS+cho8PW7avMvOOhMHqOY0FSQlzM7X//GjgN2hkFZZ3Zr+te4WqAKS6zKCihIBfT
	 XFX9vuClWACYz96lh0YviwpRcel/8DVG27Cg4cYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/752] usb: host: add ARCH_AIROHA in XHCI MTK dependency
Date: Wed, 30 Sep 2026 17:18:51 +0200
Message-ID: <20260930152359.478571924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c4736d1d020c5..24bb90f5a4f23 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -72,7 +72,7 @@ config USB_XHCI_HISTB
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




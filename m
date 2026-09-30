Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B28350AC15;
	Wed, 30 Sep 2026 15:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782472; cv=none; b=VBQkqW7qL94dGdT9dGGVtaXVRAEv1SJxtH2H6cNMDyf9RQ0UXsL+LkiLxtADzMwNhpepd5LCAh1UjblWatmU7v/IKSYnW0U+pwol23Hb80xMVn42r/kl4cAe7TWYQFcN8Q2KoOoa0Ev3Ar+qywAVa1uxMZWldtvE80hqAfQV9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782472; c=relaxed/simple;
	bh=3AJYTAM4Kg+PrIoaukHVahs480/0iwZNaanIRpYCJmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7VijLNaTYEAj10fsRWq0MYZxgBv660uMw0BYhyOMUKh38qKqnlF+n9vbbmSIFe6hbCrewP/jIySmeeQs+AKm7yMDTOTybiwRRiN04lJMEvF0CzKL4XiP2Q7Z0GcruwEBi6lIX5N/YP8tB1BIS67cLirBgTfqwiIRatwBiu4F4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXEwFZCT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXEwFZCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925E41F00899;
	Wed, 30 Sep 2026 15:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782462;
	bh=zhSQgHawaIKKX7ynXaAh07ncyDuGoAxytNGUwlZSzAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXEwFZCTOUhdpLUzh1+2PY7ZXU3s7+wbPyrbad8y19cSplhSa8msWajjBQCadoC1/
	 Nv0yXzg4zUU2fzz6xhghWBknnSXrlIWP4a25emqns9K3vrMNii9iXT6B3EHTyD6Rlb
	 T4v3yRsHBVS8BUj4jxiyYaW/myf26k6CHYCWfOL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/595] usb: host: add ARCH_AIROHA in XHCI MTK dependency
Date: Wed, 30 Sep 2026 17:19:07 +0200
Message-ID: <20260930152348.892690833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ab12c4bf0ef1f..d9bce38d42765 100644
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




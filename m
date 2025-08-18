Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F11322DDB;
	Mon, 18 Aug 2025 13:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522980; cv=none; b=Y933ZzQtX8CXy616x/69HO00l2gNJL76Z1+55NKkJPLyZLhL0hgZxOpAoLiBosHUTngPI9hfA0UdDgUdfdaGaASBOTnpH7vSziYalh0IUIQU5RYWUQYsmsMp2x2d4wAVwwlHNJbSXDZc1+zu+zO+o/86J4qzT415igmA+p2dyKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522980; c=relaxed/simple;
	bh=DAirSdcau4lMLnM2MjJueO5sFC9K3kP4U1F7FXlxKrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlI2FMaKc/4Z2J6w75tJnxY6KjsDT0vbPbn5Tj3rQCwdur7aDWXyFQt2jJrm0phgDhGXSo7PKMslHI2FSDA4jiUgvq0Z14pYdXmV26h71MXWqqrrU4UDKVCos1O0FiaAk9W19hrawDjM5U0ynOpH6Vudia5bS89twYPUCkIAnGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/gXOJMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/gXOJMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B8DC4CEEB;
	Mon, 18 Aug 2025 13:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522979;
	bh=DAirSdcau4lMLnM2MjJueO5sFC9K3kP4U1F7FXlxKrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/gXOJMgwc7sdEyLykkcmy2UnNFCM77CJ/TvkOp4j5bwdFRXC4+PoU72N0WyThzuv
	 VdSRZJznBOA5N2IzG73vePdsLUu2tTgAKBfE74+apLBmMmX86ed7gAp3EkGPmTEiS5
	 rmt55WgNU3rjoYRJKlF47ZuQ2vIqd2s3QMDNYX4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.15 033/515] PCI: Extend isolated function probing to LoongArch
Date: Mon, 18 Aug 2025 14:40:19 +0200
Message-ID: <20250818124459.726277733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit a02fd05661d73a8507dd70dd820e9b984490c545 upstream.

Like s390 and the jailhouse hypervisor, LoongArch's PCI architecture allows
passing isolated PCI functions to a guest OS instance. So it is possible
that there is a multi-function device without function 0 for the host or
guest.

Allow probing such functions by adding a IS_ENABLED(CONFIG_LOONGARCH) case
in the hypervisor_isolated_pci_functions() helper.

This is similar to commit 189c6c33ff42 ("PCI: Extend isolated function
probing to s390").

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250624062927.4037734-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hypervisor.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/hypervisor.h
+++ b/include/linux/hypervisor.h
@@ -37,6 +37,9 @@ static inline bool hypervisor_isolated_p
 	if (IS_ENABLED(CONFIG_S390))
 		return true;
 
+	if (IS_ENABLED(CONFIG_LOONGARCH))
+		return true;
+
 	return jailhouse_paravirt();
 }
 



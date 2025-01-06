Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BC586332;
	Mon,  6 Jan 2025 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179007; cv=none; b=Esy3XmSJbvEtLR1UYRp//sGnpXIXNjcqWnkMZUcPlJ8okQJ0YzCMgC2WSHq+mJNz5JIDyJLVpjk08a4Bgk/1RdYbWnAA8ErueVg+jFHsBlpwkpwbErhu8FDOJKQNLSPMLw2pszl5IDLLYIetdTN3e2eushqgX1CUQfEpBhCN8pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179007; c=relaxed/simple;
	bh=2sknJLy5kzibUkY8/O4+HuicBGVoQkOIfaQ+qNicZbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXOxwQmFnuGXM0dJdEL2R9Nd2OPlnyfwHv6jz8eRyuJ9IUVnsBYJRjGeZEJvq6BpulKgzcUPUllBXfYKA1kYiuksvZlHZWo79wK8r05xpEdRZvpKzblO/l7W6H6b1XIz8s2BMIaFusMlsM7D3iqujzgUJRToBdNUKVFFOx5tpzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/8vsLgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/8vsLgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F7EC4CED2;
	Mon,  6 Jan 2025 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179007;
	bh=2sknJLy5kzibUkY8/O4+HuicBGVoQkOIfaQ+qNicZbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/8vsLgCDTvbwkZDuLq7OZ0M3eo2ZwrKSMejsBFzgBxj4Tvu8Vyx4oIe6GyqKQFbG
	 IdHKijaT6pH1kBHjMMb4MPK9UaVismCnSRBFsqZc+jOXHjhAeIP32pJjnUHCWEvrRx
	 lMU5zmLxfHVkmGbjO6Trhs9OZkmkrxgX8/OVEd3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pascal Hambourg <pascal@plouf.fr.eu.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 164/168] sky2: Add device ID 11ab:4373 for Marvell 88E8075
Date: Mon,  6 Jan 2025 16:17:52 +0100
Message-ID: <20250106151144.622370973@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pascal Hambourg <pascal@plouf.fr.eu.org>

commit 03c8d0af2e409e15c16130b185e12b5efba0a6b9 upstream.

A Marvell 88E8075 ethernet controller has this device ID instead of
11ab:4370 and works fine with the sky2 driver.

Signed-off-by: Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/10165a62-99fb-4be6-8c64-84afd6234085@plouf.fr.eu.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/sky2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -130,6 +130,7 @@ static const struct pci_device_id sky2_i
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x436C) }, /* 88E8072 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x436D) }, /* 88E8055 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4370) }, /* 88E8075 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4373) }, /* 88E8075 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4380) }, /* 88E8057 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4381) }, /* 88E8059 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4382) }, /* 88E8079 */



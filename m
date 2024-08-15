Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10871E526;
	Thu, 15 Aug 2024 14:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731681; cv=none; b=RP61I9bUkHnmyAQDUkHkRFlKIhEILT5Wg2Pngj0jP/umWhxrfhPtNFdAIQU+E7YIhZjVZbTvvQYbSrzLnHY7YLdtVtVuS35wbOPfjh2tBUiaWXI+mDLslm4PXMUXOWFdX/pzO+KJlJ09rr0YHFVRal+PoZbOZzkrCBdb3z37CZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731681; c=relaxed/simple;
	bh=3MfDpYmACuqM+QWRX0LPPbEWDxVvshdPwegkcwL43JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+jf1ouJCQSXGhjIqqilCUKbLrxBMoDcG5yUdGateuPbNueDtTvmikbj4LojsoCxiTpmYsJA37ZzeBzqZtT5aAD+PK4EhYPqavckPC7UK8kXHEFWKiZvNszUriHj7Ok5bAphHKw6R/kbhg/qvs63AT/JQti6mIbkmCtTSm+F/0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjbZZb6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjbZZb6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D1DC32786;
	Thu, 15 Aug 2024 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731681;
	bh=3MfDpYmACuqM+QWRX0LPPbEWDxVvshdPwegkcwL43JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjbZZb6K7k7va8tLm275YG9nvPU4t865jGYyHxGyL7ZWnlERtGcl6RWsQBytDumgL
	 l3EIakib++iS1NQIflfaueZHpS5MTQ05fZN3Jl2TZiZJ1yxhJ/rMHy/dFlcH4KGbY7
	 oD03q/DmLeB6odmb7eOyv28z1XfEjNv9sNnNBnVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/259] PCI: Add Edimax Vendor ID to pci_ids.h
Date: Thu, 15 Aug 2024 15:25:30 +0200
Message-ID: <20240815131910.383686665@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

[ Upstream commit eee5528890d54b22b46f833002355a5ee94c3bb4 ]

Add the Edimax Vendor ID (0x1432) for an ethernet driver for Tehuti
Networks TN40xx chips. This ID can be used for Realtek 8180 and Ralink
rt28xx wireless drivers.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20240623235507.108147-2-fujita.tomonori@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d8b188643a875..bf8548fbdf558 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2136,6 +2136,8 @@
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
+#define PCI_VENDOR_ID_EDIMAX		0x1432
+
 #define PCI_VENDOR_ID_ADLINK		0x144a
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF35134AC;
	Mon, 12 Aug 2024 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480019; cv=none; b=LBNwz4hdXt23pmPKv0giA90c7l5kovajKfq6sJYoNKENwBngbnglpOF9++dBOUsctrMd/YlTLfDs8oynhwVGnIQ6zzN3xtWeVY0LEeF1x7u69sZ1j7OUKETfUd2vux5P1il2+mFC/ovJWXQWx6I8zRgRY8Eu9J6WSKF4PdDYsJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480019; c=relaxed/simple;
	bh=ss6ckAD6uIFR9MubE9TLCCUunO8NQ5DtfbNVynOHRNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csmHTICDaBAeFTl0rsto73SwKGjheD75j4qLZlleDWMmCzuZGnNVge3jDs1JCC8gmLB5f/wE4RRF8Zr9l7ejnKh6C11hxwlee/5+8JlttcmTxxi5ogx+VMmdR7o9jrGA0PRtTTgtW9SHid0dKQ3Wk6fTDYa8DHd+NX+XDaqTcq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSZ6LSU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSZ6LSU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EBBC32782;
	Mon, 12 Aug 2024 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480019;
	bh=ss6ckAD6uIFR9MubE9TLCCUunO8NQ5DtfbNVynOHRNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSZ6LSU6N3gQsz8hxtRhfMppKu8Ogz1JZ3w08DfEq1Z1oT972GHSBu0ZvPeIaEO7v
	 9YVPuh5/cyNgSyeetspHa6eolt6KMUbbh1DRmMYVpPA/SOBuQmQi23bM6EmE+OdMfa
	 Q2U+kG1NVbaTMhf2ye+mmho2AcWkt+H3O4f/460c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 071/263] PCI: Add Edimax Vendor ID to pci_ids.h
Date: Mon, 12 Aug 2024 18:01:12 +0200
Message-ID: <20240812160149.261019271@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 942a587bb97e3..677aea20d3e11 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2126,6 +2126,8 @@
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
+#define PCI_VENDOR_ID_EDIMAX		0x1432
+
 #define PCI_VENDOR_ID_ADLINK		0x144a
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
-- 
2.43.0




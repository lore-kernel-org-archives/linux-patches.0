Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BDB3A7E0B;
	Thu, 15 Jan 2026 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496080; cv=none; b=g6V8oNrfeUA3BhjL+iciSOTGcNnsO+L/F51zx99B47DYIfdbFt725gXgEGQnUGU/LNhZ+/pK4wB6sKXrWHGfOnwuoU+JhJbhNEOJDP4DKVd3famY0t2ayb+dQ5K7c057rYwFFF7GTSjSbO/yEJ6frHmBKLOaSFmbZXLE4PY70O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496080; c=relaxed/simple;
	bh=1uzZUrA7ixcq/5Gmw/xa4G/EL8y3ubtQvAReWzG0lIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHatRn2rlU3HkPyMTD0FNr5Vr3eXrFQoJp9o6iqL+BqeIe0QFFVyLZdy8xJBg6aQFsR7blV37mtGZy9f8RiBINeCJplYAPwOaTAfk5JN2SFToIbj7p/OiZlyVun/pntxhSfKgAue5fXai4oRo3x0N7SXF7Tk8TYPhgz/AuWkw00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dmg0bo42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dmg0bo42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA68C116D0;
	Thu, 15 Jan 2026 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496080;
	bh=1uzZUrA7ixcq/5Gmw/xa4G/EL8y3ubtQvAReWzG0lIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dmg0bo42aYeczHT6sw5M5gRWHL626uqRQymjogX06/552VoPZxfe5iICavO6nH4oQ
	 7l80sbmTGjnfnzwVN+Rmm9Jh9spfpQT8IjbIQ0ZQtddz0R7Gv2s3dqytXTnSkr881O
	 gbkiO8d8ffU3kYWiOBpfX6OPMkIEau0t2CHN2Uis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/181] arm64: dts: ti: k3-am642-phyboard-electra-peb-c-010: Fix icssg-prueth schema warning
Date: Thu, 15 Jan 2026 17:46:46 +0100
Message-ID: <20260115164204.816810921@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wadim Egorov <w.egorov@phytec.de>

[ Upstream commit 05bbe52d0be5637dcd3c880348e3688f7ec64eb7 ]

Reduce length of dma-names and dmas properties for icssg1-ethernet
node to comply with ti,icssg-prueth schema constraints. The previous
entries exceeded the allowed count and triggered dtschema warnings
during validation.

Fixes: e53fbf955ea7 ("arm64: dts: ti: k3-am642-phyboard-electra: Add PEB-C-010 Overlay")
Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20251127122733.2523367-1-w.egorov@phytec.de
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/ti/k3-am642-phyboard-electra-peb-c-010.dtso   | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-peb-c-010.dtso b/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-peb-c-010.dtso
index 7fc73cfacadb8..1176a52d560b7 100644
--- a/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-peb-c-010.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-peb-c-010.dtso
@@ -30,13 +30,10 @@
 				<&main_pktdma 0xc206 15>, /* egress slice 1 */
 				<&main_pktdma 0xc207 15>, /* egress slice 1 */
 				<&main_pktdma 0x4200 15>, /* ingress slice 0 */
-				<&main_pktdma 0x4201 15>, /* ingress slice 1 */
-				<&main_pktdma 0x4202 0>, /* mgmnt rsp slice 0 */
-				<&main_pktdma 0x4203 0>; /* mgmnt rsp slice 1 */
+				<&main_pktdma 0x4201 15>; /* ingress slice 1 */
 		dma-names = "tx0-0", "tx0-1", "tx0-2", "tx0-3",
 					"tx1-0", "tx1-1", "tx1-2", "tx1-3",
-					"rx0", "rx1",
-					"rxmgm0", "rxmgm1";
+					"rx0", "rx1";
 
 		firmware-name = "ti-pruss/am65x-sr2-pru0-prueth-fw.elf",
 				"ti-pruss/am65x-sr2-rtu0-prueth-fw.elf",
-- 
2.51.0




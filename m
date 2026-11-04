Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829538;
	b=iHXeFjZpE5p286GIC/GRieMG/UU/zunVPyjB9O/a4iU/QrwaWkxH9cK5oS7yCyqhm/m5
	 XRPqsCC6TrTNZ+EOhAkJwyaqhrckKLh8LZzWUHY297LtqSoE+4/2ihAFJexUvsDCxOgTW
	 N7xV/U5o0ClSbHkZacFF2zA19GfOyyxLmHlYIRJjSXMnBzq/2e22Ja/ibQxdOHed38ZFB
	 yh95ACQDzX/xbRreLobjVh0agz4X0hQmRs9FjytbeInlm7KqXGaSY38D0ogJcIDVWwWY1
	 oC1kySYnaHNqzdoj7aZn7V83DlDdjspREqs0M2IXl9EIf9efMNOa6/pao/D0lv3roVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0j9FoBCdoOO0kOzYmtVRPXi8CAl5knpeAHtogx49A10=;
	b=dio3D5HwX+8l9mJR4FsPJDaXwu9O/yvRynFnlsVxWGbF0SBcEBAEh3IfBPLy8Iqb1Jyk
	 vbsAniGfpBdkPlATvGyu6RhQv/hE8kpcK4mb8O+nRSnB46MSNtSJoh1AyNr2FcaQMcD3a
	 3axj7zTvP67yerDriSgD8ALdzDuEmES0sZmRjYigcA3ZNk1oWbbRo5IGTQ6Gov6sYuWl1
	 zuOHk7NOK2iMnZ7GAnik2zqRCMOzYB7OAe1oLYKwFOkCUE7SVMEe2fZOYQGLwb4tBa03a
	 UWHbfDRhAMxoIT5XQ6c98vOI5vNPNEtaFTCyisDK09wnGAB5B1ASEF/ITLA7o3O1YPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbgWwJrk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED86075254;
	Wed,  4 Nov 2026 21:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbgWwJrk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA79C1F00A20;
	Wed,  4 Nov 2026 21:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829538;
	bh=0j9FoBCdoOO0kOzYmtVRPXi8CAl5knpeAHtogx49A10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbgWwJrkiSyMhHpeQQAigGOU0EwQvOOBLtcqv3/7RtyBFg4h3E71v5MRnHNJpJoH4
	 pxI+EHA25oGJeoEqhrJAVwTGH0h+hIxzgyXje7WIJ0WikO700uxFBP0gTz3baTBCOm
	 FnYoO9NDjVH6+mE/e6wA7Lsgcba0afquQnKhAHoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andrea della Porta <andrea.porta@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0190/1005] misc: rp1: clear chained IRQ handlers on teardown
Date: Wed,  4 Nov 2026 15:58:43 -0500
Message-ID: <20261104211049.116221445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 82aa033fef523ab4f0165afbc1c1fb0dadb89f94 ]

rp1_probe() installs a chained handler for each parent MSI-X vector and
stores the rp1 device pointer as handler data. rp1_unregister_interrupts()
then disposes the child IRQ mappings, removes the IRQ domain, and frees
the PCI IRQ vectors without first removing those chained handlers.

If a teardown path runs after the handlers have been installed, a later
parent IRQ can still call rp1_chained_handle_irq() with stale handler
data and a removed IRQ domain. Clear the chained handlers before
disposing mappings and freeing the vectors.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andrea della Porta <andrea.porta@suse.com>
Link: https://patch.msgid.link/20260616151028.69890-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/rp1/rp1_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/rp1/rp1_pci.c b/drivers/misc/rp1/rp1_pci.c
index 4d00dab48d475..847feb2cbb681 100644
--- a/drivers/misc/rp1/rp1_pci.c
+++ b/drivers/misc/rp1/rp1_pci.c
@@ -171,6 +171,9 @@ static void rp1_unregister_interrupts(struct pci_dev *pdev)
 	struct rp1_dev *rp1 = pci_get_drvdata(pdev);
 	int irq, i;
 
+	for (i = 0; i < RP1_INT_END; i++)
+		irq_set_chained_handler_and_data(pci_irq_vector(pdev, i), NULL, NULL);
+
 	if (rp1->domain) {
 		for (i = 0; i < RP1_INT_END; i++) {
 			irq = irq_find_mapping(rp1->domain, i);
-- 
2.53.0




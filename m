Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831490;
	b=ucDZhBQ8MmQK9SKIcrlI0it2HoGnMYbRYuO9xRNT7ps3TvedCVMcbiRRXk7AS9FVEo4c
	 v6MxaNl/ocCZkK8xO/CZbkLf1FqpjY6dJa5tJRewDqBo9LAZDKPDPEQvjFe3mcCav1Uxo
	 F0n17lLC032jiCML8wWSH6Wq2Tia9kzkO/R/qUbXDQeQsqRzbzqxTI4oAAKJlIODtYmqi
	 jwIsBTmDxeWSkdje7BQ+Y3uW9asQsQ78F43Ti879eOvKYJ6S1MZqRC3GOcmbky62/HoYs
	 byRqF09p4qAsXMKxKcPXABxZkysmG23F5OBnVdwA1PIb4wlGgggyIbQoVJ2fUWgdUoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rqSrum3OjI3JFHuJ5SgNjd50FNslsEi/RhCCrORqnp0=;
	b=Sui6EWtVQ5ZYXM3cv7s7TKBkFP5zFxdNABDBozFCPeTaMzHfYMxgV/whUHMZ8hjQ5//D
	 wHhXIKbDbCqwEuSJ086P01O6V/FXqSbHLg5UKkb823llBC/2QwAK6JF/tSGD3SUYw7iWR
	 dK6Oatro5mZJyBYhPH/E0zvJnHR+mSDPvILuseshMd56ib3Me9HNEJexqVGyXFSuoVEGx
	 pqcTuT2WKLwe9mGXlLQE+mDiyCfNP4TRYLpxSb30jGiWNctnZDSQfc+RbcPHY4CrySMrx
	 WmsId6TitEoakNLIm+H525q/VE45KDqjzaNomyhANExFwk5npMsUgILR/KfYFAk37og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+oAgxNi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CF6606B3A5;
	Wed,  4 Nov 2026 22:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+oAgxNi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D4A1F000C1;
	Wed,  4 Nov 2026 22:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831489;
	bh=rqSrum3OjI3JFHuJ5SgNjd50FNslsEi/RhCCrORqnp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+oAgxNiiMfN8P/oGRAIbiR8wSvI/OrLVgECnNqb6Q1/T/IdrmQO/mfhHIugRFTOY
	 V8mbUuSsnQ8+R5qRr2VHUjipmstjkOcjoQt3CbshENvjQEDPVmLxul9a+TJNw9YjZ9
	 LOzJkAKFh/IuHjZGE2cWsq/TlqYOStp+m+MpXGJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 0735/1005] wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement
Date: Wed,  4 Nov 2026 16:07:48 -0500
Message-ID: <20261104211104.079217410@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 022f5f8b7a0580da50fcbc34da853d03d4321fe2 upstream.

mt7996_mac_add_twt_setup() links a new flow into dev->twt_list before
asking the MCU to add the agreement, but exits without unlinking the flow
if the request fails. The flow-ID and table masks are only committed
after MCU success, so the still-linked flow is invisible to the
mask-gated teardown paths.

If the station retries the setup, the same slot is cleared and its
embedded list node reinitialized while it is still linked, corrupting
dev->twt_list. If the station disassociates instead, teardown skips the
flow and station storage can be freed while the node remains linked. A
later scheduling or debugfs twt_stats walk can then dereference the
freed flow, resulting in a use-after-free.

Unlink the flow when the MCU rejects the agreement. This restores the
list to its pre-request state while leaving the unchanged mask and
agreement accounting untouched.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260729173632.14387-3-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260825112620.97568-1-enderaoelyther@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -3347,8 +3347,10 @@ void mt7996_mac_add_twt_setup(struct iee
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
 	if (mt7996_mcu_twt_agrt_update(dev, &msta->vif->deflink, flow,
-				       MCU_TWT_AGRT_ADD))
+				       MCU_TWT_AGRT_ADD)) {
+		list_del(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);



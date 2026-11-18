Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024556;
	b=XU9k4lgFXQoLKzs/b6GU8mhPL/lhOoI/lBqLagZg5g8jevz4yon1yJ911PQwrtlUU7t+
	 dKl0m/bBS3Joo94Qdn/TIZX0J10S12pdCAjwFot9zwdgJrnuk4JR6wwWtbt5XN5VYT+eq
	 Cyv3P5mmE2pk9OQ3YSijcYpkl2SWEA1WxWs/aDErERa2LEo0N0jaC2143PphBUvovnLAb
	 R1KdYjeOsGeTEqYb2kaJFrXxFsILCSm8txmz6DsjorGcWbBonB+Nl4BAoKb2YCiNuIVcP
	 j7XJi6LEPPYNj2gv9AR7RVZu66HNV7+HutwefD9s0vJHtj4Ok2zP2pRu7+yB33d4L6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hzASVbnHQ6QkqNxXxtyBjCTVeOBMKd8L5jipXclqfm8=;
	b=zuyoZEGoavoMdhxMonOCn/8NAqr2F2kIe1FZz0WXr10PVtwXNx+6bAIUn/fyXT2//H3S
	 Yfx6pNT9i9VBC4fk/sOFhZ1cLbP5wJqVSyVNXTUlOUD7x+ZbszeTK6sBfOoQFnj0OREXB
	 uc623q8Ove2vmcLHlI8UidMZahzjk3K4du22flX/8yip7MLdQETQNbgJmOU49olABTgOa
	 O+O9T1WInSoMnmlqML4w1ctuVsJfm2oT9BqtE51VUCAXCsPrmKWTQZDW7OQ2m2U20TlGb
	 gVyoS+pj4qinwZiPP+hTmAukN1PzpXBmzRueb0h4z4j/DT3NG2CoNQHdWiJrinhCgZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPskozMu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E55606A320;
	Wed, 18 Nov 2026 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPskozMu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5471F000C4;
	Wed, 18 Nov 2026 17:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024556;
	bh=hzASVbnHQ6QkqNxXxtyBjCTVeOBMKd8L5jipXclqfm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPskozMuyW9jhT/fhlvKNBRSpKa2lTpqYebJdjj1yfa11vm4048z93xRP9jOmJZQr
	 TboR1V0N65HMbXwQS+P7RP+puJgqMH2KmqcydmoHV2rVJvStYM9AVI3tRgeV1HD6kV
	 TE+a8VMGJv/v4xw9MMPPdKgUwZTSo747OTkgnm7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Lu <alexandra.lu@nokia.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0766/2151] bus: mhi: host: pci_generic: Fix runtime PM imbalance for no_m3 devices
Date: Wed, 18 Nov 2026 15:41:41 +0100
Message-ID: <20261118150149.994680839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Alexandra Lu <alexandra.lu@nokia.com>

[ Upstream commit 95601e9948b42f82600ff2d9e0c2f699a067d561 ]

mhi_pci_probe() drops the runtime PM reference taken by local_pci_probe()
only when the device supports both PME from D3hot and M3, but
mhi_pci_remove() re-takes it based on PME capability alone, without
checking no_m3.

For a device that is PME capable and has no_m3 set, probe therefore never
drops the reference while remove takes an extra one, leaving the runtime
PM usage count one higher after every bind/unbind cycle.  That is benign
for the device being removed, since the PCI core resumes it to D0 on
unbind regardless, but the struct device outlives the binding, so the
count accumulates across repeated cycles and can end up preventing
runtime suspend altogether.

Cache no_m3 in the driver's private data, as is already done for
reset_on_remove, and gate the removal side on it as well.  Unlike
reset_on_remove it is cached for virtual functions too, because the probe
side gate tests info->no_m3 for physical and virtual functions alike.

QDU100 is currently the only device that sets no_m3.

Fixes: 0494cf9793b7 ("bus: mhi: host: pci_generic: Disable runtime PM for QDU100")
Assisted-by: LLM
Signed-off-by: Alexandra Lu <alexandra.lu@nokia.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260807143353.1932381-1-alexandra.lu@nokia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index a5b47728f9aba..a5b7e1f9fcd1e 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -1030,6 +1030,7 @@ struct mhi_pci_device {
 	struct work_struct recovery_work;
 	struct timer_list health_check_timer;
 	unsigned long status;
+	bool no_m3;
 	bool reset_on_remove;
 };
 
@@ -1341,6 +1342,8 @@ static int mhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mhi_cntrl->mru = info->mru_default;
 	mhi_cntrl->name = info->name;
 
+	mhi_pdev->no_m3 = info->no_m3;
+
 	if (!pdev->is_virtfn)
 		mhi_pdev->reset_on_remove = info->reset_on_remove;
 
@@ -1428,7 +1431,7 @@ static void mhi_pci_remove(struct pci_dev *pdev)
 	}
 
 	/* balancing probe put_noidle */
-	if (pci_pme_capable(pdev, PCI_D3hot))
+	if (pci_pme_capable(pdev, PCI_D3hot) && !mhi_pdev->no_m3)
 		pm_runtime_get_noresume(&pdev->dev);
 
 	if (mhi_pdev->reset_on_remove)
-- 
2.53.0




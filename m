Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829600;
	b=Rs7yce+oMEm/ob+w3td3eW35tO7527u6s5+JS3VchF63EaluYnnCCoVq0GajVdOcf0xP
	 Jn6oyFRNgbC6tMHfeLdmuBWebqXsvpvYuzPxFJLVpLgtuQ3OqSQnN3HCfaforZxqnWWoq
	 J6tlReGwZMUBiASaA3Pymzw2COyWohEvgyYP2x12rEY4QH2BtAPcYKeUC2AuB9GNhgsH9
	 qFeWgbLO7eaBkyHUbBnuunlGy/4gStFo98qgvvoCArp7giQj/r8LqSo4NLhYuq5gh8j4d
	 74rFQBn5Fc1m6BLy9x7xVNN2F2GlDa8r5z9oxOaw/qGX4LEu+6UtoXYuRI8uk+Jl+3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g/R2WmWMKPPTpub/+P8+h0VG1ngccf5QItvcm6qzjBA=;
	b=eVp6v6A0ZYr0l3aoPNYoHNYljNGEHDeqo0WjgbjCJy7eDa191HudXEJRUMpnpRL+Axhp
	 ECCfXFx5zOgqyDF34Lq4/JMJd4NvmUNpscaY1qA3YYDl5O5YT86gHwXe1NZ30RTkxp6BD
	 jmQ7yxAWLqG4sD9y5Mzl+Cr3YXl27adTt1+XEv6iduM04jFsoTMHtRukHClWJDskTtkHS
	 uLQ0cXf5fWA4S69wZFgiMxt4rIZMCg37/ZhVsJpxKFwBP39Wq9X0U1+FskNuoC3Ws7hjR
	 SDDMZkPd22T4Bz5QITYHW93SDIJAzlpevIvSNYQCPqtuvCblVpLPse+rrYwiktV3cVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F44Uq2Ay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66551606B2D2;
	Wed,  4 Nov 2026 22:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F44Uq2Ay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E981F0093A;
	Wed,  4 Nov 2026 21:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829600;
	bh=g/R2WmWMKPPTpub/+P8+h0VG1ngccf5QItvcm6qzjBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F44Uq2AyNR6FseWiTR2zI3+jsmsUS05zk3OWhN6umiiC0IDJZmVUaFj9QCbdevcWX
	 sVmFDkCUU9vvCa2brLJSE6IWjQeHpjFo2xcllUZPyrToi5DlShlmjoNqE7zMAc4+lQ
	 CLzqMJtcDD0nn/Zbnc+mDIkh036fMb14xiLe4cgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0228/1005] thermal: intel: int340x: clean up RFIM groups on DVFS failure
Date: Wed,  4 Nov 2026 15:59:21 -0500
Message-ID: <20261104211050.225037115@linuxfoundation.org>
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

[ Upstream commit 28f34d7dafa6dfa657efd6760b7c78e98c9b2f6a ]

proc_thermal_rfim_add() can create the FIVR and DLVR sysfs groups
before creating the DVFS group.

If DVFS group creation fails while both earlier groups are enabled, the
current error handling removes only one group: the FIVR branch returns
before the DLVR cleanup branch can run.  This leaves the DLVR group
behind even though RFIM setup fails.

Use one DVFS failure path that removes all previously created RFIM
groups before returning the error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615065245.84252-1-pengpeng@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/processor_thermal_rfim.c    | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index 635bc8fded1e9..2f32b230a4b15 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -460,12 +460,11 @@ int proc_thermal_rfim_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 
 	if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DVFS) {
 		ret = sysfs_create_group(&pdev->dev.kobj, &dvfs_attribute_group);
-		if (ret && proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR) {
-			sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
-			return ret;
-		}
-		if (ret && proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR) {
-			sysfs_remove_group(&pdev->dev.kobj, &dlvr_attribute_group);
+		if (ret) {
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR)
+				sysfs_remove_group(&pdev->dev.kobj, &dlvr_attribute_group);
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR)
+				sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
 			return ret;
 		}
 	}
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015746;
	b=OecJRInua5G4GCVVCZuuckzpjg+Kr7YZhUtq2uniuj5UiN0wEMidWT85PVHR9uXSOXBM
	 E3DsJGV4n+5k8o4J7A8ie2oQ1N0oxUhZ+2ZsOe7mUXAhT8sB9I8tSlVGPeZtJOjeaMZX4
	 /KJZbp8nUHEYHZlC6SpHnFgZXN4iRVRMjMdrCYipt2exCq/6LYKNzZnZqXgFD5wPHCxt/
	 mCa1YVemObwq3t0RsLLBqiBUkkA3l1/QOChyUIDin+VTrFpo/PdwkBAvWRBWesCfmUsZz
	 SKyB1UAFTM5HqbGKpAcjDQWfkwTpGBVMJ1YzS39RAtxgJ80qD6FEPCDrQ6y61jKSW/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cfa58blc1z7FTlmr5wFhXziuoWSbolLf1qhG9L/koN8=;
	b=n1bXISbdk9K2H5K7xGdraAj5b+O+jc5LTyP4ZyYMartV8oKsXOuCdgcevKy6JhJIhToy
	 NDAWu3/U/VttymGj19LxkThcF6dg20lOTNE3kaQqMCuOXrepjuwedavRpAlqrmJHdgMe7
	 VC/0SPWckwSpjQN/qxNpXtARDxMi80QpmwE0KivyDbpqCbDJrKrmPLxLBy6fBAuJL+8rT
	 SnG4bj0C+d8i2//1+GtyvwEih2zLiQkQAi/vTHUUmbywbmAOjXyMutKafWET29NUKDbhg
	 AmANWHvFBWS8829qKNAjxgwCjUaUV5r7UVVUMi+xF+7FSReVYRhMWMPfba+WNYF/r5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSdKdcTM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9E8606A331;
	Wed, 18 Nov 2026 15:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSdKdcTM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58A61F000C9;
	Wed, 18 Nov 2026 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015746;
	bh=Cfa58blc1z7FTlmr5wFhXziuoWSbolLf1qhG9L/koN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSdKdcTMN1MXN1xpsrjI9H8v3qSQrZeoFvTCmJnlAWx89R9r61zNi3lEzsAv1xc1n
	 zpTnGWwL/a3U3pFNGXp/GglXx+ikzbcl3maOH8PCsGmwD7sC0vfKCCKcp16VJAjyKq
	 Llh5XMo6cfvRbWv9JHkvrO50jdfGnciyl0sMRnF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanhua Wu <yanhua1.wu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0282/2651] EDAC/i10nm: Fix Granite Rapids ADXL MC mapping
Date: Wed, 18 Nov 2026 15:25:22 +0100
Message-ID: <20261118150258.066724863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit ba71d9b4e9dd83c1614b3b5cec6c82a39d290f7e ]

ADXL reports memory errors using memory-controller physical indices,
while the EDAC driver identifies memory controllers using logical
indices. On Granite Rapids systems, BIOS may disable some memory
controllers, causing the physical and logical indices to differ.

As a result, ADXL memory errors may be associated with the wrong memory
controller, preventing EDAC from reporting errors for some DIMMs.

Maintain a physical-to-logical MC mapping so that ADXL memory errors are
decoded correctly regardless of the BIOS memory-controller
configuration.

Fixes: ba987eaaabf9 ("EDAC/i10nm: Add Intel Granite Rapids server support")
Reported-by: Yanhua Wu <yanhua1.wu@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260819025259.266201-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index 12e1949fcf44f..87e541c3bf4bb 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -479,6 +479,7 @@ static struct pci_dev *get_gnr_mdev(struct skx_dev *d, int logical_idx, int *phy
 		if (mdev) {
 			if (logical == logical_idx) {
 				*physical_idx = i;
+				skx_set_mc_mapping(d, i, logical_idx);
 				return mdev;
 			}
 
-- 
2.53.0




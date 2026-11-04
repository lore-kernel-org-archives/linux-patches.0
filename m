Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829489;
	b=vB71afe3/qsTTiQt3YThjoT220zi8RY30wYU7ur47KpLFZ/q8XkubXhZUggFg10m8kyN
	 vqy1Jz5UzEMI86tQ7oWaz644IYaqRWL3bkv46sSkT7EO2RwzdD81y5OOea1F5kPK0q2rO
	 aS0I/24hGfYM8Ws5YqFQ5XrwqSPcghFLF9YWhPohk+VbrfihLk+LOcdFVRh4NipvUoRlO
	 M9fJubS2eH8LDRvvZe2JrKQZrYiWUhqCFjy5yTUFYQVBgdfdPaB/b4hSqFHWoA+3zGdNc
	 tTbAC7Nhagm1OuirQQuEroY+aOJFG9S0wcQpQmWxC8fwSSAt4l4gKWrVkJ5W6VIPLGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zqWCBC2JMBKH1EK8bsHurUM/Ihtwfj+poVhpau7MuzY=;
	b=r7B6SFGjGzFf2Kv+eJ7THw324n13cMOUC03OHTGVaJEt0sn5e2IBe0LpeycLTNBuTmwB
	 saQU6LHpa6bBysYqRv8oaVeIt2y04qb8B5rWzdsJW7p1AP9LKX46BzlAuQS62kb5Z27Dh
	 wnvSvLcHBnpI72uqjojdSPibadNYiAloj94S77jI05oeFB9ILYgkVTeFq20DSogFD4gnP
	 kgCPIdn1t5xOh1ufgr7Zgf896enO8WouJ56TfNEUZ/Tv1uHxnqksA1WoPXyeC+79bhTU7
	 EA49yFDStcxpG0b+b4uHf3qki32qDf9pgn2IZ4l4Sa4HGTMhL05dIchymlkE8HXK7Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stRM3uBG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D24F606A878;
	Wed,  4 Nov 2026 21:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stRM3uBG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB7A1F000C1;
	Wed,  4 Nov 2026 21:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829489;
	bh=zqWCBC2JMBKH1EK8bsHurUM/Ihtwfj+poVhpau7MuzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stRM3uBGUe/Eg1/+Y8ZYjGj0CzDptCOdZIlU92ZpXdIlw+JevRoq5jKPYclyAI6Wm
	 P6F69vV5RBYuORTDdP1/2FRIZ8OqwMXI/JH/quAD71GQJLWRC1DYAQ7hdkOqQyGOG4
	 zPyCPc5Qx+leX+qglJ/xR3qyrF3AWBBfYKih49cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0157/1005] wifi: iwlwifi: support TTL platform device ID
Date: Wed,  4 Nov 2026 15:58:10 -0500
Message-ID: <20261104211048.153712625@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 3bff0d12c36247073fca976498b58a940fca72dc ]

Add support for a new device ID that we will have on TTL (sc2).

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260714165826.46183446954f.Icc260831e530c1c92c9be615a7077768b1b9ae30@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 0e8481219839b..4314d95dd12af 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -548,6 +548,7 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xD340, PCI_ANY_ID, iwl_sc_mac_cfg)},
 	{IWL_PCI_DEVICE(0x6E70, PCI_ANY_ID, iwl_sc_mac_cfg)},
 	{IWL_PCI_DEVICE(0xD240, PCI_ANY_ID, iwl_sc_mac_cfg)},
+	{IWL_PCI_DEVICE(0x9327, PCI_ANY_ID, iwl_sc_mac_cfg)},
 #endif /* CONFIG_IWLMVM || CONFIG_IWLMLD */
 
 	{0}
-- 
2.53.0




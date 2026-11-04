Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829500;
	b=pB9XhUBiSMyXy3vVJTJFWoGWdeUDJg4aMACdk/IesjjWOFEivMPMxyriWrxdblB0fJBu
	 PZLhrx5jxTUfW36jda1mGf7HsWU1aOauDhGepzl/ZSEn+byoXeOOr1ZwBvHGTQ/SCvGR+
	 LFI6Nb4UocqazmPjUv0wRCwreUDoAL/lB8/XM2RlylyXDFoTHuELJV9Gi51Af8E8vT6ZJ
	 4GQFWy1EfUjq5fAHgyJWumq9G6P2x6OSqdrL0BvD3amZ0UdYfF7Azxd0FFJ4uftG8LwuM
	 Or2UQ5TcjftzuO8wKBJDEPnuGN7Pxyi9nxw0CdSWBX7RcMteV4rofiLbs/UUtjMbNbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Ze7Bw79JwnWMZsa4NcPWDY7TG+sc/3bKKNrTmRplm8=;
	b=rKzapTY1vQw2WhIQWM/I0ZMjQm5Zo15U8COrDZpEO9Ts2+gbshfourl+D9nIvrus8kcm
	 4kfTZQPS6xNQp6eHut+sFP8AJqELWHuaxQhGmxoySROk2xtGrrp+e+h6AAzTFEkyLkW5P
	 h7sVaDx5ge5HB1mSBHYSa7GzgIWFk7UsViMSNhitPnMAOCmFlfOVVhKu6pkzLhd9zvUS3
	 nHKsxQuql/dnKS/BS2gggBzoZ3/mD4TnBa5NfwUu2xNJ1Qfpji7wwsK8lIPiKh4eqJB09
	 b8af1GfyAqVc6wvDsrkOr/Nm59WCzDAsuyteIBgrb+HpIbi88zFgy+AOFcumbRRNsvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nrq4pU9e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAB2606A844;
	Wed,  4 Nov 2026 21:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nrq4pU9e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB72C1F000C1;
	Wed,  4 Nov 2026 21:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829500;
	bh=0Ze7Bw79JwnWMZsa4NcPWDY7TG+sc/3bKKNrTmRplm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nrq4pU9eV8JOb55oqk8i/pV5Mql327C2XsX0ausUAt17hN7QlMpoEvZiJlpzgeapB
	 oio5/TCcWJ+QLERXhUIfW4LcxeDJ6s5IMPVaC3TR/3IwDK11tVaDzRiuQbrNEyQFyr
	 Ls7OchlTmnZ4165/ol1J8M9o91v3yB1meyZO3kOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0163/1005] wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
Date: Wed,  4 Nov 2026 15:58:16 -0500
Message-ID: <20261104211048.329188294@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a51cc8131214870af92abbceab64877b27e690c2 ]

The smart fifo is a feature in the firmware configured by the driver.
The driver keeps a state to remember what was the last configuration
sent to the firmware. Obviously, if the firmware stops, we need to
reconfigure the smart fifo. Since we didn't reset that state upon
firmware stop, we thought the firmware is already properly
configured and we didn't send the smart fifo configuration command
as part of the init sequence.

Reset the smart fifo state in iwl_mvm_stop_device() so that we
will properly send the command during the init that will come
later.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714165826.7d3c5efe2d1a.I16b23c328a677257257f695fa6f439e41fbcd081@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d6a13174b5617..3e7c620821069 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1535,6 +1535,7 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	mvm->sf_state = SF_UNINIT;
 
 	iwl_mvm_pause_tcm(mvm, false);
 
-- 
2.53.0




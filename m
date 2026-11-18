Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051135;
	b=I2XhwFre4XlyMgW4jjEVTQqF9E4IbTGUhODLDtlidJsJaUX03C3CzWKWVCUmrXEe9SRF
	 dOEmZ2jopZ8y6t2pz5fTcA9Q3qXArvk1TpnbEmMM4HGPsb1r19HNepWEuD6qmQ80PiUpV
	 MNjGpdsvvfifnJnhENI8f8YLPMWChxv6Wxguhh6yykQN7T+hMcapy3Y3AX21zZeQjtvBo
	 9lDp+HlJTvjMb5/HsbSLVxOzLP01DQ4fgnoKLsSAtoxUD83ErqHoQRgUu0ooKfPeW5GIR
	 +eNUmg6usnkNb63Dz6f5oTY2D70i5a6ltIi2z3yBd8XM7b3JaMd4ExbUu9OmKkhCfCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D2EgXpRWapQZchckmIuGXuxEzHggyJJBpzIV3s/TlS8=;
	b=086XcgerrOcBGKjyeKaLsNykZSQYlpK1wJi8ToWA4hWHS4JIwJuRaPvqil0pace2ug9G
	 /Cyf6Jw27AvfQ5/8APFm/pZgmjVkAkRgnKuGyhIsJBm4Zvimltm8Pbl+y6dA5lAOomKq5
	 rIiTZyrJ18xKGbj13HGSzs/G/lXAv06Ula3gTwJhf2QfRvPOn1Tvvx2PbFbTv3PoApys5
	 jS7MckqXl7aoPC4FMQEnQZ5/HzegFaqDkO4aoevr/0pffO8YsWucu4aDz0HiUQJ9oBGEV
	 U5cjlrS2884jny/BRxc3vGaEmmHhpPcrn3nM5TQ1R16xGRc68DDpJO7u5xv7EMdEPig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I0YmH0wU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BDE606A334;
	Thu, 19 Nov 2026 01:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I0YmH0wU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46BE1F000C4;
	Thu, 19 Nov 2026 01:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051135;
	bh=D2EgXpRWapQZchckmIuGXuxEzHggyJJBpzIV3s/TlS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0YmH0wUs6sCIXEIjvryuIGyimOqE/z5gZEGlsJ2E6Hyq3fQIjvRLqSIkEFoW01r/
	 GU4ju2xEOpTqvboanmlK4eLsVf3LlgsDeg1Cly5JjTI3F5tEiL9OdV3CPjun76nbJ+
	 bzL7g98hE3zhU/ErUh/WQPUfrgzgqgQnS6PIvbtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0084/2214] wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
Date: Wed, 18 Nov 2026 15:29:20 +0100
Message-ID: <20261118150013.356707234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 05e1a6de8c2e3..0d7edc2a09e5f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1019,6 +1019,7 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	mvm->sf_state = SF_UNINIT;
 
 	iwl_mvm_pause_tcm(mvm, false);
 
-- 
2.53.0




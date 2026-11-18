Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043114;
	b=ef18zl69BrMo6Jo9tAJJdRZT7R19hBDevA77NugmvoYPLTHu4IorlHCHl48wKNFMySpB
	 Dv3td+OD1g0wAje+HQbdwkNQiOvmMJG/L2qZWuvawOPNyJVgqRTVLnmibXNX+QS+WQplD
	 SkCl6vsT8Ly+98IeYhAjbxA8aD8X8dxSORb5dNoJGZx0tfoG7nOxC34PrIlQVKMusjVSn
	 h6d7xHZOxXIl6z19RFqfIj6b8S1XlCTMNJvbVEHYJUcMR5a/LPCFfeg6a4m5co1uOwSlL
	 yl8YTEmumWm4/+dog4l20qMbeTQpiyNJFmp2yPhax98Txh1avX0i+mP1AckgMlrdjNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b5cgn0XfbSkwmvO3wC7M8zUoH/OMnSi56o2NWJc16vU=;
	b=nRtn1Kvu7S4b8kVu/98B7t9fiFWL6FZyWamsKP565pt8AxaayuYig0XNUb260RX+m8JA
	 rbhAR1LP9iYvXSRMnj9tiIDsmTURkQNCDpF251wW2viWZGJod2ntLQse1pmHlL46MEG/5
	 Jzk65pLhlLNGnda2TSkxMVZQLTwERiDzUrCkLafoqh2HLXmpZ5JWyNnm85wTJRmknLdcv
	 npBKWxz7PFNYKbjWoYBLEciXmtt3r2PGrfNXfWtDtQ91zbskz4CS40Q1O/aE933V1cxjj
	 UvgrSUS0eb7Sl6ff266BiQ3Ip3eQFKs6mCqOe5ZnB74vDkvNcdxOSwiVaz60dMJe/tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EBFSqdF9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF57606A31C;
	Wed, 18 Nov 2026 23:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EBFSqdF9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738F21F000C4;
	Wed, 18 Nov 2026 23:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043114;
	bh=b5cgn0XfbSkwmvO3wC7M8zUoH/OMnSi56o2NWJc16vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBFSqdF9vpnY/XeDw5qjGnPIDuEL46usvoqWBxiHIzwlDc3NezeYmBnkaHom9MYLw
	 faIhrfQrgp/LIxpropCmWkPyE0/YxwAfSWqoV/3uV1c3s88DZOJKEMhODhdH38S9E8
	 vG1ZlMo4p4Jp6O4RQK3DHwQb7NIgJfFbwuYeTC/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0094/2857] wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
Date: Wed, 18 Nov 2026 15:18:48 +0100
Message-ID: <20261118150204.655733087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 591c073bf0a98..ad87dc4db20ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1367,6 +1367,7 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	mvm->sf_state = SF_UNINIT;
 
 	iwl_mvm_pause_tcm(mvm, false);
 
-- 
2.53.0




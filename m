Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033719;
	b=euGE+a9QPN+H5e5tfSJPExCEMnvvZQavHXtFdWKcTJqrKRIDwLGpuT8SQH84mmGOxCAL
	 YUa66tNjkOPliwoVU1NK0xaxE7N3B3X6+LphTK536dYmJuTJo078CuCr8GBkucOhMIo8r
	 +TYg+zdPaEyz0sEeJ9hV/Di8UpFmZrb58KmhPkkVGJnHOIVE0hJK4PPzKfdxd6bV2oOLR
	 OPf7XyE1POXZQl8hvHu0glcHOzsH/ERmLOtWOfpRLF829RV1Fk/w3zeDE1b+ePhyzdZDx
	 6N2zskZMg+PubIPlDP/HA+LTgjinBzrL82Z6kMcfIKBbe79L/X/xYERUfNQpwjExYEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iagfcAZdgdf/V2LgDOFLcXi0TS4rjEYjUusiErspEiI=;
	b=KIBW6N96v6LfUwcEVBPxNYSZGseiQZmTuiyTrTto9XlEo7n9mmZRgSj9033vf7yF9D95
	 WRmQsTBqYe2weuI+NUrgQA03XZrDyRquDysIZcAeogOnKTYUrXjiOch7NbesKodNz6dcl
	 12URoKNuQb9EfeEFT3rlr0uxmyYVFEdj0qj1d3Hu/laztjYLFrN57yPZkmtEVDxqqZtvT
	 X/TvizCfAI58/szie6cfF6h5RFlRHJQ3U7RRg3oovTqv6N3mdEojGZzGL0b5d4wNi9BlU
	 tV/YIbMVFZ6B5YQWipsHZPax6xzGfKWOnmR/J6xOFiYruNj88g/Sb2Nwx+E0xQS2Ouw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXW+hEZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01409606A330;
	Wed, 18 Nov 2026 20:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXW+hEZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B001F000C5;
	Wed, 18 Nov 2026 20:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033718;
	bh=iagfcAZdgdf/V2LgDOFLcXi0TS4rjEYjUusiErspEiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXW+hEZQljlL5VIhvHTL4bsoEeyw9qo4VcycfXqTpd9x9utspRIQfNTGkcFC+GwVX
	 sm8uad+mUFbDifbLmC+5be+rXf+Oj6f7qUGqv2ttcogL+kONjFfwSxw5lfW+Nvyl4C
	 yV+2SKrihVtDqBmIuXXvsfpy/UJu2hVTkP4vYuVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0112/3318] wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
Date: Wed, 18 Nov 2026 15:12:14 +0100
Message-ID: <20261118150317.648854569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fdebe570ab8cd..16b21c3349fe6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1429,6 +1429,7 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	mvm->sf_state = SF_UNINIT;
 
 	iwl_mvm_pause_tcm(mvm, false);
 
-- 
2.53.0




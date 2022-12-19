Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA93A6FB9
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCE3C433F1;
	Mon, 19 Dec 2022 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671478011;
	bh=cFZDr3iGcfKiX9rWgBaBaE9vpKVOax1baPuaHLrzF6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQYnxBuk7iWsHWF1/fypIDSDG9gLna0Aa/6bVDCtcyI4nDxKmOT5YmtJKeg++QT/t
	 NQ3TWOq+97EE3EJL+bd2qhEYiXjoQ0u7GTEaaGxliwtgE4WvI3ooTeJPXjk9DJ+trQ
	 7AwRcUhd819GQOI9cFzE3LTXLPK5swx6FlePQous=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 21/28] igb: Initialize mailbox message for VF reset
Date: Mon, 19 Dec 2022 20:23:08 +0100
Message-Id: <20221219182945.105856338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Nguyen <anthony.l.nguyen@intel.com>

commit de5dc44370fbd6b46bd7f1a1e00369be54a041c8 upstream.

When a MAC address is not assigned to the VF, that portion of the message
sent to the VF is not set. The memory, however, is allocated from the
stack meaning that information may be leaked to the VM. Initialize the
message buffer to 0 so that no information is passed to the VM in this
case.

Fixes: 6ddbc4cf1f4d ("igb: Indicate failure on vf reset for empty mac address")
Reported-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221212190031.3983342-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7522,7 +7522,7 @@ static void igb_vf_reset_msg(struct igb_
 {
 	struct e1000_hw *hw = &adapter->hw;
 	unsigned char *vf_mac = adapter->vf_data[vf].vf_mac_addresses;
-	u32 reg, msgbuf[3];
+	u32 reg, msgbuf[3] = {};
 	u8 *addr = (u8 *)(&msgbuf[1]);
 
 	/* process all the same items cleared in a function level reset */



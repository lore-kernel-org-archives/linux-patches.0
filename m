Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD1315C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A0AC433D6;
	Mon,  5 Dec 2022 19:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268312;
	bh=LBzpaqq7MMeWU0zBrB4T8GwA7+BwVUeepb7gcK4lmvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mre2WhS3hhTkYWtO4SHId05nWCdF3Tz4/oK9Txfe6lf4fghWGQ12UAz+zpWrod3OW
	 VwADx2R5f4DkZOgLQvHDItmWGQ9Hd7meEt2pdcyhcgQ/v6KJ8eu+8e3EjONWuz14l5
	 L9uDRftTf99JMiAhelLDn+YxxoxSYFl71cMyKnwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 055/124] net: wwan: iosm: fix kernel test robot reported error
Date: Mon,  5 Dec 2022 20:09:21 +0100
Message-Id: <20221205190809.992049143@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 985a02e75881b73a43c9433a718b49d272a9dd6b ]

sparse warnings - iosm_ipc_mux_codec.c:1474 using plain
integer as NULL pointer.

Use skb_trim() to reset skb tail & len.

Fixes: 9413491e20e1 ("net: iosm: encode or decode datagram")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index d41e373f9c0a..c16365123660 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -1471,8 +1471,7 @@ void ipc_mux_ul_encoded_process(struct iosm_mux *ipc_mux, struct sk_buff *skb)
 			ipc_mux->ul_data_pend_bytes);
 
 	/* Reset the skb settings. */
-	skb->tail = 0;
-	skb->len = 0;
+	skb_trim(skb, 0);
 
 	/* Add the consumed ADB to the free list. */
 	skb_queue_tail((&ipc_mux->ul_adb.free_list), skb);
-- 
2.35.1




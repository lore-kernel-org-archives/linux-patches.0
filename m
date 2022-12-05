Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FE615C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B850C433C1;
	Mon,  5 Dec 2022 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268900;
	bh=t4JmcdAdZzLx3kuTJ0ae6hMmJIOmaIV3nKsii15PHR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYRYHXvuCtLzFSSOfI9RgYJi88ElLnTOBNhPuATTfJjlWbGidIYnDVabHEL8uz+HF
	 ss5H8hSsn/geDAb8T9AjXztvuy1kkY5dAFmDbH7lAOUiRPqBOXUekyCoUtvv0Nfx38
	 EH4DYQAzgKCrxJ8v0tPp6gZN5/I/D0Pw3fIUaR3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/120] net: wwan: iosm: fix kernel test robot reported error
Date: Mon,  5 Dec 2022 20:09:53 +0100
Message-Id: <20221205190808.205964323@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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
index bdb2d32cdb6d..e323fe1ae538 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -830,8 +830,7 @@ void ipc_mux_ul_encoded_process(struct iosm_mux *ipc_mux, struct sk_buff *skb)
 			ipc_mux->ul_data_pend_bytes);
 
 	/* Reset the skb settings. */
-	skb->tail = 0;
-	skb->len = 0;
+	skb_trim(skb, 0);
 
 	/* Add the consumed ADB to the free list. */
 	skb_queue_tail((&ipc_mux->ul_adb.free_list), skb);
-- 
2.35.1




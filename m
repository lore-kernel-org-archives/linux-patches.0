Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016696;
	b=3SP9Cl+SR2r0ZkTqk3n7dGFf8Epw0ZWjjtB4LCSsLC6EGE3hincGEj9rOh5gMsH0ch6d
	 nbS2muGo/ozOiFwFl/Sa1RYnk5zYuIODT8Od8m+fVOFiivgzqEe1fZUAIkJtVNOW0X2jF
	 fapIRxGHS84QAYNIuo34tWpthQa3dRbe4omxP6B7pFbCU+P8EWAMmXttGBvMgHGRRvRNx
	 c92AGKDRhZ1JLew9rjLCeZ0zK0Q/wkpQUqaZ0Q7FV2L9+SplIFvXMQf669DRVTcp/5Wzo
	 rHYl4KuCYulxz1LIi/Rccw1HZOFov1OlFFHZePvlEKf5tuwFwIFaloVVBonZiR+ajhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KkKKcyDqlePD8kbwIUvH1eAk2yDJnsEOZC5P2yzG0b8=;
	b=Jp4SRFoYPUSDmTwNHdDkkV9HsARrh/Ccm0xUC76QHJwOqXKF8iWD010ixbmkkbI76Gc2
	 is11zHiaZzX7InT+55+C/a35t8Enl6ilWR32CpbwgTiD8r8VbNC/XzHgVuswREU0t9O4q
	 koZje8MZ1f7poq1S3ns1zJ1JfEiZjZ8Y/PJdKYiLAehVydHnJCvZyIG5oesAZ0t7YtUzb
	 9Bvx/G8vonce6RDM2mhW1yk+TzlE8Sp1mTVdZLDLLW4KbNvLFVMKnkVqPgH7eRL1fcyIG
	 l61URaZJKGd9yL0JncON1w6Co1oWRax0p5rO4s9B+8n+JkrGQMZEFlI0WQD1KdWtzVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UujcYvuG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B37C606A333;
	Wed, 18 Nov 2026 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UujcYvuG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800781F000C4;
	Wed, 18 Nov 2026 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016696;
	bh=KkKKcyDqlePD8kbwIUvH1eAk2yDJnsEOZC5P2yzG0b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UujcYvuGAnGKcjFrNXrO/EF5GkZkqHUyLZJ7bTqEayEjDVnt2KSYkRHo97g/GBoYR
	 VFL15tq42tLQCSJRzGKVPWsU9B3s1EEY5DxYP2HFyygSaEO2LiSvAqZuWprcUHf4C5
	 TNeuJ5kKqOixtQwEsjQ3dkuP0jCiDQ2CvTQcGhjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0621/2651] i3c: mipi-i3c-hci: Restore controller state if i3c_hci_enable_ibi() returns an error
Date: Wed, 18 Nov 2026 15:31:01 +0100
Message-ID: <20261118150310.054823236@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ad869331ac616bf192c04081ef7e206e1d106ad8 ]

i3c_hci_enable_ibi() performs controller-side setup before sending the
ENEC CCC to enable IBIs on the target.  If the ENEC CCC fails, the
function returns an error but leaves the controller configured as if IBI
enabling had succeeded.

Fix the error path by undoing the earlier setup when the ENEC CCC fails,
ensuring the controller state remains consistent with the failed enable
operation.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 8b3a87d8a8bb0..166d9f70f4358 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -703,11 +703,15 @@ static int i3c_hci_enable_ibi(struct i3c_dev_desc *dev)
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct i3c_hci *hci = to_i3c_hci(m);
 	struct i3c_hci_dev_data *dev_data = i3c_dev_get_master_data(dev);
+	int ret;
 
 	mipi_i3c_hci_dat_v1.clear_flags(hci, dev_data->dat_idx, DAT_0_SIR_REJECT, 0);
 	scoped_guard(spinlock_irqsave, &hci->lock)
 		hci->ibi_devs[dev_data->dat_idx] = dev;
-	return i3c_master_enec_locked(m, dev->info.dyn_addr, I3C_CCC_EVENT_SIR);
+	ret = i3c_master_enec_locked(m, dev->info.dyn_addr, I3C_CCC_EVENT_SIR);
+	if (ret)
+		__i3c_hci_disable_ibi(hci, dev);
+	return ret;
 }
 
 static int i3c_hci_disable_ibi(struct i3c_dev_desc *dev)
-- 
2.53.0




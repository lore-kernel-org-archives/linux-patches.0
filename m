Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212339;
	b=qAd/sJ20hfb2Nc20JMmyl8gZVjML3yJzhyiFrJ1MHb9sNnl096zIuqf1JyKI6vHor5n3
	 5vmZlF4Ge+rPZai+3A6/eIC9TD0oyk5j/VGSePZNhwes7S0gFxqqrNxbcYQtUQ8RihWij
	 0BH030nDWy38s15XQKbE45YgcH5gkm34Ko3suMsSMQsd2jtiUvDHtRz/b+UAHlRICxeLL
	 qiDYm5BKJD6+J+GYknrdopH8LCekh3S9v/5rlziLf/X+iiWV+423NzJC85cT25kw5PlUN
	 gVPf8XrPZXOCAIjSMq85MLR6TU0SyygLa7mLvfxeq8ztIP5/+ClVUXIoEYEmTYAi96Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dShQ3uowCerfzLJa663MYDpMuMJkjecy6vJ3Xj3sIfo=;
	b=uz5Xv0Q60BolftwJe0QOFy0PV7GWWvofxvmNz/fXPl/jAdz407X9CI/p5A9VAdHmgYzZ
	 8HumRDZknFHrr+omMqF2Vhg3o4dJSrhmwdNBOIvy+lsYOgQvwqcK7iZc97sS5gKWPR54f
	 YErGYEvvHl5NIW4dSSAI6tA+5iIqvA4crWeD8kIGafz+hvu6x7OxUoaUq4KlVwDPII1Tk
	 psksMxOdXHuJ6j0m4bikdPNBRgSJk0cux6g/GpwG1xO8Qw++m+ojJPCouHh5jzSozpJCW
	 19tj1Rk8I9Hjh0ghL7YtYuUFmlDnnwapqiK8ucZo5MHhzc/f3LW+N4sfw416dsMn+TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plqAtiEJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F19C606A31C;
	Wed, 28 Oct 2026 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plqAtiEJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEA81F01825;
	Wed, 28 Oct 2026 18:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212339;
	bh=dShQ3uowCerfzLJa663MYDpMuMJkjecy6vJ3Xj3sIfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plqAtiEJul7LkERv6RnwHtMsUf8+vkQhZvPziz/MyKPDJM4UGZsNdfr/ihkyCF6ue
	 A4mjd1/kFRYHQYkkONX7pVFlPvHqfgxvs+Fs4Ox4R7izbPFGbl0JuO39yipRAmf0Dv
	 Rme8EuOEXZh+WBGuUAwuFq11ju8zd+B+xgEDvqU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahil Chandna <sahilchandna@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0120/1887] net: mana: Reserve extra CQ slot for the fence completion CQE
Date: Wed, 28 Oct 2026 17:36:56 +0100
Message-ID: <20261028170501.967520415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sahil Chandna <sahilchandna@linux.microsoft.com>

[ Upstream commit 80dd7e754b3aa9637a0758ad93fa209f9650ec48 ]

The RX completion queue is sized to hold exactly one CQE per posted RX WQE.
MANA_FENCE_RQ makes hardware post an additional CQE_RX_OBJECT_FENCE after
the packet CQEs. The current sizing reserves no extra slot for it and in
rare cases, CQ has no guaranteed slot for the fence CQE when it is full of
packet CQEs. This can lead to dropping the fence completion while the
driver waits holding RTNL lock throughout the timeout duration.
Reserve one extra CQE slot for CQE_RX_OBJECT_FENCE. mana_gd_alloc_memory()
requires queue_size to be a power-of-two and at least MANA_PAGE_SIZE;
the reservation pushes cq_size past a power-of-two, so round up the CQ size
in mana_create_rxq().

Cc: stable@vger.kernel.org
Fixes: 6cc74443a773 ("net: mana: Add RX fencing")
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/20260901121837.3503240-1-sahilchandna@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Replaced MANA_PAGE_ALIGN() with PAGE_ALIGN() to match the older tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 4afcb202e3509..2d1e5b83a0769 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1662,6 +1662,10 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
 		*cq_size += COMP_ENTRY_SIZE;
 	}
 
+	/* Reserve an extra slot for Fence completion
+	 * event (CQE_RX_OBJECT_FENCE) in case RX CQ is full.
+	 */
+	*cq_size += COMP_ENTRY_SIZE;
 	return 0;
 }
 
@@ -1715,7 +1719,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 		goto out;
 
 	rq_size = PAGE_ALIGN(rq_size);
-	cq_size = PAGE_ALIGN(cq_size);
+	cq_size = PAGE_ALIGN(roundup_pow_of_two(cq_size));
 
 	/* Create RQ */
 	memset(&spec, 0, sizeof(spec));
-- 
2.53.0




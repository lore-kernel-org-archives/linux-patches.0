Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043239;
	b=iA6TYYnyFicwMst/meaDdDbBuYoVvIxoRbHiv2+lkWdH4cjfn3AtUbS5+E7Q4wYAGkX7
	 eqTUwEOR3IgrZur7QQf0PrxPhMIMVgYBnGT7ptdxIyfuObHijOy/nF1cGE7UNxe7NwyTo
	 wmdbN+diFgWXvPNsidF6xBIzMAYVpqHi10VRzQAx3X+bDQbkjhpdXmkahT8WPuBr8xo/7
	 Ki92yhecR4LZ4ObmtEHE/E7aSpOTnxwo5C/Yu3EbcE0jrSi+a5+gMzyuxmdrDr+tTyd3A
	 yImJE1usRoqVKDqx53lgETf0k91ylat22tOHOeYSU1juGSxAP/FheKNfUD+uRtanj7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=udMxoBscSee/vjr5zFUCpYXfZSO9UGfmstojORf9Pgk=;
	b=bYyq9lGc8/Fvyi2dUm4TvhorYz9LhrITP99jP4k22uiIyjLwSJXsdQzDsctV5YfXS/4D
	 DESEMqewd5SQELxrCTpuFoc3HraFYQUZxNhrJGQu5X50XbRyHq29lAz8oo3McuISxx+tK
	 Jl5o40gH8b+aijcg/SLm0d0/zHxVGQ5tS0TkcGWCyu3CY9i4iqFR4NU95rrcsm79mV7ns
	 cV/tTPM7CD3PuOozt4uZ9hBn8CjpbcC8UOwFSIvZIdOQQMqUTBjiyklLjwC8sFk0iIfb2
	 kijtnL1A9V5GFl8F2h5Ka5RS3YY7BbcMndwK9LD+L60FeCh8K08AT32UWOSNoRboVYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7rxfY89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A675E606A31C;
	Wed, 18 Nov 2026 23:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7rxfY89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0830D1F000C5;
	Wed, 18 Nov 2026 23:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043239;
	bh=udMxoBscSee/vjr5zFUCpYXfZSO9UGfmstojORf9Pgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7rxfY893bif7d63dLknLA9Ko+tVm6HclGOkmXncmTBcpvTLTgAyPAH7wP4fqVsN4
	 LzIcNq5aL78lJt9Gzx1MCPmBP20PY3rYvb4Q2FigwzWsfhbZJJ5mtGpOExKigzdyE6
	 MUmzazAaQUY12Rno+VxhRIgGTrGQKYtK0e669QFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0139/2857] wifi: cfg80211: include cf1 offset when sending chandef
Date: Wed, 18 Nov 2026 15:19:33 +0100
Message-ID: <20261118150206.359286133@linuxfoundation.org>
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

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 5a69b8dffd2a1b06e4cc4c9003c639eb78bac4cd ]

The cf1 offset is not included when sending the chandef leading
to incorrect channel resolution in usermode. Include it.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260721053958.227853-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fab77741663ff..f94ba29f2db1d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3825,6 +3825,10 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 		return -ENOBUFS;
 	if (nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1, chandef->center_freq1))
 		return -ENOBUFS;
+	if (chandef->freq1_offset &&
+	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1_OFFSET,
+			chandef->freq1_offset))
+		return -ENOBUFS;
 	if (chandef->center_freq2 &&
 	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ2, chandef->center_freq2))
 		return -ENOBUFS;
-- 
2.53.0




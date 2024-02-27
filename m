Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3367613B293;
	Tue, 27 Feb 2024 13:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040761; cv=none; b=B9X9cOEuoTwEjodR1emEdVOeKTuIZPY07UOhcNrHSk3XQz1Wz17RXq+QNVKLPqR/VvVyhxobf5whV5ZWHlZasEfiwCUjt7h3m/9uq1sflkWUqAHoRXCoXzBnJceIe5oFs7cGaJFkRbjhjI9+R53IcHqDWhT3NDbFXVEQlD4QaRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040761; c=relaxed/simple;
	bh=qvNhkK87M9C/eoWEnAzREXSGEmBt7dApX/jL+amykZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBbG6BN/OIEFaq4qO3P1J1XyAcfSiBJJ2SqEc0DYn3FElwO7Ln12Fs75NZoqfBk8HGXbfxTHY5fpcVrnfRZwLlPrrxZp2IeM5TZupcu2HVlmpiQUEvyBbw0Xa/W5DrXUtwkerr2bYfmFBCzS/JzXWmNf4HdramaAHdRU2L5QGC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePZ8Hnjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePZ8Hnjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6097C433C7;
	Tue, 27 Feb 2024 13:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040761;
	bh=qvNhkK87M9C/eoWEnAzREXSGEmBt7dApX/jL+amykZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePZ8Hnjj1CYuS+kSdslvRQPnRu1mcHP2jG4OqjkkyhWDXHtkRaXjgAvuHu4tQ8nN9
	 A4lfCbIHE6vh9Hqac8crnVlSXLseB9d3cURPxn02g+JkAnlwe8zh9dim8kw/2Pbyt1
	 7UBuzjgs/qxksXmbv3tM3yhR8AaWSnuwKi9wmqeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 101/334] wifi: mac80211: set station RX-NSS on reconfig
Date: Tue, 27 Feb 2024 14:19:19 +0100
Message-ID: <20240227131633.754721657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit dd6c064cfc3fc18d871107c6f5db8837e88572e4 ]

When a station is added/reconfigured by userspace, e.g. a TDLS
peer or a SoftAP client STA, rx_nss is currently not always set,
so that it might be left zero. Set it up properly.

Link: https://msgid.link/20240129155354.98f148a3d654.I193a02155f557ea54dc9d0232da66cf96734119a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bfb06dea43c2d..b382c2e0a39a0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1869,6 +1869,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 					      sband->band);
 	}
 
+	ieee80211_sta_set_rx_nss(link_sta);
+
 	return ret;
 }
 
-- 
2.43.0




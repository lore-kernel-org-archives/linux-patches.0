Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049406;
	b=LUZdlDLEbJGxC9RyNUEofydpqMR5XX190v1jLdtf7hSVVygpGRfhFHyzPxMsGGI/bKBM
	 02bh+/PDQNcSUzMGxBCdhcSMd9eCvSTe69blF8SrzrZtDLjXFSIamgm68cazzEnyVc4jC
	 //H5nhD54IofMhHmT3lKJRqdiQ+qBMd9XsMt18TfgrXZfKkN1Oro+AG6Isvt2iRM5wW47
	 KqubyIviovfGKzJRqZvgA/tJr96WlcjYXd4gIzoyamYB7gnUYM9GZnDyVGRqoTlSQ8fQm
	 Z9XPmQi+A49TcJdAuJVB3dNesx8sP0iTHyH5OoMvmxMn2ZsjM8rGUcegdhBq8yXZfcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HGcRiKx9aik8EDjZ/B4Swt/G64FX3nw/zmB5vEkSNPU=;
	b=dIalhbASG8Uk8KHoZGvAS9DfWpL8CpHatH1WupfqSfUAMxOtXty7VZNxmWVDg4/rJo1J
	 Br7ns5zNL7H3U2F+G/edGYpOKlItsF6JdtTlxmtroRpu+couRhounWn846Csi2XIQ0Pfn
	 4u1fXEuhpwTkwBn7Ts5wQGsM7lH/4HYhut5ic+LA2AWlxN9vBZUDJ3brhUVEsE7aLxpis
	 dhdPerEj84xBHWfZujaHb+orJGUiarSTv16XmNxUp+W7ckeSnkgK8RLIIMp6ghwZGOz/G
	 Lw4TXFZsfqSJfThyXb8HDm+6VPDJUBmZCFzHZzmYsHl4aZ/q2Q0tDkrV4PNwqslzVQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w0Nl2F/Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0805E606A331;
	Thu, 19 Nov 2026 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0Nl2F/Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9341F000C5;
	Thu, 19 Nov 2026 00:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049405;
	bh=HGcRiKx9aik8EDjZ/B4Swt/G64FX3nw/zmB5vEkSNPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0Nl2F/Y4d9I2nf1P42O0gC23IXdWsmImVyG9tCcCfppEV6bFCdUYqDcoHkdJlBal
	 aasj7oKLk74KQxN+p1F2tJXc14ZAI+b4oy3N/2wd3JuUe79kii3SoKclOwzW0G865h
	 2v5PgqD68KPKjuirC7laC7mk/piYKcgduJd6wY9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2340/2857] wifi: ath6kl: dont take RTNL in del_virtual_intf
Date: Wed, 18 Nov 2026 15:56:14 +0100
Message-ID: <20261118150325.787437858@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 97aab70a03df478ffefcf890ed4be258c0240bcb ]

cfg80211 already holds the RTNL here, so this will
just deadlock. Remove the extra RTNL acquisition.

Oddly enough this was all true even back when the
locking here was added, so this is just a revert
of a broken ~13 year old commit.

Fixes: bc52aab380c7 ("ath6kl: Protect ath6kl_cfg80211_vif_cleanup using rtnl_locks")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20261008165646.48866f0521af.I1c166be830384473f67677eeb187afa7e54106ea@changeid
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d96cc8dba2eab..c306004f25474 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1551,9 +1551,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 	ath6kl_cfg80211_vif_stop(vif, test_bit(WMI_READY, &ar->flag));
 
-	rtnl_lock();
 	ath6kl_cfg80211_vif_cleanup(vif);
-	rtnl_unlock();
 
 	return 0;
 }
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041154;
	b=rxfzDr3qan7RMebt0CS29AIxecsDDAt0rj522o2V4nQQ/7F5IhZksKxKfC8ibbmJWw2d
	 fmsnXPkTXNt+RsYnSTtsT6V4rXccTNLEo/yNng4jIUFaDFYCObs8GkD+sn7vQzMgi72h4
	 5Eoy95ngqwDo3ZU2OpMuUmLWxshrBI625EpS2gkOitvc4PZzoN/t7XtX2XIVYBJ7OCSh3
	 w5yEMsLKzS837opi92kzjxzZ8eI+wfG/D4RWT+hB5etnkkJnbrcSMdD4gjYmUgRD0tocw
	 17bozA3gV3sAOXRgeRdQ+RmRRBjCXvFdELme4l5B2EYoBy+d9Y2Bi1lbpetICdSv6rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TLTwHYN2fbx3eKh/W++bUgACdh5gMMcxdpl8QJRrgkA=;
	b=oVdk71yv8iau6c3fTTVzWJ6RMqz+woyIY7XLdzlHQheddPwTZ8HxaGed8HR1tthqNXKW
	 3wmtJTZMBNrxoY6nIXTKMlr8+WirypSfeTmt/D83HNQZR8sXl/ckTBy5QhMv8ir9rzSgU
	 QMOJAvpCaRN/GZOIn9z/QOphA1Ww6KXPuFPMMvpxjETje3L899cTyrXdAKEoqGVsDoe8q
	 EVCcfAeX8uZODwCErGwIzJBawVZlnQ+FfWbfvLzC66W7kGyJcWfK5l1jaFcMjo5Jlleth
	 St2Ul5QKR3uHKnXxLUmC8B3EaOHDaLOQnHqiFkM3vR7LIf7cAg2q9AwfopfGfsE+NYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJr0yY7W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C02606A31C;
	Wed, 18 Nov 2026 22:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJr0yY7W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6057B1F000C5;
	Wed, 18 Nov 2026 22:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041153;
	bh=TLTwHYN2fbx3eKh/W++bUgACdh5gMMcxdpl8QJRrgkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJr0yY7WB7RZLAZqdi6vFEtrKsPsJCbs4M6hRIo0wZ74WZETQ09KxKppD1UZdDCzS
	 HjHc0G+sj0YlJi18knkDshuEQMiHGhHRvajXOG+WgWecQqIAbs+Cbna1xipHE2Gm+w
	 OvboqmKAOG3WS6gHdbMQ4YhZzEsfOJaNxSoXaOhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2710/3318] wifi: ath6kl: dont take RTNL in del_virtual_intf
Date: Wed, 18 Nov 2026 15:55:32 +0100
Message-ID: <20261118150442.183424579@linuxfoundation.org>
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
index 77404c7e70414..2c0af3254455c 100644
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




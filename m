Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060765;
	b=48vlH2MZa/Vehxji5jrNQYEnhfrCVWwvKRvUNj04pY144HJFSakK5tAAccJ1+PgZTNDD
	 l6hx9jFVuk3CdvZjLAHSngjxpTRNtSGZ9yC2SNm9wrWzoqyBxNemvvS4RyvPeBOuYjv4W
	 GQdhcL2iUxmGdvb9FqyEZLRayp5HFLWakSGRAXNXOajPf198Mvj7o2SzuSP/A/f5xc7M5
	 IxPvdAVwvyhwsikvbezFRm6DJgQg47DqZVF+C5ZdyB7JHi2zP+RyK1q6lgPO7MyNwF8NQ
	 SKAJiFfBJsBFu1Sw9/1fobotaIOIHduHqFbBpUVEDOnB4ikbIs/mmRXSaHD0Q060++Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TgrfGgp+bIjz8FJ5MxX+RDXb559kg7BBdh38LkFhdEQ=;
	b=l7qzVQ75Ph+Gf9XbxFS5/lV8m82L7+z+PCoGwUeRvYtOF998ax6sGdzKZHJGqMj2MYxp
	 AGvH79tmF9qZLzCRWc2QwYpqySKUcYLdU2ohvJW+OqXxpE2ILOYTkYvba2WNApauYhmHk
	 8ftcSe2auPz1QKhICH/ZJFeROHScKxAIWvTRVxCyszXwjOppTCjsAD0Oo2nhi9E67pwIo
	 LeRPrjBDdGo2654g68CSxqlnpq74NW1WtjYi8w3DBfvBM74FCklnOeEuJbVBmBDrsccgc
	 igAcz5XWswRuv0XJSglEW0XyN5eOPpRsfYs2WL1d7BUwfBXtCuJcWh+ZMeXjgtx8VRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dWXm8bNL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42439606A32D;
	Sat,  7 Nov 2026 14:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dWXm8bNL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35B81F0089F;
	Sat,  7 Nov 2026 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060765;
	bh=TgrfGgp+bIjz8FJ5MxX+RDXb559kg7BBdh38LkFhdEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWXm8bNLvGdi6UwlC+SrqxKOte2H3ULEYL7XGp2sK3dBrXo1ywg6Wnn0LXURTGFL0
	 EXdcUw8cMYET0chT1AKiHpaOybCr27/1NFlx//xOpqgCMZ0po6PoAQm6E5h66v7UD+
	 vPwqsl2p5xZ7zG5p6pimNaO/bW7wSQYW3g47lGh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0177/1536] wifi: mac80211_hwsim: clear PMSR request state on abort
Date: Sat,  7 Nov 2026 08:36:33 -0500
Message-ID: <20261107135002.630632326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 37a77bd1395e8261d1760ae39c7f5eb637300550 ]

mac80211_hwsim saves the in-flight cfg80211 PMSR request and its wdev
in data->pmsr_request / data->pmsr_request_wdev when a measurement
starts, and clears them only when it reports completion.

mac80211_hwsim_abort_pmsr() never cleared that saved state. cfg80211
owns the request and frees it once the abort callback returns
(cfg80211_pmsr_process_abort() calls rdev_abort_pmsr() then
kfree(req)), so after an abort data->pmsr_request dangles. A later
hwsim PMSR report then dereferences the freed request in
hwsim_pmsr_report_nl() and completes it; a use-after-free.

Clear data->pmsr_request and data->pmsr_request_wdev once the abort
matches the active request. Move the wmediumd/virtio notification check
below the clear so the saved state is dropped even when no notification
is sent.

Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260708195911.84365-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index f1b96cd1198c5..71f07e1a2a972 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3609,9 +3609,6 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
 	int err = 0;
 
 	data = hw->priv;
-	_portid = READ_ONCE(data->wmediumd);
-	if (!_portid && !hwsim_virtio_enabled)
-		return;
 
 	mutex_lock(&data->mutex);
 
@@ -3620,6 +3617,13 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	data->pmsr_request = NULL;
+	data->pmsr_request_wdev = NULL;
+
+	_portid = READ_ONCE(data->wmediumd);
+	if (!_portid && !hwsim_virtio_enabled)
+		goto out;
+
 	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb) {
 		err = -ENOMEM;
-- 
2.53.0




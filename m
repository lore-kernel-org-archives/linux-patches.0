Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829580;
	b=KrXMIQwY5i5IBbSIhZ/r5xI6Il4NM24aigMtTD5RsL3eC8jXbPlmfqx9HDOimo8SlExY
	 lX3YBb6Y2hBEt8ymuDQHNA8SV4+j4rBngO/a352bkbQKsM7M8uBDfcW6vOngC5a6mZjvw
	 ESonMd1ucVEibWvSmRhA2l0AoWzNnaff9+CtAZ6hcd8+8+qGLV7pLtHuddorH33bfGN2Q
	 +bwpx4qGE8kCVrUaYyWYT6at2XL02LzmpafyhlnxhvW5EGB2VhydhKfGTCDRMXEhEqjW5
	 XNxvh/nRt4iXi5NK2IAJr2o0zKCaZ5N9nNox5DmP9LCamyUiuiZgecUSKjrZsY5v6xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dyTv8Laz0GAMC/7uDXp8awJzD03Y/ZBaDFNdeVEiYr4=;
	b=Fe1TvzC19h10Zj9yfVXxY/Ldfmn7zXcVoU5D8vVcexk7kK7BsRvytc1SDYhqc8QdQXca
	 ZlAu6akrYMo4iPzPke2iOAz9F4/JdX2OxJ68vX/whZdvJEM+LLAee3SItGIw0irP673m0
	 I7NysSJ3/O/F72SjcGB810OlRlQxS+F4tdl22puHFYoFZ8FvMrfRqnFleNyRwl/yfBC9c
	 CTZWZLz4b09pWvRbEed9Vs1OnmnR+PCGD3+oGPIPdWp3ijug571BUXKCt1GaFfihZ8rOJ
	 D/DWIqsDkrVjQZJlwHjqyLto0jskIqpH0QX5xRlWbLhk/W+FL0fsnObPJo7Apj3Q1sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrZ2uq4O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B549606A33E;
	Wed,  4 Nov 2026 21:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrZ2uq4O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2831F0093A;
	Wed,  4 Nov 2026 21:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829580;
	bh=dyTv8Laz0GAMC/7uDXp8awJzD03Y/ZBaDFNdeVEiYr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrZ2uq4OOpA45mQswPar0EU5iF9dG6r5Immd4nWCZEldi8lk7R2uudDcVzH4isaDo
	 1IyAfUx/a8G59x6spOtPL/+T2eVTAEo2axLEM3ldCkstdj3ALcAewO178x0j+ZTpEr
	 Hde1Tu4JAaeM5hZSCyY+o+X/FeTnU+y6WfzdblhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0214/1005] wifi: mac80211_hwsim: clear PMSR request state on abort
Date: Wed,  4 Nov 2026 15:59:07 -0500
Message-ID: <20261104211049.807925066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 484198766efda..89794c724858c 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3654,9 +3654,6 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
 	int err = 0;
 
 	data = hw->priv;
-	_portid = READ_ONCE(data->wmediumd);
-	if (!_portid && !hwsim_virtio_enabled)
-		return;
 
 	mutex_lock(&data->mutex);
 
@@ -3665,6 +3662,13 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033832;
	b=bp/xhoAU4Cz1UtY6k8CdyrinDoBot6APh8BIJfgo+GxwSJuVrgeV8vmG6YZmFEnTl7vi
	 ZDHBbLPqpJf7J1rXz5ORoSwjo6aPVGko4ixQpf1BL7HDYwF9fArRCjtxfJEWU4R0EE27J
	 3MKtTS8z0hcVcnY0YDNnIjEE9Iq5O07L2OxkufgbnZRIn2uAQ4CKk8F3X4U8NmLZ+sloq
	 3pv60eigCPvY6iNIizz4cb1SxXLoLdw1VEAVW+elvwjCQ8tSLWgWL2F5AON7ruA0fmR++
	 LsyyGuaE8kBmj0sf6Rmdanmf8CvH8TYI9x2/1EvhZwURsnlOb06HOoGOb771otCGKmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ZZr+1xpKUgXcVEmexEgxKVL+PqraL13wgCJ9pDnntY=;
	b=EP45DMasi8xeYtaX6/rFja/UpJ2RxcyowTB8aW8LJnuTHFmudtLyFDCMXwQhZFdKxJmQ
	 GPkrgFBCFNNh3lkOxOCOMVyLLE0InTOWyXZrDtCIf6hg1ECz/2sGejOO+Aw+SUgnRRtlB
	 0T2PUkme+wUwlJv+bEBqQKYyaqKxAumd2tb40m43TvadlclmkhV+nkDP0X4YlyDRBaSlt
	 Bs/D50UlREcCRFjITPJSBbJu9DHZmJkIGymN9YS3GE9WgU0ptIgpb0QRZ8n2XU+KXe8jN
	 Gy11ikzlJ7VTVPTjGS26HHxgV0uekp+mHFgxsiCJwm/k/yoCoUwJG6EOTCGw2kBidnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0NjB1Wky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E062606A320;
	Wed, 18 Nov 2026 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0NjB1Wky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECD31F000C4;
	Wed, 18 Nov 2026 20:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033831;
	bh=5ZZr+1xpKUgXcVEmexEgxKVL+PqraL13wgCJ9pDnntY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0NjB1WkyxslAgEeJvE8HsH88DDQSe1Nu/AWrJitxgmXtZBuvwJZqQntocX6AmjEk1
	 xFtNQsbEV3m0p2y83Bnq3so/d+XjVGya5KmP7EeTyAeVroPfkl9dpjPAx1HDmrzyMs
	 pEeYUX1kWYE12c6zymeibBzOxxXruTad8nQYPFyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0153/3318] wifi: mac80211_hwsim: clear PMSR request state on abort
Date: Wed, 18 Nov 2026 15:12:55 +0100
Message-ID: <20261118150319.122060017@linuxfoundation.org>
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
index 4703406944353..6731f0a3de1b3 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3483,9 +3483,6 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
 	int err = 0;
 
 	data = hw->priv;
-	_portid = READ_ONCE(data->wmediumd);
-	if (!_portid && !hwsim_virtio_enabled)
-		return;
 
 	mutex_lock(&data->mutex);
 
@@ -3494,6 +3491,13 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
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




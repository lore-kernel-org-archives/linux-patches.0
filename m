Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210301;
	b=TKLWR72DiUyWP75B6ohydQF0jxbAcHi6vVvAYSmzTRBsEHCesXF+Oei2KlYbmjhEir7h
	 SK7t80YEKYUNlNg03QSn1q77yZodlSTJzOkqknAlSRp8eWp8+qDBnVnl8TNZsl+QTw1qk
	 tNwmfDCFHzpLl1+nrp6V3UHWTE1nRT3M+p4j3GuT8iHaRKlTpVyihGkVxifpQ4/kTWsOJ
	 b09Ng53kDXT9OHTZ0qwHkfJrc81tDBehIoXcl0UzRmZSZGZCC6uzGyngjtdpUOZb0DgMO
	 WKGDROgEcw354hrbJWwCurpvdAhNBznZCxoHibcZ5LuwmnKziEbvoix14mzF6rIeZpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1O/BpWtEaekIzbtaCV7z89BT2nJuOwUCKRvVMK92UDU=;
	b=uKAU8V1tMN+lHNUXGguSkoZ1m5a3k3vBJfqcaXQs2vmSfYugtgkklGMn/vVJ8We+B+3z
	 G+IASOdeww7O7aIapuwesyhnvVu5qjr1cIhtKUSOL5tIlv3uMrwxyx7g4JGIDWCQQRvpY
	 UntXcd36wWnzUZGQe/cka1IqMNcN2CpQ8GKauB3YaPuC5cko74nkiLwcqnAJGwISkaXLo
	 A8GLtou9G+rgbH4PK7CWo7aoeQSgK8AjV1tz413T570RM4nfhJSC7CiUw28kzHtX9ysdj
	 k8pt55r/UWYMcUP09Cwxn7xOu91r6jT/S/tCgv9Y8xC+ulj1bBVoWaxzJBjhzxdO+AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YARsLfnb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E09F606A31A;
	Wed, 28 Oct 2026 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YARsLfnb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7521F01825;
	Wed, 28 Oct 2026 17:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210300;
	bh=1O/BpWtEaekIzbtaCV7z89BT2nJuOwUCKRvVMK92UDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YARsLfnbcvULyuswif6hDQz4g6e/fjsWKMFNlBCAG8BxZe/OzOju+QglBLFhpQMXi
	 tAxuQ+9Gnbetm2HHYcWB7Op38dcF4jpbQZqDUuDVWthtujrqoIWR+5DlpFJen9FZe0
	 la8tIJD8tcBSTU4egRfOdMMV4BxCeNpUIt0ivFYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/168] ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for aggregated ALH capture
Date: Wed, 28 Oct 2026 18:00:38 +0100
Message-ID: <20261028165945.503295414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 746de48c3a250f0c264105dcbfcdf0c5001e970b ]

When ch_count is smaller than blob->alh_cfg.device_count (e.g. a mono
capture stream, such as a SmartMic, aggregated across multiple SDW
links), step = ch_count / blob->alh_cfg.device_count truncates to 0.
The subsequent GENMASK(step - 1, 0) then underflows step - 1 (u32) to
UINT_MAX, causing GENMASK()'s internal shift to use an out-of-bounds
exponent:

  UBSAN: shift-out-of-bounds in sound/soc/sof/ipc4-topology.c:2363:13
  shift exponent 18446744069414584384 is too large for 64-bit type 'long unsigned int'

Treat ch_count < device_count the same way as the existing "channels
equal to output reference channels" case: apply the same ch_mask to
every aggregated device instead of trying to split channels that
can't be evenly divided.

Fixes: 0390a102cc18 ("ASoC: SOF: ipc4-topology: use different channel mask for each sdw amp feedback")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20261008090130.15135-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: used a standalone guard because the playback-specific conditional is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 8911c075251ca..8e16ec8038382 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1690,8 +1690,20 @@ sof_ipc4_prepare_copier_module(struct snd_sof_widget *swidget,
 				ch_map >>= 4;
 			}
 
-			step = ch_count / blob->alh_cfg.device_count;
-			mask =  GENMASK(step - 1, 0);
+			if (ch_count < blob->alh_cfg.device_count) {
+				/*
+				 * When there are fewer channels than aggregated devices
+				 * (e.g. a mono capture stream split across multiple links),
+				 * set step = 0 to ensure all the ch_mask is applied to all
+				 * alh mappings.
+				 */
+				mask = ch_mask;
+				step = 0;
+			} else {
+				step = ch_count / blob->alh_cfg.device_count;
+				mask =  GENMASK(step - 1, 0);
+			}
+
 			/*
 			 * Set each gtw_cfg.node_id to blob->alh_cfg.mapping[]
 			 * for all widgets with the same stream name
-- 
2.53.0




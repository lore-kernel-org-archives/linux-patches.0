Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774184;
	b=IlSernVms5s5C/VkhJI8DRWmgEPbzPDQzEwcpRkHToN2+TOCVVcKZFeTtmZ1jm9H3UVR
	 evqusgVEHUjKcM5aEdaxDiR+UWNOoHT0KxWumUiEcBENSfop5z80bAG3XXzasUdborzUv
	 ZkzpAWj0jailitE8WW+bQtfANRvnVo4z1/MiXYgK3k/HAP8eiQ9/L3eyEaeNedfwTSjqW
	 sovXZlPJKP8zP9lz56aKO9bS83KM8ZhLnKQdxdpE5lbtMelr0BEeLxjFmH3UqCwY7gObw
	 FV2l72SACNnzwoJCXFriKGwoVm7UaMbd5v9L60uNMt+VgItNXq2Ex58ElATaGUbRXUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oTLfUB9GbkPUqyuXHJJT6PvaNJAW67KJf6tYZvyRZP8=;
	b=ErbUZ+HZfLHBubbzCDtJE9v9a4IdY3zek+4ANgMn881cUd/vFNBqQIz+cbtOcrrPcN4N
	 clSf8LkaIqT7B50TBDyuKr6yzo9WeNvkZ5CAA3HpF/AoSLDZKcP/Bav5eSRm6WBOFbW8L
	 5IixnfsqrtJ8u3n+G8CcezcOGhOmoE+GeWw1RDODamFHd3o0syhWRCDufAlw6t990ICG/
	 9ruo8TrpKOsjqd0veCb7eRrjEmGVqhwgY5Xz+N74Kd4B10m10yhW2T7VqQf+JsZLQW16b
	 7XOkDfpAZNy2UPIIKDFW7lvfwnaEYAydRGC4HzKIyhk8F3Lr2HuhRz6DSZa4jCcw+lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aStTkzbO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F9B60A2602;
	Fri, 23 Oct 2026 16:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aStTkzbO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A732A1F031E0;
	Fri, 23 Oct 2026 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774184;
	bh=oTLfUB9GbkPUqyuXHJJT6PvaNJAW67KJf6tYZvyRZP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aStTkzbOhwNoJikjyuHzY7GOF4oGs7spkSyvInTXep0FKLorDdp3emeXmNBjtrXSp
	 2e83gStEhcadY/0QSRGDu60ce9XD28mXPV9Y8EHgrzgZ5EUQwqx4GehbFYewS0zFJ3
	 qklNiwzUAJ6N7hsi4jhwXuh9VyBk1Kf9rDXvPFUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/193] ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for aggregated ALH capture
Date: Fri, 23 Oct 2026 18:37:07 +0200
Message-ID: <20261023163717.760304792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
[ sashal: Added a standalone guard around the mask calculation because the upstream playback conditional is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -2286,8 +2286,20 @@ sof_ipc4_prepare_copier_module(struct sn
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



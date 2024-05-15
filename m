Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF5B4CB5B;
	Wed, 15 May 2024 08:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715761625; cv=none; b=Nbk0OxRcii42DRBjcsgQWvxLY6ZljOzlnKQefzJLkG68YjLTs5gKTKl537Jk8vgMw06epm6Yx3McBGtLgI4ohhYZpQEn8MIYsul86328DfGZUBcWAq0KeL90nLMcVh+ea+wWg/YMU3azugXBk8fbN4dkhEVtIGtRBDyZRIJUp88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715761625; c=relaxed/simple;
	bh=+5BqGuTK9hufD0rN7YqMHhWU9YO8PmGpMCXhI7dJmMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3SDZGGHuIzUAAEhD0Ird5k0iqdXyALrWurJhchaWc4x18xczS4fx12L5E5lzqGizeWptbgtjviZ7B6btFHnToK7aG130zsbl6hshp9iBfWndIi1JLgPU8WlhwOXilETYo1/m8sa4aZMJFAogW4YEp21jcZYtOwoCrcLFYjDIkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/1crl5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/1crl5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83337C32781;
	Wed, 15 May 2024 08:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715761624;
	bh=+5BqGuTK9hufD0rN7YqMHhWU9YO8PmGpMCXhI7dJmMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/1crl5M37oxYEiPe4zFh7ChW50k9wPVfGNG/hhd9g7/e2qeYftYwqVvYvU0aJ7Y3
	 jOPb2vzpTDCmrkpCgZwlOJRoQ3n1cSvSdbp0x1zG7P6YglN0+cUpJQMPlchi2wSkth
	 xOCaXGdCPIPPpZAIkc8MLG4O9m0HeXUFMko9Eb4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Courtier-Dutton <james.dutton@gmail.com>,
	Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.9 5/5] wifi: mt76: mt7915: add missing chanctx ops
Date: Wed, 15 May 2024 10:26:42 +0200
Message-ID: <20240515082346.251843733@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240515082345.213796290@linuxfoundation.org>
References: <20240515082345.213796290@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

commit 2f7cf3b61d85228ae749b6cb8eda1e1df9d4926f upstream.

Looks like this was missed in the initial patch that made
the conversion to the emulated chanctx drivers.

Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Tested-by: James Courtier-Dutton <james.dutton@gmail.com>
Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1657,6 +1657,10 @@ mt7915_net_fill_forward_path(struct ieee
 #endif
 
 const struct ieee80211_ops mt7915_ops = {
+	.add_chanctx = ieee80211_emulate_add_chanctx,
+	.remove_chanctx = ieee80211_emulate_remove_chanctx,
+	.change_chanctx = ieee80211_emulate_change_chanctx,
+	.switch_vif_chanctx = ieee80211_emulate_switch_vif_chanctx,
 	.tx = mt7915_tx,
 	.start = mt7915_start,
 	.stop = mt7915_stop,



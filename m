Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E5E44CF44;
	Tue, 16 Jun 2026 16:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626364; cv=none; b=LaTohRdVi/Jq3MYcAtMYubU9FV7LKJCymV/0YosdS5lIvF1x3QM2Z/Gnsiia+Ar8oCaKk0r5Pfcx4Jz169GZHJo3NXyJIJ65Tzkn9AKMLSzktkNvhMFlJNypDlvYBgMFkqPd55gpfJj4GdSHkCxsip+OQkAYGDCU94gwWO/BeFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626364; c=relaxed/simple;
	bh=f4o8MGSgJXmNp3Ev+sbAog8wGSTot0KdnEHDaVzJ90Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGX1QCmEnQp8+KLzZrtlXy9q/Xwp8I7HSoYl0GzFt3/7HJ6g5Rdp6LaQ8DlyCNhsYI7WsIWmRhJXLVEbPxSTp+oZqIdg+0ko/MJrwNldigx0TfnLjGCMrgHicEGvUvUIhYrhKAgv4vYhfNoatqfmuq8+enwubKqlMTLTT/7nfOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xw5XYs9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xw5XYs9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC221F000E9;
	Tue, 16 Jun 2026 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626363;
	bh=1RDT6R4K7TLD9+2rSQtG9/jCYb6fAZftPPOGJY7TuO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xw5XYs9XRjiOdmhZnSWdYe0OUodLOsb2Bukt8sfpAL/qXQFlAVKjqggJh/1oD3wpS
	 GjqKrzP0QTHu738QygOdX67yNFmNBhsIOiyArfeM5UEONaB8UY3kP20YW7r6eSVukt
	 AIBfc5jwyxXWt3yBkE2nZj6vlPsWNJIcYy8/ITUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 307/325] wifi: mac80211: tests: mark HT check strict
Date: Tue, 16 Jun 2026 20:31:43 +0530
Message-ID: <20260616145114.290726111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 0cfff13c94cb5fa818bb374945ff280e08dc1bb9 upstream.

The HT check now only applies in strict mode since APs
were found to be broken. Mark it as such.

Fixes: 711a9c018ad2 ("wifi: mac80211: skip ieee80211_verify_sta_ht_mcs_support check in non-strict mode")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tests/chan-mode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/tests/chan-mode.c
+++ b/net/mac80211/tests/chan-mode.c
@@ -65,6 +65,7 @@ static const struct determine_chan_mode_
 		.ht_capa_mask = {
 			.mcs.rx_mask[0] = 0xf7,
 		},
+		.strict = true,
 	}, {
 		.desc = "Masking out a RX rate in VHT capabilities",
 		.conn_mode = IEEE80211_CONN_MODE_EHT,



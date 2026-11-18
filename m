Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057369;
	b=mG05tglEnVQH902h5jYQvvrHO33ZvmjIPIIWqWCWm4LWunuAIC1efgV4o6BX+hhMHYsz
	 lEU54Ykh3rQo1EbCXp+JrjOkRmWNfwfx+OBxEtX9nCT/GqWTAyFzVf7eMCsoWAh6Ut2xx
	 xTEC/WHyBxEiWiFjSpXILEW7rK0tE97Xng6Rs/mgHJaqPvue95e+0b2TUaKNe34rBhc6d
	 kXw2/S2Fnf7x4nN1bn4f3e4vpL57VraCBWNTfICpyu9ezg4Z1HcfhFqt2re0B1MzHOE3e
	 GB2Wc6QHq9NgPAIb0nv0hirZts4xegn+9hgOtNoXaT1mAsxjmSCRBJKGeo98qTHHkUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VTSjOST92GBe7cNl7mjpsQzHgGHxZ+WriatNaQJLAO8=;
	b=Zdd+Su3WnGzC88LQsi9gpWUQvIyB2RWg9XRc4fTPhRWpqYL4Oc22gQvF5t/uZ/pE1rBl
	 ijdYZIEBv7prU2HjlHLIOHH1/xmLE9b0i5hFmaTMxdmcwt9IedS8tnZw5idzr1h4vcFvp
	 ZEvmNXIXr5tZKp8z0MTESeM5wZa2ronyBecxHny703RCtQyIFi2ZHwKaT2Ay8lsCZtiDk
	 Op6+ry9PpXD5Sc81XqZ+mH78RJhwcj7PNTYykSDJm9b92MoXF+TYWTSsITRhjGsb/mNWE
	 lBtFhQW/ax6EgS23gFeZcoVpn1puuTg8crs3m7lDPGPHdHlXw2K9foj7PfBlfyahRPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oug0LBSK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1219C60A2607;
	Thu, 19 Nov 2026 03:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oug0LBSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF981F000C4;
	Thu, 19 Nov 2026 03:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057368;
	bh=VTSjOST92GBe7cNl7mjpsQzHgGHxZ+WriatNaQJLAO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oug0LBSKr68++8nWrp+2BOb8gIwcDowx04AAiwGDnTpTx8o/YSOKBV3NF7GfLZ62X
	 19aiTpeE3ArbgnHCCeypd5kJFMNMOf7cUKgbjPkQjROnjS9B6WUjbwyDgzfxG9ffgW
	 jqyDBxv0hKkVYpCNAtsq3xFEVX2ynbmdWi/6Jags=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0107/1848] wifi: cfg80211: include cf1 offset when sending chandef
Date: Wed, 18 Nov 2026 15:35:45 +0100
Message-ID: <20261118145915.528689912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 5a69b8dffd2a1b06e4cc4c9003c639eb78bac4cd ]

The cf1 offset is not included when sending the chandef leading
to incorrect channel resolution in usermode. Include it.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260721053958.227853-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 506d621212e44..e175593d8cedd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3429,6 +3429,10 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 		return -ENOBUFS;
 	if (nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1, chandef->center_freq1))
 		return -ENOBUFS;
+	if (chandef->freq1_offset &&
+	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1_OFFSET,
+			chandef->freq1_offset))
+		return -ENOBUFS;
 	if (chandef->center_freq2 &&
 	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ2, chandef->center_freq2))
 		return -ENOBUFS;
-- 
2.53.0




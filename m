Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620081;
	b=WWsklb4nmwysPjkhGUy9Yf3gFb4n/SqyAFkdM6Q7HvI4AIxbncyWPSv1XVa1RaZ7JL7M
	 vOiLFbTitMEWGCKtAKSdRaEYWoNngd4wV5mj0Sy0Kf78Pxy1ad4X2KofOymbAInJUhJWs
	 PNpyHJnYwEWWm8RSIYrrUnOgAJmKL9mJuGT+j6PEVunxVVjbqYL5MwKE6iqq5zywZ+Sir
	 K9l5ZajXuhZjwHYl4mseDQGHGs4VWdT9Ul7yQzWfDMxGP0sNE59zdIsKcYVHwKq62ncj8
	 8fOgC0LB+4HESXhjZTlZ3yiEE937VlEhV8Lm8rHzqYkILML/HCgdemBRy7EQuvO/GhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SFbKovdamuvplMViLGP+x+9DaqgJ5jkU46and3W0k6s=;
	b=MCYIBNzxBC/MC45Rj1ewHmVQl6kgyjNhK1UK/sp8jrW71rsRdEa+N6NstuFwWU24UT6r
	 0d+wFC6zZ8dIFtC+iYyS+LK3M6y7wDYdQbmw7uW6x4kSHMk2FMTbrpLziKsHL+byzuPwz
	 1nPSpXTpHaMW5jAcPH3vbRDy9JzpP2Cpwdcl8GGnzr6vRDnR+0Hzpii9Me8VEp0CuIi+Z
	 toNMxs06mqENbSuskmpueyirMxzXnp6KxyuFrizb77Ac/co0MxyNIE3prQ+C/URTBBQkD
	 2qDKpGx0mDdefKsd8FyX9wQBBg5LTb/ObP7OERTnLmiEW09qe0X9978CPkz+VNVRyZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=birdTN3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD23606A31E;
	Wed, 25 Nov 2026 15:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=birdTN3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A26B1F000C0;
	Wed, 25 Nov 2026 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620080;
	bh=SFbKovdamuvplMViLGP+x+9DaqgJ5jkU46and3W0k6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=birdTN3Hskzk+se7ybgEA3EiKGHhYUdBn1+9WeBII6UqjhBaUoUusvkWtuB9Fq5gm
	 UWGVlrQqrfaGiW32p3Eju10yw1pPtWvOsaBY9iphIzlzEJrt00V92eYYeoPFq9+zAd
	 5XZaMaHRk7/J6oJmF1BUyoFttKOANvI8Ex+OcCPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0803/1005] wifi: mac80211: reject invalid EHT guard intervals in airtime estimates
Date: Wed, 25 Nov 2026 15:35:41 +0100
Message-ID: <20261125143840.544863582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 582edbdbc5d288bd128b54935738fe38f15c8c29 upstream.

An invalid EHT guard interval can select the wrong airtime group and, at
320 MHz, read beyond airtime_mcs_groups.

Guard interval 3 advances EHT_GROUP_IDX() into the next bandwidth group
at narrower widths. With one spatial stream and 320 MHz, it evaluates to
264, one past the 264-entry table. RX rate parsing rejects the value, but
the common TX-status validator has no EHT check and last_rate_info can
carry it to the airtime helper.

Reject values above NL80211_RATE_INFO_EHT_GI_3_2 in the helper. This also
protects exported ieee80211_calc_rx_airtime() callers that do not pass
through the TX-status validator.

LLM assistance was used to find the bug and review.

Fixes: 3702a33216e6 ("wifi: mac80211: introduce EHT rate support in AQL airtime")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142212.14523-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/airtime.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/airtime.c
+++ b/net/mac80211/airtime.c
@@ -550,6 +550,8 @@ static u32 ieee80211_get_rate_duration(s
 		group = HE_GROUP_IDX(streams, status->he_gi, bw);
 		break;
 	case RX_ENC_EHT:
+		if (status->eht.gi > NL80211_RATE_INFO_EHT_GI_3_2)
+			return 0;
 		streams = status->nss;
 		idx = status->rate_idx;
 		group = EHT_GROUP_IDX(streams, status->eht.gi, bw);



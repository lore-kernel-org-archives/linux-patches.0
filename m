Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623319;
	b=YdmhIG0GMC1xREPfIMPXjTua4TRsj1Ye4B6ePT4FDCXCmUWCd6KmmReL8uknjRseFFeX
	 baDNjJPQ8AqMrvZecGzK0DSuXRL4Wp5AUfAQfFezIwm30ZykuDdDM6WCXXzP+7ihmT+4m
	 6+FQHR8bh7fdolEZRFd7NK6iBt7jdWNQwHF0ly6LPbNEgD6KTeIge57OHm4ulQpheuUGq
	 zTTBRttpJp8eqA/8uY8yq5Sr4t5qK0tRQMDDAjdVLSjyB0JHPFLTqFnOGPxqasoCM6QAj
	 QPVz7M9blae/4mZxHbJrRplIbz7adoyaUb8P+qMgVkpf+M/bgS1qSwlqduuIUfp77MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DxaLuTpiYuI4QJPN82LaRyb3MeZwnnh6G6i75J3P8X0=;
	b=cgMSjc7T6bGJtFaXc3R8glGO5dqOs6OTGfUmGNfdzuXx7jytWkoYSd+cqkKxb7LmHaOZ
	 SCGlAlObdem8/jCHQD745lK3UjtPv9LwxrFTi729gIEsbNE8CQ/qqDP73xskqnsrUvFy8
	 /HfJTwwKdZuaBIfIQ+X4sctL19tdv8fUWdfgpQKRCAe7ad66n+fFUiQ+07P1ScrQto0N5
	 Fm23AHQ1DqV0dZ1XEg+BWyMSZ0gDWP+L1DNwNyCSCgZCR2aEZ95oK1UO3lG4rtB9QfVhm
	 JFg5Pem3FkC53EoMXRxMzR5HFTCDeucS0d8muB5ejKFoKpoojNxV8TDRo0LpSLTG5KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6O5b5ii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7CE606A337;
	Wed, 25 Nov 2026 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6O5b5ii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885EA1F000E0;
	Wed, 25 Nov 2026 16:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623319;
	bh=DxaLuTpiYuI4QJPN82LaRyb3MeZwnnh6G6i75J3P8X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6O5b5ii9lR8Os2ASD7WaVE2NsXpFJXTXuNu2K5sRfQKIBG2/YnlKv+AGFSiTsj1N
	 quH/UyDaCi7nBPHFlFYgwPBzGyAZbkfteeBkOOQvFuqUnKIL2sXc3oYWQYuulCThgt
	 KmmgJG33uJDYFdIA9MwfqaaZmUbfPphj68hnHB7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 819/990] wifi: mac80211: reject invalid EHT guard intervals in airtime estimates
Date: Wed, 25 Nov 2026 15:36:26 +0100
Message-ID: <20261125143841.224377085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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



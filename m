Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020187;
	b=01LTaxHlQaGW3wMqFBNILZzd56EnXmdFfLqtRct/mYn7YLeFJ5vYUleXOhvgnXLZreZH
	 Msw6pegtVVViGEqJ7sU3Lv3QoW9SKKDLJQe9sHSwT8jeH0eMUVfhI7OXVcfL8GoYfLu6K
	 j51SH55IWFhJIMoJDQ5XVUoYTAJjGcXMu0KRTZqmDlI8QEA1PWxv/TabUqph9e5g2zQRo
	 kHpbSpQZjqNq476OrHnhbgScVf/+1KFQSri49hljEGqgsS0ToBn7zcNlGON+myiJ0MJsg
	 JmZD1copBIOAc9Ft5FtEUoP1TG6Omtf9HAWt6fET6vjW3s/FZ2fp0cGue13zEwhU+lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=71uBsFO7lYVFuXmBRqH0b39TfvU7Fl6TO28Ed53hnxU=;
	b=ZyT0EeWg5ngfTYtNyC20jVFekxPQRfwWFFZ4UCJ8m8HGU+HRQ7Tb4TKclVizZ6eIZdN7
	 UxbKmCJXq/46xealuugTMA1i2JSYmZ8mbSAP2KMnXvoq+IiMRT9Jtw6wkxj7tYpTf9dN/
	 wCGarEoiVNz+oV9dfkIks+q8Hb/+M4F3I1IK0uNin2oLcWU2syvntFtOXDUdNGlQBjp9V
	 0Dyj0pOQyOuNitAwywSKZkqxMd3OLKRtbj5glIoJoPMGP9S6rdBBmobHwFby9Qrq4rgZx
	 e8RsnBc9xSmm1/XUbN9cOysssi/JX3IjvhN998emRbYowslECBh4vdGn+27UzGwSuPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEYs9nnz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F2F606A32C;
	Wed, 18 Nov 2026 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEYs9nnz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B941F000C4;
	Wed, 18 Nov 2026 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020187;
	bh=71uBsFO7lYVFuXmBRqH0b39TfvU7Fl6TO28Ed53hnxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEYs9nnz0YmviqgovfYUXWxbs3NwoX43+TXibcb5PHS008fnGGKotn/WV8YwxU+yb
	 LUPFY7ryWIIou1HRvJd6VUQpqYoPTYykN4YjfzJTG0cDaiwpIYO0isnWei/Ronhtx1
	 1xHN3Ysw5XiNMFzbSTPcu8xVEj+3o2tiIkzmKV6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Endrik Einberg <git@endrik.dev>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1835/2651] wifi: iwlwifi: mld: include VI packets in low latency detection
Date: Wed, 18 Nov 2026 15:51:15 +0100
Message-ID: <20261118150353.170979493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Endrik Einberg <git@endrik.dev>

[ Upstream commit 3627924ed81fd7783394fb2555ea179c6606a231 ]

iwl_mld_is_vo_vi_pkt() checks whether the mapped access category
is less than IEEE80211_AC_VI.
Since mac80211 defines IEEE80211_AC_VO as 0 and IEEE80211_AC_VI as 1,
this only matches voice traffic and excludes video traffic.

Synthetic video-priority UDP traffic does not automatically
activate low-latency mode, whereas voice-priority traffic does

Include IEEE80211_AC_VI as intended.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Endrik Einberg <git@endrik.dev>
Link: https://patch.msgid.link/20261005144225.170280-1-git@endrik.dev
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/low_latency.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c b/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
index a4ddc32e28609..e7482623111c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
@@ -257,7 +257,8 @@ static bool iwl_mld_is_vo_vi_pkt(struct ieee80211_hdr *hdr)
 	if (tid >= IWL_MAX_TID_COUNT)
 		return false;
 
-	return tid_to_mac80211_ac[tid] < IEEE80211_AC_VI;
+	return tid_to_mac80211_ac[tid] == IEEE80211_AC_VI ||
+	       tid_to_mac80211_ac[tid] == IEEE80211_AC_VO;
 }
 
 void iwl_mld_low_latency_update_counters(struct iwl_mld *mld,
-- 
2.53.0




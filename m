Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038167;
	b=DgeNODFG5WibYkk5SsZC+03/1GTaN9L/TISVRQAmjHxU2ipRr2ODAvTabb6/UIfI4UZ7
	 Y1YDTiwHSa+3N3+05gdPHES5Osy0kAhNXU6uPT1Ba8+swzCeGpDQ1DEpHO1voA9qg0K17
	 Qxwf2MEzAlkBWiYF3D3XevGNFDOsPGEf6KP6Dysu6MtuGtaPRt+ysf1b7DQkrXtAub5G+
	 F/KE4lc914TsforXH2qX8l+ovThD242uE2cwPGZtr9K9RgTUvTLScMsm0sUq3pnEbCOLS
	 JKhaMpx7NooWdSEALHL3ZGBOmglazLa64MGkQbXdSQV102cFGmCNpO3yyv92t2ggmeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YeTk58rw1sCbVO/ld5PsyvUQvDhrA3H8RY17YUt7JZU=;
	b=iQioWHALoftW/FDdKqvQkEP6pUEdJEllEDg72soAFJb5+tSNSjsMznVBe9GqKR5YQ0WK
	 8rLkkSO0ZwKSvtIqq5tVnk3MLNytv/sSievJz8XrRjCG2nWJYmDreWt0VudoLxUhTHLaW
	 rXM/HkFbulTx5EbPbSAoO5Vg/wXK+bG03XExBbhjFiZnROZgQRjr5lxgJZOLzeFhZzzKJ
	 XQqQky5fmVxaN6IQ8d72JzUCqM1N63KLHMZT6wbXqiSjQRm0pA7q/2/xT74TKdhuHjgoW
	 RcvaK0CwWn12VuhGraU6CS+xZd/fN087L9rDEtNRleMs/v1Cj9G+Cr5M+MNjQIWWRkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAKyjlSp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6CA606A32C;
	Wed, 18 Nov 2026 21:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAKyjlSp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296E41F000C4;
	Wed, 18 Nov 2026 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038166;
	bh=YeTk58rw1sCbVO/ld5PsyvUQvDhrA3H8RY17YUt7JZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAKyjlSp8Su8MjXVYvULyc8EXbVXvDaTYzSl52ZMGQjyQ7SHKGXBTvel5S8jLL9Tp
	 6FKQu+s2aVlZ5ehs+2Yh82r+xuHCBOWUpcP/kHCPmNe20hB3HgMX9SPpR7iZjD/LnB
	 YZZU4ANZO+/F0yK7Hj3/DxLwtRrzMX1AhQyMeA/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kexin Sun <kexinsun@smail.nju.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1608/3318] wifi: mac80211: update outdated comment
Date: Wed, 18 Nov 2026 15:37:10 +0100
Message-ID: <20261118150409.426048545@linuxfoundation.org>
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

From: Kexin Sun <kexinsun@smail.nju.edu.cn>

[ Upstream commit b8a57b979a7c2069081ed0bf88a727b17d85ac96 ]

The function ieee80211_start_scan() was refactored and replaced by
__ieee80211_start_scan() in commit f3b85252f081 ("mac80211: fix scan
races and rework scanning"). Update the comment in
ieee80211_tx_h_check_assoc() accordingly.

Additionally, remove the broken gmane.org link in the comment.

Suggested-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Assisted-by: unnamed:deepseek-v3.2 coccinelle
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
Link: https://patch.msgid.link/20260228061944.887-1-kexinsun@smail.nju.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 13e51269b665 ("wifi: mac80211: queue frames while off-channel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cf463965b8d40..14513d4fe6329 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -301,10 +301,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		 * active scan) are allowed, all other frames should not be
 		 * sent and we should not get here, but if we do
 		 * nonetheless, drop them to avoid sending them
-		 * off-channel. See the link below and
-		 * ieee80211_start_scan() for more.
-		 *
-		 * http://article.gmane.org/gmane.linux.kernel.wireless.general/30089
+		 * off-channel. See __ieee80211_start_scan() for more.
 		 */
 		return TX_DROP;
 
-- 
2.53.0




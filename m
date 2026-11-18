Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046651;
	b=SNChGstYZJR/jHOBBGQzAGzXqs/Rw3d6OlawiMekzv22Q1tvRxFjeaGSw+asTOh+fgfW
	 XOyAOqa3Poc7kTkLEwinTrpa1r5yqkZXg/yafGIDhjR2Cfj0jRWEbIlrMEcjWEx4xuEBE
	 tNqs2gFjAuR3tDMPnE7ux4eYpbuNL9x8e5eOiDqaI6ixoRmbkC/65RsdjT4yyJNaaHFFF
	 70VlmBJ2auudO6W8fExOQ4xnk9nGJn40HyExu26wJCDCqRPAMFzLxvJv46pQWeqgW7lyO
	 MZCOAcYYkTBBToPx0Bg8Yj483zAGXK+6SoHGs9vesljL5YzVeYhTKLHMdwqtCq0PB9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P+zQ3e/hS01s9Uhd7Etgka9cU/8lz/tGNDD+ze4y0i8=;
	b=J/yXClVvAtVmMNnwbynTWBTBat/qxFFQFBBMK/eVxfDpgFwXoViv0VvpkFSGCsuZ3RO/
	 OeO7NDgU2/8OoefZu35Y91rm3ObVMBzgftLvjHnREth/0U2YJ2JWtkeV5hM0H2ufvMaLJ
	 23+GyRIKKwHIReH8rly6/Su14Lm6mGnjD2ynbMWb4xja1IprYro+UFUUt1RQfjE9s02G8
	 8Qlh3TbHdQmQK/aVqLz/9USfdFBetFRFtZT8D8fr7BPg73hYzTAU8PR+TyGOLFOe+zdXQ
	 OthONnUYln69MT9PEUKLDbxdaDTakghe+AyHzpZU9huX9y81N25yHCivm0Eti09JR/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ne4dWZ09;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47920606A320;
	Thu, 19 Nov 2026 00:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ne4dWZ09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCD71F000C4;
	Thu, 19 Nov 2026 00:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046650;
	bh=P+zQ3e/hS01s9Uhd7Etgka9cU/8lz/tGNDD+ze4y0i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ne4dWZ09DJIPD1BO8b9dEHaeCl/5AnetPbDY1xkBxMeWkEQyuqxtEXv4rFCp5twkQ
	 FcqCJ+eHlBYBn9Vj+VzwCB1xFDvSCj9P2DipFsu2EQjqMYz2tdvKu+GXJRriBA9VlI
	 emwkPRRQkQWmwQVwRGBFcgeDbBZ/Ik110G8FkJ58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kexin Sun <kexinsun@smail.nju.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1357/2857] wifi: mac80211: update outdated comment
Date: Wed, 18 Nov 2026 15:39:51 +0100
Message-ID: <20261118150250.266778012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 51cf8c4e0e90a..36ea274efd051 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -300,10 +300,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
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




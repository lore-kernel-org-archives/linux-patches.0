Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212535;
	b=2uVUhhIcEt5hP5UIvdolRLMf68k69hUkw0e+/NTym/Azn4YLWxxIAwq2P36Ilb4A3IDL
	 4frWKGDVAJ7waACZmDXmuSwF1gkCDyuacQSiq/OBgkI61qmkgEtdf+RnsXfOaO2ylWD+5
	 e7nvqKOTKicA4rBWfG8lwOZ3u2AvWf2qq0kMcQPhJrtsUaFFlNBbYXX5d7yvyfyKlTIiX
	 GT3Sa2aHbPefSlQ9c6KHiAk/AQVloHphgjXPGP6k/NaYyPPAOvkugo8yDWjqTKXIakMJl
	 AH1zJPId8zCWy7Wv/pTNHQtEC3L6O6t3uWivjb6Xe8mcQ+9ZJjPfny0hWsO2GQm6VBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUx7rCjhTFyqQzTc7x2km+p/bVF1e+rwV119uqNZ5LU=;
	b=xhVJjDzadM3PGa+FbjSKTutf4gfZOSeyVf3B2f8I10GrhCEf+hO6Run22oDBT/xdy+UB
	 7VopJXdB5cgaN4m+2qO1Faqd5yiTe5/KCJQFZTvwdVQ+p29ZiBH9Kjxy7JtYfucMN5wzs
	 0QldZXOceq/lJ+4wl7B+CrrmUjiug+qJDGDGeHFCAxitKdr+VbSyotB14nmJS/rQpIQXt
	 iCptRbJx1g9T2qSJtlm8Pw98uaDDuKCkEbV/fAJ9hdwWR9vUEcziyiq4tPYIbB5Whf1yp
	 dK3cYssV9BHL3+V2kCzgGSRKhtjCKynMm4R+dpWQF5dzt3h2oX003IPuUG7uDFo3yog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7TI7NIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B68D606A31D;
	Wed, 28 Oct 2026 18:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7TI7NIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB961F01829;
	Wed, 28 Oct 2026 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212535;
	bh=LUx7rCjhTFyqQzTc7x2km+p/bVF1e+rwV119uqNZ5LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7TI7NIU4uLE90mJd63Sb3Bsy7Bygu+6ur/hZfkwuezD5NhEQ96ZDuMBdsW2k1Da/
	 PiAi28Qzou/GMbb6PCGmo9HFgDEtR+vj8R8rXYQ+N/8V4Pctn2JD9SiczJ5UgGSpgS
	 mVlnCPyaeRI9mQDlLMuBd7hFu9D5JHtTMSwOIfEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0187/1887] wifi: cfg80211: avoid double free if updating BSS fails
Date: Wed, 28 Oct 2026 17:38:03 +0100
Message-ID: <20261028170503.490769871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit acc44cbd7727115f9381c35c2898b1b5af665ec8 ]

cfg80211_update_known_bss will always consume the passed IEs. As such,
cfg80211_update_assoc_bss_entry also needs to always set the pointers to
NULL so that no double free can occur.

Note that hitting this would probably require being connected to a
hidden BSS which is then doing a channel switch while also switching to
be not hidden anymore at the same time.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231220133549.8891edb28d51.Id09c5145363e990ff5237decd58296302e2d53c8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ecf9021219380..a8901e07e96d6 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2695,10 +2695,9 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 
 	if (new) {
 		/* to save time, update IEs for transmitting bss only */
-		if (cfg80211_update_known_bss(rdev, cbss, new, false)) {
-			new->pub.proberesp_ies = NULL;
-			new->pub.beacon_ies = NULL;
-		}
+		cfg80211_update_known_bss(rdev, cbss, new, false);
+		new->pub.proberesp_ies = NULL;
+		new->pub.beacon_ies = NULL;
 
 		list_for_each_entry_safe(nontrans_bss, tmp,
 					 &new->pub.nontrans_list,
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705530;
	b=2C0Mh+twZsllk/asbA8Hquewdog0Xq+NIvEHaWn3m/bmycx83eBDYUz2PyEyy0tGlAwK
	 BvgOspeEKrqIbqpZcEMMfQgwQA5KiAgNM8prnX2XjTEVJSZC+NtZDNkdV17Mde6RGKMvF
	 hl9qIyIOCCUnCcNQ6i9mepUWIoSuJYbnK0agVq9A6egmsC5GHh+27oHN6gfLqafGc99NC
	 dVJwCLxTh7Rur9Kve5t2MlNiZQRwgTEbeGKcF627wmdI0WqVxJi+ZZtgYSEJC38yE9YwK
	 ziD0Nvbct30YEo9wVUWUmPeeXt5o1r43u/QJr3frZx1ndacYNP0Z3hPGCPrmZBMIJ2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eCHCbkzBb5dsN3PCVdK996mtZvG9RH2etaTke5eheE8=;
	b=puvgFpTrNR4jmu7s4tqpJb6VqNQ2xeJ7AM6bDxA6QL/DciwVar4BzUzMAymN3EpE3YJt
	 SpTOqecBt38STnudLaF8hNFQEoFn7ydDp2KeiraMASccNWfWGdII4aOHqevqVb/0+Pgxa
	 WSpLdBvKeXPWqGo9z+WJkd4PunKcFhDuagSXzWEVptsDhdAAHtofYDLe2uFzVL7+xGj/c
	 srZ/5AkW6D1bJDg6wMmnLMhmbDtuu0Dyg3A/I6MbmMa2NyCDuZ5NXa2gC8UQhFl9qNgVn
	 btqDq0r1YF2va+eB4+iMPgqGQVvrM6+Qhk3yO1nHThvR2QiOcY7YI0AOsvcf13DBliQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Otp6Gk6F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E35606A339;
	Thu, 26 Nov 2026 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Otp6Gk6F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D811F00A19;
	Thu, 26 Nov 2026 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705530;
	bh=eCHCbkzBb5dsN3PCVdK996mtZvG9RH2etaTke5eheE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Otp6Gk6FO7OEbYEwEmuAkV6MWlSM/CEOIYGlg1C1eb9jrARad0pPSOBkIn/7zVQh9
	 G1dfDvfWjC6ULJLtoJV3aGQsin8/AdvX2Vyc68jheBrYYfFw2r/Fle1O4Q2Cjna9WQ
	 UTrrdpJPWGZz8xFE0lbk5RY8jYOB/rQMaXHwj9Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 230/319] wifi: cfg80211: release rejected nontransmitted BSS reference
Date: Thu, 26 Nov 2026 15:39:58 +0100
Message-ID: <20261126144011.940922699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit f3c45d5b741a7d7586e639c2f55d2557029f2e1a upstream.

Repeated MBSSID reports without an SSID can leak BSS entries outside the
scan cache, where the BSS entry limit cannot account for them.

__cfg80211_bss_update() returns a referenced BSS. If adding it to the
transmitting BSS list fails, unlinking drops the cache reference, but the
caller reference is lost when res is cleared.

Release the caller reference before discarding the unlinked BSS.

LLM assistance was used to find the bug and review.

Fixes: 0b7808818cb9 ("wifi: cfg80211: fix BSS refcounting bugs")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028141731.6185-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2109,6 +2109,7 @@ cfg80211_inform_single_bss_data(struct w
 					       &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res)) {
 				rdev->bss_generation++;
+				bss_ref_put(rdev, res);
 				res = NULL;
 			}
 		}



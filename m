Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620190;
	b=kMpeGQZKByOLbEjrhr8e5p/ReBUlO9NceyVWAdVTk85YWPcDHr8JcLYRTPbTEga8PU/M
	 CgcVLiIbWkQjz2EkhIJDDWT85eVozYEQcNDmHNrB6lV3gDhikIWOlNvubgpEo/SRdlYly
	 1wgQ9fDnZeltixDtvN+ZeN08Yz1XyNCQBFkORxevQOIjpa6ErNiLoSYvjJOaAfOcMVTRl
	 YWGO6a3T/q1i6658GCWBa687XRoLpuq8nazRhThtpHLeLPhA/USTYG2YIEPNjrItrCW9G
	 ofWKBPn0CnNlMg3NfRsPsQGKmz2CDkDFhrfsu7wKR8w4O9d5kgEG9kLZG8TKS7CsZGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2oewGqZEp6SGsyebBVxDylVq8gNZaFr0WglFM56Bs14=;
	b=dC3G9sjaDdALO7FVP0lZERJqpN+fljl9nrz4w5mp3bqkgsd+vDqsfUj/u4tlidbxzd/D
	 IM+qTjvMz6KHdUXFAcSxW5lDH0FdSCnIncy9piXsdmXdSwnbBFdqmopWJt9TayUsUwTHv
	 4wdxqPHTmEFtL6waRlj2ht7J2qb8DF/5xAoAaZj4E4YOSZsf3GFUROmuWjCA9+Fu8TKz/
	 aLbSU58yXlCy7Hyp3bSnJ3q+fMElpx24n/VS+sSx9XYiwHOBJOCsRuB8QaQ1E5XL2EhIo
	 UKtEP073I4bV3b4hu005mE/7Z4MzXSRdTpcL9LEqwfkRRZ7Vw5jYUwMRjZW9pnoCO0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwdGpe97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525AB606A329;
	Wed, 25 Nov 2026 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwdGpe97
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9063B1F000C0;
	Wed, 25 Nov 2026 15:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620190;
	bh=2oewGqZEp6SGsyebBVxDylVq8gNZaFr0WglFM56Bs14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwdGpe976hDC7xFoj7EBKAEGAG9AUKGBYqNK7pUhs8SaR5beLhFFrbQ1HHa2fz3pJ
	 4m3aWISDj8M9+9kJ5ExSETiEIz0R7Cd5XK/79GPBU7erMXuq/MBcC/YJhXEF5kjw4l
	 +Tjs0JpVZS2AB5ehiUDlBGCNMLmaR9KBQB5SHeRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0793/1005] wifi: mac80211_hwsim: ignore non-generic netlink releases
Date: Wed, 25 Nov 2026 15:35:31 +0100
Message-ID: <20261125143840.314152442@linuxfoundation.org>
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

commit 989f47c56e48d442d79497a25ed946d029c4dc53 upstream.

Closing an unrelated netlink socket can remove mac80211_hwsim radios or
clear the active wmediumd registration when its port ID matches a generic
netlink socket.

mac80211_hwsim_netlink_notify() handles every NETLINK_URELEASE event,
but netlink port IDs are scoped by protocol. The notifier therefore treats
a release from another protocol as a MAC80211_HWSIM socket release.

Ignore release notifications unless they come from NETLINK_GENERIC.

LLM assistance was used to find the bug and review.

Fixes: 7882513bacb1 ("mac80211_hwsim driver support userspace frame tx/rx")
Fixes: e9ed49bf4c2c ("mac80211-hwsim: Add support for HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028141751.6728-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -7197,7 +7197,7 @@ static int mac80211_hwsim_netlink_notify
 {
 	struct netlink_notify *notify = _notify;
 
-	if (state != NETLINK_URELEASE)
+	if (state != NETLINK_URELEASE || notify->protocol != NETLINK_GENERIC)
 		return NOTIFY_DONE;
 
 	remove_user_radios(notify->portid, hwsim_net_get_netgroup(notify->net));



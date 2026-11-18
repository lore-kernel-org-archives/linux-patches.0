Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059395;
	b=E3qKLcwIPB9N0e7bwuTKQs8CdmPchuDoH+vHcDrKQaG6tWapBrZqoqt8C72s5bm77wcy
	 4yoJ4+M/eA+5SZraa/30dEeSM+wW4ztWdFCG7RJDq0Pkwb/0j0Q7VLZoYPe+VncnBZjOH
	 IszfiYOGs/mlSHuihVGITOs1YdKFvT0SHIzr//7sjL6bBLcit7M84cmpvkl+64XmYciNX
	 M8Lawj+1USPwaYGdHG43nI79aW9CHDhaec/dqPwfoKD9SakIMOzJKhnEaM0911iG43b2u
	 ur01f6mTW2jinvfT87XcPODAe/VVKL+7l/M1Fu9FkapjpBoffpp5Ms1tUcrPd5f0HVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2CkvE1xhMwmm59Mj9vp1eBdOhUFBDlR6/U61cRvcFwQ=;
	b=306IL7p6YnW9qddlVqyn6F6fRN+tYrw/d8wmDXj7kl1wNkZe4BDDTQOgpb/TRrsIkLXv
	 BB2xUmBav7N87o02x6/Ow5ndTSwR+zu/95NrFBTsCvoprrvy8AenHsaMC3Sd2OnbQl6Xl
	 MnQZ1xbTR6Xi4OjeDa5hKa6+193Xrnxoo8xEIRu94uTSFm5iNT+W5YU0o3LJQfkM5NcwX
	 gEeOY5gIxYWiA7P3TXrVM7grsQAf1GBojSDVcG0c8JTK7+0HnEp/Luj984J487bmzm+ii
	 OYsL2e7FGEKUNgKpZokQaFF/lc7U4JO8EyVUp8j5yHheEQmg1JmzCwui/XdLruVsmJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UPD0gOAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAC3606A325;
	Thu, 19 Nov 2026 03:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UPD0gOAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E501F000C5;
	Thu, 19 Nov 2026 03:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059394;
	bh=2CkvE1xhMwmm59Mj9vp1eBdOhUFBDlR6/U61cRvcFwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPD0gOAYLHQ2LXZxnjwYRhnvEutpiB2JGjm24Nj/5AL7y29DjBWBB3J5/q6d4UFjT
	 RGWtcyN+0rzhmXJyhoOtP36SWSnCVYCqG0QFQAreC5WNrE5WVI/SiQi1pawz6vyBqY
	 4JhU9qzM58eXp+Jp96bwqPX0vdI4avkj9HvVGQxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0799/1848] batman-adv: tt: send ROAM_ADV on each roamed back client
Date: Wed, 18 Nov 2026 15:47:17 +0100
Message-ID: <20261118145949.831874880@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit aff4d5d10f2dcb4a9b604e27414dafa1d51b6406 upstream.

When a ROAMING_ADV is received for an announced local client,
batadv_roam_tvlv_unicast_handler_v1() creates a global entry with the
BATADV_TT_CLIENT_ROAM flag set.

If the client sends a frame again before the next TTVN commit,
batadv_tt_local_add_roam() is expected to announce this return via a
ROAM_ADV frame. But this doesn't happen because the global entry (created
by the first ROAMING_ADV) carries BATADV_TT_CLIENT_ROAM until the new
originator announces the client.

Let batadv_tt_local_add_roam() always handle a roamed back client -
independent of the ROAM flag of the global entry:

* trigger sending of the ROAM_ADV frame(s)
* remove the (with the roaming) associated global entry

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ adjust code still in batadv_tt_local_add ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 23d34e1b48eec..1065003c99dfd 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -776,7 +776,8 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 	/* Check whether it is a roaming, but don't do anything if the roaming
 	 * process has already been handled
 	 */
-	if (tt_global && !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM)) {
+	if (tt_global &&
+	    (roamed_back || !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM))) {
 		/* These node are probably going to update their tt table */
 		head = &tt_global->orig_list;
 		rcu_read_lock();
-- 
2.53.0




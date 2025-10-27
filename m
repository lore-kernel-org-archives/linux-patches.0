Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D931578B;
	Mon, 27 Oct 2025 19:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591627; cv=none; b=n8ZvmRWPgOsSxj48L9VIoGBQfg3+v9TWfoZEbrQ0xCkYwPiphfPgPDr4yGozoyKEqawXdh4c+/IVzrkqiZplal0Xn28o4kAULL1ZfcuT3JTwMwCDNYrxTAfH5wz03ITlY+sxZ5n5mvHjFiqL73Gp/VBtFClxSDJB/7l2Kwr79XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591627; c=relaxed/simple;
	bh=m10aOH3Hx4z2HTfCpNR2nmexFi/rRqHqEOsaQCYjYdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yj5MPi9ObeMMCtCR9w5zHcUx1BOCoCig1tTTngHMjkt7aelUP6+3iWc2ARJUT0kaIL/WYzfR0hEqImCSd95Odv8BrXEt81qO6M5wX85NbYZPSgoaZUTEFS7M6e5O8gJ3dYqGy8bO10e/khyibTq7Q7DkGxSHTwcagE7lR9HDyNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lp1pke5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lp1pke5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50944C4CEFD;
	Mon, 27 Oct 2025 19:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591627;
	bh=m10aOH3Hx4z2HTfCpNR2nmexFi/rRqHqEOsaQCYjYdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lp1pke5g/hhAV8vRlLfYWCB7Bqnr+/oyfy2dOLsZEG+jj0iaHwo2fiWc9WV389FhM
	 BqWQELuF5BcFk8zfzf6iRBPH1cy0N1o0XDT6YkhqSFPNkIo41jFq34YfGkvoCQ2Gv0
	 2BCwT+Y+iUhwU4rqlqM+DlUquVWX8zzU8Uuc/U0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/332] net: rtnetlink: use BIT for flag values
Date: Mon, 27 Oct 2025 19:35:23 +0100
Message-ID: <20251027183531.990457641@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 0569e31f1bc2f50613ba4c219f3ecc0d1174d841 ]

Use BIT to define flag values.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 02b0636a4523d..030fc7eef7401 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -10,7 +10,7 @@ typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *,
 typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);
 
 enum rtnl_link_flags {
-	RTNL_FLAG_DOIT_UNLOCKED = 1,
+	RTNL_FLAG_DOIT_UNLOCKED = BIT(0),
 };
 
 enum rtnl_kinds {
-- 
2.51.0




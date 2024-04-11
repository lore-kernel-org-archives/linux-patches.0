Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC42145B1A;
	Thu, 11 Apr 2024 10:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831070; cv=none; b=IY2w5mnnVypRAvZvPGPa7xXq5xPErNCCHdnJJxACNIFbSyugoluq2RUk/UAhB4DO7f8co2wLK3tN2wxOJEd38kmhyrZWDUIHcserCdrh8AYdlZYXjQFWv29y3CPbybg379rSc6E1C9waXY9e0Y5CIZdVJG5OHzLnQQYZI27ZiyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831070; c=relaxed/simple;
	bh=eb9LJ7F8gpXikqE3WMSM/7ilkRiZpwPPcw01qYi5UFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uF/oafHayKd256d5M+Ad4P5njDNQZU4Qq4X7BE07pu89XbuRvvOiOfjvtptaj7/2rjitoKrXXFxwbjZ0QSd46d8rPlXTVCiimy9KVU3BNO2sa7Aatn2esQevzS0KNNb8sOMhQ7HbkV9thjWHtI9dlxTnFHVjXtIMvB4YH7L6Vr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Yb3znyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Yb3znyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCBBC433C7;
	Thu, 11 Apr 2024 10:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831069;
	bh=eb9LJ7F8gpXikqE3WMSM/7ilkRiZpwPPcw01qYi5UFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Yb3znyhE2cLQf5m1PuAxKOcCntxE1ukS2UK2h3mzQ4KwRrvp9Fu+5mbJ1PIEY5Nl
	 sNK2KRht5rlsbJonwmECy/sA6EkolZAxfCZmqb32zUHwhBG7iPIeE7k60Qa2Sy5emW
	 vsDDasOSC9K5rZ08Ml7VOzMgepMVGWMMhnobUUto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <eric.dumazet@gmail.com>,
	William Tu <u9012063@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 213/215] erspan: Check IFLA_GRE_ERSPAN_VER is set.
Date: Thu, 11 Apr 2024 11:57:02 +0200
Message-ID: <20240411095431.265015183@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Tu <u9012063@gmail.com>

commit 51fa960d3b5163b1af22efdebcabfccc5d615ad6 upstream.

Add a check to make sure the IFLA_GRE_ERSPAN_VER is provided by users.

Fixes: f989d546a2d5 ("erspan: Add type I version 0 support.")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: William Tu <u9012063@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1106,7 +1106,8 @@ static int erspan_validate(struct nlattr
 	if (ret)
 		return ret;
 
-	if (nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
+	if (data[IFLA_GRE_ERSPAN_VER] &&
+	    nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
 		return 0;
 
 	/* ERSPAN type II/III should only have GRE sequence and key flag */



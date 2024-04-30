Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E387217592;
	Tue, 30 Apr 2024 11:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476429; cv=none; b=RPEGRSmTDS+6HoRuhOvynNQD3vPEKdwoDQHxt3tHp1gAFWlf91bJPhvrXA0uvq6McJfnRqL9YYdNkw8yxvYSt3NvnPzkNOGwBbiFupzyVJgh+GrtAQg7IlisEss25PyVpM0xNJTOHj68f4IACqa1v5nEOFEx2FBO0eg5Xow6YEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476429; c=relaxed/simple;
	bh=VEwVqhdG8zplwv9hgvQQiIza+yj/i4evhYY6SypqrxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoNj4q4OLhEQj9ZK3vSGG7M6npBQnNDbiHqLqU+lGZIVWBzETE2RvNpe6Zje+k/X2QTeKhjXuS8yMssE20+5vGvHvUFdO1prOeKMAioE2NWsJ0KZ5hJ7ZeBbpkbHxk6/pnfN9by0yV8cfk9rTLceLRyHz35EaMkqeVMbH/6JBQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NS2dTeAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NS2dTeAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A440C2BBFC;
	Tue, 30 Apr 2024 11:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476428;
	bh=VEwVqhdG8zplwv9hgvQQiIza+yj/i4evhYY6SypqrxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NS2dTeAPv8w4oRbRhGbzyN/eNjkkepRX6UvlPs6TwveuSmbCO0PzgOUhXPYV2a9M8
	 RXER1o/9rpQYiFBoD+IqI2tgMSk7nmuTNGh5n+FaTWWdj2Nc2rF2141cOvWvRLAQtT
	 29YCg9AywYl3q3uRdLJuz2JuaNCWawsPw4G/Q1OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/110] bridge/br_netlink.c: no need to return void function
Date: Tue, 30 Apr 2024 12:39:58 +0200
Message-ID: <20240430103048.429387202@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4fd1edcdf13c0d234543ecf502092be65c5177db ]

br_info_notify is a void function. There is no need to return.

Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index d087fd4c784ac..d38eff27767dc 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -650,7 +650,7 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
 {
 	u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
 
-	return br_info_notify(event, br, port, filter);
+	br_info_notify(event, br, port, filter);
 }
 
 /*
-- 
2.43.0




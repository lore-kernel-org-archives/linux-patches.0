Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058742;
	b=YTsVulbN5lAwb9ORvaRC4dayXNonWiltPFW+x2dz2jjJt0f6b2CzqY1gBs5p/hTd913U
	 lBc+Yh5s3X6oJXJj0b8lZFD2KY+17xHSzPPRtTViK5sCpcwUgeJbmMWkqmDCIk0Ebl/yl
	 rzxGn+EuAdkUSK/rm73a0a/qV7dJlnX3TIAUse3MTdqzdjaNsH2bw4MWiwdd+8sTJ6Y06
	 seQsZAbS0cp37Tn9gyesHvVM8gt8NcO3Rnd2xoIvq82Z7xGN6PVVGQCJfaywA0vrBLBzJ
	 QedSVT6ThPW/a5PTncs+cbYWbEXqlt3pzX6FgGIZGw9dUDD5vS+a00LO4Hg4jYWt3mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BA5g831+4+4TVIT66zOk3xUj9LZwFYbWBbogHCcWVLw=;
	b=AdWk3kmCMZLUpPhOEn4vP9Yesh2fKPwyjZ3fll0sCmuZWjXdTbE3a7yx7OC2Ayc9R20k
	 4r/34lPdt4pGaFYf0QfGBWCRhNx1v4udXR/x2RATNHOcUw6gE/yi+gOHKWgVkJbJN7PVS
	 RlBtIMvE2xn2tiYRxaHU8UTwANeZ0l/cD/49lFBkOzZhWCVGjjrgdJIc5SVIQh2HAHYst
	 j9w4lf6Ev3hcj0SB1jWEnxTlwH8L3xEZQXZolvqh2WdfbBw7MXWsc2FUwJWBPg3a0aHNm
	 ZH5PGh6eXRzA7x2Qjg66covBlex2hMFFXTYlvFjETR8+mN3eIlksMqiiSxPhBOV9K4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOZviFUf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4723B606A31C;
	Thu, 19 Nov 2026 03:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOZviFUf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B311F000C4;
	Thu, 19 Nov 2026 03:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058742;
	bh=BA5g831+4+4TVIT66zOk3xUj9LZwFYbWBbogHCcWVLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOZviFUfjGcCiqcnh9DlGzwGWW5DLOyRuVmk/h8xF8YFxj9MkdeGx40ZHec/uDj3X
	 Ay5AQzFs06QH/bZZk6E6dUmvqN1DLQAfCiMmZhWIKGLpujDr9AA0L9KUjP1ic3iBWq
	 9RNsLq8XmsAsPSWOTfpsSpELzVK1unjwqcmtrl3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0594/1848] macvlan: fix passthru promiscuity accounting while down
Date: Wed, 18 Nov 2026 15:43:52 +0100
Message-ID: <20261118145940.258741023@linuxfoundation.org>
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

From: Xia Yan <yanxia@cmss.chinamobile.com>

[ Upstream commit b6743653d134c9ef8436e2db1be1ad4c1e0d0091 ]

macvlan_changelink() adjusts the lower device's promiscuity count when
NOPROMISC changes, even if the passthru macvlan is down. The reference
is acquired in macvlan_open() and released in macvlan_stop(), so a down
interface has no reference to change.

Clearing NOPROMISC while down leaves an extra reference after the next
open/stop cycle. Setting it while down can remove a reference held by
another user of the lower device.

Guard the count adjustment with netif_running(dev). Keep storing the
requested flags while down so the next open uses the new setting.

Comparing changelink with open/stop exposed the unmatched count changes;
the same issue was also described in earlier macvlan reviews. A netlink
test on UML reproduced both DOWN cases before the fix and verified the
expected counts afterwards. Repeated flag updates, two open/stop cycles,
deletion and bidirectional small-frame delivery were also checked.

Full x86_64 builds completed with WERROR disabled for allmodconfig, and
WERROR and KASAN disabled for allyesconfig, including the resulting
dependency changes. Neither comparison showed new diagnostics.

Fixes: df8ef8f3aaa6 ("macvlan: add FDB bridge ops and macvlan flags")
Link: https://lore.kernel.org/netdev/179170088566.434549.4699134797461783473@kernel.org/
Link: https://lore.kernel.org/netdev/20261016003009.2692872-1-kuba@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261022090809.12019-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index f6ad599252d32..a92e6c0acf749 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1580,7 +1580,8 @@ static int macvlan_changelink(struct net_device *dev,
 	if (data && data[IFLA_MACVLAN_FLAGS]) {
 		__u16 flags = nla_get_u16(data[IFLA_MACVLAN_FLAGS]);
 		bool promisc = (flags ^ vlan->flags) & MACVLAN_FLAG_NOPROMISC;
-		if (macvlan_passthru(vlan->port) && promisc) {
+		if (macvlan_passthru(vlan->port) && promisc &&
+		    netif_running(dev)) {
 			int err;
 
 			if (flags & MACVLAN_FLAG_NOPROMISC)
-- 
2.53.0




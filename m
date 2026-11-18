Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033732;
	b=T6d5B4zdNuIKCR8r7uYt7rXkgHMtosoYp9PtPB5OczFEspCmtqwlLEByDNyCC26QVt2r
	 IwuhNgN3GBoFhjCZwNu1VelvnBFrLVHfFacFHx4mYD6lZuKgJKzH8nEDBfnDpKm+hjOZF
	 72PMh14Wof0WCzyznWTJmniLeHeTukrm+eu4qxhHQTwf6krE8p2En/UGlQzVpLCWHEDym
	 4pWiNJEq3ADVqsMvAH7Th4vt+nwWtrLjTol2lNZi/v87jcgwvIxcNmPfanV3eb5H7DPr4
	 fg97TAOGM7wxz7blZGj/NG2n3mJdykTfyFFSsJCKJ0jfx2nwFvi4LjBh6CjPgjikxIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oU8qLa5/92dGMYgJs3MgJ8rrlBiFeQn5e2brW1Zkgvs=;
	b=Tjx6+m8J31hxerB8nocFGJZ13EEPcFXXW1f/6IvH37soS4k2HOoTKS5mQ9ETAeIr5mj1
	 DhEa9AyJxA3hx+0IeJTAnNBIFUNnkpJN0OLoccsBhGaveWeZyQKzhmwOPyjcNb3Sk3NgK
	 M3V5otIrF459wTRWIlWzhaGkO9U1DyMiC2X2h5gTaZNg4uyozeUW5PN4kwq4+T917Hb4k
	 EMACX3V2symj10OkZG++b+9ihpapFrHv1vnMi9/0xbwU2TH9lV3+ZUYW7fmElnmXlI4r7
	 YGF/Mw+g6GzUh526zsymuOYlY+Cn6KhVSjJ7MMs7trk3b9t6BWaNZhTcZh9QyPV6HmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aB1mF0V5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1865606A325;
	Wed, 18 Nov 2026 20:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aB1mF0V5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC6B1F000C4;
	Wed, 18 Nov 2026 20:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033732;
	bh=oU8qLa5/92dGMYgJs3MgJ8rrlBiFeQn5e2brW1Zkgvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aB1mF0V50h7HNKWjM0TvoFKpb7zEqIi/QWRLD6XngW4VFWt5RhfBUO1Scn3wbi5g7
	 KmqUUYr6GG7Y5Sp0gdpqaCEWzIQDDfZju/j32YHrlcL4TMJXqUB4+JyqI4ZbztTkK4
	 2uy7SvBj7C7cB4Vq5mabgozcWuZPEZmBYYuoTGx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devansh Soni <devanshsoni874@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0077/3318] staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure
Date: Wed, 18 Nov 2026 15:11:39 +0100
Message-ID: <20261118150316.381444463@linuxfoundation.org>
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

From: Devansh Soni <devanshsoni874@gmail.com>

[ Upstream commit 51b554f1a758570159a770983c7a0ccd7c761491 ]

In rtw_drv_init(), if rtw_drv_register_netdev() succeeds but
sdio_alloc_irq() fails, the error path jumps to free_if1 and calls
rtw_sdio_if1_deinit(). However, rtw_sdio_if1_deinit() calls
rtw_free_netdev() without a preceding unregister_netdev(), freeing a
still-registered netdev but leaving stale sysfs entries behind.

Signed-off-by: Devansh Soni <devanshsoni874@gmail.com>
Link: https://patch.msgid.link/20260619125724.12458-1-devanshsoni874@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 3b5a6f685bce5..258f68c35dc07 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -382,11 +382,14 @@ static int rtw_drv_init(
 
 	status = sdio_alloc_irq(dvobj);
 	if (status != _SUCCESS)
-		goto free_if1;
+		goto free_netdev;
 
 	rtw_ndev_notifier_register();
 	status = _SUCCESS;
 
+free_netdev:
+	if (status != _SUCCESS)
+		rtw_unregister_netdevs(dvobj);
 free_if1:
 	if (status != _SUCCESS && if1)
 		rtw_sdio_if1_deinit(if1);
-- 
2.53.0




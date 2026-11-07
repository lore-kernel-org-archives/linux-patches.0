Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060802;
	b=WUH+8uAh7HiN5UF9F4rg7wm0umu01XkxF7acqfT3doai8xEtvOq/+A2VGvUGXK1ct1rn
	 o8aNTAsrtgWZYdhLKahCyJeUCo0lyQc4dKVgol34yBWzRGjoh80KJSNL71B7WnDkLtD2L
	 CFhOMkRYEviqS2h/5xzcyrTcC6glZ7/5eBcx2ip96N2CcMf+qw9RRowxSj/7JsrmrZKHQ
	 nhO90npNtHavoarM39t2VCXi60s76+ijDpWM/P+2x3AhMeZv+iwX2d2soRaVecF4vXSoq
	 oQsTpDbttpHKSeSlbbBLPVsDl/qMbLaSQnPGnG4aOsxIcEJwRH5s3RAuxzQ78Mt00tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zzl72BKSfANWnXGNgpc/YGjl0hhh6mElT6BU/86Avjw=;
	b=f7BBNYrLo8rRGoFHb9cXQnwxUurANTFv7LnuCa+dRZv0DVUjXxlxKjYUMG1EA0lL6yY9
	 W8xQkoFCjUQsGfk7/6/UaZxICZeZw7SBiJ0GXosOyocpR5lwv1viuTHAWcRDG+X8E1+aT
	 Hr5ar53y5m/kqn+SZGmvGbXKbU49EjBx6CGUggeklbivSPIxr4ynmrUBtOH/C/042sKIp
	 x0DILXwQ1OpAWxbxey7SWZsDv3ipgPZCnPy10bs+tzayC961oUINMBwTzEajyRGBWMutD
	 1lXjcgiC2uYmYwAFRyV/eMlSZZzBZf+Tpg1KHbUvy9/2tFmOUK12jYjToehzwKW+DTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZhjXqNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71F8606A326;
	Sat,  7 Nov 2026 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZhjXqNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BE01F0089F;
	Sat,  7 Nov 2026 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060801;
	bh=zzl72BKSfANWnXGNgpc/YGjl0hhh6mElT6BU/86Avjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZhjXqNFIfas3sMa7yYr3q58eBazarPLcA0ncTeSefb/RGc1oBC4ovnEbuRrtqeO1
	 /uKcEk+ICoLswZWnkrRd3ptM/d0iE2qj32eSGlrXWybKt8rLD5kqY/Z5THdhTyidCo
	 wryOiukRZMgSq2x2B4IPHAjLyElrYAyO+i+iG4wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0201/1536] soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:36:57 -0500
Message-ID: <20261107135003.304918901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 01479280fa5d4691013bcd64fdfd935117b69769 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Message-ID: <20260704121851.63805-1-pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ixp4xx/ixp4xx-qmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ixp4xx/ixp4xx-qmgr.c b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
index 475e229039e30..e3ad0e0237a77 100644
--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -454,6 +454,7 @@ static const struct of_device_id ixp4xx_qmgr_of_match[] = {
         },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ixp4xx_qmgr_of_match);
 
 static struct platform_driver ixp4xx_qmgr_driver = {
 	.driver = {
-- 
2.53.0




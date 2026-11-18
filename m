Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029376;
	b=xk0JNJ6hoR5rv5Dn80SU1hg7cmr5jQfroJYzJhbWph22nP4lTubSCjF0tkDSrqgEBtlS
	 XggIyk+N0/6DBRkoOj0TFwsY9qPDzIrjhfu8TgfA+llW5yZVP6HAnrPjCsE5qOIH9ZOC3
	 w8iqDU+6ThGVGifXxOxEFy2r3lHBe5+JreNu7E3B+VkCfEeF+eBdwzA9P3PTGdWuR+pz4
	 ZCZs8wTbYgkEL3M3MXZ6fiw7uqnMJOyVop/esdZ0gvsSnkwxD3GAZIW/TEcC4vthEgaeR
	 G2oQjXoJEIubcfulYE4uZ6e5pytUwlkF0dhssvrRsWSUQuHbytq7GNnynxY/RqZk4/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1DxHPrqY90xuOO0sjWz9LbbSqRbzTGLOLvbDtyI84WY=;
	b=q5acH1x1OqhGDZV2pnF7qQHuct0JXVY/D/3RD9aV7UDaJQ2XWqdWKzGoFAk2K2Xdql9T
	 GRLsoRWHw0dl89tI6ESt9tlm4lrxk7XXhUpXy9xQXBS7qrPKfgRtJHXbesdJ9KWQQ9318
	 bnW2H7rtM4KVdVeiU01/Pd/B2iL74Uq0IK7mdadM+SDmew56v82IOxxsgsnDl9341CSbt
	 v2J5bdmbNd5DtCuusGF8uTqIhCImHUvonTcKK/YmvrmLZzf/4gSIjiqEiarkbrGt79eJq
	 A5B3jl1Z/yyiGCK00WlhpItMWI+sVctCv73vA5e0JB/JtxpZAKgZ/VN8DTLEXXGGMRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0/RIWRrE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED6A606A32C;
	Wed, 18 Nov 2026 19:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0/RIWRrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FBD1F000C4;
	Wed, 18 Nov 2026 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029376;
	bh=1DxHPrqY90xuOO0sjWz9LbbSqRbzTGLOLvbDtyI84WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/RIWRrE1BscTfvZZH3dkxj2KfyXG9NZ8qT3TYRB3KyeNB1tqcV5BOBkTd5uT4DiN
	 TbP+vV7Qza2MoV1l/BgKdYHLGaA8eck6vz6djaOvY9qfmh2+r/vNKNC4eLwKX+ptc0
	 mCcFgY3fCkDaZOsgDHEJ/+VpHwg/G/fc7pFpNZF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0329/1756] usb-storage: alauda: check the return value of alauda_read_map()
Date: Wed, 18 Nov 2026 15:40:56 +0100
Message-ID: <20261118150021.363828015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit eb882419790c6710646904c6b25132189152cf33 ]

alauda_ensure_map_for_zone() ignores the value alauda_read_map()
returns. On failure lba_to_pba[zone] and pba_to_lba[zone] are left NULL,
and both callers dereference them immediately:

  pba = MEDIA_INFO(us).lba_to_pba[zone][lba_offset];

alauda_read_map() returns USB_STOR_TRANSPORT_ERROR when either kcalloc()
fails or an alauda_get_redu_data() transfer fails, so one failed bulk
transfer is enough to reach the NULL dereference.

Return that value from alauda_ensure_map_for_zone() and check it in
alauda_read_data() and alauda_write_lba().

Fixes: e80b0fade09e ("[PATCH] USB Storage: add alauda support")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217862
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260901065831.43567-3-arka@arkamondal.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/alauda.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 13dabf6a16f82..05baaa996ca67 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -697,11 +697,13 @@ static int alauda_read_map(struct us_data *us, unsigned int zone)
  * Checks to see whether we have already mapped a certain zone
  * If we haven't, the map is generated
  */
-static void alauda_ensure_map_for_zone(struct us_data *us, unsigned int zone)
+static int alauda_ensure_map_for_zone(struct us_data *us, unsigned int zone)
 {
 	if (MEDIA_INFO(us).lba_to_pba[zone] == NULL
 		|| MEDIA_INFO(us).pba_to_lba[zone] == NULL)
-		alauda_read_map(us, zone);
+		return alauda_read_map(us, zone);
+
+	return 0;
 }
 
 /*
@@ -849,7 +851,9 @@ static int alauda_write_lba(struct us_data *us, u16 lba,
 	unsigned int new_pba_offset;
 	unsigned int zone = lba / uzonesize;
 
-	alauda_ensure_map_for_zone(us, zone);
+	result = alauda_ensure_map_for_zone(us, zone);
+	if (result != USB_STOR_TRANSPORT_GOOD)
+		return result;
 
 	pba = MEDIA_INFO(us).lba_to_pba[zone][lba_offset];
 	if (pba == 1) {
@@ -980,7 +984,10 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 		unsigned int lba_offset = lba - (zone * uzonesize);
 		unsigned int pages;
 		u16 pba;
-		alauda_ensure_map_for_zone(us, zone);
+
+		result = alauda_ensure_map_for_zone(us, zone);
+		if (result != USB_STOR_TRANSPORT_GOOD)
+			break;
 
 		/* Not overflowing capacity? */
 		if (lba >= max_lba) {
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054932;
	b=BHtoHomUaOjPXS02F72Pxt06Ge6cxS6ZZDXYU9UDmvaYhLki3V0YE7wjBDzeLGYe8M1B
	 N1SL6o0ULeuwT/4S24McwTF3VdR+AhZVrflyd9pGf/Xgu3+ysNutSezo53NXzBZk5YAsK
	 IfJ/d8vI0+8SdXmYbK7OZPRzgstLxMMal7cdGGv5q+QdfmRimFjeM8u7WMIv77dGJRxc7
	 VSCDeKfC1Bca6WyPsY5nJRNUYRNEZMYcOWWHdOPG+bDFHXgie867ZzJ6fS+7L30rQhPjY
	 EzX35vD4/e85j/eeDcabn1UimrrUCbmBSrZ3RnrWdQclEl7/Y/h1H6VKALRZPKOiWYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TdjzmY4Z3L1CxWsNg0eeMPcagoRdeInB93UokdmKHUI=;
	b=ZmUyuHGOLnUyZdJyCrLt8aR8xwFWvEq+tvvUWybFh/jPkgF5TbnJXUYLC9omUw+QBDGC
	 WTm/EJcClMwUBvDHSSD/TufQEcYAQYsC/2YClh0jmjPxLrsp5eW9R0pH/VDAxMFf5jWuP
	 Hk7w2N1x/+KiWVxTR6xuRIqknSgHPY7nQUrHJGEj8/mFFJXVw0jZL1/RyzVa2fNEbUkYn
	 7WiWwyPxi+tmvnc8Hk+6FvhSJXlC7xy/PHd7M/mm9kzZ7T7CdllJjcRcgWtigzTm7Hx54
	 XofpEt8yv3UXH2z+uKEreyjDNsYZFCAnTaySO8plZq07/tySNqR0LiVOOrmIRcS9Ddg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGW6OGSM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C02606A31C;
	Thu, 19 Nov 2026 02:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGW6OGSM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037AE1F000C4;
	Thu, 19 Nov 2026 02:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054932;
	bh=TdjzmY4Z3L1CxWsNg0eeMPcagoRdeInB93UokdmKHUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGW6OGSMDzov71h1sTAQzHUcB1kgwZI2c4l9FbaSXOtlZIyVy6N9vEPeXFZsIXo61
	 cCcwT2alpcSVB/0depF4KgMl5TmNgFu4uJIp/bWUvEF9IjkLwwI3G9B2i7g9QeuwMA
	 ITOtroqu2N0Ifg2f6exbQRLOlJsqzANoNI8SVigQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1450/2214] usb-storage: alauda: check the return value of alauda_read_map()
Date: Wed, 18 Nov 2026 15:52:06 +0100
Message-ID: <20261118150109.095148535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index db73d1452fa29..de74f98f7a8be 100644
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015964;
	b=UBTjCt4uklDo0R6/pWsoGYDnghH9B2xWda9GZJO22XHlTI84G3vJvVZvLEoydYpE6+8s
	 zaz8I5dIzT85Xt2kjIW6uzH6WGplr1aNq2Q4+MTKmjoW8sSt6zXmxy5E1ZD6CW/A9Djwa
	 XINWG6TedfcPfjbROHuDAfxb4Ltk/YWuK5yScddsQmEUNlnqbNloa3RInmyiOewSnFTQ8
	 mIxeqZUCqKZPreAjxiiHlu4hhcuH49gAFaO7t34nraIvcVSa84vBWvFVMNgNBvS04uRI5
	 22OtZRbkQ1OkjYvoKQJc13xszhKCniGZ0uRnM2blz/koumZdftMiSpN3qvuPCOpV41Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M3WY+msrfF/zYwVorfF+h2MOV0BJStF9LgR7JAJPJUc=;
	b=IJYPDU6r4olM5SMg34LZml486Sw79prXwKCKq1sDe2hlA39i/fn4W9nt0XZZ31SSLXVK
	 qXEAO+OfP7ZrdJw+Pdry9W6JW2RHW8NWRacRbnLbiOM/dBPQ1dUZ36/iRI96Q/OCZawUd
	 1VVfkrQrR1fBDtXaJLc2orVqBf/tzvnviLwR+3P6vydoNjEBp4gi7t7dMYLvAWWt0vHav
	 P7L6VJBg/d1dY6jY0W1Cbc1BYmAp82P/k4tyeD2ta2WhfkJZK8d8WF+tDHgHu7WiVNqRo
	 Xvwi+FRpGKsZuMf6x91cZVmzb+IhMMMStA5PkuS7enjNZUT5xqBcgJe0HDUqCIZbwWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrm4P5yF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F456606A337;
	Wed, 18 Nov 2026 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrm4P5yF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D101F000C4;
	Wed, 18 Nov 2026 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015963;
	bh=M3WY+msrfF/zYwVorfF+h2MOV0BJStF9LgR7JAJPJUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrm4P5yF0iO9R+yzArSLjOblzF5s0EP7mi8gBvlxK3linDEJnaXJ7BcqqY1qXA51x
	 ta2gosUNYhn6JxocYKCovnaGngLhla/LlEbVGxUGenrwpPECamstHyACfU3KBDJE+4
	 EuO1jhHT0ZnRyCVuDpx99rRIJ0OrSKxmz3OHE/co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0360/2651] usb-storage: alauda: check the return value of alauda_read_map()
Date: Wed, 18 Nov 2026 15:26:40 +0100
Message-ID: <20261118150300.794954426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 878c404106c54..d47ce01d519a0 100644
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




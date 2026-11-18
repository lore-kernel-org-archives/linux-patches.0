Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023398;
	b=vN/Y5lLpNzI6Vk8EeqpH0i6fG0Us78b6ENZKv44vgTGKzERn4vOMwPkBnHcHLtH/zlCx
	 kpKBLwmt9UVS+HbAxUCUizI6jgdlsOHWC8l7CGUWlBUyJG9N0ZnHAjzvCoBtVCN7QQoSQ
	 sarkCu9Y6QiKpuyjZz8ijYgLdBgfkEEph3RdM3QWFC1AEQfA7Kr7zlidWnZIiX0v+INmw
	 xM0iJXd/9z29VsAhrNsiPwvt/nX7BFulxqq2/HdCoeNPjouHt5mStgolThc/vwpGJ8C3R
	 iVXId02MVevsHe2rxhlIIkK7NUOcH8QpnhTaEsH337m/MH7FkAzJQCu5HwtiaGa9vQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H4/ja5HJrbglZKdMzsVadYU/AaB0CNYUkGUgAUK4aqI=;
	b=hAdmODhO+vrlW3gUTKMsSqLn/cwhGGHU/KDDWPCuMz5mrIYla/1hhXJeczOwiWB/B47u
	 08O1rKQa0TAaAeCPfsfYJ/iSvue2ci2Cx6eH/8Qr2Hnblbo/dLiCmDEa0BSfWQ0gfmqbQ
	 /9WJ5MMhf3BUMXcCEUmA6IMl822GuDKyY8vGAcytkC+9MYmtss0qd12f59ttgWQ2wWpXS
	 4Bmu0A4Lz3nCsxsmkoDl+14IVwdvCuZTAuLFCiToyY4jCYclaSeQNPWA35jLeUwzMjbGt
	 zMhQLX30SQ5QP4Q8u1wdoMzxHx9j8fbFngiOI5zcE9sZW52Cr7LnWWnF6KS+p5XX09Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=clA9BDsJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1B0606A337;
	Wed, 18 Nov 2026 17:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=clA9BDsJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C791F000C4;
	Wed, 18 Nov 2026 17:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023398;
	bh=H4/ja5HJrbglZKdMzsVadYU/AaB0CNYUkGUgAUK4aqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clA9BDsJvmInvuuCERLvqVvAE2wKiiz8meH1fH8bBQSsNNBg9qgljSvP69VO90tAD
	 /PxfImGXB44SEDoPhyDWmDESJfcCE4N0AXMjKUrhGEmf+4VslVoTBFnChzTspkYCaX
	 mCz71yEaeDIRtBSEnFSwcilG52+WCYc0I5ZQP2KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0356/2151] usb-storage: alauda: check the return value of alauda_read_map()
Date: Wed, 18 Nov 2026 15:34:51 +0100
Message-ID: <20261118150135.069072731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fac8336c0db2b..1de09c9f115ab 100644
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




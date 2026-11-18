Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048093;
	b=bIOch9gcdzKN6CgeQUMIwcrdlw5P3m/+SZANWGyYV4wvhVNdcFiG5HlvZ3k2wQpWgjTL
	 PPWM6C7zthEZlSeWkYCOBFh83zXrCxh+PfOnEp1PcGS336eosVOKSmfj9BG4iX5PVnjch
	 c/hv9znIuSgn04Ntgk6wF1akV40uq0YpwkEP0WPEdSbtyIsRCdX8B2EtMQyHfQv/nXZ7C
	 LqOiDzyWaaClfnM7VtHl6kSF0fnBSI78n+Sg2laQdS4RWfk45GIn04w6EA8FzWPHrTuHb
	 jC+frra0C/MMoomJb+fGXXp6++l9O69XN68+8rjKX0FuwZnSJCXugMRZJ9FshAF4JTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h1e/aKoKKZm8vqMMLp+uZIxL116kkLvrf5iNNyVJ+Gw=;
	b=g2aZdyljoS73Ue1EyVcEX5J1lqR8HyZ5vH3HY+DnX+PPoKSsFMVcVb0pZ+IbX+0Y9kAx
	 OroFqXn1KtlyfZzP9xEjAWBhlOVgoCVUHXV1pR7fUjEDRhfmkYFSrMqmz/eAq0EIhSMz3
	 aSWsg5JTGhLJUqVIOY+ZgIf0xRaM1l2ewJA0fcbzRyTWWdznenZZQ/b52FGwo051Ztynl
	 Ajz0udtM+vgesApaZ+XfV/n0BjCLnuthE5U20BWUhj2qtfpxdMyssztEG26liCwARD9gE
	 YQfVZh+n7SzkVnKaroh0AFCr/q9jnI8aeP6eO7JuKK+EHQchQTQAtGT5rVHpFxTIDlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFOmooOK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64960A2605;
	Thu, 19 Nov 2026 00:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFOmooOK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB1C1F000CA;
	Thu, 19 Nov 2026 00:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048093;
	bh=h1e/aKoKKZm8vqMMLp+uZIxL116kkLvrf5iNNyVJ+Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFOmooOKNOAw/6pC65DTA67WljYKO/CGDNgZ1Pm6FCYFBYW+m8B8qIbKqvaUhpVie
	 RcmP7Jn1u2BrQeCB3AcThfQKSSsEJLL/RGLWM2gzb6Mp2AbI95Fi78Tc9fWWRxmftp
	 n3/FfCp0RAXkB/pOjmqdml8Eqr+hUrEnEEB62plw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1873/2857] usb-storage: alauda: check the return value of alauda_read_map()
Date: Wed, 18 Nov 2026 15:48:27 +0100
Message-ID: <20261118150308.673999670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 46039016ab82c..fdedb5820f5e4 100644
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




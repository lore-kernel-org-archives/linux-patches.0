Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618719;
	b=zzYj+t48gyCFiGje2Gcypv+hcSdjEot0Iv3NN6H+vh7UMp5fnIs+VCOoAekv4NfkVoVh
	 VYgrtO4qmWAF1zyiyN26Mcsa7+MkQG3JC1hoqtdgf47bhvpqv2bI5rbguzUas15GzVAZS
	 CZU+RgMQAonaewdIyg9YDZQhIqDGiUahGw1sAmhIghnkXJDezjG3YDwGYYEpMT/OSWcny
	 +gnhL+4bq6KyNvY0dSYtcVgr33UOz51hOlqxd/L94SYXjlknxpHUgKxSoBNRD8W71Nj6N
	 JnrnFdTmKQvz2YB4HpskLfenXtEbHWok4utA9O7vOAKj3QmrsXcsnKQg2FKlZt5AFKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iA1rOE3PzV0DQrOzAE8n6mccZSPjX3HTVJk+9JUEQv8=;
	b=u5rLLbVbO/pWCzxXGsO1YUrI2AZE9zoqjp4Sg3HNIjdk1GTTNuk5Y6uFXPxxMIlte9FR
	 pTwbXzH6FBhbYwJcGf4bAHyGHigBeZD60S5EXQ34Ve1p0SkOe5KN1oCRAl8Y351UsyGbo
	 b9kpvON/FOMFviUUnXu2gQszn8zxXpp1hvRVTwiIEJi46iAhwGYBMJFxbFapgVP0Sg2rL
	 VowG+9voH71he/C9qxZnVRFFf2briOcNDo9vYHp6g4pLhVnEvfCBRJR3aC1CTUiK9uaRK
	 8Zk+oxPUKNVLkW+PKRu0QqBU1fLfeJ4LjRTXJDFaf4bAWUQggQJKhNDxj44+PgDL2Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5W0tJ7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFFF606A339;
	Wed, 25 Nov 2026 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5W0tJ7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0BE1F000D1;
	Wed, 25 Nov 2026 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618718;
	bh=iA1rOE3PzV0DQrOzAE8n6mccZSPjX3HTVJk+9JUEQv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5W0tJ7sjnqyUh3k2Dae/E9geEpmalfkVeZ9pDU8p8FLgGyKlOK506A1J2MMIm6lj
	 nlrnxNLrbr46XHVf32Y9j7Imb0ZDV5IF56fcCvsIzeDv5PQ6RvtlG7vYHwE6AwCTFN
	 XKJDbALjM/T6OJLbr5lNsaEoxNY+Pj8VG5mNbSJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0369/1005] ata: libata-scsi: fix MODE SELECT handling of data after the mode page
Date: Wed, 25 Nov 2026 15:28:27 +0100
Message-ID: <20261125143830.378414558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 6fde0444d07ec954f3d885375e0402ff2f2e5064 ]

ata_scsi_mode_select_xlat() only supports one mode page per MODE SELECT
command, and rejects a parameter list with data after the mode page with
INVALID FIELD IN PARAMETER LIST. However:

- It does not set the field pointer, so the sense data reports 0xffff as
  the FIELD POINTER.

- It only checks for data after the mode page after the mode page
  handler has been called. ata_mselect_control_ata_feature() has then
  already updated the CDL enabled flag of the device, even though the
  command is rejected and the CDL setting of the device is not changed.

- For the control mode page, ata_mselect_control_spg0() does not need an
  ATA command, so the check is skipped, and the data after the mode page
  is silently ignored.

Check for data after the mode page before calling the mode page
handlers, and set the FIELD POINTER to the first byte after the mode
page, i.e. to the first byte of the next mode page.

The reason why only one mode page per command is supported is that a
MODE SELECT command is translated into at most one ATA command, so
update the comment accordingly.

Fixes: 1b26d29ccd59 ("[libata] scsi: implement MODE SELECT command")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-11-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5be2e2597770f..3b65a086b535b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4629,6 +4629,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	if (pg_len > len)
 		goto invalid_param_len;
 
+	/*
+	 * A MODE SELECT command is translated into at most one ATA command, so
+	 * only one mode page per command is supported. Reject any data after
+	 * the mode page before calling the mode page handlers, which may
+	 * already update the device flags.
+	 */
+	if (len > pg_len) {
+		fp = p - buffer + pg_len;
+		goto invalid_param;
+	}
+
 	switch (pg) {
 	case CACHE_MPAGE:
 		if (ata_mselect_caching(qc, p, pg_len, &fp) < 0) {
@@ -4651,13 +4662,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param;
 	}
 
-	/*
-	 * Only one page has changeable data, so we only support setting one
-	 * page at a time.
-	 */
-	if (len > pg_len)
-		goto invalid_param;
-
 	return 0;
 
  invalid_fld:
-- 
2.53.0




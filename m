Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BDD145A1F;
	Tue, 21 Oct 2025 20:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076891; cv=none; b=sbb0IKRg2eDE2It+vO8t0RxNA4XOjnkLDJDnhS/1f1BUESMHdwZ/GyC+ShKdzHKt+XQ9JdK6z8WeHOKpZ026QtqopB3bYxZky0WRNBHq5COuwP39MLz5Zim3MilBMhdN48jv9CfnPg90unVgZ633b1jym7Qr4l56srGmV6+QmT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076891; c=relaxed/simple;
	bh=9Du5nKseZ0nlPkg53gHpxnx9o6gcchmHqUXkFC7ce48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iS3ynbllaIYmjP9isjNkEfXkc1Eel3CVR/PPCqrygWOqldDu8MMPBi81+/6h1X1j+UAU9KeLpa9G5WeNUc5iHAzHQwxPSWiz+PL6jgYcreS8WApkFwQc4/OpXf47AyAhw6P/6i6XQ3wpEXr79Pbg0/u0qlputDshuaumY4E1OSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSMuSBSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSMuSBSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3841C4CEF1;
	Tue, 21 Oct 2025 20:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076891;
	bh=9Du5nKseZ0nlPkg53gHpxnx9o6gcchmHqUXkFC7ce48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSMuSBSUbNOYB3ATt1ntSjkRglPGS/6hvP5oFhrbvUnwpjdyO2pgSk2H+Lk0s4wv8
	 Dqwpt6XCcnPTLE7h3vsV9ainOE5Wiy+OerXKTALHmCipBftg/47IYVmFQV5fEQAxCe
	 rfg6MoxkcANQ9uIQKdUIhu1zORm1S5WXl67VFVyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/136] drm/bridge: lt9211: Drop check for last nibble of version register
Date: Tue, 21 Oct 2025 21:50:58 +0200
Message-ID: <20251021195037.656942401@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit db74b04edce1bc86b9a5acc724c7ca06f427ab60 ]

There is now a new LT9211 rev. U5, which reports chip ID 0x18 0x01 0xe4 .
The previous LT9211 reported chip ID 0x18 0x01 0xe3 , which is what the
driver checks for right now. Since there is a possibility there will be
yet another revision of the LT9211 in the future, drop the last version
nibble check to allow all future revisions of the chip to work with this
driver.

This fix makes LT9211 rev. U5 work with this driver.

Fixes: 8ce4129e3de4 ("drm/bridge: lt9211: Add Lontium LT9211 bridge driver")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251011110017.12521-1-marek.vasut@mailbox.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9211.c b/drivers/gpu/drm/bridge/lontium-lt9211.c
index c8881796fba4c..4014375f06ea1 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9211.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9211.c
@@ -120,8 +120,7 @@ static int lt9211_read_chipid(struct lt9211 *ctx)
 	}
 
 	/* Test for known Chip ID. */
-	if (chipid[0] != REG_CHIPID0_VALUE || chipid[1] != REG_CHIPID1_VALUE ||
-	    chipid[2] != REG_CHIPID2_VALUE) {
+	if (chipid[0] != REG_CHIPID0_VALUE || chipid[1] != REG_CHIPID1_VALUE) {
 		dev_err(ctx->dev, "Unknown Chip ID: 0x%02x 0x%02x 0x%02x\n",
 			chipid[0], chipid[1], chipid[2]);
 		return -EINVAL;
-- 
2.51.0




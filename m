Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0320832143F;
	Mon, 27 Oct 2025 19:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592336; cv=none; b=cXDAYviR+SzwgL7hENSbDAcJuaqykkBJ/O97PKJY9ebT5PNE38EkZ6reXpLw9UflxZ+zAQk+HgOMCtvPQ1g5i69HfxWdLTqLKSdUUwhigis9XwtQgxVzPgfwreBfhxScdKUBjExZICsv8iCzI54VQ/FiQn5LRS+mqdU7ErwnGdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592336; c=relaxed/simple;
	bh=loZQpvgWnPcvXuTSjKNy4VOIVRB6lg53XECs0pp0ReU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot8v3u8Gfi3uMdRc21DhR2cdnj2O2SZFvSXo61EUuWmoiDBwcMrGF2V3j1DKUOROCXu9D8zndjilNDvnoeFDIF7FvGvCyR5YXniZVbsUS3wciC+ihRJm5HWWmnbcF1E2+7rW/7pysx9WzJjSdLG20wivCyWVkgRM6nrj5VFaHic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MamaXwNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MamaXwNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C61BC4CEF1;
	Mon, 27 Oct 2025 19:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592335;
	bh=loZQpvgWnPcvXuTSjKNy4VOIVRB6lg53XECs0pp0ReU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MamaXwNXI0iSLlSE89IEwlsM9kCpuVFwD1cv/yOQu8ewz1AWTy/UmcRLc/StJW+yd
	 RQOAoWBCJx0nrdO8EYrEhORrDEyCYl7GII30DeoxP5y1daykNq1CcuaLmtJM8b76RV
	 DfE0uwQY5zP/5n/uTISJaJps0E3UlTIWCd3QIVWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/157] drm/bridge: lt9211: Drop check for last nibble of version register
Date: Mon, 27 Oct 2025 19:35:14 +0100
Message-ID: <20251027183502.713869433@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 933ca028d612d..fd581160d95e9 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9211.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9211.c
@@ -121,8 +121,7 @@ static int lt9211_read_chipid(struct lt9211 *ctx)
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




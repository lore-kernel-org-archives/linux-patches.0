Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C40158DD0;
	Tue,  9 Jul 2024 11:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524047; cv=none; b=V/BiVg6Meb6qa9rjO4hOfZh+txZDptb+oqHVyGW6+kaGePf3lBF8csn3JflMeswqg9sH7UDzd8++BNJYvPilBiIiF+Og2EFNVV54QHd4z5+h0x6RzeaRmO92Dok2/qUDYJJy0ArTrJQ3Q6pG0WxRmhMIN0dO9suzJOKVsYiQ2YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524047; c=relaxed/simple;
	bh=BHMbCkerHxJ4WM0VUyzjRIzK+x4yf/obbcStvLf4pS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnfHLznXMV+R7NSBTfqMSyqZvBaJqP0Yg2+YSsueL/DWkOG6s8BG1W/JBirMvVRPVYutp2Z9a/qrLKDggEMdlqXs7sIsE57VufPAtDVoxl/69mvsJyLUQjJTfZthMb1iu3idJNSR3mC5VISnY9g8+obt3c3NKguwyHt8tWULuIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkxv7AMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkxv7AMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46979C32786;
	Tue,  9 Jul 2024 11:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524046;
	bh=BHMbCkerHxJ4WM0VUyzjRIzK+x4yf/obbcStvLf4pS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkxv7AMWN5r/5S6+KjurXN7eNt36yOhjh3el5cvT/Kb6J6vbfTa+bYJR7wLKNTO3q
	 2UkQ29R24Yxd5aEkaLnOmEP5lMtfX6jp7JTXTOo7Zj0FweVPhFsouGTdAZDzf8gYbS
	 6sKK1V/K/t9q+1DVfsRnmBdgXc299as9nDWCKLNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 053/197] media: i2c: st-mipid02: Use the correct div function
Date: Tue,  9 Jul 2024 13:08:27 +0200
Message-ID: <20240709110711.015524638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 22dccf029e4a67ad5aa62537c47ece9f24c8f970 ]

link_freq does not fit in 32 bits.

Found by cocci:
drivers/media/i2c/st-mipid02.c:329:1-7: WARNING: do_div() does a 64-by-32 division, please consider using div64_s64 instead.

Link: https://lore.kernel.org/linux-media/20240429-fix-cocci-v3-21-3c4865f5a4b0@chromium.org
Reviewed-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/st-mipid02.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/st-mipid02.c b/drivers/media/i2c/st-mipid02.c
index f250640729ca4..b947a55281f0e 100644
--- a/drivers/media/i2c/st-mipid02.c
+++ b/drivers/media/i2c/st-mipid02.c
@@ -326,7 +326,7 @@ static int mipid02_configure_from_rx_speed(struct mipid02_dev *bridge,
 	}
 
 	dev_dbg(&client->dev, "detect link_freq = %lld Hz", link_freq);
-	do_div(ui_4, link_freq);
+	ui_4 = div64_u64(ui_4, link_freq);
 	bridge->r.clk_lane_reg1 |= ui_4 << 2;
 
 	return 0;
-- 
2.43.0




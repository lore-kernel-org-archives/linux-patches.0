Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF23F328B71;
	Sat, 28 Feb 2026 17:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301341; cv=none; b=KqnZioUyQAGDt90zOo+TYvkoG9ay801vW4T8FKi3ruukozdTFR3wQbynjLdVlG/tiP9jnCVOFAp0+wgLoa5UER7NlrmGH77BlKUD9m2XP5DAyWB7H2acYz0+NkCBE9cpyO674As0Z40v/CgYJDzN5jRayw+c/wp+TaTA/VL4/Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301341; c=relaxed/simple;
	bh=VyZLVXUPkudy58ZFvfqr7Up7sGe3c+Vwfqt4FqfURlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1tEOWX5Sm6cC/vSSQrdon0dohyG0pfnQEv21tH9fEwAhBRm3SwrcbE9UW4kxXOtp2vgbNFmQiWdwEeXabmr3qFc1hY95Q/qmfL/oC1+cZeF734hQefKxXEXhtd/uk037m7YaSKUnR/cUMTXpm8jeqztag5oofzqmIRxYEu4duQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7ayVPJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7ayVPJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BECC19424;
	Sat, 28 Feb 2026 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301341;
	bh=VyZLVXUPkudy58ZFvfqr7Up7sGe3c+Vwfqt4FqfURlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7ayVPJhxJcr11NvCUnRaGkAXMRzFOhQky2WsUrO5mMheRGpgqpUPNHTNgD5A1S24
	 vWyODXEp/0ykNFacC/VcHNiiYYHTCOrwWM+aGHcjFuckS1cy96/50dZU0V190tgSUc
	 Th+Pox6dPb2cmpg18uCbVszti62fgz8CJdY9Jj+58C4ZF4kHdMJeSAO7FiFG+3m9JP
	 p6ifaLTbzPwcdpZAXV+LhMcW/wQbJewDOxrPFr/ywtZCdn+4QUUc0aT40EX8lmqwkm
	 t768OPDyPfxxdqLpDUnoAJKbWTrTazwdoepfXmd3V0Wfkqz1BZm6QU8D9ltGn4SnHo
	 plVcDo7M4PpUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jai Luthra <jai.luthra@ideasonboard.com>,
	stable@vger.kernel.org,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/752] media: i2c: ov5647: Fix PIXEL_RATE value for VGA mode
Date: Sat, 28 Feb 2026 12:43:59 -0500
Message-ID: <20260228174750.1542406-528-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jai Luthra <jai.luthra@ideasonboard.com>

[ Upstream commit c063632b494b02e891442d10f17e37b7fcfab9b3 ]

The pixel rate for VGA (640x480) mode is configured in the mode's table
to be 58.333 MPix/s instead of 55 MPix/s, so fix it.

Fixes: 911f4516ee2b ("media: ov5647: Support V4L2_CID_PIXEL_RATE")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/CAPY8ntA2TCf9FuB6Nk%2BOn%2By6N_PMuYPAOAr3Yx8YESwe4skWvw@mail.gmail.com/
Suggested-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index c0f1121b025e5..bf5b0bd8d6acb 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -582,7 +582,7 @@ static const struct ov5647_mode ov5647_modes[] = {
 			.width		= 2560,
 			.height		= 1920,
 		},
-		.pixel_rate	= 55000000,
+		.pixel_rate	= 58333000,
 		.hts		= 1852,
 		.vts		= 0x1f8,
 		.reg_list	= ov5647_640x480_10bpp,
-- 
2.51.0


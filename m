Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E2073451;
	Wed,  7 May 2025 18:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643641; cv=none; b=KyU5X/l0mPJna+eddLXv6iMg7ruZVCaXNOSI6UT0DzNjcaAd7Jvpel2kDMAgKqni4U606Jw3lzFmwolcvoBh8C4giEHVPpj76nTIKKf8gANX82A14J5Znyw1RvvG0ivcEn5WHJFVXPb60fG/5DXuuNBLrqd2L4S10W48w8QNQRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643641; c=relaxed/simple;
	bh=PSByi+6z2keFnjkvSh+tOrudEIJ/LGnWQc27Ki7JNNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xte3a6g0nTSJcM4TTFXslXusywI8Hc2s90nd4l00kiTW40VMDBeyFhP2ahf6oZ7YkNuV+0cERxdC6F/PQqpXfpzrWoltMFfeonjwkixB6PNtQ+sod6XNQ4kcD2XoOxrMwgOxygHfVaDGdfq51HvnzYzZqdPrWxUz/EOyJdVHQYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjkL/zdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjkL/zdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61197C4CEE2;
	Wed,  7 May 2025 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643640;
	bh=PSByi+6z2keFnjkvSh+tOrudEIJ/LGnWQc27Ki7JNNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjkL/zdUw6OP1tyG7ArimfUC9DGakoBKrNWY+397qIh/sMp8mJdd05JEOhzHMxICu
	 LXfMUI4AvDJXcEpYEG9AxMd0N+gmMlQwI4J31DByrxGgmCGmDXUDSGpPOLDM3NOEmF
	 ROyJx7pX1Cc8xoKkBxZiE2VoLPRFOSeLOE6A1SjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 69/97] net: vertexcom: mse102x: Fix LEN_MASK
Date: Wed,  7 May 2025 20:39:44 +0200
Message-ID: <20250507183809.769292114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 74987089ec678b4018dba0a609e9f4bf6ef7f4ad ]

The LEN_MASK for CMD_RTS doesn't cover the whole parameter mask.
The Bit 11 is reserved, so adjust LEN_MASK accordingly.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250430133043.7722-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 45f4d2cb5b31a..55f34d9d111c4 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -33,7 +33,7 @@
 #define CMD_CTR		(0x2 << CMD_SHIFT)
 
 #define CMD_MASK	GENMASK(15, CMD_SHIFT)
-#define LEN_MASK	GENMASK(CMD_SHIFT - 1, 0)
+#define LEN_MASK	GENMASK(CMD_SHIFT - 2, 0)
 
 #define DET_CMD_LEN	4
 #define DET_SOF_LEN	2
-- 
2.39.5




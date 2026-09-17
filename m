Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2F82417DE;
	Thu, 17 Sep 2026 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668390; cv=none; b=IoyY6ulUroGVhPN0OkTNc6EyjLB3rb2MCWXCZ8YrG5KSWgUx4VkIJhBIcwOw/Th+oDM2ldAFoZRiBjvvkvGVYOQ6R8hwzJrPlIUOv/Kwvaq+Nj/y1IUQGHAugbSz8uksxQIblfJyPSSQz0+gSxMIudZUOfy3Z6I72GsvZsfAwQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668390; c=relaxed/simple;
	bh=L8YHd+6rm6iJX4W1dn/mCV9F2CaGzzAf0uVsqzL7PCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJebissUE51KB9gpchnv1Qm0Ial9SGJxkShNs4ixJ8EFlbzNTp90TfNFfVNVdvq6yov0mMl9m0O+eJPcRT7uut3A4SzuMipbBA0LNvGd3HJetbGcDRB32FYGyWPo9GsLiHYNfhfUUgQEg5rOArVUJLjlamyE136v0wOGuoMFkIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7RBmS0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7RBmS0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2391F000FF;
	Thu, 17 Sep 2026 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668389;
	bh=9Hiqdztd5jSYozL8AfB9l5WfdBKu1gy5YFb5JE1gk/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7RBmS0OQU/GPjqNjHLYiNAVwDz7IgD1/x0rg0t13byhB4ubKIm5uidCFMcgGV8mm
	 TYGNDg18P8YoSEdzFwp/Ba/UvKdPxR0YPaNOTTM79i2M1bOcvm1M5X7gp/EDRodyXk
	 ko4Q2CM2NOImh0P2YT6fqH6GFC/BpfD7CvDCpWN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0369/1102] ASoC: tas2781: Update default register address to TAS2563
Date: Thu, 17 Sep 2026 16:05:12 +0100
Message-ID: <20260917151548.914465736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 64184f07e7516eb3ac1839387eb7cbe2dbeaa96f ]

The previous TAS2781 address is overwritten during calibration,
so switching to the TAS2563 address is required.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20260625102815.20043-1-baojun.xu@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/tas2781.h b/include/sound/tas2781.h
index 8cd6da0480b79..a9ccbbd1945c4 100644
--- a/include/sound/tas2781.h
+++ b/include/sound/tas2781.h
@@ -50,9 +50,9 @@
 #define TASDEVICE_I2CChecksum		TASDEVICE_REG(0x0, 0x0, 0x7E)
 
 /* XM_340 */
-#define	TASDEVICE_XM_A1_REG	TASDEVICE_REG(0x64, 0x63, 0x3c)
+#define	TASDEVICE_XM_A1_REG	TASDEVICE_REG(0x64, 0x02, 0x4c)
 /* XM_341 */
-#define	TASDEVICE_XM_A2_REG	TASDEVICE_REG(0x64, 0x63, 0x38)
+#define	TASDEVICE_XM_A2_REG	TASDEVICE_REG(0x64, 0x02, 0x64)
 
 /* Volume control */
 #define TAS2563_DVC_LVL			TASDEVICE_REG(0x00, 0x02, 0x0C)
-- 
2.53.0




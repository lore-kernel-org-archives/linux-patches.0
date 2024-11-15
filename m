Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A558188737;
	Fri, 15 Nov 2024 06:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653110; cv=none; b=ZaMVBQ+UKnctEH3yZ4usJqzo2EeKR+dA9Ca2TWvHDbKYcWarl27XmFuR+kNomcz1V/jKXhxP/rcQuN40G3zkLGC+OQZ/FrauLzb/a9K67hG83d3BokGPLkER3mTxTh8V9+vCnand5QWrBgjZdMXUUH4LpOINBw6BMGAuK+Ll2BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653110; c=relaxed/simple;
	bh=TFWGlV8z0X1wXGAMFhmCsyDZdXxaer7yFap0Lz8x+0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca8sNoVRqHKX/XPayjt5l0DLZmZjiB4vp0AnrC2yODqIvsFGNlIK2e0vrd2gLP+fmvauQHjKPn4pc2Z0mFU0NoGdYDq8Y0kATy1rNIT9d1qCx8mqkNiIAQSfpgrBkxas1iwtLCwS3f0bw10QWKtpb57A3lsNVSfhMJAuuJifttg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sgh1k+Lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sgh1k+Lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2D2C4CED0;
	Fri, 15 Nov 2024 06:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653110;
	bh=TFWGlV8z0X1wXGAMFhmCsyDZdXxaer7yFap0Lz8x+0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sgh1k+LfveSJ+QdAovFVJ46+qnrO62xpX6dgIK2mcYoU2WDCE8DriDFIItcxJKWDC
	 fv6vVtnYQOiQqrXLsrEk1dp5M2a+2WyxRnJUoaa+nCenwBp57Ggx+irFmmwfkHQ2Y2
	 wqz0VEjhUU7ReeOiveR9JYMAXsRUZCMPOlGWhm0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yann Sionneau <ysionneau@kalrayinc.com>,
	Julian Vetter <jvetter@kalrayinc.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/66] sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML
Date: Fri, 15 Nov 2024 07:38:06 +0100
Message-ID: <20241115063724.899655084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Vetter <jvetter@kalrayinc.com>

[ Upstream commit ad6639f143a0b42d7fb110ad14f5949f7c218890 ]

When building for the UM arch and neither INDIRECT_IOMEM=y, nor
HAS_IOMEM=y is selected, it will fall back to the implementations from
asm-generic/io.h for IO memcpy. But these fall-back functions just do a
memcpy. So, instead of depending on UML, add dependency on 'HAS_IOMEM ||
INDIRECT_IOMEM'.

Reviewed-by: Yann Sionneau <ysionneau@kalrayinc.com>
Signed-off-by: Julian Vetter <jvetter@kalrayinc.com>
Link: https://patch.msgid.link/20241010124601.700528-1-jvetter@kalrayinc.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/Kconfig b/sound/Kconfig
index aaf2022ffc57d..cb4cb0d5b9591 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig SOUND
 	tristate "Sound card support"
-	depends on HAS_IOMEM || UML
+	depends on HAS_IOMEM || INDIRECT_IOMEM
 	help
 	  If you have a sound card in your computer, i.e. if it can say more
 	  than an occasional beep, say Y.
-- 
2.43.0




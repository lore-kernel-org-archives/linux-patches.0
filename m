Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8012230BFC;
	Mon, 10 Mar 2025 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627529; cv=none; b=W4Zg9VO8zMt7mW30NMrybxPhn0WqyKfeFSRjOD91HhttLH3oBMTQUOMPebe/5mDgCMavIrHaRGy5R6g0HYin1AETaaYyx/JkQW7Bbyg/nhHbydntBfZ/i2phJHkt+3Y5UFFNFTwrngTLFkzg/iPi+VxN309vMXUg7/RtkyvLAKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627529; c=relaxed/simple;
	bh=Y0fmzxdXKhiVLjW+wFMbgvRDEUM4yinum5kMxhvsxfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gM32MSv/8LuLJpeBI99Y0cjV+beDgAEsiuOAireA2WTCogGI7tj6T3QJo1OeoKiehAKG/SbzkPnhvfIxkYYBozDQg1ZJlethDnNUDBcHVvoMFNWIR9s/PghHUnZeIod7NZ6vTVz8/1U+XRaHzRqCWkyaO4p9pp0FJ15nftXmTUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wglevev0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wglevev0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D9EC4CEE5;
	Mon, 10 Mar 2025 17:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627529;
	bh=Y0fmzxdXKhiVLjW+wFMbgvRDEUM4yinum5kMxhvsxfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wglevev0G3L2yYx3xYDSMgSobm0Xsw+mw0y+G+jNqLGwbziYqhyxXniEf0ui3o8EG
	 XNbbv4CdD0zlt+cbjNnJ+YLOKK457TUWMesFRFvd+Ca2i3QRsCKi3j/CAe034G6l4d
	 HN3L6ceDQfqJ7q3kn405qER8NlR1Sz2o5mXjkZ/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/269] drm/nouveau: select FW caching
Date: Mon, 10 Mar 2025 18:05:14 +0100
Message-ID: <20250310170504.137569382@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 6b481ab0e6855fb30e2923c51f62f1662d1cda7e ]

nouveau tries to load some firmware during suspend that it loaded
earlier, but with fw caching disabled it hangs suspend, so just rely on
FW cache enabling instead of working around it in the driver.

Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250207012531.621369-1-airlied@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index ce840300578d8..1050a4617fc15 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -4,6 +4,7 @@ config DRM_NOUVEAU
 	depends on DRM && PCI && MMU
 	select IOMMU_API
 	select FW_LOADER
+	select FW_CACHE if PM_SLEEP
 	select DRM_CLIENT_SELECTION
 	select DRM_DISPLAY_DP_HELPER
 	select DRM_DISPLAY_HDMI_HELPER
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90BC8465
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A07C433C7;
	Wed, 20 Sep 2023 11:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210963;
	bh=V7FRL8FwEObH8wmNneCsSOy8lDXtzGiI9tmE5E0WqP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FP0sDMSjCIFCE2zWWlwNUnMIc7cpKHtf5UYY1RaWgP2yLVwK6YzrzdkolnfVcBXY+
	 Mh2SqqaX+FhYVqTkNTUfCm+7UYRH2VFqQyT1l0uRn31DoKEIbV4kg8cPqyHTC5Ak7v
	 ZWSY8t+pwyvwyMwUT2hIPyaHPTPILoamh/Wdozsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Campbell <rcampbell@nvidia.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/139] drm/edid: Add quirk for OSVR HDK 2.0
Date: Wed, 20 Sep 2023 13:29:34 +0200
Message-ID: <20230920112837.129414835@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralph Campbell <rcampbell@nvidia.com>

[ Upstream commit 98d4cb705bc00afd4a9a71cc1e84f7111682639a ]

The OSVR virtual reality headset HDK 2.0 uses a different EDID
vendor and device identifier than the HDK 1.1 - 1.4 headsets.
Add the HDK 2.0 vendor and device identifier to the quirks table so
that window managers do not try to display the desktop screen on the
headset display.

Closes: https://gitlab.freedesktop.org/drm/misc/-/issues/30
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Tested-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230621061903.3422648-1-rcampbell@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 739e0d40cca61..5ed77e3361fd7 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -231,6 +231,7 @@ static const struct edid_quirk {
 
 	/* OSVR HDK and HDK2 VR Headsets */
 	EDID_QUIRK('S', 'V', 'R', 0x1019, EDID_QUIRK_NON_DESKTOP),
+	EDID_QUIRK('A', 'U', 'O', 0x1111, EDID_QUIRK_NON_DESKTOP),
 };
 
 /*
-- 
2.40.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E2127453;
	Tue, 29 Apr 2025 17:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946778; cv=none; b=fleSAO8jPdltCD3yHTlHaC/FhdqbTVbcoH9N7Qv6NU+UfB1U1kCjcyFZ097BkRGbuJ76tI7igz2WLRKFsYst0FtmCs9yJjNmNRtLNjJSNfeS3cH1hPGeSJdR1zF9Ct9JqWSAIJOliByM+3AoJc7fdv9JS06yaMC/KruWHy3a8vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946778; c=relaxed/simple;
	bh=0aGYIJf9m+EQkgJmUnc0OkvzR/zGmhmPIXNujZ+Clj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdnH0hBnvd2W6yMeeCQpkTIuspOunaCv6X9QAcHlM8E/uoIi1KV6FoRMnMxiR9fBXQeq4LKPpDqzaNxlXU1P3d0u0yqec7G4+NU3Q2P2KjvgZpiR7wu1aQA22o/6dmhKhD5p4ZYAMi6RYN5XHXkSREIIkFd99BxBhkzk39nMC+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzE9tEkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzE9tEkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4A2C4CEE3;
	Tue, 29 Apr 2025 17:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946777;
	bh=0aGYIJf9m+EQkgJmUnc0OkvzR/zGmhmPIXNujZ+Clj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzE9tEkRpVmDC+kxMVn+rJJFnIqzxC5g16E7O6qT3hkMGaz3SBsDL83OogoSNaxz8
	 i8ZpwpvACfWIesCPAo48RzDOrTnFWvJ681fkFC4rwUVGDHb4snB72ZMY7SdFLj4fF0
	 ho/jIttJXgSdIo6G4f7Z1cM3FNPj1QzNuHNFaacY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Wyatt <fewtarius@steamfork.org>,
	John Edwards <uejji@uejji.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/286] drm: panel-orientation-quirks: Add support for AYANEO 2S
Date: Tue, 29 Apr 2025 18:39:01 +0200
Message-ID: <20250429161109.386741576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Wyatt <fewtarius@steamfork.org>

[ Upstream commit eb8f1e3e8ee10cff591d4a47437dfd34d850d454 ]

AYANEO 2S uses the same panel and orientation as the AYANEO 2.

Update the AYANEO 2 DMI match to also match AYANEO 2S.

Signed-off-by: Andrew Wyatt <fewtarius@steamfork.org>
Signed-off-by: John Edwards <uejji@uejji.net>
Tested-by: John Edwards <uejji@uejji.net>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213222455.93533-2-uejji@uejji.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index bf90a5be956fe..6bb8d4502ca8e 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -166,10 +166,10 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T103HAF"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
-	}, {	/* AYA NEO AYANEO 2 */
+	}, {	/* AYA NEO AYANEO 2/2S */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYANEO"),
-		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "AYANEO 2"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "AYANEO 2"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* AYA NEO 2021 */
-- 
2.39.5




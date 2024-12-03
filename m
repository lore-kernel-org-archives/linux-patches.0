Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BEE1F666B;
	Tue,  3 Dec 2024 14:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237759; cv=none; b=n8LQrauTNwPl3CXF+n0tFFo0UI6/jCgXuxe6ET1TCYgLTsg8EsU4M+JnwFDmTtMjCs7eOvjO8ywhFTxYlqNprInp03wnzA1as3m75OYm9tfVsAS7ejGcVbFs3ttc7d7u6gIAhwQgFjjOESPcKR+IktEr89/MVKitxjRaIM77dLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237759; c=relaxed/simple;
	bh=twPrG1vo4WEKOBpFQ0tYEi65/S64GlyiNbAtxDCA3Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k356o/vrziR9LB6YiXzkdEp9ArL3zR/BRBrCAIy9gZJwnob5voSBZ3wvpZLRMTTqPtXJUr9cz0ygHmrxcyxZ/bHAaroFwvJ1V5KT+VgkI9jWM4lbVPdf9BoKVzNLZVPLrB8AgtN2vnooNhPgjmvfi/tYRYZsTkXdMBawOngwzm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6BlvUSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6BlvUSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0025C4CECF;
	Tue,  3 Dec 2024 14:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237759;
	bh=twPrG1vo4WEKOBpFQ0tYEi65/S64GlyiNbAtxDCA3Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6BlvUSpX1GedLmJ/1Td+c4/VJ8swJNj6D+IAFg3m4F/rRjhrDU8JVirygChR8vEN
	 w1YJ9hF179pr1PfyBIYFUzb5oVxzwnHp+cGvTD4/iv9eur5xKRkPXVDHfZFQkMKaML
	 8f+do/jAJUDLbT+LPOj3MwZErauygDhV7pwJQtzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 035/817] drm: panel-orientation-quirks: Make Lenovo Yoga Tab 3 X90F DMI match less strict
Date: Tue,  3 Dec 2024 15:33:27 +0100
Message-ID: <20241203143957.020946328@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 052ef642bd6c108a24f375f9ad174b97b425a50b ]

There are 2G and 4G RAM versions of the Lenovo Yoga Tab 3 X90F and it
turns out that the 2G version has a DMI product name of
"CHERRYVIEW D1 PLATFORM" where as the 4G version has
"CHERRYVIEW C0 PLATFORM". The sys-vendor + product-version check are
unique enough that the product-name check is not necessary.

Drop the product-name check so that the existing DMI match for the 4G
RAM version also matches the 2G RAM version.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240825132131.6643-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 0830cae9a4d0f..2d84d7ea1ab7a 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -403,7 +403,6 @@ static const struct dmi_system_id orientation_data[] = {
 	}, {	/* Lenovo Yoga Tab 3 X90F */
 		.matches = {
 		 DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-		 DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
 		 DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
 		},
 		.driver_data = (void *)&lcd1600x2560_rightside_up,
-- 
2.43.0




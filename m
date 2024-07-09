Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF76158D91;
	Tue,  9 Jul 2024 11:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523775; cv=none; b=EIhl5NgbbPZKtspDCAJb0tqeC8dJAL/iVPs3Vzb03lALjRM1P+npQk2zfP9GrZLlW7vbYYnn8nQw1EnGE5CdmB9EaiD3KFFW8r9XWkORCC0Fm0DGJ1d7QvYmQBMdKpFG/swxOJlZKHQiq+ykRzmIaUzDsU4GXD5tv56VUYJB8xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523775; c=relaxed/simple;
	bh=2Bwc0t2jEkU9E5799WwD/IRD+I3pahNE795MGHlO4ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/95F6ZXcRfI5nhs2unGZVW8JZJ4/mkOrodWdA3ZohZv2xrZs/qfuU82rwj3Aji67KpHPRApAU6XUyv/jrBJHx1KJos+sALl9d+t+yXymAkZTXdJfktTyA/KqCCSfOakW5Nv3n3BV70388b8yWTbA2pcRivTDM3usNknCp9dKuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtheiXHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtheiXHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8A6C4AF0A;
	Tue,  9 Jul 2024 11:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523775;
	bh=2Bwc0t2jEkU9E5799WwD/IRD+I3pahNE795MGHlO4ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtheiXHMAHnyhfhk+A65aqoC7hqd9OwFx5K+r54YRZBjorBhHhlC4pX1GOF0410we
	 a/xBk5B9VY77WbfpVVSbnJYf15vNKhe7wIMpnDbIfto9cHaE3TCS3juPYX2sh70sug
	 2Ydxs8zs+fb2OXDWYvP6sFTT1Mt64acQv5OUxlbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Schoenick <johns@valvesoftware.com>,
	Matthew Schwartz <mattschwartz@gwu.edu>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>
Subject: [PATCH 6.6 104/139] drm: panel-orientation-quirks: Add quirk for Valve Galileo
Date: Tue,  9 Jul 2024 13:10:04 +0200
Message-ID: <20240709110702.195639200@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Schoenick <johns@valvesoftware.com>

commit 26746ed40bb0e4ebe2b2bd61c04eaaa54e263c14 upstream.

Valve's Steam Deck Galileo revision has a 800x1280 OLED panel

Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: John Schoenick <johns@valvesoftware.com>
Signed-off-by: Matthew Schwartz <mattschwartz@gwu.edu>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240628205822.348402-2-mattschwartz@gwu.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -421,6 +421,13 @@ static const struct dmi_system_id orient
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "1"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Valve Steam Deck */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Valve"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Galileo"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "1"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* VIOS LTH17 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "VIOS"),



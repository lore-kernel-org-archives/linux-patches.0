Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495D527713;
	Tue,  9 Jul 2024 11:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524353; cv=none; b=MXmF8cSAlSPzkDAKU0qGfRjssLK9GWS9eAIVBDykJkd5Znfa1leUSIaGOM6qJQpxl1uaH40J73ZijT6Ygi0dYiw0vE3uq4kfk4TZ7GCAMPkl00pkanL+xJI1ieCJcR7RKmNPWZeXpB+EeF38gZoc80tzWt1fCAfp9mSCzandPAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524353; c=relaxed/simple;
	bh=KnphAcfHPboEsiG9Aw/ko0KLNqUQr/zWXFHl9f+k7CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQWWztT2j/SezMg9AVMKe+SSH9+xb+rNkauMX7/ww0ZKD5V3SWC8zZBmgM0T633enTdb+C0KlOYuSbTn+kGRn1KbQHnZlazkLoPY1fge0SCXKMmvpVXDEeXr31lKWg6ZUTF4lHqPeA6+m1ME4sFwdTY2xznxUNJfEUln850WPks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoP/pqq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoP/pqq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C445CC3277B;
	Tue,  9 Jul 2024 11:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524353;
	bh=KnphAcfHPboEsiG9Aw/ko0KLNqUQr/zWXFHl9f+k7CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoP/pqq8O/CeSqW5uJFPG4z/wYvRB8pyGC0R0X0UMeYIf19sC1Ul2P5sotKo+X0Jv
	 hnTu4/M/YWEVQQaDU5NxM/aI6VSiUgnaQTEfKsYpFYHgrogPVY0Pew0d8UNprh/jVm
	 tsKrYPiCSjU1Ptqk8TWkJ8BBOrgRkWE4lmxY3+4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Schoenick <johns@valvesoftware.com>,
	Matthew Schwartz <mattschwartz@gwu.edu>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>
Subject: [PATCH 6.9 153/197] drm: panel-orientation-quirks: Add quirk for Valve Galileo
Date: Tue,  9 Jul 2024 13:10:07 +0200
Message-ID: <20240709110714.872414385@linuxfoundation.org>
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



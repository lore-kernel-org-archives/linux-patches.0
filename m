Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD06655E4C;
	Tue,  9 Jul 2024 11:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524715; cv=none; b=ttUT3CkI+nlpwjGL9JQN2YVdwBMRq8p62UXpFVHwTBL40wRH6odYA/QLZnQzVi1R3JyJeN1kCJW/Wl6zVU8/8L+EmnhCMYN+3H1pXaD1wIgMCdTKrQaOM/sreenpKo+3eqTnqtjyW6TC/VgLBPkS4Ojqozt2T1tx3iRYzeqiZfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524715; c=relaxed/simple;
	bh=g+eTw1sspSCrVQkNpH/CoJiq9Rsc8y9dYtyCpNL3cfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlzJBdrMU0Vv3oLMRr7ra8M4GtaYpIBxx+iuvASQqf71ABkg3Cl4oeEMkuZYtiGPgSQ7VCJkP3gK7wc+XSFPiDWUwmFYoLamKFumiZfWKc7tPHfzfYvqOK4c63oHlCR6CvLVsmqk9v9aFFt/e/NhEY0L8t+vsQFM0Gq5uQoeRU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCvcfQUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCvcfQUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F13C3277B;
	Tue,  9 Jul 2024 11:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524714;
	bh=g+eTw1sspSCrVQkNpH/CoJiq9Rsc8y9dYtyCpNL3cfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCvcfQUryDAfTdBxW5NOX4LB1obJteexJPSyJTHf13VBFKuMoODMaSR4AXic24M3z
	 +Z2D87haxhNIB5O+Rf/eoM8we0AnEOMM458zRQAIDjg/KGu1zKWorWc7VXHglItECv
	 3iVaFdP5szVKEzjmVAJfGs4sSUe8IrnYWoK4snMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Schoenick <johns@valvesoftware.com>,
	Matthew Schwartz <mattschwartz@gwu.edu>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>
Subject: [PATCH 6.1 076/102] drm: panel-orientation-quirks: Add quirk for Valve Galileo
Date: Tue,  9 Jul 2024 13:10:39 +0200
Message-ID: <20240709110654.330410686@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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



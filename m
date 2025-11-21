Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375952874F6;
	Fri, 21 Nov 2025 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733552; cv=none; b=baqFzBp+w6A+42sTQLIYLxL8eLWS9UCY/KZnNnGOVqW+5hrC0tEZiZf/QSsUFJVP1fC7low2I/xuIurTctjx6h81/U0yiPkA97ReZ4kMU5f0mPbnY0SvcfBblZ6VFHtpsqnr47GaEDDr3YfNM7fkEdT5xA5IVNc4JAde4tnHYmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733552; c=relaxed/simple;
	bh=hZU1c/q5QoszjcXQTblYbCPtEAwRPnAh1LPRhIJVqDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OInnCvm7Ua1PhIH//EQHFQny7fPVQX9cwDHcDccyNxUDxqgXfgG4KWR4idrq8HTVC8fw0+2fXM5EUvgfR4U8Bd5WpGfRoPaWiS5mzDEDcs/5KtZlZPDHBIjUZJQQ7vIruTVBkmHOPzoBIGCdE5/QHbBWhdQXtugSpjRYKCaEIZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJWmeORj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJWmeORj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67E1C4CEF1;
	Fri, 21 Nov 2025 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733552;
	bh=hZU1c/q5QoszjcXQTblYbCPtEAwRPnAh1LPRhIJVqDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJWmeORj33EGmTJ6tS0fA/JapXLT/na+S1axSSLrFFEQTCWrp3jg+YjaJiDW93wzq
	 /g+bDhEByjOeqO9PuK/KK/2v8ZjyMYcT3VorP1pfQbtCQaAe8w6EVMb3zpWS10i3jT
	 CCgxZD7goKUgBE7KL4t0cRZCMZZN/LdZKFfTBEK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 508/529] scsi: ufs: core: Add a quirk for handling broken LSDBS field in controller capabilities register
Date: Fri, 21 Nov 2025 14:13:27 +0100
Message-ID: <20251121130249.108860036@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit cd06b713a6880997ca5aecac8e33d5f9c541749e ]

'Legacy Queue & Single Doorbell Support (LSDBS)' field in the controller
capabilities register is supposed to report whether the legacy single
doorbell mode is supported in the controller or not. But some controllers
report '1' in this field which corresponds to 'LSDB not supported', but
they indeed support LSDB. So let's add a quirk to handle those controllers.

If the quirk is enabled by the controller driver, then LSDBS register field
will be ignored and legacy single doorbell mode is assumed to be enabled
always.

Tested-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240816-ufs-bug-fix-v3-1-e6fe0e18e2a3@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d968e99488c4 ("scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    6 +++++-
 include/ufs/ufshcd.h      |    8 ++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2368,7 +2368,11 @@ static inline int ufshcd_hba_capabilitie
 	 * 0h: legacy single doorbell support is available
 	 * 1h: indicate that legacy single doorbell support has been removed
 	 */
-	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
+	if (!(hba->quirks & UFSHCD_QUIRK_BROKEN_LSDBS_CAP))
+		hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
+	else
+		hba->lsdb_sup = true;
+
 	if (!hba->mcq_sup)
 		return 0;
 
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -670,6 +670,14 @@ enum ufshcd_quirks {
 	 * the standard best practice for managing keys).
 	 */
 	UFSHCD_QUIRK_KEYS_IN_PRDT			= 1 << 24,
+
+	/*
+	 * This quirk indicates that the controller reports the value 1 (not
+	 * supported) in the Legacy Single DoorBell Support (LSDBS) bit of the
+	 * Controller Capabilities register although it supports the legacy
+	 * single doorbell mode.
+	 */
+	UFSHCD_QUIRK_BROKEN_LSDBS_CAP			= 1 << 25,
 };
 
 enum ufshcd_caps {



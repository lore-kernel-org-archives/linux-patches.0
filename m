Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DDC15EFC3;
	Mon, 27 May 2024 19:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837633; cv=none; b=hcNTYOxIxfoKTcfbzQqyEHihy5XiUNpitdAGlYc3Sep75xslv0heIaVT+OLs5UsMdVjhBz8JHNMDraoBx0QLHDWBe1lBwnBc4+GxFuMPLBGA35+ifBblEgyfOgsa36Mt10W8a85hztBcCpCvA3UPErxPhrXISzn/rlEqem+klXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837633; c=relaxed/simple;
	bh=Dx236jsBTf/fST+TGdMwbl3HXvellZiT7QGNvPVzMpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqa1DAuWp50WgvrwwAXu0Ug8sajb6kNReO/7JGVqZEX7Tt6YWdNYm+D2h/dxLQIu/Duhx+3vrv/DT3G+ez9Vx86IaLIipy1h8G9etVhw6JI9KShwAW05pyvJYrLTv2sy0HIUCfrBZslDoOgPDpLW+X6zuuGnHKZGw0sX3SLbxVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DR7i1SEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DR7i1SEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9FEC2BBFC;
	Mon, 27 May 2024 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837632;
	bh=Dx236jsBTf/fST+TGdMwbl3HXvellZiT7QGNvPVzMpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DR7i1SEQnytfVklMpSFdIU+DEiQHkLBHx1TvXoyKX8Sd2c1jk0sG0j4bZ4TMiTtr/
	 q2YXrlEki/zqW840UimUcoJOqr7Opg+tJ673MkqCW4tpihmKS9+LHCmsCggi5iPFI7
	 EbO/jcI2QidN5dMIVk6NLLqf5Lw2CXsXiCfI7FCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 082/493] EDAC/versal: Do not register for NOC errors
Date: Mon, 27 May 2024 20:51:24 +0200
Message-ID: <20240527185632.878636026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>

[ Upstream commit edbe59428eb0da09958769326a6566d4c9242ae7 ]

The NOC errors are not handled in the driver. Remove the request for
registration.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240425121942.26378-2-shubhrajyoti.datta@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/versal_edac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/edac/versal_edac.c b/drivers/edac/versal_edac.c
index a840c6922e5b9..4d5b68b6be673 100644
--- a/drivers/edac/versal_edac.c
+++ b/drivers/edac/versal_edac.c
@@ -1006,8 +1006,7 @@ static int mc_probe(struct platform_device *pdev)
 	}
 
 	rc = xlnx_register_event(PM_NOTIFY_CB, VERSAL_EVENT_ERROR_PMC_ERR1,
-				 XPM_EVENT_ERROR_MASK_DDRMC_CR | XPM_EVENT_ERROR_MASK_DDRMC_NCR |
-				 XPM_EVENT_ERROR_MASK_NOC_CR | XPM_EVENT_ERROR_MASK_NOC_NCR,
+				 XPM_EVENT_ERROR_MASK_DDRMC_CR | XPM_EVENT_ERROR_MASK_DDRMC_NCR,
 				 false, err_callback, mci);
 	if (rc) {
 		if (rc == -EACCES)
@@ -1044,8 +1043,6 @@ static int mc_remove(struct platform_device *pdev)
 
 	xlnx_unregister_event(PM_NOTIFY_CB, VERSAL_EVENT_ERROR_PMC_ERR1,
 			      XPM_EVENT_ERROR_MASK_DDRMC_CR |
-			      XPM_EVENT_ERROR_MASK_NOC_CR |
-			      XPM_EVENT_ERROR_MASK_NOC_NCR |
 			      XPM_EVENT_ERROR_MASK_DDRMC_NCR, err_callback, mci);
 	edac_mc_del_mc(&pdev->dev);
 	edac_mc_free(mci);
-- 
2.43.0




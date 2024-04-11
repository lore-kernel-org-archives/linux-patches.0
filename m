Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE331E48E;
	Thu, 11 Apr 2024 10:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832665; cv=none; b=BAFQBAZNA2O76qz8IAUFw6uQwgA7lhjiR2Sp7NsTo2ywmxTySyF9N7hiUTr+8wkxRRs+bFWiDc0zCa8mCHMvj4bYa53EATglE1cV5Bj+0irgg+SVwTifDqNeuBxsZwIrt47AboInFN50BKv9OG082kdykAnmVu+uLDzzmahZg4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832665; c=relaxed/simple;
	bh=+g/xuGL/K/V7JpDQngmcAi4EzY1XtFSW966rpLcINx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBHMLG4xZLqljGXt0zGvmRQ5mSugS/YIbaXw/O3WdnCJiBAnZe3ep5ebH0M9BC8lIiQ7qJSlIA3V1SrJStr3kHv+4fNDpuK6nLNkzt6dK2L4ksLmMJe5GHK1egSTWLHtPcxXdIfXik//N9r9/OrLNsb74t6GdQMCL2D2zETgzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faDDUdJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faDDUdJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76440C433F1;
	Thu, 11 Apr 2024 10:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832664;
	bh=+g/xuGL/K/V7JpDQngmcAi4EzY1XtFSW966rpLcINx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faDDUdJDRGWmg273A/KtDL4juXzwuZnaVZZQt2osFapFc0JDjGkw+WUvgd5vIozCY
	 GHj/2c6ASVW7nsFnE1jrdOEvU4NqXOlP+2/EWF/BWsLq9Q89fw+hkD0HXIONoe40Mb
	 +1N49tGnEbu+CJToVVHG7IaY9EAqsW/1IfbYeqqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/57] usb: sl811-hcd: only defined function checkdone if QUIRK2 is defined
Date: Thu, 11 Apr 2024 11:57:49 +0200
Message-ID: <20240411095409.234522657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 12f371e2b6cb4b79c788f1f073992e115f4ca918 ]

Function checkdone is only required if QUIRK2 is defined, so add
appropriate #if / #endif around the function.

Cleans up clang scan build warning:
drivers/usb/host/sl811-hcd.c:588:18: warning: unused function
'checkdone' [-Wunused-function]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://lore.kernel.org/r/20240307111351.1982382-1-colin.i.king@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/sl811-hcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 825ff67273102..d3de9f47552d0 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -585,6 +585,7 @@ done(struct sl811 *sl811, struct sl811h_ep *ep, u8 bank)
 		finish_request(sl811, ep, urb, urbstat);
 }
 
+#ifdef QUIRK2
 static inline u8 checkdone(struct sl811 *sl811)
 {
 	u8	ctl;
@@ -616,6 +617,7 @@ static inline u8 checkdone(struct sl811 *sl811)
 #endif
 	return irqstat;
 }
+#endif
 
 static irqreturn_t sl811h_irq(struct usb_hcd *hcd)
 {
-- 
2.43.0




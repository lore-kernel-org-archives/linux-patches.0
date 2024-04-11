Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A261442F7;
	Thu, 11 Apr 2024 10:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829998; cv=none; b=D9bWd03o3qnYOKsIn9f0irhc3h2QceZKM46TA4tRvtI5RdxWOySPpr2RZMN9c5umOuCKHA60zmod2nd5dWxQbzAdfFgURXnn/a+rn14QENzzpUivxtEyWROBTJe1AQbDTp6dJnN0i3/14Zt6mEgnvfLt5IFzgNqKUQAGsPIf62I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829998; c=relaxed/simple;
	bh=MYQlsxjKSJxpCiIedykWyxuVkIjmOZjJcsWOJEpGVmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3yKl1LioFf1TYwQ2gXgH9QVE2zO+Dyg9/gDDjOMUG/0oyumniJzgg+6OJNW2xHQm2EkxrHfOWZlFQHp5z9hzwCaMVzUPDP/SFx8zy3BgHFHfW8OYiwp9ARMc+gravTXoqeKIDtEd1RGCf65EEpHM6Zg4E22JqOdNBpvP2AgU5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIPcmLZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIPcmLZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080E6C433C7;
	Thu, 11 Apr 2024 10:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829998;
	bh=MYQlsxjKSJxpCiIedykWyxuVkIjmOZjJcsWOJEpGVmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIPcmLZkvQvLVcwd6Q44fXXQO2dIQ/pNsCoga4yN/0ZqvkPV04JgIdVvVnJMSS9jj
	 gnxQ7p8ukuvSv92ET4097di1NVSS98XuHSU7YbV6UdzSTq5kXygw3AmFEx1sXWubPr
	 k3WMIVJCo6kX8Kgk7jXHrdxWhsd3bses/uMHGe2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 164/175] usb: sl811-hcd: only defined function checkdone if QUIRK2 is defined
Date: Thu, 11 Apr 2024 11:56:27 +0200
Message-ID: <20240411095424.501771210@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6dedefada92b1..873300e8cd277 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7C014600E;
	Thu, 11 Apr 2024 10:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831354; cv=none; b=dM/FSSiv8fTv9GpQcKCvgmfVYBXNnPnW2aUbvjdB/1tsH2sR5G/9n+mfnQN+a4l2qCfbOEYlt858tvIc1E7LoZUYfvXSpW79hMx5CrZeAFERSaZaDkuMYENoYeklJvfqVKLJOKrR1tjODlHx9MMnWnWh/Ce2HpFvB5n2Jj66tjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831354; c=relaxed/simple;
	bh=fKNCk1nKi4wfLbdrU2mdqEFPabRdQ5dfjZ8ev2N3i2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcuY6bo/LqILD5DaiepMxvsLe5HGMHSFcNwTXr7Y+5H/BDkLYatrQGr2bxar5RP2dgdB1PHaDKkVpZFEifGTAC/dgoeNX0t4eDE+Q7XGK18HzQoyn6XKSIQgvVfjtEYgSDbi9Qm4cvKVpY3E5FmfBIxLsig320wkj9HuqB1kOYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQ+f2GYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQ+f2GYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1340DC433F1;
	Thu, 11 Apr 2024 10:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831354;
	bh=fKNCk1nKi4wfLbdrU2mdqEFPabRdQ5dfjZ8ev2N3i2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQ+f2GYOTg+/cMP4ryIARxSX5gMnAHF1Oru5HY3+GIjykV+hUuUIxCR004kcm+rtG
	 8kKS31tAInL4GM7XJg7A7jmTvGaIKiad+Opsq6HtXCefpvec2hbiJicrUNGDizRezA
	 bu7Djo5OOR7CyrSGlZ93lRTdV7ViVsqg08zDsE+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/114] usb: sl811-hcd: only defined function checkdone if QUIRK2 is defined
Date: Thu, 11 Apr 2024 11:57:00 +0200
Message-ID: <20240411095419.699047410@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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
index 0956495bba575..2b871540bb500 100644
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




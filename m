Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30701448EF;
	Thu, 11 Apr 2024 10:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830354; cv=none; b=GpNUNkdXEPsMrwaaFuKxoytizzm7hymyttzdDIWcTbV586ljh0OizU00AAijOFk9LV6XeY+NWBKZc5SfGkzJC4HE4FL7rzPK7wMhVvJYNa8RFxDH4f19h3+BqSRAB1Yu2CLFX2eAoq1ZdRn+htnhqfUtEY8RJrZT4CDKriTAeBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830354; c=relaxed/simple;
	bh=lGvQwM7zmU5mZTtNvnsEpV9RivuLlE3Zx/IGcWD5Toc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us/k31DXvQco+z5V2FGyPW8FggouNdwouauysSqX0eh4QG1zxZlp5SPRllc64pFaC03PpBeKKToRUn0n1spt5SbuY9ChqufnREiZUazLJW0ZJ1f4QU+jlPwAe8nm9pBa789/SPMx4j0ZWruL6J6NSoPehIfhQ4JpiTKFV7R+7mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnsE6vWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnsE6vWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFC4C433F1;
	Thu, 11 Apr 2024 10:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830354;
	bh=lGvQwM7zmU5mZTtNvnsEpV9RivuLlE3Zx/IGcWD5Toc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnsE6vWN8DYJuXdC5v78HxCgGogxXi2uDFbRrHtvkfpKn/Nm1zT0zDTVWIJ5Sm1JL
	 2VkBqG0AGChluHbj4cPVSHnd18W6fokwRYyQcp9wFRPsQ93HQMrtkzJ3EHWlieAtFU
	 BuNS8d4hirUimYs7hJy2CzLgJLuUEgvO19Llb5NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 119/143] usb: sl811-hcd: only defined function checkdone if QUIRK2 is defined
Date: Thu, 11 Apr 2024 11:56:27 +0200
Message-ID: <20240411095424.488893010@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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




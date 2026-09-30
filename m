Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09535509F0B;
	Wed, 30 Sep 2026 18:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793848; cv=none; b=I0HPCX6k2d5txQOK8F5KOBtWcLU1HPNPDirxZCd/Bj65D1ri4czykjJE6tv1RSjHv7/Hx8RtEsuBa3wfWl0eIjrjCRnEccnY0NzXtNMFNvbf0UWaOwVPIM6NYfs52XvJo6Eu8y5SrISTcsajBNIPemSqDLNxOjH1In8cge7zypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793848; c=relaxed/simple;
	bh=54sd3Pl/xbjX8PYTrCM6EVMc5alabW38VRIUrQp4uLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bS7n3pwtk1PAGKEln8JBcl/7BoBxHtBpsRjD4GVNPCH007CPn8gvJLBZ47Bp0j6n5njF+G3qdw/1wn1+v+H/fSNR+dhR9Vx8wSFveb4BucDNdFL+jkL8Dh8AN16t45BG8Wneuns8XhmW2Q2fOmilDMHw6cSyc6CQk4FqpnehypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2LvIGmW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2LvIGmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663E91F000FF;
	Wed, 30 Sep 2026 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793846;
	bh=697QdIDJM4zPy8zDdwfT1eCj6vVRZH5WIcbk6Z9SuDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2LvIGmWywzmDO4FWrR9ExQfwOjD1u7bsiGMzYJEmyNRFCPyg7OzPtFXDXIh+sl+P
	 9Jt1MtUfOM/AzGds54+344OOZsmogGRtHSyzLV+DPJ0l9/6ljVglQUDorHV1G43nW/
	 XYnFuUBAIOkkdUl/xH7uVOv53iSFM6xbJ4iGkcdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/395] HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM
Date: Wed, 30 Sep 2026 17:30:30 +0200
Message-ID: <20260930152348.677037315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 5e130f58629a2819c9d053507ad368160d25eb65 ]

This increases build coverage and allows to drop an #ifdef.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: aa9dde93e05a ("HID: alps: unregister DualPoint Stick input device on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-alps.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -845,10 +845,8 @@ static struct hid_driver alps_driver = {
 	.raw_event		= alps_raw_event,
 	.input_mapping		= alps_input_mapping,
 	.input_configured	= alps_input_configured,
-#ifdef CONFIG_PM
-	.resume			= alps_post_resume,
-	.reset_resume		= alps_post_reset,
-#endif
+	.resume			= pm_ptr(alps_post_resume),
+	.reset_resume		= pm_ptr(alps_post_reset),
 };
 
 module_hid_driver(alps_driver);



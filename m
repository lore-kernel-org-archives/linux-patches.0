Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C858F56511B;
	Wed, 30 Sep 2026 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790462; cv=none; b=nKg09s3yDKacvTyL7Ws38zfTYI6U5ASXAKb+ZE3jyeMiwA5kVv8FEyD2f5+dCHPoPgjG+WXW79pQLxmGtl8VjLQ5TxHbEsD1EHXFiR4oYIndCnDln57Ci70kRrIM3f7suDDsSi9UxDYbIj82VQ90lN9M4MYgzBVXTHchnJXtIDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790462; c=relaxed/simple;
	bh=QsQqS0f3OPUC78oLsc3IBFMjEEGFslPV4ynLIWdinaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLdhE/S767yz7PnS7EOHa6LuzPGsE34dyf8B5NVmddwwGdqdqPC/7W8eVAtXy0DOVDpqgQoSRfdMcW/VhfnJ0lHUSj6B/cjyWvhHErGZzj6cJSRiZfQfqQn0RteYhsq+KEYWGb1QU13mxIdev2TtHPaVSaif64NVGF85rIGPKGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfq/Zy9U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfq/Zy9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4CA1F000FF;
	Wed, 30 Sep 2026 17:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790460;
	bh=Qb3E/fK4Ug7j7thu4XK6leWjDrGW869/Mrq5Ax+cTq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfq/Zy9UBrXcb3dOjKK4cU/XB1PZm4VcmlO5tVTqmdj7XTZ3wBDPZjVJBJPr1oBrz
	 qnG0JUlnlerh9SSC1ProTpqDffY0Z9mJTUYyvbFotSVc5NadxVxZcW2qiLoLj1fchR
	 ot/6fksf5M0/+CsCZ+tpCxxibzqb5cl8t0O0ub0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 838/877] HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM
Date: Wed, 30 Sep 2026 17:29:09 +0200
Message-ID: <20260930152432.820085454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



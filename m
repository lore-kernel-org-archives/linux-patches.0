Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA47C3AF666;
	Sat, 17 Oct 2026 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256202; cv=none; b=Rzwype2KqvSLMOxPkun4kEz2S5Zf0xLnFvgiFSEA4VhsUH1FYmxUdQYBvxh7J3O7HDexwkMamPXVRi1uz+La1tSdv8N6JYHtPYtoFLbEtOt25yvmbHy/pWMlvrp+M34yj3vDqJD+ks5MI0Wj0QktlqzX1Rf6qMdj4oCunioVnZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256202; c=relaxed/simple;
	bh=8McnJ/cjUS+mfdbgNZpX9CWNceTH7Oanf+fobp3kxsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMuuhCrk7HCRgpKsZOxAV5JSYV+vWldSR7WJv4OtPFdcG/U+8h/nybyNiLCFwGeEplsNaCh8w/N+t2H1kwo/kWzkJ6/EWPZWNG1ZJktc7b6o87b4wFZorL2UZZ642U5EalfsAmV61k8+uu4G17Qfez5QZGGOk4b7sNN/Zg9AWpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecHu00Nr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecHu00Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB5D1F000C4;
	Sat, 17 Oct 2026 16:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256201;
	bh=xnDTY+uIC9uJYqIz/Z4u1pIP26kVX2ePu+ToDqW1hEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecHu00NrrpIeAvYVmgc4hk7/Y4otjqyALtfvKeU40E6KolTGVeV1CGAaSqUqStSVD
	 qID0AzmUmGCBIW90bptmVKrjojmvbHbXyotnljSPXn8/FF+n95+GOdEzVl9oy3UtUu
	 Uno9e5+8xPuDRDS0gMMQFSFFgv4LMDsvT5irzFdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0156/1674] HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM
Date: Sat, 17 Oct 2026 17:40:28 +0200
Message-ID: <20261017160435.166500146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 5e130f58629a2819c9d053507ad368160d25eb65 ]

This increases build coverage and allows to drop an #ifdef.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: aa9dde93e05a ("HID: alps: unregister DualPoint Stick input device on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index 8aed5e17e5819..35df84426196c 100644
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
-- 
2.53.0




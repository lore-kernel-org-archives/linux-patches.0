Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C529E20316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2T1UoGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C69C433C7;
	Mon,  6 Nov 2023 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276618;
	bh=2zeopLZGW5yea+tgNF72zXMPJaxQBTNBh/zXNBDQr9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2T1UoGnZwvJCA7W1UcFd/hxgLk4Br/nJv3FEHGczW8pLCPyCoftXsFrep9yVBn9f
	 Y9nf/fKuc1fxULfSU/xqKVtFgdNBTxVHdo3iBtIfuL+VTjoeOM3aG3qordAVv+Njfs
	 pf0rPmYB/pWF9afDOj847VHQfJaX+Flf6uZuPtuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 40/88] fbdev: omapfb: fix some error codes
Date: Mon,  6 Nov 2023 14:03:34 +0100
Message-ID: <20231106130307.297147962@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit dc608db793731426938baa2f0e75a4a3cce5f5cf ]

Return negative -ENXIO instead of positive ENXIO.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap/omapfb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/omap/omapfb_main.c b/drivers/video/fbdev/omap/omapfb_main.c
index ad65554b33c35..0be95b4e14fdb 100644
--- a/drivers/video/fbdev/omap/omapfb_main.c
+++ b/drivers/video/fbdev/omap/omapfb_main.c
@@ -1648,13 +1648,13 @@ static int omapfb_do_probe(struct platform_device *pdev,
 	}
 	fbdev->int_irq = platform_get_irq(pdev, 0);
 	if (fbdev->int_irq < 0) {
-		r = ENXIO;
+		r = -ENXIO;
 		goto cleanup;
 	}
 
 	fbdev->ext_irq = platform_get_irq(pdev, 1);
 	if (fbdev->ext_irq < 0) {
-		r = ENXIO;
+		r = -ENXIO;
 		goto cleanup;
 	}
 
-- 
2.42.0




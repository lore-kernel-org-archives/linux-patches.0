Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B382414BFA2;
	Sun,  7 Sep 2025 20:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276353; cv=none; b=hn1rskrIlHzLGjN9rUaDDIFonTuGidm/NHcv3sO8fGsnPQFLyRzg8t6ZBNJlOxWsbV8bVrBt7pMiOPOw6BRQaLpvqHQ1kw01Y1/ODsYSnVmwi1wtyzbBKyvqXcYhghUL/qrgSwLIOdLf2U85o37v4a/T34/4BxwZ2fH5kXLn2Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276353; c=relaxed/simple;
	bh=YcsWqAWqOtWX2eTSJqyb8qdhyzSGW5eKL2Vid9t1Gug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHKn+18u0DgBlEULPfPq0zdfNn43zKpKE0HHqnIMvZRJ+7ZgHH0EsWhXtpAb0NAiTQhVSUFBPDr+IcM0MRCOr1BFIZwWhTHUR4pwFNnIzqJMg8M6wre+KpHMFdaFzwv/snXcIc1+J0teBFdzO7ItXhD/kKdiXOw5nxgjgB9x4Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vG6E3xtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vG6E3xtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367DBC4CEF0;
	Sun,  7 Sep 2025 20:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276353;
	bh=YcsWqAWqOtWX2eTSJqyb8qdhyzSGW5eKL2Vid9t1Gug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vG6E3xtE8vkqt3Mfgfg/bVNfQ7MiBLVSi3iNlh1+vj3M1l5OoONjJn/uCw6VPmQcr
	 ZGFmVh4TW9G8ZPlVBGhOfTQKM2+MddFKM7CXOovPnNONbo/Vlys7df3OvolbBGg2Oj
	 qrdLo7ydtKoSKynNMw5iidIJzxCT2PkkAxO1Y8/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/104] pcmcia: omap: Add missing check for platform_get_resource
Date: Sun,  7 Sep 2025 21:58:36 +0200
Message-ID: <20250907195609.723190270@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit ecef14f70ec9344a10c817248d2ac6cddee5921e ]

Add missing check for platform_get_resource() and return error if it fails
to catch the error.

Fixes: d87d44f7ab35 ("ARM: omap1: move CF chipselect setup to board file")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/omap_cf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index d3f827d4224a3..e22a752052f2f 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -215,6 +215,8 @@ static int __init omap_cf_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	cf = kzalloc(sizeof *cf, GFP_KERNEL);
 	if (!cf)
-- 
2.51.0




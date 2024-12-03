Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1271EE001;
	Tue,  3 Dec 2024 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240969; cv=none; b=h8hxIwuJ03mqO+HyCB/cckx5U2JEGSSTHF1HvqNWuc6Ffr8WVfpnGSo0BpwpIVoksIcbEpHkuHu8iAukofFFtKf0Qgd1euJ+fxFbulMObRY2nHxk3ir+tDp1vcImojOPvJXNNeZOSFrlTyAQdqnGw6Jpj6VX3RRTPpOxDqZDFAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240969; c=relaxed/simple;
	bh=ggoliECVWRiGVPhy6PhJUHQ93+4hTsCjFPEy5JGgvK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szpD9hkPNzkJYIEOdfCNZUPukwtazJySySij2MXNeSmHdkUHxf2LmkOJ+vF8IpZwnEyWGpVg7pMk2qJYHkoPuuvEJBuCInuMKv5yEyx62EMSxkXIke+v6MqleqdhEOc3mIJ0niczbD8VpSZnpul1LdtQfUNwh2IrCDP14+GVWWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXwr2mf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXwr2mf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF292C4CECF;
	Tue,  3 Dec 2024 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240969;
	bh=ggoliECVWRiGVPhy6PhJUHQ93+4hTsCjFPEy5JGgvK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXwr2mf0tlB0bBVTcrYu3NugnLP1n5uF+2Ru4oQLL8Vq56rS5XKkVufQl9aISK3/Z
	 oRGesAZARZq2LeshxlcjfTvrG0RTEAvadcjuE8QpmKpaphxVWlz1UfSY9vRLGeSsvE
	 /3ytFbBAtwTwXHVD3wiKBFgsFxzFjEQnIJpzvjPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/826] wifi: cw1200: Fix potential NULL dereference
Date: Tue,  3 Dec 2024 15:40:16 +0100
Message-ID: <20241203144755.041769138@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 2b94751626a6d49bbe42a19cc1503bd391016bd5 ]

A recent refactoring was identified by static analysis to
cause a potential NULL dereference, fix this!

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202410121505.nyghqEkK-lkp@intel.com/
Fixes: 2719a9e7156c ("wifi: cw1200: Convert to GPIO descriptors")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241028-cw1200-fix-v1-1-e092b6558d1e@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/cw1200_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c b/drivers/net/wireless/st/cw1200/cw1200_spi.c
index 4f346fb977a98..862964a8cc876 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
@@ -450,7 +450,7 @@ static int __maybe_unused cw1200_spi_suspend(struct device *dev)
 {
 	struct hwbus_priv *self = spi_get_drvdata(to_spi_device(dev));
 
-	if (!cw1200_can_suspend(self->core))
+	if (self && !cw1200_can_suspend(self->core))
 		return -EAGAIN;
 
 	/* XXX notify host that we have to keep CW1200 powered on? */
-- 
2.43.0




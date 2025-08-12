Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DD326FA77;
	Tue, 12 Aug 2025 19:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025641; cv=none; b=J5w6HqsaBEBxWzbLojmYb3QCJS8MWMoPaP8VJJRu/4LvPWGl7s9YHsXYlLBpK2z2m052QU8MxrKAZQ1KER9XQV6dxqUFTtu/V0pbzJVOfsc18CW4BI/Q34QskbfT97SyFwvl75pvOHszn/2kSYwstp78cBY/z0DsZ/IWTbgNDTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025641; c=relaxed/simple;
	bh=zgbNtByENSDdYK/l7j76fl0hy7ukANXtUGn5HEfGSx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5UroJSQZG5jX+04HsjnYMcRptcA9Khp/tqgwJApZCjWh8g017M8GqA6xxkHfbwaZmhyw5lt+aQdq8/ncK3jZS9VqavgaqB+63P80Bx6c7IOpUIluxJNH//J6SXs72JpzDD+yZ4Dai1f9QOBoJUmhXJ8QfTIgJb4GwWYSg6MZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYf+kj+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYf+kj+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441D1C4CEF0;
	Tue, 12 Aug 2025 19:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025641;
	bh=zgbNtByENSDdYK/l7j76fl0hy7ukANXtUGn5HEfGSx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYf+kj+dzF7ZnKAViGKpoJKj8upUySWC7Y8gSL8gs3vye9QM6MgX4Y+maMmLOIwNF
	 G3p9tUiPA25auKYbWuIGKyA3lGw44VaGBQV+c4I5bWC5TdjOC/p9H3bRIjpvNUE2mu
	 Cy0VJHZs39SqtSiDl8x/2l3kPWaPAHRZpnl945dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 101/480] drm/panfrost: Fix panfrost device variable name in devfreq
Date: Tue, 12 Aug 2025 19:45:09 +0200
Message-ID: <20250812174401.629463986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 6048f5587614bb4919c54966913452c1a0a43138 ]

Commit 64111a0e22a9 ("drm/panfrost: Fix incorrect updating of current
device frequency") was a Panfrost port of a similar fix in Panthor.

Fix the Panfrost device pointer variable name so that it follows
Panfrost naming conventions.

Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Fixes: 64111a0e22a9 ("drm/panfrost: Fix incorrect updating of current device frequency")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250520174634.353267-6-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 3385fd3ef41a..5d0dce10336b 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -29,7 +29,7 @@ static void panfrost_devfreq_update_utilization(struct panfrost_devfreq *pfdevfr
 static int panfrost_devfreq_target(struct device *dev, unsigned long *freq,
 				   u32 flags)
 {
-	struct panfrost_device *ptdev = dev_get_drvdata(dev);
+	struct panfrost_device *pfdev = dev_get_drvdata(dev);
 	struct dev_pm_opp *opp;
 	int err;
 
@@ -40,7 +40,7 @@ static int panfrost_devfreq_target(struct device *dev, unsigned long *freq,
 
 	err = dev_pm_opp_set_rate(dev, *freq);
 	if (!err)
-		ptdev->pfdevfreq.current_frequency = *freq;
+		pfdev->pfdevfreq.current_frequency = *freq;
 
 	return err;
 }
-- 
2.39.5




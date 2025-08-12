Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B75305E08;
	Tue, 12 Aug 2025 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022259; cv=none; b=mqMlEzuRgtyvpxjCDdvdnz9a2zKd/igcQYkwhsckk2jqYS4VaE3sJ9xDSa8PQesarPPz2cXe4HQsoSnbZAGZYYonTSJClFy0MuCdr+RVSIsAfJXDUwvvnhWuOvuqFNAYqGhqtUpUvFvY+28je6vDWcIxFN2FYVIsyngwnplvn1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022259; c=relaxed/simple;
	bh=4XnLaStQsnKoyxKsrP6G1ikUAIYS9GWH548CRu+rg2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c+1myiSJ6fNmH6JwqtddDCCJ13wWeb9QXVNcGCLqclutWlfwk2VuGa6MoG3M1TVu6E7VL1tFD6v2Adc51Rq3TyEqD+dvIWTIH8C7LF5YT2MiuLXcxvjT+sZFVuVkJ2So5NnPH8SQh7MsSbO40JX7wv9DoQ9byK04O3WwHOLUDTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwl8je+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwl8je+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532F5C4CEF0;
	Tue, 12 Aug 2025 18:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022258;
	bh=4XnLaStQsnKoyxKsrP6G1ikUAIYS9GWH548CRu+rg2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwl8je+1iL1Jb/ok/muhbPvlgo8agKPrCLkpNKV2ZJKwIv8msjQMi1e5EWRDZku7x
	 j1s469ELl8V+gtXIHlJM2zbGcZR2MSlKsnwkb47IT3eau38X9kMhsns1qsN20qvUSD
	 hUVq7QO0QIN4yqjlaGrRmiKST1o+Z8ZjtDHevU8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/369] drm/panfrost: Fix panfrost device variable name in devfreq
Date: Tue, 12 Aug 2025 19:26:06 +0200
Message-ID: <20250812173017.369801357@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




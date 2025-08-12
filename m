Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E230D26A0EB;
	Tue, 12 Aug 2025 18:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023742; cv=none; b=PD4uvGtN/rz794w7hmqq0gLF+9muPLSSzoL0PdMa6c7dSptmW4KwWFv9TiI75plcXUwS/5GaeT2l5dmwrmuW137Xc0oY3T9XZ+R0zsltE/qKXeY3d64N4Euno8R2AVygmH/qSK75EjwE3Tax1f8ZB3fR/Z7bwLNivrIgfd474m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023742; c=relaxed/simple;
	bh=e4vYY+OzEHOVfT5s8XTzX6a6tMV7lenTx/N7l2phCwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XXMoz6O9PWJM4jE6SEJOhkwYpUB3wkGa4yyp2nNsD11Y8B8ICTzZe1f6uSfjR57K9HP2cy73dKS+LyLf5HjJNLBo3r/OZczLhvb2JEkDPgXIM/QvW0+QMlscqOTjRDkigUVgapDHTde2ZxHFviYsUb0BbFP2z8jagH72AYXCSC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRw0wf00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRw0wf00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E61CC4CEF0;
	Tue, 12 Aug 2025 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023741;
	bh=e4vYY+OzEHOVfT5s8XTzX6a6tMV7lenTx/N7l2phCwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRw0wf0099zQXZBeZNNrYrGB6b1d+6cy+htiRNqRL6rzXclDAQBbM9G+FX/tojNK1
	 EeLG/yWI86XEXNUZifN8qV4Hf4r1IB1rbYKnH+c1dZY9oWHfpXdtMEFgbmjO2n6a2d
	 1ZWpJjEMP5oEaC6V0hJfdcB68HrK4eSJa9hT46VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 135/627] drm/panfrost: Fix panfrost device variable name in devfreq
Date: Tue, 12 Aug 2025 19:27:10 +0200
Message-ID: <20250812173424.442977787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9671E1C38;
	Wed,  6 Nov 2024 12:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897767; cv=none; b=HCp0Yc5MR9A9elZ+FdDucYvuD102B4AenSIDBZ+M8eZ1HT1xy1Um3DPggOHw0OWPYnWrYJJNb04AZyI4bUT2PiGgMHad/3r1y4lYehdqfcnzuIMpruDqXXzFZh0P/BRgSrIhB1MwVfGpVWRUwH4VfQdTApQ8tm8l1oyl4hMsEEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897767; c=relaxed/simple;
	bh=zZJQ6y00Y06at/mzRddhDjTfLk8ZjlZUPZsGzQqUdGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkYJ+fYbvmiwKiinJFjYTVblmIdFWyT3gwOR3AoUpmg7sLpMzwIWeQ/YQap/rQCiKNgHOBwGOgluPShy9v/uM2uTtFagkkXlI0Q+g80gdXQSx7svjCGKgj1jOLcoT9E+PYbsrNbHi+AhCyB57rI9RjtZAT6OAZZcE8U5lYFhZRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TstVRIAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TstVRIAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22623C4CECD;
	Wed,  6 Nov 2024 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897767;
	bh=zZJQ6y00Y06at/mzRddhDjTfLk8ZjlZUPZsGzQqUdGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TstVRIAj0CY8gc2wZUziWrDpp/lsadCC2IDj5cbFCMfXI+O0Koza8USIzo7QmJGv4
	 y7Uv7yXSpxV0iibNs0gtCPnQhnsavYtPb5m3bZ4XmGoExbZm8b1APVCf4K2ZaZ+/X0
	 jdDVetpAV9mdEKRqZqlpPnp3ywXo4L8s8/mSrp0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/462] ASoC: allow module autoloading for table db1200_pids
Date: Wed,  6 Nov 2024 12:58:26 +0100
Message-ID: <20241106120331.834116138@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 0e9fdab1e8df490354562187cdbb8dec643eae2c ]

Add MODULE_DEVICE_TABLE(), so modules could be properly
autoloaded based on the alias from platform_device_id table.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://patch.msgid.link/20240821061955.2273782-2-lihongbo22@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/au1x/db1200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/au1x/db1200.c b/sound/soc/au1x/db1200.c
index d6b692fff29a2..cdde5ba2ec351 100644
--- a/sound/soc/au1x/db1200.c
+++ b/sound/soc/au1x/db1200.c
@@ -44,6 +44,7 @@ static const struct platform_device_id db1200_pids[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(platform, db1200_pids);
 
 /*-------------------------  AC97 PART  ---------------------------*/
 
-- 
2.43.0




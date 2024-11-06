Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B28B1DEFF4;
	Wed,  6 Nov 2024 12:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894945; cv=none; b=cQJdQII3bWQgztfuiP+DRDIDstgMRtEGbs+y4MTkh5+tJ2zKHPXTNqLCKcXWvdcyfjBD92e1EKsyzX9NUubenmZpyrs+A4wTWIQ0wRMR7eg6ctfL/IekP1a1jEd6V3Igdj+8iVA2a8AdTSgwTkPCjvBnkbotqWbPs+VGwT1C4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894945; c=relaxed/simple;
	bh=/71qhSYi7rYutApy6drycimdqiKyn69kZN7uowmcx4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hh5FfG2HychZTszI5Dlu0+lEbmv+Z8nRbf0/iDJvM0R82AT0VCHiED/TFnPX3LF7WDqiRHpKmJNUuKHnZqpdwrBxniP0Ds5Yr+HEHhbccljxDX/Wq8kCedS6hcYZSPPg6r+jBkfjrseE8CYJD+upVm6396xrTVY1ptpjb17eXgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8G/qUnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8G/qUnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D126C4CECD;
	Wed,  6 Nov 2024 12:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894944;
	bh=/71qhSYi7rYutApy6drycimdqiKyn69kZN7uowmcx4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8G/qUnjktNAFCpcMWHq9+ojDW32Wde4SipKie6LalRI2EDKv+LX09qybKgHvyR2k
	 2df4RXp+kOKwj1oEcjiRZoF6J8yvDzlz9wRYaZr79VzXm0RcFeldHtHNkCsNvbVNM4
	 KAbzJLpu+8XuPWgIsFJ2QGhgt2nmMtFUWLqQWix8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/350] ASoC: allow module autoloading for table db1200_pids
Date: Wed,  6 Nov 2024 12:59:03 +0100
Message-ID: <20241106120321.249146740@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 301e1fc9a3773..24d16e6bf7501 100644
--- a/sound/soc/au1x/db1200.c
+++ b/sound/soc/au1x/db1200.c
@@ -43,6 +43,7 @@ static const struct platform_device_id db1200_pids[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(platform, db1200_pids);
 
 /*-------------------------  AC97 PART  ---------------------------*/
 
-- 
2.43.0




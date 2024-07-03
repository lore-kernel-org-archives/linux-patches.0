Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9372861FDF;
	Wed,  3 Jul 2024 10:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003881; cv=none; b=DSB+Oob8V9NZDvdKcWiEyWTaR7rwL2pR4K5+lfoO2HjaKEUlwmPX/nruqL5oB3oFpNupjxc1BS8Ajfiqz91LAFbfiXMxAJeSSrsVTKZ8QI1dr/4LoMKVw+81lsIPmcd++kGWgUijiX5CPjPSAZKvNsjxI3de5yEdpJRhHCyG52c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003881; c=relaxed/simple;
	bh=NIAKuHO8mltuoNJb8P8dkSiqKIHkuh3EPOAU0Aw48r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEkzfC22Kvtn4hUqVu25BqtcdtsCSzQ8qj5sjKEjTnPl6qT6NHiZi+nHDyn1MiXtoIx/xk/Oy+pflYjGiRCUTeqJYFcvtX38NEr2iuTCjIavXc4JkEekO98Fr9f3+EUofUOX0iUu4yg+BGenMh5fUGMlODrkWvIgMlhK7S12Wjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9eMI+IZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9eMI+IZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9485C32781;
	Wed,  3 Jul 2024 10:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003881;
	bh=NIAKuHO8mltuoNJb8P8dkSiqKIHkuh3EPOAU0Aw48r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9eMI+IZpbqMICq896qkJNNkQWquJ23Z5r/A/rBr6o3P8kdpvKvwGu098/jDopjPS
	 L5IOXaliUGlGm80vmakHyQh6lIqh8CIUw6iMdqG6xyK1OW22amM/459RMTdVtTTVXF
	 GnIFinfL95QYUVeUsPHjA4I8LmOad/4y1LIKqN+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/189] ASoC: ti: davinci-mcasp: remove redundant assignment to variable ret
Date: Wed,  3 Jul 2024 12:38:05 +0200
Message-ID: <20240703102842.419841298@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f4d95de415b286090c1bf739c20a5ea2aefda834 ]

The assignment to ret is redundant as it is not used in the error
return path and hence can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200210092423.327499-1-colin.king@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d18ca8635db2 ("ASoC: ti: davinci-mcasp: Fix race condition during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index 0541071f454bd..76267fd4a9d88 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -1743,10 +1743,8 @@ static struct davinci_mcasp_pdata *davinci_mcasp_set_pdata_from_of(
 	} else if (match) {
 		pdata = devm_kmemdup(&pdev->dev, match->data, sizeof(*pdata),
 				     GFP_KERNEL);
-		if (!pdata) {
-			ret = -ENOMEM;
-			return pdata;
-		}
+		if (!pdata)
+			return NULL;
 	} else {
 		/* control shouldn't reach here. something is wrong */
 		ret = -EINVAL;
-- 
2.43.0




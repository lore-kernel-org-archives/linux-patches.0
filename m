Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C87D416;
	Mon,  8 Apr 2024 13:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583337; cv=none; b=sTzm3JuI2vQBtk3EWfSwn8TCptnYmAQmAE+WgNw/Rf/wG7mJxaTeknYM+Jh4xz73dd0GfAiOjJTJF4qfoLxagBCiRD5Z2AkVxZBa7G1aKZF5xIvk2tCtms25Rv5cXffUHIZ5qhTkBz8L9FA2I9H1iLCH5181Yl+YW6rK/a1kHSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583337; c=relaxed/simple;
	bh=lE7CPWTdvL4L84BL5CTuC7ES+jSyISCn1MOQhvBtUIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R36dpCdchahrhHEtKTKPL+IBmIvBeoMG9f6MW0t3WDvhPTT6g3qnn+HJq7Rq2O+dBLRmWl40FkJGl1BvyX7SDNZEhEDqzTjwOCF57Q3QgX0KRTjrP3EWGIXCfGszxbkM7HdDlsVYuimVcmnpcYmLeF0PP8s3zdDspKp71UyBGkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H28mlllc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H28mlllc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CC6C433C7;
	Mon,  8 Apr 2024 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583337;
	bh=lE7CPWTdvL4L84BL5CTuC7ES+jSyISCn1MOQhvBtUIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H28mlllcd2svk7u6wgsGdRWsJpAwnbFjBKil8ETXg8b9SglTE9wGtF7OVALhqAznf
	 E3mSwebDKUyOgY03fkt21UPTxPpA/R96meW1oAEkIQSrkEZs2mIDfVRUUxSQ70O++1
	 MJGgQ4J2U5EasCVQZrljcwJSGxYnOuxyF01DXFUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/252] regmap: maple: Fix uninitialized symbol ret warnings
Date: Mon,  8 Apr 2024 14:58:02 +0200
Message-ID: <20240408125312.345313448@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit eaa03486d932572dfd1c5f64f9dfebe572ad88c0 ]

Fix warnings reported by smatch by initializing local 'ret' variable
to 0.

drivers/base/regmap/regcache-maple.c:186 regcache_maple_drop()
error: uninitialized symbol 'ret'.
drivers/base/regmap/regcache-maple.c:290 regcache_maple_sync()
error: uninitialized symbol 'ret'.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f033c26de5a5 ("regmap: Add maple tree based register cache")
Link: https://lore.kernel.org/r/20240329144630.1965159-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache-maple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index c1776127a5724..55999a50ccc0b 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -112,7 +112,7 @@ static int regcache_maple_drop(struct regmap *map, unsigned int min,
 	unsigned long *entry, *lower, *upper;
 	unsigned long lower_index, lower_last;
 	unsigned long upper_index, upper_last;
-	int ret;
+	int ret = 0;
 
 	lower = NULL;
 	upper = NULL;
@@ -244,7 +244,7 @@ static int regcache_maple_sync(struct regmap *map, unsigned int min,
 	unsigned long lmin = min;
 	unsigned long lmax = max;
 	unsigned int r, v, sync_start;
-	int ret;
+	int ret = 0;
 	bool sync_needed = false;
 
 	map->cache_bypass = true;
-- 
2.43.0




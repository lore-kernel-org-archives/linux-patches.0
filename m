Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C03914A098;
	Mon,  6 Jan 2025 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178750; cv=none; b=OAxocI01+MAme45LYJmU40BhpDYeP4hrY6cn5JXegqo5fDd162Kcci6jJfO0oeaIMYInSb51uWk7ijHlBnnQkgu68mnMOrHp/IxN6yS/ykreNQQASjFMDFIOhcCN06K5zmAeUoArlw3/lYqO5GgyjtLsTggYDUqrsVpTCkzd5oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178750; c=relaxed/simple;
	bh=SE8L8v6lbyVQyRJW+E8UwvDUJoZliry8OSQ/R904uaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P547NigZv5Rm3UTRPkTpyEyyj6tgP5WuHfQSoH00KqXtzIWcMB00AZ6UGGGQ8rxEyMKFmy0Vrt4sljTd4cf1DTGSgB9XoSv6zeOKAZ8qIp8j4t23vDgWyvmwQrDKCWRgnpuqnrCuvlHqbgnm6KKUlAeE1jgjt7IAdw2ffb3tBt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0At68a5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0At68a5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89425C4CED2;
	Mon,  6 Jan 2025 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178749;
	bh=SE8L8v6lbyVQyRJW+E8UwvDUJoZliry8OSQ/R904uaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0At68a5Txx7W0eDdfcFJ+rq1U2xsqtBfYsk8JS0/HfMfVZDgEMFNHNpvvNfjrgcT
	 gaZXjSQeBtbzVn2yxXU+dwW9za645H73jCi3iqHpdDjfYmgqo1dEz5Yt/3W/fF7aLL
	 qYxC869UPpuOn5/RyCj2oKqoAQta+DPWmbK20Gec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/168] regmap: Use correct format specifier for logging range errors
Date: Mon,  6 Jan 2025 16:16:28 +0100
Message-ID: <20250106151141.486861096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 3f1aa0c533d9dd8a835caf9a6824449c463ee7e2 ]

The register addresses are unsigned ints so we should use %u not %d to
log them.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20241127-regmap-test-high-addr-v1-1-74a48a9e0dc5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index faa4f7ad45a7..00437ed9d5e0 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1153,13 +1153,13 @@ struct regmap *__regmap_init(struct device *dev,
 
 		/* Sanity check */
 		if (range_cfg->range_max < range_cfg->range_min) {
-			dev_err(map->dev, "Invalid range %d: %d < %d\n", i,
+			dev_err(map->dev, "Invalid range %d: %u < %u\n", i,
 				range_cfg->range_max, range_cfg->range_min);
 			goto err_range;
 		}
 
 		if (range_cfg->range_max > map->max_register) {
-			dev_err(map->dev, "Invalid range %d: %d > %d\n", i,
+			dev_err(map->dev, "Invalid range %d: %u > %u\n", i,
 				range_cfg->range_max, map->max_register);
 			goto err_range;
 		}
-- 
2.39.5




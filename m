Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9E7346AE3;
	Sat, 12 Sep 2026 07:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198772; cv=none; b=CugpXUNO/qU75P6vMnyv+yVw5Ppz/u/Jl0lZE8KZqD3BZgwljqVWE0G7n+kmnbK1mHrFAQ8v0Ox8mzBELpP7Q6vKEBSZby+NPi94xvMiFh6+QPmUhdUldu+y3y2YjSPBg7cMZwOQLSca58n9omB38FWzSyP48QDxAT3wSfWEZ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198772; c=relaxed/simple;
	bh=4f1Is+YCtH3Am1xQGneImEWBMTkRR0SOnZcNZeLs5Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfcEfqZqUBgDANfT+HZyqSV5h3Q++IOHxlS6I3OLwn84X6nQBB0szn6u7SS2N546+e6yAcThpA+Q3rqz8dcaYiR/YO4lSt9TpcsbE/yz1tZEZXtuFpRmC88GHdq3G0nw9tfjbFG9nTOViNwR7vU3OiwOVOFqAc1zDQjaCUy606E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/7BmP5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/7BmP5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719401F000FF;
	Sat, 12 Sep 2026 07:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198771;
	bh=t0aLcuEUAxDX0SPo5MnC0IusRHb8AgOz7HO6jJahOgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/7BmP5o0WRittgtIU31ratYYkmf7wFO21EVzSOQmIGpFhnETbZ9WU9Bk0r8Rsd3s
	 Yru7LlPRUCi0pXM4ZUR9/sUXLhLYbxeNGME1+e653vxjSZ7lx3zsHVqnONPHmD4Oj3
	 OjdwAwPKMjQmZJhNJqhZiEE3dPobYPFizqpGbKEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0412/1815] regulator: adp5055: Fix error code in adp5055_of_parse_cb()
Date: Sat, 12 Sep 2026 08:36:02 +0200
Message-ID: <20260912065658.563442116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 153bc959ce0f91b4446fb6fb805b8c1d2ca20c75 ]

This code accidentally returned the wrong variable instead of a negative
error code.  Return -EINVAL.

Fixes: 147b2a96f24e ("regulator: adp5055: Add driver for adp5055")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/alFJVBbiFNxhqa_1@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/adp5055-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/adp5055-regulator.c b/drivers/regulator/adp5055-regulator.c
index 9ebd52b392357..7eaa7d9dc08cc 100644
--- a/drivers/regulator/adp5055-regulator.c
+++ b/drivers/regulator/adp5055-regulator.c
@@ -224,7 +224,7 @@ static int adp5055_of_parse_cb(struct device_node *np,
 		adp5055->dvs_limit_upper[id] = pval;
 
 	if (adp5055->dvs_limit_upper[id] > 192000 || adp5055->dvs_limit_upper[id] < 12000)
-		return dev_err_probe(config->dev, adp5055->dvs_limit_upper[id],
+		return dev_err_probe(config->dev, -EINVAL,
 			"Out of range - dvs-limit-upper-microvolt value.");
 
 	ret = of_property_read_u32(np, "adi,dvs-limit-lower-microvolt", &pval);
-- 
2.53.0




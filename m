Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A5B43AAE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nl1rEHbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1099BC4E777;
	Wed, 15 Nov 2023 20:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081645;
	bh=WupA6UGjpumy57daNgDr0RIKZrYS7My2kLAFouEVGNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nl1rEHbgqpqXt2cJiuENiePAe2xHdBpeXjeqnfDXVZWcwcZ5KjLNDDpxPo/0tvXVN
	 8QAdUnAKo5FmVsV8bUPVcgbyLulSf9991+odKQv+OSfae0QlmgZPWbkluY0bFtRK3o
	 l6R2VmfUOQ9eU/3Rm8bUJTGwWDKbCy3f7txV9HyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/191] regmap: debugfs: Fix a erroneous check after snprintf()
Date: Wed, 15 Nov 2023 15:45:11 -0500
Message-ID: <20231115204646.717615190@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d3601857e14de6369f00ae19564f1d817d175d19 ]

This error handling looks really strange.
Check if the string has been truncated instead.

Fixes: f0c2319f9f19 ("regmap: Expose the driver name in debugfs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/8595de2462c490561f70020a6d11f4d6b652b468.1693857825.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 211a335a608d7..ed54dc31e6fd4 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -48,7 +48,7 @@ static ssize_t regmap_name_read_file(struct file *file,
 		name = map->dev->driver->name;
 
 	ret = snprintf(buf, PAGE_SIZE, "%s\n", name);
-	if (ret < 0) {
+	if (ret >= PAGE_SIZE) {
 		kfree(buf);
 		return ret;
 	}
-- 
2.42.0




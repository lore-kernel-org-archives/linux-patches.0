Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7987043AA3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJDMUEVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265CAC433CA;
	Wed, 15 Nov 2023 22:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085742;
	bh=ukS6b+fyk8d7Ax0780a8lfg0P4jN59a96d7/pbo9rAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJDMUEVpOaoeCi/XLlFAWfAy8f8gzTgFUIlsBF06y4FXNradfRLfI6NyF8gYZhNFD
	 kmytjaGtv4892lDsCmwAgQKA9epsd7J/P4fRGV48U06IZJ7cT0qc6yc87DlDZ4N5J4
	 zUfziOL3h7SiKcWDm5P7G4c9mVLhh1FQGvMVHRBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/119] regmap: debugfs: Fix a erroneous check after snprintf()
Date: Wed, 15 Nov 2023 17:00:13 -0500
Message-ID: <20231115220133.339014530@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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
index 4f2ff1b2b4502..214d19d1337d3 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -49,7 +49,7 @@ static ssize_t regmap_name_read_file(struct file *file,
 		name = map->dev->driver->name;
 
 	ret = snprintf(buf, PAGE_SIZE, "%s\n", name);
-	if (ret < 0) {
+	if (ret >= PAGE_SIZE) {
 		kfree(buf);
 		return ret;
 	}
-- 
2.42.0




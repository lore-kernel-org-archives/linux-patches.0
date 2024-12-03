Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A481F4283;
	Tue,  3 Dec 2024 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240400; cv=none; b=ECuSK3bBuyG5lsqoN3azMfdkG1he+2g0v6JVKZt3YjfvhYKQFPeBw04lCckc1OHUmmM92b77Zc81vFASfJnrYJlXOKAU6LoNonXWYmhAI5cG+0JHw1pKSJevey+fb4rvHvpzaCR6Ez3VYoidObb4d2ZHw9fGJBBbW1soqjdNb0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240400; c=relaxed/simple;
	bh=5UPqwYSVO21e99d+C5OKlPdPXZa5560epyHZrvvWO00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRLOlDM7xLC2RrKf9IuB+FqLFskQc2uvdg833cMLti6sKCFV/Y2dfoNVEHYVwq8ti8C2S4FBm6Yw2JUnpGXQGNal2vwGAYE5kHjuZQwzQyxe3aIw/SIpoXfoKuf7eZPjxMVZNYtPl3ZU8xBjv75amMRnYh0Aj3iEAasFsEJYsRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIekWEdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIekWEdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB10C4CECF;
	Tue,  3 Dec 2024 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240399;
	bh=5UPqwYSVO21e99d+C5OKlPdPXZa5560epyHZrvvWO00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIekWEdyVKdY27VsVokokjR2EuQYM8wOAaC+JNQ0Cu+ckLH324bimXdUoxwRzEELj
	 Jepym130AYymro2W9tLouS+YRTU40a8zW+JVX0sFkW/VJGUoc4brq0qXBD6dYUpS+I
	 /PcH6SRoZEcOQmd+qCvXztj+a8e27apHfqLwi+m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/826] media: i2c: vgxy61: Fix an error handling path in vgxy61_detect()
Date: Tue,  3 Dec 2024 15:37:31 +0100
Message-ID: <20241203144748.579701628@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0d5c92cde4d38825eeadf5b4e1534350f80a9924 ]

If cci_read() fails, 'st' is set to 0 in cci_read(), so we return success,
instead of the expected error code.

Fix it and return the expected error.

Fixes: 9a6d7f2ba2b9 ("media: i2c: st-vgxy61: Convert to CCI register access helpers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/vgxy61.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/vgxy61.c b/drivers/media/i2c/vgxy61.c
index 409d2d4ffb4bb..d77468c8587bc 100644
--- a/drivers/media/i2c/vgxy61.c
+++ b/drivers/media/i2c/vgxy61.c
@@ -1617,7 +1617,7 @@ static int vgxy61_detect(struct vgxy61_dev *sensor)
 
 	ret = cci_read(sensor->regmap, VGXY61_REG_NVM, &st, NULL);
 	if (ret < 0)
-		return st;
+		return ret;
 	if (st != VGXY61_NVM_OK)
 		dev_warn(&client->dev, "Bad nvm state got %u\n", (u8)st);
 
-- 
2.43.0




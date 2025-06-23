Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E4B1E5206;
	Mon, 23 Jun 2025 21:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715897; cv=none; b=pPtQPTRz/RJR01PPw7YrgugR2jooPW8k+LMRQFYQ688GsNrHkdA40r9KQbjQmgfLZs+uQn91xu2S/mJuBePX5IQkYVj18bZNYouE0XDAlMIh/X69F3aiqETKXL/xNKZalS4R5LiaVrVgWi5S7KQksYN3fJsAzorh5FQ4iXciGBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715897; c=relaxed/simple;
	bh=Nj0yrQNyxHX/vhNTn/J9vaqUtk38m5nlfAA8sqbxz2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDs/gff8Ft3Z1mMDsxFvL43v2EGICQX9+YAfKHe4iWJwmce0vZGTJb3tdqnO/wbbm8+kRDx/ugjArhoP1tlI4ozrLmZQ4t3B7aJc8kk+pMNnVl/4sh65caRJ/U5ZpJSkz2tLdtXG3y7tJK94BlYn49Cxgh4UJCJ48SHM6L0kNgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBVptEpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBVptEpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A902C4CEED;
	Mon, 23 Jun 2025 21:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715897;
	bh=Nj0yrQNyxHX/vhNTn/J9vaqUtk38m5nlfAA8sqbxz2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBVptEpXRBzoE9/Til8r5Q1HQowQebIuTjAxF7PSe45QHM3Hh/3Wvhv7dSDeoUUg/
	 2Aw16TLmJVMaKtetAfP/X+FrNQaZDLJNOfVWIxen07IawaorJ/SXboc6DXuHP0r8KY
	 zpvUKWzAl5+qRLxASYde3RZmrgj+KUsyLkdEOv3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 510/592] drm/ssd130x: fix ssd132x_clear_screen() columns
Date: Mon, 23 Jun 2025 15:07:48 +0200
Message-ID: <20250623130712.564887849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit e479da4054875c4cc53a7fb956ebff03d2dac939 ]

The number of columns relates to the width, not the height.  Use the
correct variable.

Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: fdd591e00a9c ("drm/ssd130x: Add support for the SSD132x OLED controller family")
Link: https://lore.kernel.org/r/20250611111307.1814876-1-jkeeping@inmusicbrands.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index dd2006d51c7a2..eec43d1a55951 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -974,7 +974,7 @@ static void ssd130x_clear_screen(struct ssd130x_device *ssd130x, u8 *data_array)
 
 static void ssd132x_clear_screen(struct ssd130x_device *ssd130x, u8 *data_array)
 {
-	unsigned int columns = DIV_ROUND_UP(ssd130x->height, SSD132X_SEGMENT_WIDTH);
+	unsigned int columns = DIV_ROUND_UP(ssd130x->width, SSD132X_SEGMENT_WIDTH);
 	unsigned int height = ssd130x->height;
 
 	memset(data_array, 0, columns * height);
-- 
2.39.5




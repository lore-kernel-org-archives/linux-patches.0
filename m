Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29AB32B126;
	Sat, 12 Sep 2026 18:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239082; cv=none; b=R+Z6bjcgwUaZvuB9KxWRZlR5FcT8l/Bb9h5ZYFMnI5x0SI85D2TB9yk1Hd1jfHI6BfcNtywrAnrKznQG5DwHH3vMq+D/uOlWYV7IaANh1xcYxx4GrMUAAcWlRxumKjszyw8JCYDXJ4pLfDzvf7osGT0zIz8oDYh9wr2PEuiAjwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239082; c=relaxed/simple;
	bh=Zd1ec5OfIwL1+vNGa0sObVaHbgtaPmnA+3E46a9XcwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjRZYO+SNSreU5LCiWYeae0JxZ+q+TeD2NISRnI7qvLM8s2fjhhYYPZWRmcbyHyUt9G6XfRApfRi3uB76gJ/X8S9xgzjGAGRGyVdz6m96WvYP5g+NZWN9jlbZrWBuz5wiRoDxE20OJ0NHF/RCc8JkKSAFuTsprB1accbNYoe61Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDaIU7ew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDaIU7ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BDF1F000FF;
	Sat, 12 Sep 2026 18:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239080;
	bh=oydcHwAVZQAmbjCOL6jORbiT1Ra8Pogjrw67JX6wTaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDaIU7ew4nd9UQmstY2rAJ+YRdqe20Wd4W86yrOVtOlR/Cjl9hXpPynxEXlPCzyDQ
	 34yPryx1A2WSDn7e8v2lfDiNuUepmjhJepCaGnTnVVTmhR+zx2dXqj1mRae34iTDkj
	 cvx95WL8rjqufdvxelVc0P/QdhxrLA5geio3DvBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 593/935] drm/tve200: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 09:00:23 +0200
Message-ID: <20260912065540.440703223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit b6c3585f2058e0fbfa8cb403458f5cc6cf5c5e06 ]

The TVE200 DRM driver can be built as a module and uses tve200_of_match
as its OF match table, but the table is not exported for module alias
generation.

Add the MODULE_DEVICE_TABLE(of, ...) entry so modpost can generate OF
module aliases for OF based module autoloading.

Fixes: 179c02fe90a4 ("drm/tve200: Add new driver for TVE200")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260715024130.186416-1-pengcan@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tve200/tve200_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tve200/tve200_drv.c b/drivers/gpu/drm/tve200/tve200_drv.c
index 7fa71c8bb8289..344126abb69a9 100644
--- a/drivers/gpu/drm/tve200/tve200_drv.c
+++ b/drivers/gpu/drm/tve200/tve200_drv.c
@@ -257,6 +257,7 @@ static const struct of_device_id tve200_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, tve200_of_match);
 
 static struct platform_driver tve200_driver = {
 	.driver = {
-- 
2.53.0




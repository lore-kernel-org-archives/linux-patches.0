Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BF13644BE;
	Sat, 12 Sep 2026 07:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199728; cv=none; b=bGa+uy5+IBck4Y4nqVW7pYrhs4rmg72fLTCv+HLMwx4/7JV4VzfMwLFWKcs1C6RmI1orj5I1+uxXfbG0N1vTtaczrZTFagblR5qIpam06rk2TXnyNSwGqYaALkxkMKE9pl7Dn897bUGfSjNPWFU93ucIUGtTQkmSujLEjSIF3Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199728; c=relaxed/simple;
	bh=//edd/z4Nn25ADPLXiR7ieP5lYm04yNsePnQSAkmbdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9Z5iTWSoeC1d8CAfxrflzB0l8g0INCVnHWDdjS0mY9Z76IsPKsNIyDDE2FWRaXKgR/q04YnkrNLNgbO3RurIM7PH3UI4xMZWq7SnqnPcSGf6NiAPSKUFpYGYgAJ3i59K3oDq7tH3m72kBABkTZxBNYS1c7suTM4zn3XLUHbriY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFLZert0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFLZert0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F321F00893;
	Sat, 12 Sep 2026 07:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199726;
	bh=EUUGqRcZKeaWXejG5NyVUJpI7xKV6i8CBoEEjXhFUEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFLZert0qNgqE3l5XsSRP4nPdr1PkeSXLK3ZUpsI7cQHoJG7WdwJn/Q/GBligUm/P
	 WwPFU3Gvl82T65JFGMtAaQRHEAxBtLFxa1mS3Cn0IZnzyCISSazh1XX/5YccbUD8X5
	 oS8mH/T+nnLk/36q51QqRuAEVcuKAWrJ9l9MHTmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0637/1815] drm/tve200: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 08:39:47 +0200
Message-ID: <20260912065703.834561247@linuxfoundation.org>
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
index 562f3f11812a3..f5ef468538f9b 100644
--- a/drivers/gpu/drm/tve200/tve200_drv.c
+++ b/drivers/gpu/drm/tve200/tve200_drv.c
@@ -263,6 +263,7 @@ static const struct of_device_id tve200_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, tve200_of_match);
 
 static struct platform_driver tve200_driver = {
 	.driver = {
-- 
2.53.0




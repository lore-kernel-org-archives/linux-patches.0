Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FCF1FBEA6;
	Sat, 12 Sep 2026 19:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242743; cv=none; b=I3WWk16J98vjC38abEb7PVrFgJ8m0lmWxaVB1dglMj1zyFb2Vc5tMFhfifwZiTVS5RBKbnyJlhWFuVQkcqFkvn0BfmTQrw1ktwWode4Je7JCDzvXLArg0bAsdNaP5zWmkn4y/wUPGzu/h0nOpYuxPuw3BCR5uw8MH8LSlNinX04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242743; c=relaxed/simple;
	bh=UEZ6doNiB+qJIe+LMW4195pE23SOnWEiiHbpKu70DoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmsZ89k869PBatHkHZTPI46oC9UHonneVT0meGmIm2NvgRgz9oHL+Ai+VxdDknLu0qtrTlPKJNZhiQgKxUWQBzDcMIuGxCQbEpVFHdJf6JyZxCN9R82zJ5DWebZw8cP+Mvf+c03S6Saerj1/6rZ0/ypn8LhVKfqi4IYvxBb/510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCLC3qsL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCLC3qsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389011F00898;
	Sat, 12 Sep 2026 19:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242742;
	bh=HPsc4Sqg53m47o+ItoD+a1K0ds+kFAiU7rjfs7BSCH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCLC3qsLDrAUpofTgAaUF6e4PqeHfpG9Qbz2rkd/4NiyniLcuwSiHEDnp4TOkSP4j
	 30KFEl1QZpCWcLNcgrrsJ2QxemFj3/VN6s7WR9cfRcgkEyii9I67be7LdxRR7+pRjP
	 MhmdZMc1Xi2D1vmIQ7wcD8TPJjwWHQLaOHB427Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 509/798] drm/tve200: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 09:02:17 +0200
Message-ID: <20260912065528.801033505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b5259cb1383fc..c15abcb0cf0dc 100644
--- a/drivers/gpu/drm/tve200/tve200_drv.c
+++ b/drivers/gpu/drm/tve200/tve200_drv.c
@@ -258,6 +258,7 @@ static const struct of_device_id tve200_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, tve200_of_match);
 
 static struct platform_driver tve200_driver = {
 	.driver = {
-- 
2.53.0




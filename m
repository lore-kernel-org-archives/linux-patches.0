Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36B02F0673;
	Sat, 12 Sep 2026 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230014; cv=none; b=Ht4mFW1vFMtVzdtMMbwXMGfWALI1nTeDqFlorFSeGrAbT9hOIPW1THhJNUMDgNrh4gdCyF1kYJNlYQ7k19iTZBLwZ5i6BR3uSTQ48Ks9RNJwzYQ4VPbcCjepJU4BxbzKx36Zl4vGqSheT/+6TSXkW3T8iYIPAqffxviSeYuJqgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230014; c=relaxed/simple;
	bh=pHqlPqyXsGPea8oP+h0qcZzUdclKbo8RKjWlbU1OH4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0bR06wBmTRhKab+aUP3ooY9WAjHQbxhUo3XCggv3qshayZViL8/YKuxWnOrY0djSTQZdjkf2AHhPJ5q2opmqEWIY5R0ncRY8/N+Qi1WyYsRR4SDMlzJ9upy/KDcblS/fBYwBXoPSGmlBo297HjtLtK/TLU47J4D9zl8WcbUGWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6IyCMfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6IyCMfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4491F000FF;
	Sat, 12 Sep 2026 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230012;
	bh=hpW3y06Nsz9KFKoyCYZTslt1xkWdcYUBi7nAoD9iMz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6IyCMfEZsYuDZdKUKNVdRZ9eEntxvnA8spudCLmVQPw0dpIoknxgxVLdaEvzTrce
	 FXis2MjelKHc0gawaEaPMq67hsZL2geu8YVzeKg4cwgAVHpUOv3eJC5ua+DgL6iJJ8
	 BAo7c8Mr8Uke6FmfIAE0T4hHW61P4cxnyvDukQWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0708/1191] drm/tve200: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 08:57:16 +0200
Message-ID: <20260912065604.172108444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 04db72e3fa9c2..ed67d726436bd 100644
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




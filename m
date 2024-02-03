Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACD3171D4;
	Sat,  3 Feb 2024 04:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933929; cv=none; b=Y7Nu4b9hGSYJmg8VHHmrgG63f4lNVImNUc/73/+adH8UJe+2su5J0nQzRqBDdYVgPISVVXHk7wEPVpjL4WXdgHP6yVkyR/KsP1T8lck/UXxIBUKNpI32aYTTkT0elqC18EQtg6t9GmbXeKuJl5f3l8LgSMOuqrXQ9Kly/KWyyK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933929; c=relaxed/simple;
	bh=tw4SOrVBkY4xPskPYQTb8goULOxeriy+5ZPxoThUxCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC3n+SPHWCD2my9INzR5FerGPTHZpybYhuWVKrvgFNGtgUtjexlrukjZEp3Zbt8tEH7GsQuz5ccwfY2CLLF8JHNHEd4Z6PAqhMiSp34121LMZXb5jlSrtFvyRkY/TiQ90HN+awn3pmWh8gJ+/ejjQtStLobjdgWhGQOMSQS0EDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffqqloid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffqqloid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9FFC43390;
	Sat,  3 Feb 2024 04:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933929;
	bh=tw4SOrVBkY4xPskPYQTb8goULOxeriy+5ZPxoThUxCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffqqloid7dfHM5RgLIgtIDlm4kLt5SyJaYIsNsGOGMdnHnzCjE+1GyaWbswdI3cNX
	 gX+pg+W9rB/mSi5pDa/eHoPZOtJBcDc061P1CFfSQUHEH7S4H0EQGbXSCEIszEX7BQ
	 OKGXbPJSObjyS1cajJEgsZ9shr0AT+zWq7JCBO7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piro Yang <piroyangg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 262/353] staging: vme_user: Fix the issue of return the wrong error code
Date: Fri,  2 Feb 2024 20:06:20 -0800
Message-ID: <20240203035412.035680910@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piro Yang <piroyangg@gmail.com>

[ Upstream commit 5090a4bc2a2f04b7693b49500ad1287e8d0fb6c3 ]

Fix the issue of returning the -ENOSYS error code when an error occurs.

The error code of -ENOSYS indicates Invalid system call number, but
there is not system call error. So replace -ENOSYS error code by the
return -EINVAL error code.

Signed-off-by: Piro Yang <piroyangg@gmail.com>
Link: https://lore.kernel.org/r/20231219170447.51237-1-piroyangg@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vme_user/vme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vme_user/vme.c b/drivers/staging/vme_user/vme.c
index 5c416c31ec57..9bc2d35405af 100644
--- a/drivers/staging/vme_user/vme.c
+++ b/drivers/staging/vme_user/vme.c
@@ -341,7 +341,7 @@ int vme_slave_set(struct vme_resource *resource, int enabled,
 
 	if (!bridge->slave_set) {
 		dev_err(bridge->parent, "Function not supported\n");
-		return -ENOSYS;
+		return -EINVAL;
 	}
 
 	if (!(((image->address_attr & aspace) == aspace) &&
-- 
2.43.0




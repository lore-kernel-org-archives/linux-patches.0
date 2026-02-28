Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C667B3321D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301258; cv=none; b=fq4QAzvFoQDIWPqsIWJkLXauX0vTsKXjbDJ/Y04qdw5YTliZMQAjaN8tO05MYfrQi2GcpQR6gWeL0VpGmpafjtFqeX6qgl1KG0HcJ0IzRwuZvSeoVkhJSgc4mvuJQHAJswbl0wd9zkr+h9/hOETCG7OuXRmHDw+3G+FEOe0vMCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301258; c=relaxed/simple;
	bh=+M3Ojoc64XvgPwIK89boFs6nFnX5f6iJJtVGh9XQs3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc9GDBy9QHM1ffTgfQktQlro1A7pfZ7SSF6BuW4WaYigVnnMmLsaHR6Ndbtly5fpw1SybLrMma6tJcV1DTO/8zvYZlKxvADZmn5XNSpG7GCCd503RCAgYyfx30CCZ4fOu8tJJzJuJjrHf6+HJJnXxuwwH40i99p1iQYZ/TI6yaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IkbrAR+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IkbrAR+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20357C19424;
	Sat, 28 Feb 2026 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301258;
	bh=+M3Ojoc64XvgPwIK89boFs6nFnX5f6iJJtVGh9XQs3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkbrAR+AclG75GpNqHIWxmBzc5GRC2pMh2xNqIoAIML8IX12+THxhu3kQsGg+UCg7
	 3d8bpMtfY6CnFTTpRFOYwQuN9qLQUjeHSr/Dy/tbtajw901YOjYT4/8ZTSBZ8fv2pS
	 rgTho0FDYBEduM26IWxBvu13uqYdtZJC4+TTJ8mp6egGRvAwwHhMl203KGQV3R4678
	 ko6MMw8vsPjl9FntGk0wEj7sZdGgA9VzTdQnuQcqZnCV8Y8kOtJKmrRq9YjZt7ozfT
	 2NZ8vyzer5mwzF2hyciLN1Y7KhzG3hdbwK5f59Y6Buo3y/paPivoRWpV0CJxU3vp98
	 SHMeB0frOIdBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 442/752] dpll: zl3073x: Remove redundant cleanup in devm_dpll_init()
Date: Sat, 28 Feb 2026 12:42:33 -0500
Message-ID: <20260228174750.1542406-442-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 676c7af91fcd740d34e7cb788cbc58e3bcafde39 ]

The devm_add_action_or_reset() function already executes the cleanup
action on failure before returning an error, so the explicit goto error
and subsequent zl3073x_dev_dpll_fini() call causes double cleanup.

Fixes: ebb1031c5137 ("dpll: zl3073x: Refactor DPLL initialization")
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260224-dpll-v2-1-d7786414a830@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/dpll/zl3073x/core.c b/drivers/dpll/zl3073x/core.c
index b20d4f24c0e94..b9b7c751b7602 100644
--- a/drivers/dpll/zl3073x/core.c
+++ b/drivers/dpll/zl3073x/core.c
@@ -978,11 +978,7 @@ zl3073x_devm_dpll_init(struct zl3073x_dev *zldev, u8 num_dplls)
 	}
 
 	/* Add devres action to release DPLL related resources */
-	rc = devm_add_action_or_reset(zldev->dev, zl3073x_dev_dpll_fini, zldev);
-	if (rc)
-		goto error;
-
-	return 0;
+	return devm_add_action_or_reset(zldev->dev, zl3073x_dev_dpll_fini, zldev);
 
 error:
 	zl3073x_dev_dpll_fini(zldev);
-- 
2.51.0


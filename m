Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A027C1E86C;
	Mon,  1 Apr 2024 16:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989641; cv=none; b=fQLupZtUBB4u01BGZp1xXyZMgczupKLoBB8n0zew8N0M4Ozr1qsfyRSUb1IiJUkn4YKnvyyCnC/ei5r/9hfGtdcgHPVGj1+ddCqr9m7A/HyPCVqfgyz56u/m5vQ6Qmy7yc1cEM6giuwn0GjNGyBaiqb1TnuocIa+Z/WBeEEMlE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989641; c=relaxed/simple;
	bh=FNQnGKW/68zelpx1pwGlWeDEONGyyuY1IHg1yppW4/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC0+zMBwYJG44A7I9srDEVcszbtAtaz80qnB9jLQXJSNv7XUQ4Tt1Ws8FeR80qolUyKHp5SsEyVFOASy4cZOBBBDwNV8EhSnSyzAKEqYnUoLfbT8WYdwQIXADN3iL6S7eD5XbIzItng4Wch86HueFcLaJdW+UrS9oh6D4AOXDxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NW/3RRrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NW/3RRrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32D5C433F1;
	Mon,  1 Apr 2024 16:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989641;
	bh=FNQnGKW/68zelpx1pwGlWeDEONGyyuY1IHg1yppW4/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NW/3RRrguvraGLmntG8IT5dqadEYGFHvV2yWAExJc/PGVt7KTElRm5fF0Jtb4Wvy6
	 TZYaDQaaME8ZvQ6uGC8kAasifTD77acwYojfV6UFV01SGHF8w3zQzwRwRpLjoCRvH2
	 GLsqwLvrwHCpjLZlK3h6iaWPR0HEnEPBWHHNQU0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/396] slimbus: core: Remove usage of the deprecated ida_simple_xx() API
Date: Mon,  1 Apr 2024 17:42:38 +0200
Message-ID: <20240401152551.168700611@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 89ffa4cccec54467446f141a79b9e36893079fb8 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range() is inclusive. So change this change allows one more
device. Previously address 0xFE was never used.

Fixes: 46a2bb5a7f7e ("slimbus: core: Add slim controllers support")
Cc: Stable@vger.kernel.org
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240224114137.85781-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/core.c b/drivers/slimbus/core.c
index d43873bb5fe6d..01cbd46219810 100644
--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -436,8 +436,8 @@ static int slim_device_alloc_laddr(struct slim_device *sbdev,
 		if (ret < 0)
 			goto err;
 	} else if (report_present) {
-		ret = ida_simple_get(&ctrl->laddr_ida,
-				     0, SLIM_LA_MANAGER - 1, GFP_KERNEL);
+		ret = ida_alloc_max(&ctrl->laddr_ida,
+				    SLIM_LA_MANAGER - 1, GFP_KERNEL);
 		if (ret < 0)
 			goto err;
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8005731C;
	Tue, 23 Jan 2024 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974028; cv=none; b=IO9qr2h8p23Ca9Iq961YQkLABu3SkNIEI/CVo4JWw2HGfhqt9Xz4XK0F+dyiCQq5JYjO9RiK2MOj6mSn+7TWtI324fHhCgOs+Mnth/BITsIct4KtFcjMGZ8FjsOBBqRUgZLFSriCYj7UdRSjO6agC3pjnt7QR/33+TnI0OXKAxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974028; c=relaxed/simple;
	bh=RKquzdfDiwxbJ5TipOs/CfDmwzFu3ubnPMsxjZEZW2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPp3X5DXwrY52TSaVE+e2xqmCgDcl9UYCdaZGBe5I7aSVIqIxafgqkyt7uLRewCFEJcjYTEJT5MjsNGNfNCtNhzfPygncDbgbJ0ORP9yhECqWkK5NLYlbGKNxRZokYLDELT5+d2Yl41HN9RBcZS/YXz3m1pe82Mt+d8fcaBIOgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYeEyzCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYeEyzCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9D2C433C7;
	Tue, 23 Jan 2024 01:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974028;
	bh=RKquzdfDiwxbJ5TipOs/CfDmwzFu3ubnPMsxjZEZW2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYeEyzCY30OcXWmK42lulhpmchtl0PdA+t4nKlDXqDJQq7BqX148Ppm0d/hTqCbGW
	 CJjhYSBu1QAwev++M4sDRgQx0spY7BPtLh9nniFyEdM8nROxe9fLvvGlI9NgvzKsw0
	 krf9RN1ejHMD12i7npi+WOXBBf9aUyOOwqTzaHxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/583] perf/arm-cmn: Fix HN-F class_occup_id events
Date: Mon, 22 Jan 2024 15:50:59 -0800
Message-ID: <20240122235812.495205468@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 590f23b092401f29e410fd4ca67128fcc45192fc ]

A subtle copy-paste error managed to slip through the reorganisation
of these patches in development, and not only give some HN-F events
the wrong type, but use that wrong type before the subsequent patch
defined it. Too late to fix history, but we can at least fix the bug.

Fixes: b1b7dc38e482 ("perf/arm-cmn: Refactor HN-F event selector macros")
Reported-by: Jing Zhang <renyu.zj@linux.alibaba.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/5a22439de84ff188ef76674798052448eb03a3e1.1700740693.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index caae2d3e9d3e..6404b17d3aeb 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -811,7 +811,7 @@ static umode_t arm_cmn_event_attr_is_visible(struct kobject *kobj,
 #define CMN_EVENT_HNF_OCC(_model, _name, _event)			\
 	CMN_EVENT_HN_OCC(_model, hnf_##_name, CMN_TYPE_HNF, _event)
 #define CMN_EVENT_HNF_CLS(_model, _name, _event)			\
-	CMN_EVENT_HN_CLS(_model, hnf_##_name, CMN_TYPE_HNS, _event)
+	CMN_EVENT_HN_CLS(_model, hnf_##_name, CMN_TYPE_HNF, _event)
 #define CMN_EVENT_HNF_SNT(_model, _name, _event)			\
 	CMN_EVENT_HN_SNT(_model, hnf_##_name, CMN_TYPE_HNF, _event)
 
-- 
2.43.0




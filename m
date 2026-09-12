Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66D04BEE55;
	Sat, 12 Sep 2026 14:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223548; cv=none; b=VlVMpVXBFdslxw5i27VbK0cmD9YufSAG9j4GYyxHzUrQ0oSrAvd5rlEXOv1UVZJQQq65a4bKNkKGe2fn6rc/9LXvpS1xsI+Kbm0ZLehf0ny4cNtNVokY5Nzr+8ary3P/23RHS9mp6g1RcuFsXB7Ym6cdNqEmim0tJxhQWhZrmEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223548; c=relaxed/simple;
	bh=/fK9GjxWCIEfzvo4DWgyn4T5XpciUv7lrJ9bPlC3II8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQCqpD8QZamBY4izp9wLFe0YOJ9xXOnVmUGRG3XQ2Gqy0NBXLfodo1esvAkmyeUcfGqoEkhCSVEV8wNx4JPf97bbnU7JpD1May06anfkKXHREH2eirqJDAIfW+46Iel4w7l/3Blk5Fau7oZa+dZ1dR/HI630Keo4wS8j1gQEJmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3WgAXuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3WgAXuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F46C1F000FF;
	Sat, 12 Sep 2026 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223547;
	bh=6miNmCggRYHAOpMozHyG0XyDDfJ/Qc8gwxQvuZ4fwXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3WgAXuzoWk+3FksHGQ1axM4uosCDaR50AHFdX/v/qd8AVSTHNgiNln3Yl0UvEV5E
	 TuROFihjeJz4iNhDjYSGX7yG7XiBsdoZ7yjSKFG5AOzYxudohyFwlr/xavVA4RGIWk
	 gPg/KruEbwBZbIrZk8konDi2QS0IXOaSG9Puk4mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0810/1424] software node: Fix software_node_get_reference_args() with index -1
Date: Sat, 12 Sep 2026 08:54:02 +0200
Message-ID: <20260912065625.431161179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit ba3dedcf3bd47017307595a7e54924198f018246 ]

The bounds check for the index passed to
software_node_get_reference_args() was failing when passed UINT_MAX,
this in turn would lead to an out of bound access in the property
array. Fix the bound check to also cover the UINT_MAX case.

Fixes: 31e4e12e0e960 ("software node: Correct a OOB check in software_node_get_reference_args()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/20260611103904.7CB131F00893@smtp.kernel.org/
Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Link: https://patch.msgid.link/20260611164005.2930205-1-alban.bedel@lht.dlh.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index a7a3e3b66bb5e..c34a5fc20f1e9 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -518,7 +518,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if ((index + 1) * sizeof(*ref) > prop->length)
+	if (index >= prop->length / sizeof(*ref))
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.53.0




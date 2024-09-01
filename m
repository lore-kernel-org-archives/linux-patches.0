Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAAE44C97;
	Sun,  1 Sep 2024 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207983; cv=none; b=Bnva8kozN2XHOsmemWFG4lliBuvX2VEMVdumqeZRcvPxdKpQeDTkRBQwwPGCvyQ4DhdCz5bvIdFZbNs6T3MXNEHWAdXOCT9j3SgExEYiC28GsjDDwfPXZxfkWSZf3XvIJKtQaBuB1UQyMlBGKu294EYkaFM6ixvHoRq9+XjbCvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207983; c=relaxed/simple;
	bh=/4pt3qKWLFQCaMrMK/i1jwse6+VlGqK5wsEFrUbMCNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiezQxJ/xTfsPudyTGRtgO83/MVuYY4Nba1SbQBuKn7AcnngDhqXd2kXXp9AcK7DTzXzqXy5jr4LFyuusOC1A0iSmMSBVkctqCPJYLoVSOm0AGcW61ESCLjQc1sYHloIRXHdEn/9whcYCPkynlPZu02k1GDSSKd2YJzpVFttv3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5ql9HfF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5ql9HfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F716C4CEC3;
	Sun,  1 Sep 2024 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207982;
	bh=/4pt3qKWLFQCaMrMK/i1jwse6+VlGqK5wsEFrUbMCNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5ql9HfFhE2As4tW+4T1XKM8gU5Qu9IVwJT/mognVDmMKYvCWwdVLXd2LD5Ws27Kt
	 dxXoF6ZY57j8t+raI15LQtQmdyoLX5g7njvzK8mqouyq30FfmS2eCSFNRaLdCEdfjz
	 9zow/LqR1G1UbRwb795/oiNZEmQ2XJyojl4Devdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 38/93] ovl: ovl_parse_param_lowerdir: Add missed \n for pr_err
Date: Sun,  1 Sep 2024 18:16:25 +0200
Message-ID: <20240901160808.793617945@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 441e36ef5b347d9ab4f54f7b54853266be687556 ]

Add '\n' for pr_err in function ovl_parse_param_lowerdir(), which
ensures that error message is displayed at once.

Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20240705011510.794025-4-chengzhihao1@huawei.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/params.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 39919a10ce1c9..0f3768cf9e871 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -453,7 +453,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		return 0;
 
 	if (*name == ':') {
-		pr_err("cannot append lower layer");
+		pr_err("cannot append lower layer\n");
 		return -EINVAL;
 	}
 
@@ -497,7 +497,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			 * there are no data layers.
 			 */
 			if (ctx->nr_data > 0) {
-				pr_err("regular lower layers cannot follow data lower layers");
+				pr_err("regular lower layers cannot follow data lower layers\n");
 				goto out_err;
 			}
 
-- 
2.43.0




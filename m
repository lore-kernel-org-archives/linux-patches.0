Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFFC2F83A1;
	Tue, 12 Aug 2025 18:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022103; cv=none; b=mHWkTF6qc5F7ZILx0rG21DVFwNm5q8khDyE8B97GKsOIYp1e5epketJAogY5zk2nh0yyMaDZt7OAigtwQJABx/PazyE0UunrOv8WSXexMluBobDSyBCGapYT6PBmEiD+j6c/gOCXgcW53KkftPrUuvf/OyEfxJMfcDY7QmS85B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022103; c=relaxed/simple;
	bh=VLe2cEJAypHycOhsa6Q029BvGChAWKnFSuHHdoXNpyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rvala1N+D2EoQfANh+ngjgmgYxAI65rmK+yZj68RFs8HJcORMDwOlPNTrtzLwrdtDppHcuAVTnMnIfAKuI1+r9HRrlE1Dh/2WXeZzvCCj7nwPYxradbIScIBaxkkcRQ/jG8cYXKvjB+9zx1BFaIWq5a/3v8TaW7krV3vq3UuYFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyALh9yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyALh9yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F6BC4CEF6;
	Tue, 12 Aug 2025 18:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022103;
	bh=VLe2cEJAypHycOhsa6Q029BvGChAWKnFSuHHdoXNpyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyALh9ybQKM2gOtssYVTGn1H45fJ1DPtUeJi2SLl7TExyP/vEmmvQ49Sid4759czA
	 88TMdj4CQw9n0UKa9WjYWmYrjsyjVWBa+UxIiP3S2nX4kTwzgAFf4SyaXCG2QxMJKr
	 Pn62iomJIFmmG5xfR8Hlsg4Go3+p3j6co/O82z/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pls <pleasurefish@126.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/369] PM / devfreq: Fix a index typo in trans_stat
Date: Tue, 12 Aug 2025 19:25:53 +0200
Message-ID: <20250812173016.870589509@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chanwoo Choi <cw00.choi@samsung.com>

[ Upstream commit 78c5845fbbf6aaeb9959c5fbaee5cc53ef5f38c2 ]

Fixes: 4920ee6dcfaf ("PM / devfreq: Convert to use sysfs_emit_at() API")
Signed-off-by: pls <pleasurefish@126.com>
Link: https://patchwork.kernel.org/project/linux-pm/patch/20250515143100.17849-1-chanwoo@kernel.org/
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 713e6e52cca1..0d9f3d3282ec 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1739,7 +1739,7 @@ static ssize_t trans_stat_show(struct device *dev,
 	for (i = 0; i < max_state; i++) {
 		if (len >= PAGE_SIZE - 1)
 			break;
-		if (df->freq_table[2] == df->previous_freq)
+		if (df->freq_table[i] == df->previous_freq)
 			len += sysfs_emit_at(buf, len, "*");
 		else
 			len += sysfs_emit_at(buf, len, " ");
-- 
2.39.5




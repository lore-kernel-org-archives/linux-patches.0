Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03701C9B71;
	Mon, 14 Oct 2024 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919625; cv=none; b=KBftNdaCeEzhmawHsRtCWIa9XFOsVe546Ur7MYmAX6ixSgDXmQwHvii0XkqQtW0kezqBCLjcp+F2ydNIIgVNrStXCWbtW7JuDA+fJ/LqqkygB/0giSqYqZDx9DuSb6vAY2FjTp+Ne+5JCyf/Jzimp9vJruBo75ThVzZGGpjmHgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919625; c=relaxed/simple;
	bh=0LrMa9WBGAWK8AuJGBoOxXsSXppcR/mXmpjL/gVY+T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e1hdoE5ID6GfVPuDXjfY3oqPmrV9zeHeTYsQG+t6KB84ASNFf2xpAPv+kRoRfjxcC0JzYAAgjh+a9GDQdvbi/+vTWmxQaYaCzIjin5/dnl6SuHIN986HY4go45THgAmlG1rXhf8kQ17Y+joMAizqFjhcXp56vOL4/fte3SuszxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4SmIaii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4SmIaii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F7BC4CECF;
	Mon, 14 Oct 2024 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919624;
	bh=0LrMa9WBGAWK8AuJGBoOxXsSXppcR/mXmpjL/gVY+T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4SmIaiiEOzvc7TS2D3NUnBOoRESlQVLTuIraJeNk7/+1F7FQwh0uRQ3VTna+6RC4
	 3fzqdpocXwRUYjtrnvNRB2W5ti6vaLUG+f3jyQ54xxxvci8SzRq8VcIXLp12P9dJeO
	 77Y0M9r98x9qBODNAh7vVAvv6r+d/cyTsD85AJxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@loongson.cn>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 633/798] docs/zh_CN: Update the translation of delay-accounting to 6.1-rc8
Date: Mon, 14 Oct 2024 16:19:47 +0200
Message-ID: <20241014141242.908091636@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanteng Si <siyanteng@loongson.cn>

[ Upstream commit 6ab587e8e8b434ffc2decdd6db17dff0ef2b13ab ]

Update to commit f347c9d2697f ("filemap: make the accounting
of thrashing more consistent").

Commit 662ce1dc9caf ("delayacct: track delays from write-protect copy").

Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Link: https://lore.kernel.org/r/798990521e991697f9f2b75f4dc4a485d31c1311.1670642548.git.siyanteng@loongson.cn
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Stable-dep-of: 3840cbe24cf0 ("sched: psi: fix bogus pressure spikes from aggregation race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../translations/zh_CN/accounting/delay-accounting.rst     | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/translations/zh_CN/accounting/delay-accounting.rst b/Documentation/translations/zh_CN/accounting/delay-accounting.rst
index f1849411018e9..a01dc3d5b0dbb 100644
--- a/Documentation/translations/zh_CN/accounting/delay-accounting.rst
+++ b/Documentation/translations/zh_CN/accounting/delay-accounting.rst
@@ -17,8 +17,9 @@ a) 等待一个CPU（任务为可运行）
 b) 完成由该任务发起的块I/O同步请求
 c) 页面交换
 d) 内存回收
-e) 页缓存抖动
+e) 抖动
 f) 直接规整
+g) 写保护复制
 
 并将这些统计信息通过taskstats接口提供给用户空间。
 
@@ -42,7 +43,7 @@ f) 直接规整
      include/uapi/linux/taskstats.h
 
 其描述了延时计数相关字段。系统通常以计数器形式返回 CPU、同步块 I/O、交换、内存
-回收、页缓存抖动、直接规整等的累积延时。
+回收、页缓存抖动、直接规整、写保护复制等的累积延时。
 
 取任务某计数器两个连续读数的差值，将得到任务在该时间间隔内等待对应资源的总延时。
 
@@ -100,6 +101,8 @@ getdelays命令的一般格式::
 	                    0              0              0ms
 	COMPACT         count    delay total  delay average
 	                    0              0              0ms
+    WPCOPY          count    delay total  delay average
+                       0              0              0ms
 
 获取pid为1的IO计数，它只和-p一起使用::
 	# ./getdelays -i -p 1
-- 
2.43.0




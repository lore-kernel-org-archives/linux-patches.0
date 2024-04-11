Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA5A624;
	Thu, 11 Apr 2024 10:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832490; cv=none; b=DxXYzgaG2dpK2+fFJz7WEmImLZYBEvQyUwksNLiCvpGRCzMHQCbIUm0l6Xm2C2wk9FFB90723tEQEqJBX0Jon7vj4xbOc9EPDkxpP2E/5ox7yeg5V8oaRMiVzwvotq8qHdwe+/87K/qDD4PuNpUqCxza5pgauDRBDPWiQ44wCXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832490; c=relaxed/simple;
	bh=+9kIaa51QUdos9bmDQfEW136p9SOsDIup4XIsWriKJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejE8+HNh5fIjm/71CmCPfnOUZWqiP8UKd9nIDTUEoTLrIvviqdyTpyMgH/7W4bWmRhNdMNLnDck+bQU4y+9ENN2zZBI3dEs6v3H75ZvjTe6uzJkBTolUu+X7WBb6bmfNVn52FcpCkftFaT9u5WVxhasI32fKhYi3aw8dqH6V0Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htn5Qscp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htn5Qscp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973E6C433F1;
	Thu, 11 Apr 2024 10:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832490;
	bh=+9kIaa51QUdos9bmDQfEW136p9SOsDIup4XIsWriKJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htn5QscpizhRLD5yBUs10833YunswFDWiHWiJE7pTIND6s2Fbs3e8Ww0M+Zvh9F6T
	 boA9vxXgfy4IZhKi2EJa2+0K3+rybeOBtSAnClrZdUW2vyg2Hbaoox6DZfKDgViR3f
	 ZB3Y14G78Cgz+w054dq/LdbMGnUrqS1UMm6j0l5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 65/83] fbdev: viafb: fix typo in hw_bitblt_1 and hw_bitblt_2
Date: Thu, 11 Apr 2024 11:57:37 +0200
Message-ID: <20240411095414.641123285@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Burakov <a.burakov@rosalinux.ru>

[ Upstream commit bc87bb342f106a0402186bcb588fcbe945dced4b ]

There are some actions with value 'tmp' but 'dst_addr' is checked instead.
It is obvious that a copy-paste error was made here and the value
of variable 'tmp' should be checked here.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/via/accel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/via/accel.c b/drivers/video/fbdev/via/accel.c
index 0a1bc7a4d7853..1e04026f08091 100644
--- a/drivers/video/fbdev/via/accel.c
+++ b/drivers/video/fbdev/via/accel.c
@@ -115,7 +115,7 @@ static int hw_bitblt_1(void __iomem *engine, u8 op, u32 width, u32 height,
 
 	if (op != VIA_BITBLT_FILL) {
 		tmp = src_mem ? 0 : src_addr;
-		if (dst_addr & 0xE0000007) {
+		if (tmp & 0xE0000007) {
 			printk(KERN_WARNING "hw_bitblt_1: Unsupported source "
 				"address %X\n", tmp);
 			return -EINVAL;
@@ -260,7 +260,7 @@ static int hw_bitblt_2(void __iomem *engine, u8 op, u32 width, u32 height,
 		writel(tmp, engine + 0x18);
 
 		tmp = src_mem ? 0 : src_addr;
-		if (dst_addr & 0xE0000007) {
+		if (tmp & 0xE0000007) {
 			printk(KERN_WARNING "hw_bitblt_2: Unsupported source "
 				"address %X\n", tmp);
 			return -EINVAL;
-- 
2.43.0




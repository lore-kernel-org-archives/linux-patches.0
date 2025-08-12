Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5295F2FE59E;
	Tue, 12 Aug 2025 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024318; cv=none; b=WRWZRK6lMIKYGShYFfikxKGtC+ODYsa43AcGovX67cZylLTDuQdeiaBzwrcykLpI+tcSP4EpxDgjD9hzfHZrPE7pA87NQ7hkH5ID4J2DCdtn+yF5hGN2MlG+voK/cDzH8VooKScg8EbT+mWHjja9kj2qQk2WkrRtHuQ5ZLnjmBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024318; c=relaxed/simple;
	bh=EgX5gg9EMZ9Kb3gGt6PtCUM2rV0pzbcZsW83Rd2ItTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCyPU3//CjBS3uhb6Hl/4C0BXXJC9yXC/+fWpfX6QXJDVhafns2UfVKlEOuBHWNVc6duxvWFxvJAlJSQ8RcCmC5UKTJt2cvovijTgeYsvbdGpf7m9BxQ92km/Nu1GrFom2RCoh39v4jlRfnf1VOBtkmlEjfQxF00VRCqhVhV2Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzhLo3iB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzhLo3iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B425AC4CEF0;
	Tue, 12 Aug 2025 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024318;
	bh=EgX5gg9EMZ9Kb3gGt6PtCUM2rV0pzbcZsW83Rd2ItTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzhLo3iBeBRuzjJ7bK5ciNKeAvcT9F4uQ+b5DxPkp5wXGa7GkmRHBZqY1usGQ2BhV
	 XM3KAORK76BRAbvL3Xu5Rk09gkzLwre+K1udNm3Esa8w6bqEgyzA62+p6ohv3Gps8d
	 bMwDe9DTifY77XlHDiEvgrZrmF5RJ3F6tPUdwV2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 337/627] soundwire: debugfs: move debug statement outside of error handling
Date: Tue, 12 Aug 2025 19:30:32 +0200
Message-ID: <20250812173432.104479403@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>

[ Upstream commit 06f77ff9d852c9f2764659ea81489364d8a69a9c ]

The start_t and finish_t variables are not properly initialized
if errors happens over request_firmware actions.
This was also detected by smatch:

drivers/soundwire/debugfs.c:301 cmd_go() error: uninitialized symbol 'finish_t'.
drivers/soundwire/debugfs.c:301 cmd_go() error: uninitialized symbol 'start_t'.

Move the debug statement outside of firmware error handling.

Signed-off-by: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-sound/0db6d0bf-7bac-43a7-b624-a00d3d2bf829@stanley.mountain/
Fixes: bb5cb09eedce ("soundwire: debugfs: add interface for BPT/BRA transfers")
Link: https://lore.kernel.org/r/20250626213628.9575-1-rodrigo.gobbi.7@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/debugfs.c b/drivers/soundwire/debugfs.c
index 3099ea074f10..230a51489486 100644
--- a/drivers/soundwire/debugfs.c
+++ b/drivers/soundwire/debugfs.c
@@ -291,6 +291,9 @@ static int cmd_go(void *data, u64 value)
 
 	finish_t = ktime_get();
 
+	dev_dbg(&slave->dev, "command completed, num_byte %zu status %d, time %lld ms\n",
+		num_bytes, ret, div_u64(finish_t - start_t, NSEC_PER_MSEC));
+
 out:
 	if (fw)
 		release_firmware(fw);
@@ -298,9 +301,6 @@ static int cmd_go(void *data, u64 value)
 	pm_runtime_mark_last_busy(&slave->dev);
 	pm_runtime_put(&slave->dev);
 
-	dev_dbg(&slave->dev, "command completed, num_byte %zu status %d, time %lld ms\n",
-		num_bytes, ret, div_u64(finish_t - start_t, NSEC_PER_MSEC));
-
 	return ret;
 }
 DEFINE_DEBUGFS_ATTRIBUTE(cmd_go_fops, NULL,
-- 
2.39.5




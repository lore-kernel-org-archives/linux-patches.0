Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9333594E;
	Tue, 12 Aug 2025 19:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026151; cv=none; b=nD1p+e9bdQezUZW8DiH0AChhb1j4ew/0CFE3wW9jFVmBB0TyVoxsILj1a2VAZNYmB7dW60q+h8kRuSuFF2TWocKwKaueLd/x7FRE4f/9n0zj4gQa262pPYQcbpCjevghfnCgGcwENqndmacLFEdIufbTdMQUf+qC3mEKi9vAMSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026151; c=relaxed/simple;
	bh=K/5hf7wQYllLAADcmqi9nM5jXvm26QKD6TGTdW3HJ0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghoeqLIeHnYavHrukBsCY3F0UAoDzRiPfvVQISyxx+tLfgoiMD1xO9QB21tdje0jlsnXCNnimM0zmNh/tlhaZwZsE5QeIFuy5klU23kOLQbGEsBtHEyIta5SyBGW+Dce4CP98MdJBSrTXoOsiksDg5fJI0sA3eEBLVSTLA6QvGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3xIYZct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3xIYZct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F374C4CEF0;
	Tue, 12 Aug 2025 19:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026151;
	bh=K/5hf7wQYllLAADcmqi9nM5jXvm26QKD6TGTdW3HJ0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3xIYZct7Yfdo0l/ph2wJJR+WnGcsLV9SJhQfY1a3vrD1HUBHW5HyFF5FDsKh+LlM
	 t1eSvEirawvsFaAxMWv3G2mRz215kLByeVo3qmolWfL50J7qOSy8VdEIPy3e0jdXo0
	 r8qsEmWKU1QEUa596jJeJmzVJ5Al/lsZSWCD54y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 250/480] soundwire: debugfs: move debug statement outside of error handling
Date: Tue, 12 Aug 2025 19:47:38 +0200
Message-ID: <20250812174407.765638797@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFA846F488;
	Tue, 21 Jul 2026 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657006; cv=none; b=QgrxgKgIC7bW7Gs4HHfNJLSf4/2oAQYiYfaWG96mT2AqxalDMrRjtctkD59VRs7C5TsgHjUn8LCJPDjplyLtN31Y4FAvh8cqZhQBxQovFYEnzrUkzJOxyvwwiTnlVC2uM5rOOCf5jj6gXFNpN2S91RIs6lDtz/OOTcxY8tv8WyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657006; c=relaxed/simple;
	bh=Lyeu2TLg5hpvN+AoUgNxLmuisnK0e/Byq9xj7fkUWgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oE3tz9YtgXpAadxVGhjDceCBJ/kxEIb6n40mecgZqW0xaF0+yjrKYvZeUEqUAqemScSL9tmc0e1ib77IUpEcMAVI/hR0uRRW6OAQQOecRo7BjJNN7wbebAZnWgYyDkTRqk92194wZbBw5nyQvObEomkJFiBe6QbZzooGIIKmWpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5XbRPOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5XbRPOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3FD1F000E9;
	Tue, 21 Jul 2026 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657005;
	bh=PJBE1jwQSWb5wAIYxyvICYwYcNO3+GbjYCKXBetRyTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5XbRPOq6Yq7SJbVIwJzURhprim6tFxrSZXOuZPCGbs+0XCRSUJ6plwk7PiZfjaxa
	 dOLYZTYYqWEatgDlb1MijCD9SRzVArC9QzTpvnrCLZ2q/QeATevsXCEYAU2kIl1vzr
	 fUYWmFlr43Sx4uOaFKPs9EeKVNkqA5C9qOoX5tUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0599/1611] soundwire: intel_ace2x: release bpt_stream when close it
Date: Tue, 21 Jul 2026 17:11:55 +0200
Message-ID: <20260721152528.859278290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 8a7fe10eec64bfb7cf4091bca540de4c55d56bfa ]

The BPT stream was allocated in intel_ace2x_bpt_open_stream(), we need
to free it in intel_ace2x_bpt_close_stream().

Fixes: 4c1ce9f37d8a8 ("soundwire: intel_ace2x: add BPT send_async/wait callbacks")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260514141625.1834216-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_ace2x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/intel_ace2x.c b/drivers/soundwire/intel_ace2x.c
index 5b73bbb73be6e0..63aef983614675 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -248,6 +248,7 @@ static void intel_ace2x_bpt_close_stream(struct sdw_intel *sdw, struct sdw_slave
 		dev_err(cdns->dev, "%s: remove slave failed: %d\n",
 			__func__, ret);
 
+	sdw_release_stream(cdns->bus.bpt_stream);
 	cdns->bus.bpt_stream = NULL;
 }
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A1E2DBF75;
	Tue, 21 Jul 2026 18:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660201; cv=none; b=hZjyM/xLpHPso/x42tt3uPVRj/HcJ1HkuaM6lyMceDYNL3q6j8iur084sq2ykETydPKrBz0gXhmnzjOYlpGTvuEjGVyHX8x6gvTdLjeGB80aw6X9ICDziH1jHjIJEGOd5CalVycCgfgW5lVWuoFECulhsRu6xM6aNCL/+KV9u1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660201; c=relaxed/simple;
	bh=nymgkg4THv7XTgshxtD8T1JvyltXgv4jUcmEA7Euuk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMS7Gw8QITIPsPH/foKCFTfqc+ZF+n2SskeExs+NGospoa6+qXXld9oUUTTOba3VBTQz+G2mcqgfsYcqLUHZaggcxYv1GY/JSAZiCbblY1rRE+OisMEqZvCDDQUtfCCFblKXRyx8seeJWoGFv8FqcITNAeNc2HmLost/HXk0wu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTEle0g1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTEle0g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EAD1F000E9;
	Tue, 21 Jul 2026 18:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660200;
	bh=j26N+d88aUw+zrYnxwm532MeZcA6nPvfaAMo7YS1m4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTEle0g1hGKpZi3SrpfGtBjqD1GfuLYsgtxXf61zBfLpMS1J470sapo8Q291qQYUW
	 INT+CL7ZgiA0l9w50uIaErNZI5yWRonOFr8AxTagTK39rPMjXMYMuHCjjV0yyMMl7L
	 1jJVvCTR68jwBesNDEJRwzhPXrCG70o/vqZ2Aa5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0873/2077] soundwire: intel_ace2x: release bpt_stream when close it
Date: Tue, 21 Jul 2026 17:09:06 +0200
Message-ID: <20260721152613.383240307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 20422534baf19f..6cd3a873237501 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -317,6 +317,7 @@ static void intel_ace2x_bpt_close_stream(struct sdw_intel *sdw, struct sdw_slave
 		dev_err(cdns->dev, "%s: remove slave failed: %d\n",
 			__func__, ret);
 
+	sdw_release_stream(cdns->bus.bpt_stream);
 	cdns->bus.bpt_stream = NULL;
 }
 
-- 
2.53.0




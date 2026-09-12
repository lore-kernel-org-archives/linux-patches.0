Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926E11DB13A;
	Sat, 12 Sep 2026 14:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223948; cv=none; b=e0ZczCzruaPfGzatNOdeOLD2+Coeb/to/F7idMCul5OV5cUN9bOd9M7p5LsVOiJRN9j2lGoYkQ7TiEkHC8GkDoQNC1BeUHK6ufLgKr7DK8cZSBz27XymO+5Czdrj68OnzAO2hhsLpO9yMfIeDbQdRMGz9sfnlXMZEJeUY6a+SLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223948; c=relaxed/simple;
	bh=ejTKKASoalYoT+A4nFhxWD43N2XWlUk26vMz608BN84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz4vYkSdt20D/uImJoVtaVdMQ4nSb4+ELb2NXIgHgPJogLBlMUa/gx1u+2JVDHTT043byiY8ykMbOmmjQnlNk8KxH+SIdVcjqVAiRP60kqYgluDIwKJUjcplfFSfpwqmzbWdoDBvU5OtNRXKBiKQuWwC3zFOkfmejP5duy90xes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSwaQJLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSwaQJLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6F01F000FF;
	Sat, 12 Sep 2026 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223947;
	bh=irSIUW6pUUK8W31Yaa+bLSTUi7lOdV1ksJlduMghV3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSwaQJLfS0lGA1PH3S9H4LPbYK+tbyh/FANf/jq2e7JoTf0VY63pMMZnLwmp3ohsw
	 tD1pTJ34313X5uPzaVSVQIzOCPjV2eXZU2N85gtCKSAdjbuwkd/OYSjl5tbzZPCJnI
	 5qhH/CEde8r+I1TvrAaD/op+s8vFZA+uDS3rF5f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0892/1424] remoteproc: core: Drop redundant initialization of ret in rproc_shutdown()
Date: Sat, 12 Sep 2026 08:55:24 +0200
Message-ID: <20260912065627.304190563@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 4531b6bad5af669511c348ad5225d9f697af221b ]

The variable ret is immediately assigned the return value of
mutex_lock_interruptible(), making its prior initialization to zero
unnecessary. Remove the redundant assignment

No functional changes.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20251016-rproc-cleanup-v3-v3-1-774083716e8a@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 2482ca875ef5 ("remoteproc: Allow shutdown of crashed processors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 2d4ae3b5af86f..dec3e80810fe7 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1988,7 +1988,7 @@ EXPORT_SYMBOL(rproc_boot);
 int rproc_shutdown(struct rproc *rproc)
 {
 	struct device *dev = &rproc->dev;
-	int ret = 0;
+	int ret;
 
 	ret = mutex_lock_interruptible(&rproc->lock);
 	if (ret) {
-- 
2.53.0




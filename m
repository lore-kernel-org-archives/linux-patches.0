Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA1D38F255;
	Sat, 12 Sep 2026 19:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242790; cv=none; b=A23DDRhN0QNGTMgiiktDO9XJ9ZgW6v0C0B4Ii8Hefw5vcaGGpZLw+DvchUAIsgXsJryRRHwg99Koq2Vo3KmUjf/NrfPWc/6CzGso/lEYSwpR0aWj+5HKppQojbW3Ktd4K0YbaVCrTgaM784b3pqOVdiEHiW49KgqmdrNcQGIEuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242790; c=relaxed/simple;
	bh=kgoTXiNVuvVahilBAPYPAq/vcJA5eRjSWVeJC2pMoBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkdyiVrqJ4WJksPcXtSBceEVjbkDy7I3DHk0heyuKQDi2Hb2GtSivGSo3w14muAFAfu51GbsPQlyu6q0We0wugD6k0lzFqshNjXkuxOCQBhc2NtGYFcIlkb5wZOkEPz3dUuTNXVHuI+9Sj6aTNK9GWKHmrOK/XZqp6Iq2Gp6BmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbD8ivFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbD8ivFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82A61F000FF;
	Sat, 12 Sep 2026 19:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242788;
	bh=fo2m7kSf7IRN7FaXS22eo2RMCGn6pXqmV1PvPy3fmww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbD8ivFzFkA4F2T/iK0eQdkBHWZKRHvSJ6tkVHTF2ONYDlNEnIVeVdxB3Gw2yGuoO
	 3Padilo6xBo8Sfz4mDUTLej5s5eErkSCh4x6+54kEtAreHBOQ6i07AMexTO0Yl7M85
	 UVYLRJzMa5Uz4tO2QSvY7L/pq3AFp7lJygfrTmJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Arnaud Pouliquen <arnaud.pouliquen@st.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 520/798] remoteproc: Remove useless check in rproc_del()
Date: Sat, 12 Sep 2026 09:02:28 +0200
Message-ID: <20260912065529.052536187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Poirier <mathieu.poirier@linaro.org>

[ Upstream commit 16324fc8def1c08a92261089aaf503aca3381aa6 ]

Whether started at probe() time or thereafter from the command
line, a remote processor needs to be shut down before the final
cleanup phases can happen.  Otherwise the system may be left in
an unpredictable state where the remote processor is expecting
the remoteproc core to be providing services when in fact it
no longer exist.

Invariably calling rproc_shutdown() is fine since it will return
immediately if the remote processor has already been switched
off.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Link: https://lore.kernel.org/r/20210312162453.1234145-2-mathieu.poirier@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: 74ee3b2f5767 ("remoteproc: Prevent crash handling to race with rproc_del()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index a933e345683c4..144f0405b4c93 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2321,10 +2321,8 @@ int rproc_del(struct rproc *rproc)
 	if (!rproc)
 		return -EINVAL;
 
-	/* if rproc is marked always-on, rproc_add() booted it */
 	/* TODO: make sure this works with rproc->power > 1 */
-	if (rproc->auto_boot)
-		rproc_shutdown(rproc);
+	rproc_shutdown(rproc);
 
 	mutex_lock(&rproc->lock);
 	rproc->state = RPROC_DELETED;
-- 
2.53.0




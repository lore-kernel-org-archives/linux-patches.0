Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4093376;
	Wed,  5 Feb 2025 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767636; cv=none; b=ck6QtxyAAriPHvc7CerLr6O5VHUtzvhgpadYVikMv1HTNockYhQu8/DkCmmnyMGb6KNmFIi/IxyCaVHugIMAXJodmQ6hVqSLWORqguErCYxxAVgvene9nkR7MLKJPyLiFRj59bFcZGJUFvow7gb+UT6/zK84OdE9URKp/oW5t5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767636; c=relaxed/simple;
	bh=fulMXRiDDmi8cymfBuuHx5ioiXYKfha53havaGY5TnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s56xPqbjrO59RWl4Kc+1MXKIbRaTj7Xj1oek8uV0A+GtXBSq3JZirPAcovOvm07vuei8K1K4ETT0yhAn78v5eMRxUKXfD5zgEiYYM8sSsNYqL7ASDuYaMJoR/F9MD8ECoZQruYaSir+5i5TDG71JNLFeMopUfILaUTJ/qmr9pcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DBgphIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DBgphIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01349C4CED1;
	Wed,  5 Feb 2025 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767636;
	bh=fulMXRiDDmi8cymfBuuHx5ioiXYKfha53havaGY5TnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0DBgphIkNFNP97QiAAWynROz4MtQmTO8+bBoDy0pOa3jr2uMl0NmSXZpm8rGWmn3p
	 Qt1LDyto/gJI7JOjOHLwyRXkR8IkvM43gOdDfW01wY9bASjWa87rMBX9BvBrhatrA3
	 11UvsMBKzKJXgdRNkYs20qfDb4kvjL/V3vkbKQ60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 472/590] regulator: core: Add missing newline character
Date: Wed,  5 Feb 2025 14:43:47 +0100
Message-ID: <20250205134513.318014743@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 155c569fa4c3b340fbf8571a0e42dd415c025377 ]

dev_err_probe() error messages need newline character.

Fixes: 6eabfc018e8d ("regulator: core: Allow specifying an initial load w/ the bulk API")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20250122072019.1926093-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1179766811f58..4bb2652740d00 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4946,7 +4946,7 @@ int _regulator_bulk_get(struct device *dev, int num_consumers,
 						       consumers[i].supply, get_type);
 		if (IS_ERR(consumers[i].consumer)) {
 			ret = dev_err_probe(dev, PTR_ERR(consumers[i].consumer),
-					    "Failed to get supply '%s'",
+					    "Failed to get supply '%s'\n",
 					    consumers[i].supply);
 			consumers[i].consumer = NULL;
 			goto err;
-- 
2.39.5




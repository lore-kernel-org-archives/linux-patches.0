Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B96283FE4;
	Tue, 12 Aug 2025 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025693; cv=none; b=XcKQ+OaPJImsEreEwk7hsc3zjHk4Hm60Pp76LHP3Su24gCBngmiXXA2wFF7mPtyldwbLRdS08vUwbHjgYP2qngx64riF6OYSJt6XLfhSnA9z3N51w3u73msAsp2n0USiSf8FnUrT52Zar4iDKw0FTZqxEL3Yh0x7Rf2ffcwy7Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025693; c=relaxed/simple;
	bh=Ykc5S7ETfFl5SaCC/J/loZRWoREr7AHGQa4nq16Z3b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gApXhdmZVCOcILhb1aBQ/wVzffnJOh2MG8sJG/CrLTfff8QvUQtBerPTBSzlYo5ExTZGc7o/6tEdF9IB2OWu4rUtFPIXz/s02P7KaHRL5Uyvp49hshUtl3/7T3fVxvDBt+6xC7iMuY84t2uXosIZeVfnhc4AklI21dzDhGTDr3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXqwl1PH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXqwl1PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD8FC4CEF0;
	Tue, 12 Aug 2025 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025693;
	bh=Ykc5S7ETfFl5SaCC/J/loZRWoREr7AHGQa4nq16Z3b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXqwl1PHxAMSCDSBOno5f3QJipITIzueVvEbAY9EgTVoISJvRAS0+e9bpz4qVdMj1
	 NHZpZ08NIavHev5VKiih9/4V1Ex3vbdU313HOvTxfBCZTWtNOFbeUfAt6eaMp6Fesm
	 LIvnlehssLqsE7k/KufxThshw5MEZm6Xby4KuYoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pls <pleasurefish@126.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 083/480] PM / devfreq: Fix a index typo in trans_stat
Date: Tue, 12 Aug 2025 19:44:51 +0200
Message-ID: <20250812174400.875760712@linuxfoundation.org>
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




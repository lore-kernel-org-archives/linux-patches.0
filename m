Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849B9277026;
	Sat, 17 Oct 2026 16:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256084; cv=none; b=STOhjBMjBjX3RdvMZmdyth4hb9Mm1H/6+i8kD++IExX8ywYr0QngS+ZoI3YSNwIpbxroAZUKD6H0nU6KTWlkepl39IGnN5ttfGLJUZVw3XfVK66o7KOzzIVDMrwzaAD4SNSibkWbLPbz+jcRkJzcOu5jbYBkFB4lGleNolbHx+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256084; c=relaxed/simple;
	bh=D8CFHZzMtMdVM+S6DrZLRdRzUUIiQChYLq2PZBwBl+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qh7k9MpNsAf/vG+Bkrmvm3dvGKWGt93GCAshniFbRbeb+K91OJsjAa88UGzDbG81seOfd/ZDKsTdhkDXCmSialLiBBgluBAbvsSG2/Es986tNXm6hCInpP/aGIuayzRa85LA5PjClX/BR390vAotD0cRvzdNBTNdYW7/KQu5XOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrXYL244; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrXYL244"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DABC1F000C4;
	Sat, 17 Oct 2026 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256083;
	bh=A75pUgvwr+xEY3ZBqQe2pXlpOVNWa07xeexqqFIPoqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrXYL244hNnus6HmuIolwR/1OZh0B34yQhW+yINJEzt6T2FYQLz67K63SiKebv1MH
	 k2zragnWeDzKPOp38zWtSjV/WhCbizOdEf91FZR6lmfPTXdQ7bawgcSPEZqsrFM0uv
	 vtKMg/HulY9fMljdkFAMkPThqzlo+7uMQYMlz0hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0076/1674] platform/x86: ISST: Validate max level for set feature
Date: Sat, 17 Oct 2026 17:39:08 +0200
Message-ID: <20261017160433.085191423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit e45d6b8472861d3bac86bb37f8556a7c5aca3266 ]

Validate the level before setting, so that it fails early instead of
failing later when checking the bit mask for allowed levels.

Fixes: ea009e4769fa3 ("platform/x86: ISST: Add SST-PP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-3-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ Adjusted context for the missing write_blocked/CAP_SYS_ADMIN permission check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 3418a89c72042..db45ddf9637d2 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -770,6 +770,9 @@ static int isst_if_set_perf_level(void __user *argp)
 	if (!power_domain_info)
 		return -EINVAL;
 
+	if (perf_level.level > power_domain_info->max_level)
+		return -EINVAL;
+
 	if (!(power_domain_info->pp_header.allowed_level_mask & BIT(perf_level.level)))
 		return -EINVAL;
 
-- 
2.53.0




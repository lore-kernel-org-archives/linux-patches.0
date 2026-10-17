Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237193C73CC;
	Sat, 17 Oct 2026 17:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259608; cv=none; b=CPcVceHuGUe5JaUjcHZarqYzO+BVpJJpyaypT7nRnDGVYhVS1Sx8B3ZgM7jeunyWs20pRPxgwlaqa/r1QXbN0RcGXYH+fmLzUScg2vw9cSuPkp+cJZiedCxDha4e76gJMArly5WnNeZ1J+wcTvUkSt+3q616yQKFWRPGQXcIB0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259608; c=relaxed/simple;
	bh=z9nD1zxxbbJC7kZJ+aoll8JC7cLa/KfpW7f1+6V+eoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LuvWpdebTsSJk/nqFTOcTo3LWYks48zwmhGXseNZynM6iDuEaUYdVuxu+FAs3CjyH00TGaqdSJOlUVX6Zcig9RYTWU3Eao/LruCbqHCdZWOzY4O9p8FWmpCY3IXIKKweArGkvB6StEJfD96oyRUUfNoazWQjBwUbgWAmK2vdyEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahoaOMB0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahoaOMB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7217E1F000C4;
	Sat, 17 Oct 2026 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259607;
	bh=JSvCTdYj8cPC/tsL5Rm2HKX5pXsJ6h1cECc3ySq6Aos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahoaOMB0euROgLuxT2JtFY2gEzx0TZXIyLSvUvERVXWymrRvYsWWIv59uVtBWstj8
	 //6hpbVcwn+H7A5NVip3OhxTQvg5no2+1dfrS7qeWStZlwx9icDk/axuevrsswyban
	 u2FA5f/4tVpyRJ0XGWZvFY7LhAOsC/BwH6JoB/pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1269/1674] platform/x86: ISST: Add a NULL check for sst_inst[]
Date: Sat, 17 Oct 2026 17:59:01 +0200
Message-ID: <20261017160503.714985394@linuxfoundation.org>
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

[ Upstream commit 3de2776e9d7073765c10c2326c2bda5926811ea6 ]

To be consistent with other places, add a NULL check for failed socket
loading by checking isst_common.sst_inst[].

Fixes: d805456c712f ("platform/x86: ISST: Enumerate TPMI SST and create framework")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811222134.3912626-3-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/intel/speed_select_if/isst_tpmi_core.c    | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index db45ddf9637d2..30f4f047ef5a2 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -1153,9 +1153,12 @@ static int isst_if_get_tpmi_instance_count(void __user *argp)
 	if (tpmi_inst.socket_id >= topology_max_packages())
 		return -EINVAL;
 
-	tpmi_inst.count = isst_common.sst_inst[tpmi_inst.socket_id]->number_of_power_domains;
-
 	sst_inst = isst_common.sst_inst[tpmi_inst.socket_id];
+	if (!sst_inst)
+		return -EINVAL;
+
+	tpmi_inst.count = sst_inst->number_of_power_domains;
+
 	tpmi_inst.valid_mask = 0;
 	for (i = 0; i < sst_inst->number_of_power_domains; ++i) {
 		struct tpmi_per_power_domain_info *pd_info;
-- 
2.53.0




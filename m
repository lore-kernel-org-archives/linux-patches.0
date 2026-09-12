Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2537C33B96B;
	Sat, 12 Sep 2026 09:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205641; cv=none; b=RgFYjV0M01KjwclJpw4/7QW930xrP07wDEEy6BNmNcC8XoCZXTCxfgrxhYFxBQGyjQl1x35VSmdXU9a31MdQRgBhTvRUSDm+7P483JhiqUHWETKdXdBtfNoLZLTrmZqm68rW5O3/fahbLBjnWr6HkuRnpz/Fx2WwddLGdWvrn8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205641; c=relaxed/simple;
	bh=NlpnOU0F7t6O/n6iuqG2t40gBGDPsA3Mz3dM2fw67uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r0m9CSjEuY8cXAJrHL7ck+a/s0ugtbudCAJUIQVOukwguAHlBCB6/r1hFS+gMHGnXSS8/IxvbRX4GOdpsF2Z/CMjxMERX7r50EtVETPesMmKadO5OmJLsHm9Ns2rtTr4k9cBZ38glmaY7btkxt7K+YZo3gURqkl4uKwmhjXWxPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuMyaEHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuMyaEHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA751F000FF;
	Sat, 12 Sep 2026 09:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205639;
	bh=/c4nvmcqphYbuqRPjdPql+0EqMMDxWnJG9XFgtVYNMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuMyaEHL1wTqVqn4/qiXiWOgijX29dh9bJdxVEUZq3fkdQJzM6KpP6+afoODzWXwc
	 ZELilzllQ6kMxlW9mUN29f558vY2qoxLRhM0Z3F34qxn+h/ZfTIIcI33jVdztGDJTm
	 UeswS2TxPNxA+cEACCJbOZXENfnimS71OLYsKSbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0041/1518] platform/x86: ISST: Validate max level for set feature
Date: Sat, 12 Sep 2026 08:36:50 +0200
Message-ID: <20260912065624.363408337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -974,6 +974,9 @@ static int isst_if_set_perf_level(void _
 	if (!power_domain_info)
 		return -EINVAL;
 
+	if (perf_level.level > power_domain_info->max_level)
+		return -EINVAL;
+
 	if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 



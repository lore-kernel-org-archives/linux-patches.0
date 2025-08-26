Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3E3356914;
	Tue, 26 Aug 2025 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219315; cv=none; b=d3hY0h2e1oKPn18ai2dy7Aci82jtbsukPqaUeH/gPcce2GlNlZB1XViwd//uzAW8dIejy3HoNLeJivrDEAUVtEscBWZQDgxBdqhtuJtN+qJ3aGlhFlaqhOOD8yctUsK0LQBZT3sbzRrcezzxqOSccLFxtKceEpTkJFnHiYed1dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219315; c=relaxed/simple;
	bh=tXTEkZyA2puH4rkb173snbN6cIYDRwNnM4EBjfC8O9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KItkwXSYlQZGOm3RdtiTZc8NOHVqPAG/EfQkx2SG6ywWWVvttPq8k9Ka/rAREShtjeKg1wEhGAENeD8SyAfRoBnsc50uuCLHRFRadk0xDnLbpE1Fty+CblIibnAbHnh62LUp9o+wH1Xvy9czlqPf/oytub9rhexgtg/0purDbSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I35nAnEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I35nAnEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009EDC4CEF1;
	Tue, 26 Aug 2025 14:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219315;
	bh=tXTEkZyA2puH4rkb173snbN6cIYDRwNnM4EBjfC8O9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I35nAnEFYW+yi00Tb39z44puXIHwEj+p25WtQNZKQ1Iyj/DOg7Wxg9l1u9Cbad/zH
	 qWDPh4AyFWALLMe65zf8vLDgQWoFZEqE9Z050XbCApwJf+qLHn8YfOv57Clk1SJJil
	 k/in/ZnKg/ttwYVaf/CrzXTmIpiu6+FwrIufrr4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.4 335/403] ice: Fix a null pointer dereference in ice_copy_and_init_pkg()
Date: Tue, 26 Aug 2025 13:11:01 +0200
Message-ID: <20250826110916.101172800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 4ff12d82dac119b4b99b5a78b5af3bf2474c0a36 ]

Add check for the return value of devm_kmemdup()
to prevent potential null pointer dereference.

Fixes: c76488109616 ("ice: Implement Dynamic Device Personalization (DDP) download")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
[ applied the patch to ice_flex_pipe.c instead of ice_ddp.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -753,6 +753,8 @@ enum ice_status ice_copy_and_init_pkg(st
 		return ICE_ERR_PARAM;
 
 	buf_copy = devm_kmemdup(ice_hw_to_dev(hw), buf, len, GFP_KERNEL);
+	if (!buf_copy)
+		return ICE_ERR_NO_MEMORY;
 
 	status = ice_init_pkg(hw, buf_copy, len);
 	if (status) {



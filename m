Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB5C350D6A;
	Tue, 26 Aug 2025 13:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216698; cv=none; b=srV2fxZEmHR/8VOEODouhfkm/pcRwWN1n5FmtGG9GDT/47BK7/NYyAGAlh7zyEu21BaBGLs/NMqSTBmx2L5zwsm5NuMc+KRo1PImWs3D+Btujf0Mm6NKHenM3RHnX4ShUs5RQ8vH1kuW/zJOwjp0/lrFMAlsiC5sAc0aCzfDSks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216698; c=relaxed/simple;
	bh=AD21L8IPbLuM42IxSJ60GhGrgquIZcJOgHElLtN4S54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmBoBUmwEa9qshKU/yGeBYb42JdF6Ut2NiyCKfduI+I/5C7tjCZML1dcC9UWMoyoAEgLMcXfrtyCgNM8fVjr55gEadat5UjLTRHhHhsPTqwbOnkV3T1dHXmh50LWloGlvlsjR+1m/uvpuaodjUtVKcBfHrW/G9A9Qw/B5rcJpUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roZCOecS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roZCOecS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4221C4CEF1;
	Tue, 26 Aug 2025 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216698;
	bh=AD21L8IPbLuM42IxSJ60GhGrgquIZcJOgHElLtN4S54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roZCOecSvisPej/F3GmKV38p4U4v7K6arF016C24+vgS2D1T2k98eir1+xeckfbBF
	 n0/qhJIfRZ6MZ3ejfVSYSA+kB7k7O1asMxoIEJT/VgoDSDhCgq0WUQXG1o3KPLrB/b
	 iyAg6/ij18krSxfutQYJqawuWdBSOSstCMmNn1Yc=
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
Subject: [PATCH 5.15 510/644] ice: Fix a null pointer dereference in ice_copy_and_init_pkg()
Date: Tue, 26 Aug 2025 13:10:01 +0200
Message-ID: <20250826110959.141337557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1448,6 +1448,8 @@ enum ice_status ice_copy_and_init_pkg(st
 		return ICE_ERR_PARAM;
 
 	buf_copy = devm_kmemdup(ice_hw_to_dev(hw), buf, len, GFP_KERNEL);
+	if (!buf_copy)
+		return ICE_ERR_NO_MEMORY;
 
 	status = ice_init_pkg(hw, buf_copy, len);
 	if (status) {



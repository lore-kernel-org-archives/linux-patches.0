Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555F435A2AC;
	Tue, 26 Aug 2025 14:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218183; cv=none; b=CcLGcdripaUmstU2It77+ksXZT9i8Bo27JICEbeFXcxoaHyxpU7XcoGeUOao4FEWGCjb6a5SujQXExZYDUG7DJ2i00iKxMZYbOODBg/0w4Dz6RNBvxWg8IwDB4e6Z5Mt9qHVPriw+RDRfpTzJ3j/H4jXNa6ZFIKKjTeSKY2WeTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218183; c=relaxed/simple;
	bh=8CsDDwBJ35NG8bEssuUpcrTUAFBefsCzS1LqBf+KCrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+ZgSF75KVr4Kx2G8nBWqOg7ybjj667Rvd7mcVEnsVvqVegmdoOrl46S0GUOHm3q0DcFbOarR/XDANU9jtJu7sSPtrmRIM/1hlvgRltho4q493I7WBQ9l69KJmOYzIetPmeOjyJD8U63siUqua/D3GtkfEN08+AqY4agyae1kog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5L1tghx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5L1tghx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89158C4CEF1;
	Tue, 26 Aug 2025 14:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218182;
	bh=8CsDDwBJ35NG8bEssuUpcrTUAFBefsCzS1LqBf+KCrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5L1tghxlPrA4XtKy4Gwk1QySlQeh9uL056iODzp3rItEHgrXeovg2Ya4wbgWdB3m
	 G4HXeNa02m9EZBcyvvyxzQwj/vwe3Zn3WT7V3Yee2UVsJ3uisA9o8xe6Mr2SvkIep7
	 //OhaBZMyLcGwWRV6kGx8OXI/TDmEistNQ4E41Lc=
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
Subject: [PATCH 5.10 424/523] ice: Fix a null pointer dereference in ice_copy_and_init_pkg()
Date: Tue, 26 Aug 2025 13:10:34 +0200
Message-ID: <20250826110934.915783966@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1449,6 +1449,8 @@ enum ice_status ice_copy_and_init_pkg(st
 		return ICE_ERR_PARAM;
 
 	buf_copy = devm_kmemdup(ice_hw_to_dev(hw), buf, len, GFP_KERNEL);
+	if (!buf_copy)
+		return ICE_ERR_NO_MEMORY;
 
 	status = ice_init_pkg(hw, buf_copy, len);
 	if (status) {



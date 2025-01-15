Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380731E7C02;
	Wed, 15 Jan 2025 10:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938550; cv=none; b=ZLTn/S2ALkzAd6H7wlTYLodkmq3KQPxiHWx0wAv2qWdc+XOmWS0uh4sou2jNF6Sye4LdTT1PFBzPlqiUK2nitVvMP9hLO3omNYL6BF76JP+25FkV1EIQWqhldMlgJQuMMkKM9/bAjzo6/APS48eRR+1XcH+fjGG9Z7BnMh8w314=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938550; c=relaxed/simple;
	bh=Ov5jgNk0w6YJsS+suHU58+NhqAxez4pzYLPwKn93/zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wfn3dgOvgxCJsEApad+HU7e5Ajt+GaxTl0YEvS4HYzCBkqHm6hvRHcQRh0lKNFphWJvuFumFDNhgLDGjflOJ5qg9joMHbRvt/74IZaXcbHpoFpJVo3S8boj4b0SfimaYIiHNgrN5nipyObC6ymaFGA/oPhq131EC6JvMGUfSGB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0D7VIB46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0D7VIB46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682F0C4CEDF;
	Wed, 15 Jan 2025 10:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938550;
	bh=Ov5jgNk0w6YJsS+suHU58+NhqAxez4pzYLPwKn93/zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0D7VIB46F4oFw61LWOOsd4A38lbV8vKkieh30+mPK1cpAxoxGu9ohGZO7pHgfcFhP
	 5n6vXxkZcWioch1A7rMlmAI80GWKmJGCa+Mozv3Fl2uBTnrI+gxyNlud8ll/w/NFX4
	 iGUch3Xt+nCnX3pZVE5VEwo6KPLDiyKfaBr49Rno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Brett Creeley <brett.creeley@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/129] pds_core: limit loop over fw name list
Date: Wed, 15 Jan 2025 11:36:40 +0100
Message-ID: <20250115103555.371882453@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 8c817eb26230dc0ae553cee16ff43a4a895f6756 ]

Add an array size limit to the for-loop to be sure we don't try
to reference a fw_version string off the end of the fw info names
array.  We know that our firmware only has a limited number
of firmware slot names, but we shouldn't leave this unchecked.

Fixes: 45d76f492938 ("pds_core: set up device and adminq")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250103195147.7408-1-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index d8218bb153d9..971d4278280d 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -117,7 +117,7 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (err && err != -EIO)
 		return err;
 
-	listlen = fw_list.num_fw_slots;
+	listlen = min(fw_list.num_fw_slots, ARRAY_SIZE(fw_list.fw_names));
 	for (i = 0; i < listlen; i++) {
 		if (i < ARRAY_SIZE(fw_slotnames))
 			strscpy(buf, fw_slotnames[i], sizeof(buf));
-- 
2.39.5




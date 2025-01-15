Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974CF248BB2;
	Wed, 15 Jan 2025 10:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938013; cv=none; b=UVwpm0t+LTQR9pxCmVh37mlr3KxWWLyhMrREZ0liPy8LuA3d2ZgKSOpm5tr5cuiiUDy/l7XCUReu6/1Pt3Gb8v5R5q41DyrOqU3y8ZrT6P/ZKSkOdfbC+yQwzQpR5ajW0iCMLvIYQraYE8OKdfN/MsGqXnOXHu38RovUMjppJRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938013; c=relaxed/simple;
	bh=XAcBmaa/bYLtToBt/BiG7ELznXMlnwhKy/iupvLs24g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/g2u0QYJ2Ury63YF7Lt5s6iz0X4/UO5vBjOLhtddOp82cTWktfGangVRT/ODBLxEW+aqqdN3MPk4v2Qkaxms9mgsKPtuwAbdjsGO9ur4DCRklwFcUObe8uFozdWJs1UR8Siy+rY5DQy7wlUdWMh0Cz195EGVegEcSg323wLykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drYw/1DH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drYw/1DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CE2C4CEDF;
	Wed, 15 Jan 2025 10:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938013;
	bh=XAcBmaa/bYLtToBt/BiG7ELznXMlnwhKy/iupvLs24g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drYw/1DHrZOyaLcbe4kLbbBI2q3DlVq2UeRD/tOiPsQPEWPlPZNnAXtJXYhELiSaO
	 CDRyTzJWbL83tHUSROd2T3+l5+lNGUWOLTf6vJcKIu4BQk8mRVU5RwS/MJJ5wpIxsu
	 JfAd9H4wZ3GLnWvG+bhEF9tCFle3/+HF2v7gPCP8=
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
Subject: [PATCH 6.12 030/189] pds_core: limit loop over fw name list
Date: Wed, 15 Jan 2025 11:35:26 +0100
Message-ID: <20250115103607.561393480@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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
index 2681889162a2..44971e71991f 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -118,7 +118,7 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (err && err != -EIO)
 		return err;
 
-	listlen = fw_list.num_fw_slots;
+	listlen = min(fw_list.num_fw_slots, ARRAY_SIZE(fw_list.fw_names));
 	for (i = 0; i < listlen; i++) {
 		if (i < ARRAY_SIZE(fw_slotnames))
 			strscpy(buf, fw_slotnames[i], sizeof(buf));
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC931F75BD;
	Tue,  3 Dec 2024 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239951; cv=none; b=etAbjyCkOcDWfjXogwBIH1e9HSMkopt5lXArJKwEkt6aLFGNL5pRg0ZeBcKPvlwc5sybRF+jV8JZ/ywSA5Gxh57l/ZWXA5n8pcGRVsbWXgbXHVUxjgQhbjLE0rlMwSIVBnlF4rxlmfpBJEYXSg4s3YxjUF3zY0sVXsI9R7EZyoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239951; c=relaxed/simple;
	bh=4DJXQxfBqdCn9uuqhzU3RoLvITM9SsTKuMSr7bf87eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUgwZIthVKjhp1NUs4KsqEQkEz5hNYCUmwaHH8WQmM0sL/qoi6mDpelvqHDSDi2hC0NTSNPI1KFZgjegiVRWMIS4L+Bt3SNC7z8IzSrvmeZ5yKi5Wgtohs/0PlMYX5yr4hR8Pys3/Rpp3pGdR3y4SjX/BGmIGuMmMKXZw+gJijE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXlbkGcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXlbkGcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27587C4CECF;
	Tue,  3 Dec 2024 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239951;
	bh=4DJXQxfBqdCn9uuqhzU3RoLvITM9SsTKuMSr7bf87eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXlbkGcvR3boqMT7NnQO547KLz62RX7ZSq0j1ACmaX+tD9/i5M0HJuWbvNcZahMcV
	 hG88raI0HlBxjXP3qYGKUkpdqd5BGZ5soqTTWG6vtWlirTHORnGQQhUHaMrxqTeAdi
	 WhdSpnomOVN4O2X/FECXaPGMIwlTh8AOZLVIzcVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 791/817] perf/arm-cmn: Ensure port and device id bits are set properly
Date: Tue,  3 Dec 2024 15:46:03 +0100
Message-ID: <20241203144026.886892270@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit dfdf714fed559c09021df1d2a4bb64c0ad5f53bc ]

The portid_bits and deviceid_bits were set only for XP type nodes in
the arm_cmn_discover() and it confused other nodes to find XP nodes.
Copy the both bits from the XP nodes directly when it sets up a new
node.

Fixes: e79634b53e39 ("perf/arm-cmn: Refactor node ID handling. Again.")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20241121001334.331334-1-namhyung@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 48863b31ccfb1..a2032d3979640 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2147,8 +2147,6 @@ static int arm_cmn_init_dtcs(struct arm_cmn *cmn)
 			continue;
 
 		xp = arm_cmn_node_to_xp(cmn, dn);
-		dn->portid_bits = xp->portid_bits;
-		dn->deviceid_bits = xp->deviceid_bits;
 		dn->dtc = xp->dtc;
 		dn->dtm = xp->dtm;
 		if (cmn->multi_dtm)
@@ -2379,6 +2377,8 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 			}
 
 			arm_cmn_init_node_info(cmn, reg & CMN_CHILD_NODE_ADDR, dn);
+			dn->portid_bits = xp->portid_bits;
+			dn->deviceid_bits = xp->deviceid_bits;
 
 			switch (dn->type) {
 			case CMN_TYPE_DTC:
-- 
2.43.0




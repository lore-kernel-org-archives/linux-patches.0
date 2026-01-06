Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8342635293D;
	Tue,  6 Jan 2026 17:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720149; cv=none; b=jK/4NdObLC68COPOsaDPz3xVrDElRPJ/jE4gKSDhIWVU2EvmvwyNgDAKAME2LQXC86ABgMMSJr2tYfP488RirarZ/8r82/sIj69CtDX5iEd9ZxiPwppdMimUk6jcshVNGY0aE5/jtznjkWwlkm3upEJrMrmopXp7ouPwpKhkjP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720149; c=relaxed/simple;
	bh=PPPs8Z+kI3sh2hj8vRoEhWhnzspjsPz2NMiHso5UinE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW9//JIaJpk6ZWhPnjdGer4OPKxCbAnUvljS72VFKivZ3MZJdqfeh6jl/ZTUqzHGaKA+XJG2g1+LBVZwQ7Ppaek8/HQBX+qzC1SK42ClxQecGXWsLDBkPtBqwXOZxD/udqjZaWEQakPXz8VW1rzK1qVZvCJL5I7Kp5YN5KNBSuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwbF8lVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwbF8lVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FC7C116C6;
	Tue,  6 Jan 2026 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720149;
	bh=PPPs8Z+kI3sh2hj8vRoEhWhnzspjsPz2NMiHso5UinE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwbF8lVu0EW91l4GETlMvzUt3JF9OBoxszdaHe2dCSxQXtwdPnzfmvgbVv0uFSTsy
	 EnJBkLZPblfa0uNk9ifHKDr/SmqoC5GoNctKeen/9Uizkv+ijZc3dSssjmL2WBDY9I
	 /Vlfa6O3SD98moOFRWr3cuuheezvbwKaN4nyI4yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/567] scsi: scsi_debug: Fix atomic write enable module param description
Date: Tue,  6 Jan 2026 17:58:51 +0100
Message-ID: <20260106170456.837468271@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 1f7d6e2efeedd8f545d3e0e9bf338023bf4ea584 ]

The atomic write enable module param is "atomic_wr", and not
"atomic_write", so fix the module param description.

Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251211100651.9056-1-john.g.garry@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 89a2aaccdcfc..dfe38d34d051 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6716,7 +6716,7 @@ MODULE_PARM_DESC(lbprz,
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
-MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
+MODULE_PARM_DESC(atomic_wr, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
-- 
2.51.0




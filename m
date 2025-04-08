Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D985374C4;
	Tue,  8 Apr 2025 11:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110849; cv=none; b=FSQW7lFI5OiIY6JuLUAQK22/rMBLjaf8STU1+ggRawAoquCkYKV6hagBHdC15Om8wxxJVIwmV/ceK7KWIcRO3KeEYe02kevf5lOUsRX4U4aUgXo3t23/NYY5+epjcUmrQXfEr3k8mjYDJ3IRcZZOSVoiDD3Iavm2+Z9EUr3EI9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110849; c=relaxed/simple;
	bh=M4lUaiawyABs+j5hox2es5EPnvKRIgm2vrAdQeaqhCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC8O3k3WEZ0QEmpuYtwPRuu7zSPg6KDPgMHAwvJ9IOVRz21UG1UNRByCls52QZZ++HjyM2ETVyrJCXYmkd++ElKMKTRzGxV0f+2LC4KoWX3yFMYaYYKa1rUfmwpXeY5Kz7jRWYgBn6k6pdQWZ15M756wsgswg01v9R0zRQoCyXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICNUkPob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICNUkPob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3750C4CEE5;
	Tue,  8 Apr 2025 11:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110849;
	bh=M4lUaiawyABs+j5hox2es5EPnvKRIgm2vrAdQeaqhCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICNUkPob+ilXWb/m/ijvO6NMNV7b3Oz/Bl3MhNH6GM5+/xogSWn/fBzPFxDGXwi5/
	 gy4X0Khazbt7yok9dCbGaNORlcjFVuAszo335/TT2P6szHIAReJjex7ebHDS+annJA
	 ldWoHOWj7uAnD5Ag/lSqDx0pa9Mh45wruLurocS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jan Glaza <jan.glaza@intel.com>,
	Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 210/731] ice: stop truncating queue ids when checking
Date: Tue,  8 Apr 2025 12:41:47 +0200
Message-ID: <20250408104919.166556632@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Glaza <jan.glaza@intel.com>

[ Upstream commit f91d0efcc3dd7b341bb370499b99dc02d4fb792f ]

Queue IDs can be up to 4096, fix invalid check to stop
truncating IDs to 8 bits.

Fixes: bf93bf791cec8 ("ice: introduce ice_virtchnl.c and ice_virtchnl.h")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jan Glaza <jan.glaza@intel.com>
Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index ff4ad788d96ac..346aee373ccd4 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -562,7 +562,7 @@ bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
  *
  * check for the valid queue ID
  */
-static bool ice_vc_isvalid_q_id(struct ice_vsi *vsi, u8 qid)
+static bool ice_vc_isvalid_q_id(struct ice_vsi *vsi, u16 qid)
 {
 	/* allocated Tx and Rx queues should be always equal for VF VSI */
 	return qid < vsi->alloc_txq;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4109817E90E;
	Mon, 27 May 2024 19:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837097; cv=none; b=h4gscfkFQVaKKSlEt+z/FWpIfTt7XA/tYp0jbUt4f5O8eC0IiWwFwQ9/tojz2BNilecewBs5tdJJ+qeUgfbNln0u8QypBrWppZC0nGiQLtAAoZDCdhbce3tJcQlcB1TTxg+gdlfGuCll1qpntK1e/Is6XD9lpa8B+N0uh/NqbCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837097; c=relaxed/simple;
	bh=z7OqTSRDMgM/2owao2NQdIoWqEEH7EJo8nzoFAeL8G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i230QLUNpi0q3Y7GXfMyKZZ5wXuOB/JP+LA1w3o/sj20ctDHXILYFphVxHCHA15RgID5iY7vnf3+5QElr5jAfxXXwWj2BkSk77mvB+OLa2CX9UsnHswI1kCUXWTab767sW+/mvNWIapDwzHgNnq4yupQ2lY+9oqCq4CVSEGjbfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmU+Lga9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmU+Lga9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD2DC2BBFC;
	Mon, 27 May 2024 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837096;
	bh=z7OqTSRDMgM/2owao2NQdIoWqEEH7EJo8nzoFAeL8G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmU+Lga9yT6sXo/oWRxwmvGU0O5968csYKBDxOwXDVNTvFIDGuWXNyfA7R2l+QQDa
	 z5ZceT3o6EGGCd0+l+GgAvNOKEUq8OjEs25Cc30H8M58MT3cXYSUc6JphhjyuJVYCM
	 wVLz1Mx8sFVE7GAWVmcuUnLDojAcdJtWcdEPYkUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 308/427] ASoC: Intel: avs: Fix debug-slot offset calculation
Date: Mon, 27 May 2024 20:55:55 +0200
Message-ID: <20240527185630.741330863@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit c91b692781c1839fcc389b2a9120e46593c6424b ]

For resources with ID other than 0 the current calculus is incorrect.

Fixes: 275b583d047a ("ASoC: Intel: avs: ICL-based platforms support")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240405090929.1184068-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/icl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/icl.c b/sound/soc/intel/avs/icl.c
index d2554c8577326..284d38f3b1caf 100644
--- a/sound/soc/intel/avs/icl.c
+++ b/sound/soc/intel/avs/icl.c
@@ -66,7 +66,7 @@ struct avs_icl_memwnd2 {
 		struct avs_icl_memwnd2_desc slot_desc[AVS_ICL_MEMWND2_SLOTS_COUNT];
 		u8 rsvd[SZ_4K];
 	};
-	u8 slot_array[AVS_ICL_MEMWND2_SLOTS_COUNT][PAGE_SIZE];
+	u8 slot_array[AVS_ICL_MEMWND2_SLOTS_COUNT][SZ_4K];
 } __packed;
 
 #define AVS_ICL_SLOT_UNUSED \
@@ -89,8 +89,7 @@ static int avs_icl_slot_offset(struct avs_dev *adev, union avs_icl_memwnd2_slot_
 
 	for (i = 0; i < AVS_ICL_MEMWND2_SLOTS_COUNT; i++)
 		if (desc[i].slot_id.val == slot_type.val)
-			return offsetof(struct avs_icl_memwnd2, slot_array) +
-			       avs_skl_log_buffer_offset(adev, i);
+			return offsetof(struct avs_icl_memwnd2, slot_array) + i * SZ_4K;
 	return -ENXIO;
 }
 
-- 
2.43.0




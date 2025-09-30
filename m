Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF59E217F55;
	Tue, 30 Sep 2025 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244769; cv=none; b=OYIKMhncegRBvQUZYzc4+Vw5gQo8CsSaHn2FBCNuALOyh4KvZFu2snxtMNDiwcqZd+WlCP2kyCOd1qQulxAa1qScwru9F8eoNPeCK1LQsaYn80EGp9g4G3/xbY+D7nkG/fflSV059TMhkQ76oQ/PELEFcZkyvgyNcTuqVqJ9DSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244769; c=relaxed/simple;
	bh=+HYUXWKHt68cHzhldUrPmt8vAql7ptLMRd4TI3DDYQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9QCgyHz3bVBcFmShKnn2MChtWTfMtPi6XqfHTiDoVVStPBKNOaWX4dum0LuHgaN7sagj4N8i+Z4BeuSBncvfaFjwNbZJMYvoIGjvW9wmdHVWzXICXCe/YI5HWSLetFFHOyPUmv50Q6ydw4g/yG5PRFnHNZnLwp8mtqWeC2NTFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pn/xdDp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pn/xdDp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBACC4CEF0;
	Tue, 30 Sep 2025 15:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244769;
	bh=+HYUXWKHt68cHzhldUrPmt8vAql7ptLMRd4TI3DDYQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pn/xdDp1oNqrr0f90jBtgWugmAwO4E1PhjU5zLGOi4QfTI/yqWdA59hd+l526LM1o
	 xLt4K8olhCDYpnZLoJNYlE0B8O/t4xyV14gAAlaasAwtCDp9dJxCBJ7VwBZHK14Iib
	 Rd0NXCOhKXu6zMxPYNMV7ie2CvIhm7ueVvL9oeho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czapnik <lukasz.czapnik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.16 108/143] i40e: add mask to apply valid bits for itr_idx
Date: Tue, 30 Sep 2025 16:47:12 +0200
Message-ID: <20250930143835.537399802@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

commit eac04428abe9f9cb203ffae4600791ea1d24eb18 upstream.

The ITR index (itr_idx) is only 2 bits wide. When constructing the
register value for QINT_RQCTL, all fields are ORed together. Without
masking, higher bits from itr_idx may overwrite adjacent fields in the
register.

Apply I40E_QINT_RQCTL_ITR_INDX_MASK to ensure only the intended bits are
set.

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Cc: stable@vger.kernel.org
Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -448,7 +448,7 @@ static void i40e_config_irq_link_list(st
 		    (qtype << I40E_QINT_RQCTL_NEXTQ_TYPE_SHIFT) |
 		    (pf_queue_id << I40E_QINT_RQCTL_NEXTQ_INDX_SHIFT) |
 		    BIT(I40E_QINT_RQCTL_CAUSE_ENA_SHIFT) |
-		    (itr_idx << I40E_QINT_RQCTL_ITR_INDX_SHIFT);
+		    FIELD_PREP(I40E_QINT_RQCTL_ITR_INDX_MASK, itr_idx);
 		wr32(hw, reg_idx, reg);
 	}
 



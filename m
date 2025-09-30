Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F07640E;
	Tue, 30 Sep 2025 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245347; cv=none; b=ILgNhFpQrO4Nyk+hyoaZ6W01ApLJiKZIz7c7WdeScVlYZHcb9PxpgUv8T+T+695CeDVZcSof+3uSQjFijNF/z9jV7s2XgEk4Cid9aXcAR+LvKwdqcd6lTAdrpecxPTU99ydugigwFCwISthrb8bhAREPbpono3qmCkP+eaSgJIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245347; c=relaxed/simple;
	bh=XCMFTE9tf/e4DIdOIPmbvXxCs5KAQFFiWoTVwNHY2lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRG0Bu/4vzRKrCoTzBIO3+9WKdU5ebXC7xdKSRzL3rWpBL51aGdJfHINIHPpFSmKg81bKLvalrZkuK/xiWPKhuaR7C0TGuWLg0E1fu1qc0Zq+Qc1uhqo4PBr9nisFpMrUGbDwTWJ2WeIKN3w/I5K5aRcSfWVCudv08uus6y6ams=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09e2e1U0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09e2e1U0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A69C4CEF0;
	Tue, 30 Sep 2025 15:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245347;
	bh=XCMFTE9tf/e4DIdOIPmbvXxCs5KAQFFiWoTVwNHY2lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09e2e1U0FJZP5T9KXr2tsweHU3mOTWV6NgrAXcqJKtHoZb8kGXk3F01vTsTT3AMHQ
	 UbR+rZgtH2JhDp5svyI+H+d/WtzDTfd17Uqx9dX15JcG8+cLNLOnrm6yQTonn43W29
	 QdKJoCY9DxVRqlyZ4ttF/gPlsxO5qj6mnWImO3lA=
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
Subject: [PATCH 5.15 141/151] i40e: add mask to apply valid bits for itr_idx
Date: Tue, 30 Sep 2025 16:47:51 +0200
Message-ID: <20250930143833.208576160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -446,7 +446,7 @@ static void i40e_config_irq_link_list(st
 		    (qtype << I40E_QINT_RQCTL_NEXTQ_TYPE_SHIFT) |
 		    (pf_queue_id << I40E_QINT_RQCTL_NEXTQ_INDX_SHIFT) |
 		    BIT(I40E_QINT_RQCTL_CAUSE_ENA_SHIFT) |
-		    (itr_idx << I40E_QINT_RQCTL_ITR_INDX_SHIFT);
+		    FIELD_PREP(I40E_QINT_RQCTL_ITR_INDX_MASK, itr_idx);
 		wr32(hw, reg_idx, reg);
 	}
 



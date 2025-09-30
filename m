Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8895A2343B6;
	Tue, 30 Sep 2025 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246236; cv=none; b=sPKNJUMUC2XzsC6MWxbh4Ltnf+DesWD0f1SsZ8LbOV5e7sVLh93EK5IEQMuuEJ/q8RMRB4DxnFSg6VbPtnDm/sVLZavokHVs55OKGNGptg5T+1ifthYzMZM5z1pQT8IMaaxc35d0KT6weKfF0c1+WifOK9dZvRhARG2ueAiKC98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246236; c=relaxed/simple;
	bh=Oze6vOy2CrN4RwcH0sUrdyiQOVROn0LSP3cgH/CKwNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqX+/OUxUVZk7KvBg4hJO7xbbYBSUjzxvxU5j9Pad2TOEiH9dnPBqva+BvEOX5oJfAmgy4But04UhbJTo/FMTjO2xcnNepvZVpF1Fhr/VeABlFoU+EYmrB3E+8AN+ye5PXsWsybYkJXavwT13DlLcFB79kft0Jpfomevgou/o00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhK3ChLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhK3ChLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9527AC113D0;
	Tue, 30 Sep 2025 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246236;
	bh=Oze6vOy2CrN4RwcH0sUrdyiQOVROn0LSP3cgH/CKwNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhK3ChLfToHAr2M2giJ6hY9aptnJuGZiU3qhODAn/zq5FeLx/9CBlMauYMyrEjyQ9
	 Vye7C2iporSJFqc4kH9yxjndC6CDHVkmV1djdpnpBEtnp89fDx5G5HEgZvaUU15Tns
	 zRYUjNqkD/+04smO/rc2oH2taPbmdTsMYblssjVU=
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
Subject: [PATCH 6.12 73/89] i40e: add mask to apply valid bits for itr_idx
Date: Tue, 30 Sep 2025 16:48:27 +0200
Message-ID: <20250930143824.927279266@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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
 



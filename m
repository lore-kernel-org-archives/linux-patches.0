Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C497844CAF9;
	Tue, 16 Jun 2026 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625408; cv=none; b=SHSkv3lh3DVRLdHPd5bbKQURPVkYO9Mfjkcg34TSg7ol/4Tl9YGtKHnUZR3r1Lkk0bOoetv+5HdVoupLmG4ebfFvBRTGeSM/NB7Gk4bPo7q9TwrDx2y9jgn7PKNUcBsRECnqMV3ojGWK2PfVKA5vXYPaHMsHZNI1v/ceKbWKxFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625408; c=relaxed/simple;
	bh=p5M9+AihdxCyyc91Xd3cSdC0PlvWav17CT12RF/cZss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byaks3HDKqb2DFWji0v47SIrwnj27FtY3e3QqXG7nIbTyxYDOpawwswLAd/CMEbE9WzzueViPWVp+JSjvnbJWzI/3OjCMAWY+RWsw7TCH13tsW4mE5rrP2JiF+gC+t26fXkRYEXn7EMGIKyGGNpkpTNxAfzxgufMv6g8fOm0f84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuMRQUfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuMRQUfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52AA1F00A3A;
	Tue, 16 Jun 2026 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625407;
	bh=IK9a6aAdeOlqqkez7szO8hX8cu91fMickjzlyLb7dGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuMRQUfv6zzbCfxjnX6aNqegdXZKEPWkD7yhwRIzEl4p1EqF+OOnZdfkTIFEqcfDc
	 Ih/HNdSic8gO10yA5IR6iKYJAyTiCRQCzBvTCWG/GXavSHYROb1z3nXQkFO5n3G7r3
	 YrMyz2qPMW7zvEqJwnxXn2HPMOAg3kBNlXsTePR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/325] net: txgbe: initialize module info buffer
Date: Tue, 16 Jun 2026 20:28:52 +0530
Message-ID: <20260616145104.509850750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 0487cfca46517ff6699c72dc1a8872b0af3c31a9 ]

The module info buffer should be initialized to 0 before the firmware
returns information. Otherwise, there is a risk that the buffer field
not filled by the firmware is random value.

Fixes: 343929799ace ("net: txgbe: Support to handle GPIO IRQs for AML devices")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260608070842.36504-2-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index 0bc59431d43343..07ae491e3bc9b9 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -220,7 +220,7 @@ static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sff_id *id)
 
 int txgbe_identify_module(struct wx *wx)
 {
-	struct txgbe_hic_get_module_info buffer;
+	struct txgbe_hic_get_module_info buffer = { 0 };
 	struct txgbe_sff_id *id;
 	int err = 0;
 	u32 gpio;
-- 
2.53.0




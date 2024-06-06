Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A991C95E2;
	Thu,  6 Jun 2024 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683733; cv=none; b=X0LXQkKZaC5FjacYcv08upro2cB2wqskkyn1Sme9MXs9gpqnQzCjpe5cqIdxMgFziSpxYwAdne+8ZB/ZNn6Zkq16R729u+h5BURqt/BkceAZcTebBizvj9VJsMrhmVNKv3tD94ZAIP7yYC1dqosMeljFhqq4csJZ0pkZxjtbxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683733; c=relaxed/simple;
	bh=B69ZOMYnEMdiUoD7Cc0QsL58HSU91LpmTtszqQAfN+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1J95/+AOB6lIBTuzgQlMsH6TIzAhQBCC+ocKTaTFHA39e+u8u1F0x6nKMkMoVgv8E6dwT3Pf3zQuiorAaZYNoBJC68rvOYKaFVgDY6pFqc0kjQb5WjCkE+Ab3bpP0+lIF5+Krzpc8CPi3KaeGUG9MsWhcmEhnzZGn/Ko1F2Fu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLEFxEqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLEFxEqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FDFC2BD10;
	Thu,  6 Jun 2024 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683733;
	bh=B69ZOMYnEMdiUoD7Cc0QsL58HSU91LpmTtszqQAfN+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLEFxEqCJEbRE5wUklY3gBPPzUZkUpqpHIpZT1jf/qMGXjTQuWNmB0RcFLe52xZoE
	 MViLJ3qFmU8kLKzndvalQMliKoMg9sZ/kLWOSINmUDV6kT+GrT+u1lL8unLF0UvRLl
	 9sSqmDyd5fN02D/9JHeOp5S8dTDKH1ZzT7iJ8d1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 686/744] net/mlx5: Fix MTMP register capability offset in MCAM register
Date: Thu,  6 Jun 2024 16:05:58 +0200
Message-ID: <20240606131754.495107652@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 1b9f86c6d53245dab087f1b2c05727b5982142ff ]

The MTMP register (0x900a) capability offset is off-by-one, move it to
the right place.

Fixes: 1f507e80c700 ("net/mlx5: Expose NIC temperature via hardware monitoring kernel API")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 58128de5dbdda..3d1cd726df347 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10158,9 +10158,9 @@ struct mlx5_ifc_mcam_access_reg_bits {
 	u8         mfrl[0x1];
 	u8         regs_39_to_32[0x8];
 
-	u8         regs_31_to_10[0x16];
+	u8         regs_31_to_11[0x15];
 	u8         mtmp[0x1];
-	u8         regs_8_to_0[0x9];
+	u8         regs_9_to_0[0xa];
 };
 
 struct mlx5_ifc_mcam_access_reg_bits1 {
-- 
2.43.0




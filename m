Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DA0429802;
	Thu, 30 Jul 2026 15:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424194; cv=none; b=KfCRDjk2skvCKTZlYpp5BZn93mh6d31nibOJmhplk8fpKVRhffv5jC5pKcaipb+zSSqZSaaki79BXUk8XUOlBzr83Evs6NmNoAmztyNIolRIhCDYuJAIgQLyqlncO2FEYEQUbr8wbJlgStIrlU1XiwZ4h+YVZj1Ek7GB7pKKMx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424194; c=relaxed/simple;
	bh=janzEIb/+b2gQI1H8ZoXiC91kxR7Jmu2Vvoe5Btp5Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/HL+SswV+xjikIar+SOyJO/oG++yifaBbEDjp4ML/IivhqsLIKUK9TAyVvoi+r9DG/OUysFC2cGj6n6hQ79nGr3j5tmrAbEJRDdn6Z3QbvnW8xeSjexyZhS7xzcHIBUWuUqSBJ8e+fQwMgCVX2E+PWr8TXYOB3b/Id+lpopwHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+fELJZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+fELJZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2BD1F000E9;
	Thu, 30 Jul 2026 15:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424193;
	bh=o8r04pa8ZNxIzGrC1vkcvUOuJvO4Yx7LD6LUTyFGrz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+fELJZ6IbC5hoZtbqjO2u5NAmSmPENQj8IjT0yoqSJgAgdY9kPCfpDHoGCenBT4P
	 AQBu9LEKxUTl2Uc4YPdZfF4ikG67Lj7cZCwgywrsEsjdu8MnX8XmZMwmmLqb82auFX
	 VX8Js+jPPTI+HQoaDzAg7zvqZXWCDDDtiZO6xF8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 306/675] net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation
Date: Thu, 30 Jul 2026 16:10:36 +0200
Message-ID: <20260730141451.627897928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit 9173e1d3c7c7d49a71eee813091f9e834ec7cee5 ]

Credit Based (CB) TSA is not supported by the mlx5 driver, so reject
any configurations that specify it.

Fixes: 08fb1dacdd76 ("net/mlx5e: Support DCBNL IEEE ETS")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260717075125.1244877-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index fbd84ab8d61e70..20db77552545e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -309,6 +309,14 @@ static int mlx5e_dbcnl_validate_ets(struct net_device *netdev,
 		}
 	}
 
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_CB_SHAPER) {
+			netdev_err(netdev,
+				   "Failed to validate ETS: CB Shaper is not supported\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	/* Validate Bandwidth Sum */
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_ETS) {
-- 
2.53.0




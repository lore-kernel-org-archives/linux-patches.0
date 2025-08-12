Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71621C1AAA;
	Tue, 12 Aug 2025 19:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025603; cv=none; b=BnBVOVvYL9rVX5QfGv2OxoD9/jHI5hHNZWQSX24q2Pgwhzo57XX22qALV4czBUaxMVW/MTmwnzoj21Rw9b5RPeRt2yuabWxcBiQD7ArB6nvyDzv9+c7ZabUmwD35p4g8ZojAayJKIzv3YR7kpk+ekDcrvfzEaRDfMy3nXs2OBC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025603; c=relaxed/simple;
	bh=0i8mfQyJ+g3PmRWWgUM9+++YD+QtVgIkbUzrS0Z+3Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxIkoq9065SIvUTy3t1xVYxa+49X3boPhoHfBA6ef+zk04C0BVboOr5ueYvxC3SHQsjdIEL5KXuvkDGX8IhaFOdJrJv9icqL1SDBNbaSwMJpQwv6iMaQQtt9Ted8Bd7qL7/GiDXCOfE8a433fqd47lmHRbsdG34rkWQ4We1V5Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTvbsMpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTvbsMpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1058EC4CEF0;
	Tue, 12 Aug 2025 19:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025603;
	bh=0i8mfQyJ+g3PmRWWgUM9+++YD+QtVgIkbUzrS0Z+3Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTvbsMpUn7tscT6npCKhv0Kn8BP5i8JZA6lYJfT7Y7jWkR6pOAXQDJ1n8GDMjfu3T
	 H2IpAod+GZ1nZ1ug55k7mx5OB9ZNwwV7yS6fC7ThAkFWbhd5kF/nLheIgOdb6+DfKj
	 vvQhAEbmnIi6Wohw+VSndXpmDGqtq2r/+CMRpYh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 091/480] interconnect: qcom: sc8280xp: specify num_links for qnm_a1noc_cfg
Date: Tue, 12 Aug 2025 19:44:59 +0200
Message-ID: <20250812174401.207015296@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 02ee375506dceb7d32007821a2bff31504d64b99 ]

The qnm_a1noc_cfg declaration didn't include .num_links definition, fix
it.

Fixes: f29dabda7917 ("interconnect: qcom: Add SC8280XP interconnect provider")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250704-rework-icc-v2-1-875fac996ef5@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8280xp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc8280xp.c b/drivers/interconnect/qcom/sc8280xp.c
index 0270f6c64481..c646cdf8a19b 100644
--- a/drivers/interconnect/qcom/sc8280xp.c
+++ b/drivers/interconnect/qcom/sc8280xp.c
@@ -48,6 +48,7 @@ static struct qcom_icc_node qnm_a1noc_cfg = {
 	.id = SC8280XP_MASTER_A1NOC_CFG,
 	.channels = 1,
 	.buswidth = 4,
+	.num_links = 1,
 	.links = { SC8280XP_SLAVE_SERVICE_A1NOC },
 };
 
-- 
2.39.5




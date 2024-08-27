Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18992DDC1;
	Tue, 27 Aug 2024 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770003; cv=none; b=nsotbe9JJYNenXqOThj9buAZ7IKp6vEJ6L/tRU4Gep+NNhhuB39MVxX5Rw1X+OvUHfRBihDRIvmvxNiuL0kdLRyi7UBc4AYbcONid5XPvqvGDno6kb1c06kJ3wuTPxpZ51ujQwYKuIezwa98My8cTfvO2q4nPCfd4/kIzLRnDeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770003; c=relaxed/simple;
	bh=RA4o3+UUCNrZV0R3Lk9SitGzEGR1YZCWFJxwdWSqfSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBRzKrPrnTpZAqmFBKdRsufKyzmfr0dJhU/Raj0ueCc1o8GqxXmnO4nNpRHBVoaTYqV+rTzrvVwm9mg4b7YxNWHTz7XrBF0i6/h+iHH98Ru7Vhq6PZpaEAmwqJW2++wnXCYg5JWzxp3Lnk5YNbGS3NjgtgV6A+Sa+3ICerIvEFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaSTVgSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaSTVgSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251E9C6106D;
	Tue, 27 Aug 2024 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770002;
	bh=RA4o3+UUCNrZV0R3Lk9SitGzEGR1YZCWFJxwdWSqfSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaSTVgSmF1+VeYWd0MvaVsI9comGaOrs0ZF0lAzCiWrZIoxkRlZ0vxvXdNUtn1sd+
	 Nxl+8SY0MATfW7V3XoOls4jqq07/vHlAS/wLEXRK8vzhRXDzoFhW54f/AijRe9AzEt
	 5Eo5vbd36UM5voE+s8pmJb11RBAXnMntmW8bTTv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/341] RDMA/rtrs: Fix the problem of variable not initialized fully
Date: Tue, 27 Aug 2024 16:35:30 +0200
Message-ID: <20240827143847.174117273@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit c5930a1aa08aafe6ffe15b5d28fe875f88f6ac86 ]

No functionality change. The variable which is not initialized fully
will introduce potential risks.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20230919020806.534183-1-yanjun.zhu@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 3696f367ff515..d80edfffd2e49 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -255,7 +255,7 @@ static int create_cq(struct rtrs_con *con, int cq_vector, int nr_cqe,
 static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
 		     u32 max_send_wr, u32 max_recv_wr, u32 max_sge)
 {
-	struct ib_qp_init_attr init_attr = {NULL};
+	struct ib_qp_init_attr init_attr = {};
 	struct rdma_cm_id *cm_id = con->cm_id;
 	int ret;
 
-- 
2.43.0




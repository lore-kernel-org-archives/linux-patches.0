Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030219;
	b=N3/Ftzx8fOJz3HEPItmEDA1xgGMT3cs0u4AZVAuj3T3d2cng7vko4S3AiMQ4JOwubyEX
	 yR3v12D2iwfb7DMt+UwLVFKLs2SOTSn2HPf17k1sPND9v2Ex5mI18SL9fD397aXEbgaxM
	 8lg2DPUxMrcsOBFbmWBOGBymiEXDG/9KndZcTaH3tcmDA7MGNB+032cR+27A3ijAKE68N
	 MnqVDfYnOVkLs0Y5br4CWQCeOoxeP0J9CnXsnQ2KToc3HW4WgCeZ9CvbKhLm6z6z3JK0R
	 YsT5D2fKSoVyzkzEFvd1e27W5wiQv2H7LTbb+WWC3ItH382XSccz4FtcmzldI2fa6jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VG6kXR9YBB+FdAz21vzUoMSQMpSem94kX85QbOq+bJc=;
	b=ClJxjvCVMEXMaJpfrIvWwlv3VRrh42sPMjwk+Zo4Xi0mY28EkHTxIqMSZSCFPPenKA/K
	 OXrgf07kygii7m3coCMNmHdjN8RmRKSB10/81PwTHod8T00JYIPXurLeamcuRNW8BDzGU
	 DYKnEdaMTbPg00tCjdyWgadapoAteEJGp9bULcnnftKD1jkaQ5G/vQfzvl+rTsq1U62AX
	 vsjd8AIrjf2EDq7EPKK9AYiHlMvAYTxPcPJqxrYYemskyX4nKvInK3O7J2A9ppaLBibdy
	 kF6rxxcenkkVo5YjiYsYQP3FUmVMxm0CWOvhV5AX4ADzGdNOUeyBcqRlaPF5R1+rYFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMfjTabe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55BD606DD01;
	Wed, 18 Nov 2026 19:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMfjTabe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A9F1F000C4;
	Wed, 18 Nov 2026 19:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030219;
	bh=VG6kXR9YBB+FdAz21vzUoMSQMpSem94kX85QbOq+bJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMfjTabeBMFAgSZUPxNwhpOPk+LAdmv48wMLWMTR3Z9M816jKsTLUdapNOMEJ+dV2
	 UEYI7/wiX0mJv50523hBM0hOVF6QGV3ifJ+EPiJp5czKYi68mlxoO9Zk6HzR35rZg8
	 vliTETN+3xaiUKa/8R+qkPFOx3iMj06zqLAc/rBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0627/1756] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Wed, 18 Nov 2026 15:45:54 +0100
Message-ID: <20261118150033.846914382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit d2aa15620e98dc4c6516944397ebea03b7a62b90 ]

mlx5_cmd_create_srq() stores the SRQ into the xarray before
srq->msrq.event was assigned. A firmware SRQ event arriving in that
window calls through a NULL pointer.

Move the assignment before mlx5_cmd_create_srq().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-12-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index bcb6b324af506..38def085ee267 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -284,6 +284,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	in.pd = to_mpd(ib_srq->pd)->pdn;
 	in.db_record = srq->db.dma;
+	srq->msrq.event = mlx5_ib_srq_event;
 	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
@@ -292,8 +293,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	}
 
 	mlx5_ib_dbg(dev, "create SRQ with srqn 0x%x\n", srq->msrq.srqn);
-
-	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (udata) {
-- 
2.53.0




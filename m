Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047239;
	b=phs4SyoRF3i2ac9CmR3ZHxUM16CUddrO4IzOaqTy5iccK7W/hntcvobEINmlDW0FstHd
	 XQNxan+lq4Wp8aRvm8K9RSPua2OPC9QthK8tjIh3OuDn07iWYsvw8GBcOVmH1vv8+xl2R
	 N77fHGk+JkrlzbhY6oE5RMxX41ErOXJLEie/C3NTHG33XtzMZx6P26lMcmHENpqbokdIm
	 CJwau4kGVow3yosfg4PQNNQzY+/dP0MMJQNpZfW32RvDiv6g+gSPohEEZfYLNx6bjBsgp
	 fjPKTviDWsDbGjqwSaCnTV/ytNNmSRHbjqphK0/ufLm4dV/Wu7ig4nJWaQ+asKC3IdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=haP51m3h6AwoY4QIkWD1k4xkY0kQnVga+SLeV5ameeU=;
	b=lzIr32UNbQYqx464HlvWhpp9xRk9Hbc+vLvcJWlYUV3OCAuQ3nE8rWQBTbuP3cwWcm+2
	 9O6RfMyWpKjPSWPJhVityKN/plZnj3ZqsuCOYkOdprdFqJ/x8wnlBa7PwQlyLuhAJsVjd
	 Xy7U+n1sbWZDfIdaj8qzOb7EjKygai8lzVnpARpJYdjsoN5wbswob4vW9AyY4sp/53Npw
	 loJf+qjHfE3grNq6WkZ7wb8hFCQIAFw39Xi2tc2dp3x6+hRxv4vRmUB/hGKjLVnlPwDbj
	 OcnmfrDU2dUtD+IOzITzLX3u7YRhfXfEU6neZhkV1RSOUgmATI/cG1B8dw0sqdyk9/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPgWftop;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DDB606A31C;
	Thu, 19 Nov 2026 00:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPgWftop
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E338A1F000C4;
	Thu, 19 Nov 2026 00:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047239;
	bh=haP51m3h6AwoY4QIkWD1k4xkY0kQnVga+SLeV5ameeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPgWftopt4gRDUT40QT8HTjFneB6O0v38dRioDnJmwXBIL2QzcUq/9CymS8Pzb95H
	 RicKXZbqF9aiVxe4fGqH+ehMw2RyOhiwL/R9MgRRBxkfMwFuSix9kUY3Uj44MEKZc4
	 5vAZC+ZvmT8F0f3zsrd7v9PHjB4YwBAzY/x3Vl2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1551/2857] media: qcom: camss: vfe-17x: Fix write master selection for RDI lines
Date: Wed, 18 Nov 2026 15:43:05 +0100
Message-ID: <20261118150257.180504561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hitesh Patel <hitesh@ebytelogic.com>

[ Upstream commit fc02156a3efb747b724a490cc50e1ad8c28a3b23 ]

On the gen2 VFE bus there is no crossbar between the RDI paths and
the bus write masters: RDI n is served by write master n. The common
vfe_get_output_v2() reflects this by mapping line->id to write master
line->id, and every gen2 VFE except 17x uses it.

The 17x code kept its own vfe_get_output(), which reserves whichever
write master is free first. That happens to be the right one as long
as a single line streams and it is RDI0. As soon as two lines of the
same VFE stream, for instance two virtual channels demultiplexed by
the CSID to RDI0 and RDI1, the second line to start is given the
write master of the other RDI. Both write masters are then programmed
with the buffer address and frame size of the wrong line. The frames
are truncated to the smaller of the two buffers and the SMMU faults
on the larger one.

Use vfe_get_output_v2() on 17x like the other gen2 VFEs and drop the
duplicate. This also removes an error path that released
output->wm_idx[0] before it had been assigned.

The gen1 VFEs are not affected: they have a bus crossbar and any write
master can serve any line, so vfe_reserve_wm() is correct there.

Fixes: 7319cdf189bb ("media: camss: Add support for VFE hardware version Titan 170")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Hitesh Patel <hitesh@ebytelogic.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
[ sashal: Adapted the change to the existing vfe_get_output() because the shared vfe_get_output_v2() helper is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe-170.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-170.c b/drivers/media/platform/qcom/camss/camss-vfe-170.c
index 47049a1fe5787..c916c70f6ca9e 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -402,7 +402,6 @@ static int vfe_get_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output;
 	unsigned long flags;
-	int wm_idx;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
@@ -414,12 +413,8 @@ static int vfe_get_output(struct vfe_line *line)
 
 	output->wm_num = 1;
 
-	wm_idx = vfe_reserve_wm(vfe, line->id);
-	if (wm_idx < 0) {
-		dev_err(vfe->camss->dev, "Can not reserve wm\n");
-		goto error_get_wm;
-	}
-	output->wm_idx[0] = wm_idx;
+	output->wm_idx[0] = line->id;
+	vfe->wm_output_map[line->id] = line->id;
 
 	output->drop_update_idx = 0;
 
@@ -427,9 +422,6 @@ static int vfe_get_output(struct vfe_line *line)
 
 	return 0;
 
-error_get_wm:
-	vfe_release_wm(vfe, output->wm_idx[0]);
-	output->state = VFE_OUTPUT_OFF;
 error:
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
 
-- 
2.53.0




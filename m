Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054091;
	b=CWhqZEDRww41pXwrAhNMzozkqiIvHAZjdmZHRdlcbYc4UiqIAv+w1FlOpece1c0f7s7E
	 Hvit0AYVbdHpPlG92YfXKJMCI1nwZhTeSOY7AoT/xUUVmrkIA+qm0MTx5ozbVT5pqjN3R
	 hhDdaB53h6ze4U3DUZkhN7TF1yDs18FNVXIlVyghZ21ad6ftKy8zqwGqbEUGW/IN1JDHP
	 3TENyWqrWq+uBnxC63AXuPYL5/baRkZxgTj95zsXeaEks2yK3gm2xQP8228hDwF+j+jVl
	 SKn2BsK9tMxhfoKRNq+KIqUsoh5eYSannosMoSyN+Md+lhT1VojnhRDDHSDvTmlNdVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iFHNGr3OkpaLopIjRJ7dfzCySPFdnyEKWA3WdJqMSLY=;
	b=hjyBBhSWs0b6mfvMc5+7wnHbHf9LdWIVdc7P3Nr8KqWzi+TJi9mKjn52howb8eikqmtm
	 Ypaub6+3PQmpZ4SwOZvFEAoYCl8jVkpFR/H6KVoklqMkodnyNdvXs0sIQJyyAXnhUQCeH
	 m8TGt046yf/vSDAHGrIuBpdy6KIIfCxRzkSjmMMRhW9x/tZUUtq2sFJD1ttCtEx9Gesb+
	 SfqpuW2Ru/PmrH8FiIF88Y9HMez/VUhB0hNa8GfL58Te5sVfR/P3J9D8Ah/ZyNo0QQCgN
	 InCeWNcz9rPlL75HIsqfp5d0NmfGQdMdsqrgafl+tErQXRFIJCT1y5XBozRPxb1xemQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBPdMimE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B05F606A320;
	Thu, 19 Nov 2026 02:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBPdMimE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C968A1F000C4;
	Thu, 19 Nov 2026 02:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054091;
	bh=iFHNGr3OkpaLopIjRJ7dfzCySPFdnyEKWA3WdJqMSLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBPdMimEE1xx9KrNoJ3JdOpIJgs7Fh0U+D4SBntQ+VZacMOzB/Ln9wdMPreFj9cyG
	 d7+o/rszMxS+DeZ2UBfxjsRpeQlSo1ucKegfGzOco1a8kycVb35i0bg1CM02x3EarP
	 U6VTrpd9J2sMpfgeXmbil36NgyqXCKdRI+eEg1ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1149/2214] media: qcom: camss: vfe-17x: Fix write master selection for RDI lines
Date: Wed, 18 Nov 2026 15:47:05 +0100
Message-ID: <20261118150057.964239116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the switch to vfe_get_output_v2() by updating the existing local vfe_get_output() implementation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/camss/camss-vfe-170.c   | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-170.c b/drivers/media/platform/qcom/camss/camss-vfe-170.c
index 3c678b6de8203..f1079d9630ea2 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -409,7 +409,6 @@ static int vfe_get_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output;
 	unsigned long flags;
-	int wm_idx;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
@@ -421,12 +420,12 @@ static int vfe_get_output(struct vfe_line *line)
 
 	output->wm_num = 1;
 
-	wm_idx = vfe_reserve_wm(vfe, line->id);
-	if (wm_idx < 0) {
-		dev_err(vfe->camss->dev, "Can not reserve wm\n");
-		goto error_get_wm;
-	}
-	output->wm_idx[0] = wm_idx;
+	/* Correspondence between VFE line number and WM number.
+	 * line 0 -> RDI 0, line 1 -> RDI1, line 2 -> RDI2, line 3 -> PIX/RDI3
+	 * Note this 1:1 mapping will not work for PIX streams.
+	 */
+	output->wm_idx[0] = line->id;
+	vfe->wm_output_map[line->id] = line->id;
 
 	output->drop_update_idx = 0;
 
@@ -434,11 +433,9 @@ static int vfe_get_output(struct vfe_line *line)
 
 	return 0;
 
-error_get_wm:
-	vfe_release_wm(vfe, output->wm_idx[0]);
-	output->state = VFE_OUTPUT_OFF;
 error:
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
+	output->state = VFE_OUTPUT_OFF;
 
 	return -EINVAL;
 }
-- 
2.53.0




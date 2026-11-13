Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591570;
	b=3muss2GRtDS9AbhhAN9Nx5ItD0QkSVTY45vP86fhLnUEC4ZpDf1UMdKAW9zi3p03qwAR
	 ROWy0/s4eVY64hOzcpIXHBxOqI/dpzJS0WrkAwc9fl+zC/k0h1JqT2lXKI7xVsJGJ15S+
	 zTh1PqH9sabDxT1ASYXx/EhuAL/YvhIVwcslykx3On6AocHoo6iJpTNPAK7s0Jd5OLkTZ
	 5hqKz8hhpCEQQfunv4iuzCc14G6QQMhzfkretRc3ftxaUUG4eQopqJm0EvLMG3LrGz6bw
	 Wlo0kRozKdCAOCUvXv9xd3hrh3XFkIKC+fS9f9woqKIygpy68dfrHceLm2rw2I+ziuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dBPkBaIeGZjqXBwf7mV2UXknKtZSE7P+4+Keo7x/wik=;
	b=CKizbIW08iKDoMI+t1nDWUt1LzQF0vi5nzkkMKnFt+vSf6M0/usy4rQZjJWJQd8XLTpg
	 vbuvx4xRgIMNO8cuv5jHMeLlDAWqn6780tbhEQah1+HNKWfYaCRtTr55CtRu6acy0Wz9h
	 4aVcMu/kk6z+spPL+SjCuiRpR7rBPDzhh+NJvbhMdltSnMxXhk3O4vkU+IDoHwSNsgsx3
	 9kuIRshmqJQKI01L8akLj8aO0LedgHR/DFTu+Gs1YEw55/RF/9AdC2ZcrTQ8ViFSa7FER
	 ZAuMmNx1NDbz6Whm/cAEmP9yKfqeNuR7VMqZATpt61n1g9IB5JZ8oEA62C+9JL3iJwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvuPphEA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149CD607E822;
	Fri, 13 Nov 2026 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvuPphEA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C3F1F000C5;
	Fri, 13 Nov 2026 17:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591569;
	bh=dBPkBaIeGZjqXBwf7mV2UXknKtZSE7P+4+Keo7x/wik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvuPphEAYVnILFwAMpNsK0C+Zh+OW6KFFLitZe4+ta2yAWxJOK583pcC49EB89hop
	 BcVQSCqOFEBauYntr3diAak018MfTKATrdDiPqFjtAu/f6XC03NPp5PRiAW/i118M1
	 zslun3chrKv9iXSCkVV5T9+0tp1M4y4TSoBWM7Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 620/670] media: qcom: camss: vfe-17x: Fix write master selection for RDI lines
Date: Fri, 13 Nov 2026 10:53:04 -0500
Message-ID: <20261113153832.811610673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/camss/camss-vfe-17x.c | 41 +------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-17x.c b/drivers/media/platform/qcom/camss/camss-vfe-17x.c
index c011f64f63e93..62c2405359a06 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-17x.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-17x.c
@@ -382,45 +382,6 @@ static int vfe_halt(struct vfe_device *vfe)
 	return 0;
 }
 
-static int vfe_get_output(struct vfe_line *line)
-{
-	struct vfe_device *vfe = to_vfe(line);
-	struct vfe_output *output;
-	unsigned long flags;
-	int wm_idx;
-
-	spin_lock_irqsave(&vfe->output_lock, flags);
-
-	output = &line->output;
-	if (output->state > VFE_OUTPUT_RESERVED) {
-		dev_err(vfe->camss->dev, "Output is running\n");
-		goto error;
-	}
-
-	output->wm_num = 1;
-
-	wm_idx = vfe_reserve_wm(vfe, line->id);
-	if (wm_idx < 0) {
-		dev_err(vfe->camss->dev, "Can not reserve wm\n");
-		goto error_get_wm;
-	}
-	output->wm_idx[0] = wm_idx;
-
-	output->drop_update_idx = 0;
-
-	spin_unlock_irqrestore(&vfe->output_lock, flags);
-
-	return 0;
-
-error_get_wm:
-	vfe_release_wm(vfe, output->wm_idx[0]);
-	output->state = VFE_OUTPUT_OFF;
-error:
-	spin_unlock_irqrestore(&vfe->output_lock, flags);
-
-	return -EINVAL;
-}
-
 /*
  * vfe_enable - Enable streaming on VFE line
  * @line: VFE line
@@ -441,7 +402,7 @@ static int vfe_enable(struct vfe_line *line)
 
 	mutex_unlock(&vfe->stream_lock);
 
-	ret = vfe_get_output(line);
+	ret = vfe_get_output_v2(line);
 	if (ret < 0)
 		goto error_get_output;
 
-- 
2.53.0




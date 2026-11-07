Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064099;
	b=0iZ1FCAXCK4UhARg0C++xri0wgrpdHGaONF21qRtqzM2SQnKZo4qs1QAiI97eINzmjV2
	 jF/49fzNzPOvSJY7VkGuADzHSPsWuBGg3yDs47BBv/WuDrXUaSFXmb1e3R9WLVsED9cON
	 qN4GZt7RqkgMon/Dr92QcmsLHPF8E3SWdncWR5uRImfXFwjr8WDboqKOsdueLaERQA2/L
	 2FMVUUYDxxJ1PgbYxukIhIj7kmZpjkAm5HYvgcY5NP+j1KDWLfAafU4hTUVV7AM1lHaTI
	 vmchDluuB5+rGo0n3ljpZB92wpC8cXY98DfqoOUEJUKT2OC098eNL5Pbh40g3Cu1rAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hIHKlyKT0aPpvY6x9lME1a14rLp1NHtxn9IY5cj84I0=;
	b=qLmVKh8m7in1B3LALQoZD0CakzAzxSccTeh5XvdOBluJTXi0t5q8kl3vUbCJtZrKtRpM
	 NLrm8tnBWrz6N5nGTeevozP1VMLjTgxeSV4SuMQ/JtZP2HavPalq2ev83V2PFEa0s5sbH
	 EHuo+I6YwkVm7KjELVR9Fifqiowe80ANvZVMOfOp0sec3nokSfBpxOsyhiP6YCSwVGR1o
	 MwRzYL+HQI+g3obXd1EQz5jCGd1VI5hopldUT/O/HRR9zOuUsnXNPzUWUkgkBtwk6GwI9
	 0ov+PUrCKml5BVmZcrGJNiXB3cHKRlrE6rsyzOR+7ClDhhfG8vgBGHk1LCUcsYqdF8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvzZ1SGC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E6F606CE56;
	Sat,  7 Nov 2026 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvzZ1SGC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38F31F0089F;
	Sat,  7 Nov 2026 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064099;
	bh=hIHKlyKT0aPpvY6x9lME1a14rLp1NHtxn9IY5cj84I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvzZ1SGCeNYvL7Zq50w9Vg/3wRyr4H5JzS2YYMjl9qd89a3hOPCNHNiPMRYHF4GPv
	 JXdXFnl0CEGdLXi1wPrBgPJKFMhXW7FauaGYgGy0cXLb/woGD3A+jkVzai2PWL0tcz
	 zK82/f2DrfCrygka8v34bRBLwjgjYVewA6GjTpwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0260/1257] media: adv748x: Fix endpoint reference leaks on probe failure
Date: Sat,  7 Nov 2026 08:42:36 -0500
Message-ID: <20261107134946.683816939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 359db09cf055497075a668b192f4578a0ed00955 ]

adv748x_parse_dt() takes an extra reference for every endpoint saved in
state->endpoints. If parsing later fails, adv748x_probe() skips
adv748x_dt_cleanup(), so the saved references remain held. A CSI-2 lane
parsing error also returns from for_each_endpoint_of_node() without
dropping the iterator's reference.

Save the endpoint reference only after lane parsing succeeds. Drop the
iterator reference before returning a lane parsing error and route all
parse failures through the endpoint cleanup path to release any saved
references. This retains the endpoints only for a successful probe.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 6a18865da8e3 ("media: i2c: adv748x: store number of CSI-2 lanes described in device tree")
Fixes: eccf442ce156 ("media: i2c: adv748x: Support probing a single output")
Cc: stable@vger.kernel.org
Suggested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 3eb6d5e8f0826..70594d0018048 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -675,9 +675,6 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 			continue;
 		}
 
-		of_node_get(ep_np);
-		state->endpoints[ep.port] = ep_np;
-
 		/*
 		 * At least one input endpoint and one output endpoint shall
 		 * be defined.
@@ -689,8 +686,13 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 
 		/* Store number of CSI-2 lanes used for TXA and TXB. */
 		ret = adv748x_parse_csi2_lanes(state, ep.port, ep_np);
-		if (ret)
+		if (ret) {
+			of_node_put(ep_np);
 			return ret;
+		}
+
+		of_node_get(ep_np);
+		state->endpoints[ep.port] = ep_np;
 	}
 
 	return in_found && out_found ? 0 : -ENODEV;
@@ -739,7 +741,7 @@ static int adv748x_probe(struct i2c_client *client)
 	ret = adv748x_parse_dt(state);
 	if (ret) {
 		adv_err(state, "Failed to parse device tree");
-		goto err_free_mutex;
+		goto err_cleanup_dt;
 	}
 
 	/* Configure IO Regmap region */
@@ -809,7 +811,6 @@ static int adv748x_probe(struct i2c_client *client)
 	adv748x_unregister_clients(state);
 err_cleanup_dt:
 	adv748x_dt_cleanup(state);
-err_free_mutex:
 	mutex_destroy(&state->mutex);
 
 	return ret;
-- 
2.53.0




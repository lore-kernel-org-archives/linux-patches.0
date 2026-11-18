Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059019;
	b=lVmV7UNfKYIbuukCp3QbTiK0Y5GWwQZIK9659UFGsGzF4Q8kih59bGzc8hLf0k2/MVz+
	 FpPPrz1lrQL7NDcnrxZbBjwQR4kDhtOErlXQujmrCHDH9Q9IGuJUksWmZQ/MI7ZxPttqj
	 SxApW4oO7flAGXmQwoM2ObtnhtN2yf7pruQPlyBOrtLfnLV5GydOqDoi/I/rqPe+oYy9n
	 CG3oB3Q5FHx7HER9BhvItTGOx3wSDrtqW+//USP5LDd9D5RN1aIP4TrP5KdXLZ8IwFzXo
	 sVYkBIFL7DnNzcGKDf58uZM2CWGBlqVMa/Jh/Uc/6KsY00gCR64nvKttJdGb39BmsZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KqTJ3rlkF/fNuTj6tGDCQ27JhhaZeiNM5BmuZHshdaE=;
	b=oGb58w7ISR10e4sigcq99ilsj6FRH8VvmZWibO1/ykmrnFv4E8pELXWfCfXLRB+V5a/o
	 +QYZDs0FkLCV/hRaufYUM4ZFx2yb9xnToEUHYCdJjgaB6b/txg6n70ZPCV3aRzM6IwSe3
	 X6pVu+Lpt14Lhxfvb1DR0NUpsjZLCz3aj3ja3cAzuFZ02j3yE2V4iTjVeZsy+3SUdmCp+
	 MssMYlJ280VOJ6eqgmCJYg6BEW7qtdfANEmQ/K1rKVDX7qToG7nbNHz3sB6Po+s5YRqcu
	 w/mk3UCB6WAlg2vtnR7dEk+Am6+WgIGc5pSYBA/Z+H6nvqK1pZfJNOvOP3TgQUvPZPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JqVNILip;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8A7606A325;
	Thu, 19 Nov 2026 03:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JqVNILip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805E71F000C4;
	Thu, 19 Nov 2026 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059019;
	bh=KqTJ3rlkF/fNuTj6tGDCQ27JhhaZeiNM5BmuZHshdaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqVNILipR9U/L5GC0vp5orkPe8rzLW3GCEH0LTySyrtKn+N/7nfMCsKugA/DKk7oD
	 Hed4BbQxY9vkP7V8Q1Y5AJBJX2OK8+l5zgxYG6D0OcIU6szydQ9QKu3kdbkkrA0PWE
	 ZUGyCa6PLr1r+8/jMu3yjeNQiNFYOfFhqrQbVn4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0665/1848] media: adv748x: Fix endpoint reference leaks on probe failure
Date: Wed, 18 Nov 2026 15:45:03 +0100
Message-ID: <20261118145943.681999059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1fe7f97c6d52c..3a4498eee34ff 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -656,9 +656,6 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 			continue;
 		}
 
-		of_node_get(ep_np);
-		state->endpoints[ep.port] = ep_np;
-
 		/*
 		 * At least one input endpoint and one output endpoint shall
 		 * be defined.
@@ -670,8 +667,13 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 
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
@@ -720,7 +722,7 @@ static int adv748x_probe(struct i2c_client *client)
 	ret = adv748x_parse_dt(state);
 	if (ret) {
 		adv_err(state, "Failed to parse device tree");
-		goto err_free_mutex;
+		goto err_cleanup_dt;
 	}
 
 	/* Configure IO Regmap region */
@@ -790,7 +792,6 @@ static int adv748x_probe(struct i2c_client *client)
 	adv748x_unregister_clients(state);
 err_cleanup_dt:
 	adv748x_dt_cleanup(state);
-err_free_mutex:
 	mutex_destroy(&state->mutex);
 
 	return ret;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053162;
	b=i6Xcljpg+qa0WXAlr0aDY3YrixlbyhX908gYC6CAzCGPjayjDpJZLXtXDIOKwPW6Xuc0
	 FwgtG1K0EbPyJ9/IFWMQTTb7btXdlR8YzGFp3av0dZ2phuOipZfJh/0OtFmP5PAyC9/UG
	 w0oNcC6qXHBmd95+h1rcskfBMAXAIfaAZxOqToYO2DfTMWuex9v3SyGFSo1o2Uf/f+wfe
	 3AZxaWXHb8nyG4N65psC9tcJd/JuZk1yCXOANbXXIA1dni6/pqKhfAMZYLXgdrDYdxBE5
	 pcj3B9qtMzKNGUTlt96y+u7ngzxbSm3/2b5yscAgDANvtHZXn6o/m2x/zoch7UfCxZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OOfFmWkfhwocb6XQZ0MA1d9hxzCdE59n6QazU4jHaoU=;
	b=fGNVE2iOWv4DUamIXFWQFnOCahcd3FppkmXPZlqmBAQYWCuJLs/m+Arh6jKqLqV2YjJE
	 d5y9C3j7CErnTnuLVb2ap/DwNjHUPvDjCvK3pInSFY2igZjXmlVbZegBtxteQOAwL//hR
	 6rIZDHD6ytxl26b+qECcJ5QTCHjU284T5RaylQ8N/i4XbgLI16rOeZIjCS5YzJQSQA3as
	 6nv4rqVJr7TZgDaZ1gTUNPjrh3pj64Dpaak+Spx1vF7FtHyDgutPBBees7FTT4sbn6gaR
	 lpm33gxGcsVwKKYEKn0/yw72VH6ctHbqRxjzwiy+uo9nP6xgE8ZK1BFustVcQi58g/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fz70EF6v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694E8606A31C;
	Thu, 19 Nov 2026 01:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fz70EF6v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5541F000C5;
	Thu, 19 Nov 2026 01:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053162;
	bh=OOfFmWkfhwocb6XQZ0MA1d9hxzCdE59n6QazU4jHaoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fz70EF6vMOWt3ZbuqQ2vlrzk4+NoGUYxMy54l72MW3h+oabGnqIAMjCarESm3wdZz
	 4Ej4V0RbOW3Z0EZl5PnsLHbARurE8Wj+V7r+nTZtdRBmXrn2W2ZwfHM+mggUKjINY8
	 /VzabLXKmYkoXMW9ADzfRc5bSPee0MNAESx5q2PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0820/2214] media: adv748x: Fix endpoint reference leaks on probe failure
Date: Wed, 18 Nov 2026 15:41:36 +0100
Message-ID: <20261118150044.407309191@linuxfoundation.org>
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
index 4e54148147b9a..fa60743528ecd 100644
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




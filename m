Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993C830ACEB;
	Mon, 13 Oct 2025 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367704; cv=none; b=oGCwBbRI+ORbB6fEcddAmck82O3wutHH54AtR+wBfPw3T4O5m8KGgA8rm6xK7XVTJm9QvWTwWB1mNSyBHoe/VjEiHkLjW0pmo2XudyTAqmMVvKbePB4sMptwFoFHtbuX7KWIGAmoKFPPClPVPoTxQxsPKCL8ZNXheWJ7BaNRHTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367704; c=relaxed/simple;
	bh=b1DmzkKcyY/hDRIUqkz+PP/5bjNpCZ1oN/7cB0VuSvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/yhq4s+p3XZCwKRLgk6pXwvF+riLyCfm0ugWlwX2ekUbw3+BMMeY8Mf3jW4xtRt1GH9hGF00+83Kp6MfZ69aIrWRrs1XKcdZ+brDPq1J5ZWjOChN0ekFxu0nL1wyc6xHgIdRTFkZM9CC3UfJRsoBFGfjgvt2T2DyrB2p8S4jp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaw6k8Lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaw6k8Lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24579C4CEE7;
	Mon, 13 Oct 2025 15:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367704;
	bh=b1DmzkKcyY/hDRIUqkz+PP/5bjNpCZ1oN/7cB0VuSvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaw6k8Lqsgx4fAbiz6QFYlqNaNf8rlFpjtfYkF6TPsTvKYJNouXBpvuaIHUeqsTOt
	 tangQAxYsAux2k8ERYih8/LK9jeCzWm2sNyAncXGbxt/G+OGtYXf46TZUYIltdcTGp
	 r2vdS7c3CqW489oUXbytiHd2wNKRcJpMRczeI378=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/196] serial: max310x: Add error checking in probe()
Date: Mon, 13 Oct 2025 16:44:21 +0200
Message-ID: <20251013144317.725498396@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 672a37ba8af1f2ebcedeb94aea2cdd047f805f30 ]

Check if devm_i2c_new_dummy_device() fails.

Fixes: 2e1f2d9a9bdb ("serial: max310x: implement I2C support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aJTMPZiKqeXSE-KM@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index e339abff926d3..e10dcdeeda2d3 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1659,6 +1659,8 @@ static int max310x_i2c_probe(struct i2c_client *client)
 		port_client = devm_i2c_new_dummy_device(&client->dev,
 							client->adapter,
 							port_addr);
+		if (IS_ERR(port_client))
+			return PTR_ERR(port_client);
 
 		regmaps[i] = devm_regmap_init_i2c(port_client, &regcfg_i2c);
 	}
-- 
2.51.0




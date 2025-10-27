Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7495218EB1;
	Mon, 27 Oct 2025 18:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590409; cv=none; b=j92NLSZkAOTKEUpdW+EonhedZteEur4IwR5Bf9X6+0xp0jbJBEk5TdBqKAluu0NfbwbFgGNwVywoVF+Gc7E3xMcRo9XUe8Q8b6gGYzIMD31lQd/xumIwwVaSpO+QOuH0ASfB+f92v+VcicfsHdHyL3GF+TpdGafI6byonx6cqpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590409; c=relaxed/simple;
	bh=rgXa+i+8Q9t/Lky4eBRoKbL3u57tcLtCRslXusZu+SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZ81LzJxkWSwAUzbuDZjstgBynIzH38tkMkVp3GwXkfbqV9G84rusUKQfEJgZMoeAZ+skrSpzwTRbXOabJvGcAGBT5aBpIeLyxVCBHaYATAFwMF5YLx7iiPhg9/o5GlTQV8BEdM08PV1Jwv1zDNVwDHsaYXz29/bNMXObtriTMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGCgOtys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGCgOtys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3931CC4CEF1;
	Mon, 27 Oct 2025 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590409;
	bh=rgXa+i+8Q9t/Lky4eBRoKbL3u57tcLtCRslXusZu+SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGCgOtys5rWDBCdZOpit2Mn22SKiMlst0UfI0mPowABAmd9siKzbRLkqOJb2nSFrP
	 LNpvjHYcfhM+V+DT4iTdP3SYhSnPKpMmzdYlTVEI3eAxgBqC1+PS6z3HQgnXjKR6VK
	 OldSEXbalqjVr/5R8Yvc3hUjc+lMppPrlf0l9QOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/224] serial: max310x: Add error checking in probe()
Date: Mon, 27 Oct 2025 19:32:59 +0100
Message-ID: <20251027183509.892836543@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 363b68555fe62..4ef2762347f62 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1660,6 +1660,8 @@ static int max310x_i2c_probe(struct i2c_client *client)
 		port_client = devm_i2c_new_dummy_device(&client->dev,
 							client->adapter,
 							port_addr);
+		if (IS_ERR(port_client))
+			return PTR_ERR(port_client);
 
 		regmaps[i] = devm_regmap_init_i2c(port_client, &regcfg_i2c);
 	}
-- 
2.51.0




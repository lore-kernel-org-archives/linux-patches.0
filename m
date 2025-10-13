Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4183026E702;
	Mon, 13 Oct 2025 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367198; cv=none; b=eF25IIZIpsSiS+WbvsqG2anTs2/vdqUf7ixXQ/nHkb+BiWuS6XzyffbHgmvrYxugglT+dSo/P6tBw7gm7zB6/IFX5dnYcrpcX78TSsAUxne/XwbJWrnbLDTaWozqSYCOrvSg0qzXOssYdXKK3jVEC+fFMfY0Yu7miJE9aLIuVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367198; c=relaxed/simple;
	bh=+PAqnhX5QkMOknBv+wno2n6Pyg4g4VE8p73B5D6jcso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmOwcuM6fNccaHq+nrqi3bBgKIaQF4s82Ghp4tqCspAXzk2NnScldv4TRpl2CHadU4vGYh3rPot5/ia8i81SVL54z5h8qu0n6zgyGlDdau4YaiLLi3vqFznXqAGQSXbHwEqk+LUhTn9xWb5WfhvCz9OUP/PbxxtxIbPZ7LQRO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSyjpcrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSyjpcrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CEFC4CEE7;
	Mon, 13 Oct 2025 14:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367198;
	bh=+PAqnhX5QkMOknBv+wno2n6Pyg4g4VE8p73B5D6jcso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSyjpcrLnWgD56JZHJNCO25TyCTkX6h+sBzmwQ32oS3jkop96ujyA2aySvhzyXuQf
	 6X4j3FT3fuW8jHCDpVCR7xN8aVRwhZ0DOpPajs9e6w1xCx+95ZxZnUPAHFnPZjctJO
	 CIp+aGEauOEIRfZBBZ1kPjhoACnuxUCQ+1n6XyR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/196] serial: max310x: Add error checking in probe()
Date: Mon, 13 Oct 2025 16:44:26 +0200
Message-ID: <20251013144318.065591143@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4eb8d372f619f..44b78e979cdc4 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1656,6 +1656,8 @@ static int max310x_i2c_probe(struct i2c_client *client)
 		port_client = devm_i2c_new_dummy_device(&client->dev,
 							client->adapter,
 							port_addr);
+		if (IS_ERR(port_client))
+			return PTR_ERR(port_client);
 
 		regmaps[i] = devm_regmap_init_i2c(port_client, &regcfg_i2c);
 	}
-- 
2.51.0




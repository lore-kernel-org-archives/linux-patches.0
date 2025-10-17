Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C88B3370EE;
	Fri, 17 Oct 2025 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760712991; cv=none; b=IEQpcKwboEi+ptOtHb0LG3YrpW+pKtXJ6Gd9YpBuxN32rIwDOgsal1G/WnXQykYV5PxsqUFXSoN7GMLQaQ5v7guM/lJzM72l1DQQjQzBpskclagRqlOD3heKJNUsyARwhPras8Enz6kVzUcGV2/2UkX4pggCDRw4xqvxgeVix5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760712991; c=relaxed/simple;
	bh=8GHkwGehUtouf9lr/gRi6dbaF60iuRIXUitRfueV2Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGpNIZK1tvQytfomRrdIqNAgfrXdLJlrWjsnYA9cRkuosuuvo0b1glpVZ5U1Hh0eNzUNNZhYkInRhXsuRdOfhGxTuQ4hEQT3pPd3TmSq3QatncJN0VmPjXpsb/XUNnui6SAcGdxcRLU5YHG00Fu5ucrv4jWAfU4ebpeORKS8FUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7DviAir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7DviAir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C375C4CEE7;
	Fri, 17 Oct 2025 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760712990;
	bh=8GHkwGehUtouf9lr/gRi6dbaF60iuRIXUitRfueV2Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7DviAirxMxQ/QrLagDiorKqYUM+tDxJobVe62mYh3onGF575Za/6UWCbr1AV0OoJ
	 tiLBydRflE0yRE9LUBtLjlAt85spx3q8bXxgHZbpG/8fy8PHi91MxzLcexOSWIzbuh
	 62B5QmhXZGCKN6SfXjD5Gd+64A72YsLW4UqdQnWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/168] rtc: x1205: Fix Xicor X1205 vendor prefix
Date: Fri, 17 Oct 2025 16:51:29 +0200
Message-ID: <20251017145129.393436810@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 606d19ee37de3a72f1b6e95a4ea544f6f20dbb46 ]

The vendor for the X1205 RTC is not Xircom, but Xicor which was acquired
by Intersil. Since the I2C subsystem drops the vendor prefix for driver
matching, the vendor prefix hasn't mattered.

Fixes: 6875404fdb44 ("rtc: x1205: Add DT probing support")
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250821215703.869628-2-robh@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-x1205.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index f587afa843573..6ae7b6f1f3167 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -669,7 +669,7 @@ static const struct i2c_device_id x1205_id[] = {
 MODULE_DEVICE_TABLE(i2c, x1205_id);
 
 static const struct of_device_id x1205_dt_ids[] = {
-	{ .compatible = "xircom,x1205", },
+	{ .compatible = "xicor,x1205", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, x1205_dt_ids);
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D768E15C127;
	Mon, 12 Aug 2024 16:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480400; cv=none; b=bOxjchSN68LclY/fFJiQr6enUuXGynWL5Xb0uH3cGBxvPT/9FAdPt+Twt5lSIUWSV1w1QeGLg1vm+kmTaP4p9RNb/D8rKelBQFL0CGyeursVLrK2EkQDJGhwUJFNsFx4N9dmLtDXR3NX+FXXEqzAnVp3xG0zSiUgehR+Qc3n2mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480400; c=relaxed/simple;
	bh=HxGeVvGiYPfgzIPeX2MMMmz/uS9up5I3dCP0XU6EZhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=falC9FCrJaehT01wQcv/G/QPbTLI9WxUKth5NYMOw79SAz2daE6cxGr2B9rMwzGFfqNLhsmqjjaBVyFjhBsSrCpyrVTc9EDFmApHLtc2ZVo0y7qFz9e6bsm4I7SBYUvMIcUEbehpRzKGHNLCe8vfaY7yRjsGui0CbaDeE251r8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18Hxi7Jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18Hxi7Jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6C6C4AF0F;
	Mon, 12 Aug 2024 16:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480400;
	bh=HxGeVvGiYPfgzIPeX2MMMmz/uS9up5I3dCP0XU6EZhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18Hxi7Jjr4lYBRczka/PNRK2dP8KK/oGGVnyrM8T2dF8BP37AWuU+F6UvPY0ryrjT
	 7rwy0FdWe0fkd68x1kiBRSqlB/qB3f8fpmaf/5kBAvH9qNas8GLmt1Z/I1tu6I6Kw3
	 n0LPdaM3escKDOx8bueTpWhiaNcP9ulQG+KyWMbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 153/263] i2c: qcom-geni: Add missing clk_disable_unprepare in geni_i2c_runtime_resume
Date: Mon, 12 Aug 2024 18:02:34 +0200
Message-ID: <20240812160152.403482895@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit b93d16bee557302d4e588375ececd833cc048acc ]

Add the missing clk_disable_unprepare() before return in
geni_i2c_runtime_resume().

Fixes: 14d02fbadb5d ("i2c: qcom-geni: add desc struct to prepare support for I2C Master Hub variant")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 0a8b95ce35f79..78f43648e9f3a 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -990,8 +990,10 @@ static int __maybe_unused geni_i2c_runtime_resume(struct device *dev)
 		return ret;
 
 	ret = geni_se_resources_on(&gi2c->se);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(gi2c->core_clk);
 		return ret;
+	}
 
 	enable_irq(gi2c->irq);
 	gi2c->suspended = 0;
-- 
2.43.0




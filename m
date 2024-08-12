Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440BB183CA6;
	Mon, 12 Aug 2024 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478938; cv=none; b=UkyJd9CgLcopFhHI0Z3/3kBvrCw7l2tBh/+0AwrFPZX4bB1nRf/y6Giz2TBLUM4yI3y3xogxx30vO2UD69Ub1uzXB2xvjIaJxw6//tO81AEQ8hl3IR9/YTKAz7/QJq9LblZDQwu1NWZ9v6RSPane4AIuvF9bAP3iu0v2Xzbu8G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478938; c=relaxed/simple;
	bh=zq+WJUFsDUAECxZa5ntf+I5mW50QHzqF0AHRftuhIiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIB7v6KyBw6Nb6WVTVc22sGmRrafYQ/tceN1HSYFm+IwnBDQ6boyZxucrXrni/WDHMiL1rpAmaxWcskIfI8dEzH8L+jZWFbM1JglJcZ89Z/x4BtriKNZ2vUaoP1U2DUxATe4nCgMsuXdSbrqK/AnHbVfAfgloWQ/dwEyBX1US4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=py+JoUdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="py+JoUdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE35C32782;
	Mon, 12 Aug 2024 16:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478938;
	bh=zq+WJUFsDUAECxZa5ntf+I5mW50QHzqF0AHRftuhIiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=py+JoUdrKk+yIqBOznEPqKpUWBbupUb+46w+9nbSgd+WWbfMdGi1Bkj7A2Je/rBlS
	 hvqNhHnnkb27q8XRQeAVUDJr1o1l66tnZRo3blu8XThwqqT5XMVbSUL7QiACqobLFv
	 JUIlvS0p3mQxvMvhx3k45JE6kP+nltpir8J4DacQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/150] i2c: qcom-geni: Add missing clk_disable_unprepare in geni_i2c_runtime_resume
Date: Mon, 12 Aug 2024 18:02:43 +0200
Message-ID: <20240812160128.338041191@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit b93d16bee557302d4e588375ececd833cc048acc ]

Add the missing clk_disable_unprepare() before return in
geni_i2c_runtime_resume().

Fixes: 14d02fbadb5d ("i2c: qcom-geni: add desc struct to prepare support for I2C Master Hub variant")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 9ba48db9f77c ("i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 67bf0a27d37ed..02eab8d5082ba 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -988,8 +988,10 @@ static int __maybe_unused geni_i2c_runtime_resume(struct device *dev)
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




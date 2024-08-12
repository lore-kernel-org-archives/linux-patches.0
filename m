Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0E4183CA6;
	Mon, 12 Aug 2024 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479585; cv=none; b=flqrgz2amsRHziyZOoqUNCg9vhrZR1jEYvjYmJt5QDmk2vrLnM4x/Cd9mOpzdQOw3ktO1uXpEETNSc7wOKN6s5e5sN5UUUMJjvtZGI3Qnj1tE57MBwuDaOm/Y/AcZRlenJARx4X3LdpC9uOM+k8g1VTXd8uj6B2q3za2T+kukZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479585; c=relaxed/simple;
	bh=ErY0mxZQ0NEeiPnB3oAV04Btyw/8JgYlE0ecFC2IeA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO1c0PJERgTJu3nm0eAppIiTm36xlw2qFZl42ZMubQnOOPb8pD2PMhf+q4TDRHWoA3EMSg+LoerHJOlzIei0U36pTyj8cbu3ccOM7ADordF84fQQMVLLlmSeNU+Oew/r4PvL6ioQ7V9D9VKkLGXqHfCDco6JHJZfgTUg+uNj16M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+ub1anb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+ub1anb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2717C32782;
	Mon, 12 Aug 2024 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479585;
	bh=ErY0mxZQ0NEeiPnB3oAV04Btyw/8JgYlE0ecFC2IeA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+ub1anbA7gfeWysG+xbeoL6O4m6gKbV6LgXMlVGYT/iedw2rfFCkJGD0sYowpHg4
	 PqQAXxyqZMfY2SbAcDAI8GZSNGxTie16T9+IYeZR7IvwChzL4eUWDvdRmC/hNpgwnd
	 DNCGwvE1iAubEb3IN1YFvK72HhXKLGMkFYYfRraA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/189] i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume
Date: Mon, 12 Aug 2024 18:02:37 +0200
Message-ID: <20240812160136.030329671@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 9ba48db9f77ce0001dbb882476fa46e092feb695 ]

Add the missing geni_icc_disable() before return in
geni_i2c_runtime_resume().

Fixes: bf225ed357c6 ("i2c: i2c-qcom-geni: Add interconnect support")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 5ed61cecd8d0e..b17411e97be68 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -993,6 +993,7 @@ static int __maybe_unused geni_i2c_runtime_resume(struct device *dev)
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {
 		clk_disable_unprepare(gi2c->core_clk);
+		geni_icc_disable(&gi2c->se);
 		return ret;
 	}
 
-- 
2.43.0




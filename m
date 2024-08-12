Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2729C187347;
	Mon, 12 Aug 2024 16:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480414; cv=none; b=sezhJYu6J8MmsD6yBtp85PK3Pz2CsULWTavfDCcSNSSZSPa04YTER3Ojhthi5GdfkUEkyn9YY4+SGQNn19bnkf6ZPrfvRzUZG3FzvtElPfPCWhr5GVx44jRsnM/L4qTwyiBgAnWeQ5G+eXHXePZKJu8SPMtdoJFwsgHy2fKFnoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480414; c=relaxed/simple;
	bh=3LgyD0gkT55QUh2aHBFmL/fz905xIshsbgFXmwdF5mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8+qHgvB8+AD4p/QdJrEq9WoQ7i/DZvo0swUhnUOz5Eplzj+omJgomPJ+cKkDbwW9yROH5JJGQZc59NwWu/8gZ5yJwZ8MnP2Ewbbx5J4MEtXLb4YD4bRGiuyQ3WLdqWGnhlAP2Fe9j8/Zcbqtth7VmeBomhEsfVKd9mhBmqXcp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNrjex1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNrjex1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DA1C32782;
	Mon, 12 Aug 2024 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480414;
	bh=3LgyD0gkT55QUh2aHBFmL/fz905xIshsbgFXmwdF5mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNrjex1ozg4+mTJy1yNTEVoUx311P6Wl/HV1jYxeIwVuUTmNmmCdzPjy4b61iZelT
	 4x+3mjF77lwmV0n/zW2bQrb+neh0DHpYDw5XdUHO6c91VolPfDuDmNAhnhrbxBk+F+
	 egRtAPmo58oNmE5AF6vWUuKtNpOPDfPE20SGpfQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 157/263] i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume
Date: Mon, 12 Aug 2024 18:02:38 +0200
Message-ID: <20240812160152.557792378@linuxfoundation.org>
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
index 78f43648e9f3a..365e37bba0f33 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -992,6 +992,7 @@ static int __maybe_unused geni_i2c_runtime_resume(struct device *dev)
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {
 		clk_disable_unprepare(gi2c->core_clk);
+		geni_icc_disable(&gi2c->se);
 		return ret;
 	}
 
-- 
2.43.0




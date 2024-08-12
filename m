Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE557183CA6;
	Mon, 12 Aug 2024 16:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478942; cv=none; b=q8x/adoMXMfTT5DXnAbpaAhePCuBiiguz4zwYE8YUutrtMocV5QSBrf/Nikq6SkIldDXUB5j9KsPXdbfDVHIxd7kndtUJmo+4lbPzqTxetM9uwRKT4PX0XERBCZ6UFx1BdpX+TycL8v9j4MABy9ucOFZJGf9zb+kj63wn6n/bOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478942; c=relaxed/simple;
	bh=CYRQ7e4isLG5N/VMTY0RXIWnQYfsmforza1WVjKktRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUqAzi7RWXyYbPAgrxuCi/GkFbqVpD8pWdZbTZ7E5SMjbmkJnvCQAsaohmFFIzom/LZaH3evWocIVpaFu/vT2xOzjRA/AOQciIttueTSDmiSI4WLp9H1I0lzaswEltAzjZDwvRB0oM5Yuxj07glSxc2btMQXEhUUDVsyjtYmEY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHGYcjGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHGYcjGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BD0C32782;
	Mon, 12 Aug 2024 16:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478941;
	bh=CYRQ7e4isLG5N/VMTY0RXIWnQYfsmforza1WVjKktRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHGYcjGqGda/O2sqi5fLhGn4gY2ydqN7eDu6Nzsn+tpMl5OzHXdvh+y6guARsTMFW
	 ZPyi2EICxsZua+87aHjV6BSM7472INVC4DWuk0t0MOCLFOxJkdIZQALTwLxEduc71p
	 l5FKPgweEdpsgC0R3AC1CkoVvu04JOxnyfW4db7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/150] i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume
Date: Mon, 12 Aug 2024 18:02:44 +0200
Message-ID: <20240812160128.374227310@linuxfoundation.org>
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
index 02eab8d5082ba..6dcc0951c3d6d 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -990,6 +990,7 @@ static int __maybe_unused geni_i2c_runtime_resume(struct device *dev)
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {
 		clk_disable_unprepare(gi2c->core_clk);
+		geni_icc_disable(&gi2c->se);
 		return ret;
 	}
 
-- 
2.43.0




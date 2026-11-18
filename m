Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018594;
	b=TiPkiwgfnJGIqnQ1OsQIYVUpJafRGgrA+ZkHxHHnCpq0/5L79OwzvHbYfe0B9bcGY5rV
	 cHeP4SjcLezATkf6Y496X0zh7hhpF5zLGAdSp60SrspGcZCGd9Bkl1o7hokv26NpFxXRy
	 6WE0JY6XcDfOfqa0mcu87lDEkLXsN0Y9CD2v1aCtZvSfamm/gGaKUMGRfyIZSOmTGj53c
	 /66Yv5eJfMe5QoV6Zybojm8vyKPn0ksr3bsptKBI98Zbzm9O754Lf6WjYOGzXZ/LxbLQh
	 8F2Fknwri5GPiNMTePUkP9UkwHZrryckhXU9PUrT8kP/XfubqgnmjWJF2MWjcO3Jfeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hU3UjugzX1BkFuW7fAKuWtOSiJB7LiVlIxfIhBAZSLU=;
	b=ctlEHHQW0cLylKRYvgY7mX28OADIyljVEpJHYC/Ry1NwwhmJ6E+5aJ+TgS+NuJMCosBS
	 X7yvzW5X9gwVwZow3dqPrkVd5SB2ToNAQ5unCMnJlfBNygIowvYOvKsqhm91fCLFOWE2o
	 c9S/ssxz/AzDd5JXW+WR4PN6I0kwnxMawHW4xABmjIRYDpZ366AKkw+XLwNea8jGXQ5FY
	 MGLu6790Z1X1EXf61Zg/y7rHx7h6FtcggbYNTlQ9oX5FbA203WR2Kqn3XOD8qRaA+hOYE
	 gFt+9J5t4i/3X+Hmob0noYgiuetp38YDVo6gIhT/m3B81Jg9PwW5qINXhyL16ph9NpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GThRgegt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CFE606A31C;
	Wed, 18 Nov 2026 16:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GThRgegt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE11F000C4;
	Wed, 18 Nov 2026 16:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018594;
	bh=hU3UjugzX1BkFuW7fAKuWtOSiJB7LiVlIxfIhBAZSLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GThRgegtUgz3EZm/t2adLnnwu9mEEBcCJvK0h0lZYTJerTx6cdWwYUhormkoZX2By
	 LPjJhZw/xW/xG3cm4Z+ruQyfed0xnBkym8k73qEge/er8B43RfcbUP7qobGV6rj2N7
	 u9Mbgxluryc9fgma6NR1T+mclsb1WeG1uGQ2ITUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1295/2651] perf/marvell: cn10k_tad: Publish the OF module alias
Date: Wed, 18 Nov 2026 15:42:15 +0100
Message-ID: <20261118150334.578544139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 848468c86f716e4552bd478d2f3c3f5d81bec7ac ]

The TAD PMU platform driver has ACPI and OF match tables, but only
the ACPI table is published. A Device Tree platform device emits an
OF modalias, so the ACPI alias does not select this module for it.

Publish the OF table inside CONFIG_OF and retain ACPI support.

Fixes: 036a7584bede ("drivers: perf: Add LLC-TAD perf counter support")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/marvell_cn10k_tad_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/perf/marvell_cn10k_tad_pmu.c b/drivers/perf/marvell_cn10k_tad_pmu.c
index 54909d0031b77..301be4d92b1bb 100644
--- a/drivers/perf/marvell_cn10k_tad_pmu.c
+++ b/drivers/perf/marvell_cn10k_tad_pmu.c
@@ -424,6 +424,7 @@ static const struct of_device_id tad_pmu_of_match[] = {
 	{ .compatible = "marvell,cn10k-tad-pmu", .data = &tad_pmu_data },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tad_pmu_of_match);
 #endif
 
 #ifdef CONFIG_ACPI
-- 
2.53.0




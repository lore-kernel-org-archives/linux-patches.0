Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030859;
	b=ZjHgt8KQ+nNwiFamD11hhGcYVofQjTveKHS3ur6MBNzZb6yTCgKW9UMrKCIAh7UNusvp
	 hKBhvgQ5eEofZP391PvhQgCxeegsEvM+9upB4zMyf1PjDIaRhPs/enHlOSpqYsMoCtQ/8
	 Chih8Syba5DjAMbQjQEPNJaOobzK2fEQiRE6ngXLf322V1SlLzWrxfomieTjKxIAgBmqQ
	 5/dUq4MKUL8de3XxJMSCco5tUt8bqYMQvJZfSAkjPLgP2SH+jbmBz5j0TZwKxXEZL6zeJ
	 y9jiKvaVVWGOIsK3CTvIocGT04MmtHc81BP4Rmqj3FVSo+NcNsvK3F714afnG9G7m5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uMfqDEJ+ib4a6/JKgk/e5pTtB97EKxRDpASIU3gWtak=;
	b=oXP0zTK6uAKpaWljOFOuKlRWcpOOvfi/zHNY7fyFZAj3WQ3I1LcH2hBnZo2zijEY69kH
	 2EJT4FXg7b1fVv0nHnLQqZuFPhso5ARVKsYxBRFghThTeRlVtFyecL04LXKNePtybyzRi
	 v32Mt1aeDmH63KEKAHKeOxLyMu+O3ObQzGjqRmeOBtkKp/K0D+RBamuTq2OjakyCCb7RA
	 ZvybzGcwXLKo2JyeECTzvxCqc7YzPp6XFnyhmyZeQfMcNTq5IFghGIGCoMISGbO7FHgKZ
	 r0DOSOqkZPUgjKl4GE9fo13pvDJFZalq5jtEkLWioyO6Yk6FQ+cSuYrNh7in593o9+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCXBFfpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1FF606D344;
	Wed, 18 Nov 2026 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCXBFfpQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9B21F000C5;
	Wed, 18 Nov 2026 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030858;
	bh=uMfqDEJ+ib4a6/JKgk/e5pTtB97EKxRDpASIU3gWtak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCXBFfpQFutqqOd8KnbIE7jwtv42LvRsKfGGSpThrApHA/bTsKjG7WUgm9lH37eJd
	 T52PqjoLuq7FtIp9fRrgskvV6xzOjjktHPIrldWfkPXNVufcJi7sYGAmpeW/Rgt5EY
	 ggRY3rFFnEd1nxZTgXhKAPJ6NDstaRJ/mM2Knhig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0853/1756] perf/marvell: cn10k_tad: Publish the OF module alias
Date: Wed, 18 Nov 2026 15:49:40 +0100
Message-ID: <20261118150043.332842667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9e635f3554709..3e2e5e2e48a69 100644
--- a/drivers/perf/marvell_cn10k_tad_pmu.c
+++ b/drivers/perf/marvell_cn10k_tad_pmu.c
@@ -365,6 +365,7 @@ static const struct of_device_id tad_pmu_of_match[] = {
 	{ .compatible = "marvell,cn10k-tad-pmu", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tad_pmu_of_match);
 #endif
 
 #ifdef CONFIG_ACPI
-- 
2.53.0




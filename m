Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049177;
	b=I56Ti1XtbmVFnq5bh+hz22FmBAumgSsIH4MS8GQod1pznWX6jcGExDQqLgbMT6xeQBlo
	 aXkGbgdHkQSZg5V6ZNIif58nmrHUlV0Yvb1g1Puibvn/HyD+AptvtB9rqkmPnwLWMC0R2
	 ZpCqFuI6QmoSpuJ7WVcNNT7tvjY6utboiobOIPJBjkvePj/LNNIr7kpJAR/0iOaE97ERh
	 KlJ3s5VCc71B9xR2podPfv5oMbFN+5XFLZJZp7Lh62bQLTQrj5YMliHi5S0ckxBoJrTiW
	 h9IVMfBl9IWKOqnHQ9QusVsmnXInkvusOvSBnUOdfG0LBeU1CPzfTTd/dYPrpih6RaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2SAFeempl3BeWxNVp/ownKnyZ7udnOlcZ5OVkxDnXjE=;
	b=IIrsTBRL/dECYEkA7y0OOf+aAVQMPXFnUjrfUXRrtWyuu1qEwjXdGPeLwACPOzz5pPK1
	 QLG7NdXTvdH0/p1D/cWy6otBtVvha7h+BhIfNLaeWndPkmbehTzucXy2vGIAnHe5k1CLf
	 pIziTqmgb/PXoqLrD6JJ41fAL69vQJ2NtUyLRe3AJwOe75NzJHrVNB8fc4jiNCFMnPHj5
	 A94gqufgxfZZWeMs/rSBbZ/bz5ip3FHmxroWRJI9utjRAGkat94CiQY03T6FM1N/Ou0vD
	 EX1n38ooJlht846aUkH7UHas6a1mwO4EQhfoEhXFRGo2ece9u2ulSZxZAgcDY0xHh/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f64i3wLG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991C7606A320;
	Thu, 19 Nov 2026 00:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f64i3wLG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41F31F000C4;
	Thu, 19 Nov 2026 00:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049177;
	bh=2SAFeempl3BeWxNVp/ownKnyZ7udnOlcZ5OVkxDnXjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f64i3wLGtMsvAp4ZqpJOmNAR4f3cuw2vqje9rhETcW3sJKIBWcLaVJz5PocDvQqW0
	 dFUKFcsvVwFikSkbteDlHfxTr9krEJftA+JzNTai8Q1xIGfVxrBsgoG/Axs7YIbGmQ
	 R8kD19hNhrTMRsoS/Mh8LqW6geFMq6D2AfQbu7kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2231/2857] perf/marvell: cn10k_tad: Publish the OF module alias
Date: Wed, 18 Nov 2026 15:54:25 +0100
Message-ID: <20261118150321.745751220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a1166afb37024..dd0371a5958e3 100644
--- a/drivers/perf/marvell_cn10k_tad_pmu.c
+++ b/drivers/perf/marvell_cn10k_tad_pmu.c
@@ -367,6 +367,7 @@ static const struct of_device_id tad_pmu_of_match[] = {
 	{ .compatible = "marvell,cn10k-tad-pmu", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tad_pmu_of_match);
 #endif
 
 static struct platform_driver tad_pmu_driver = {
-- 
2.53.0




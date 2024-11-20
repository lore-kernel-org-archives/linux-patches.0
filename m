Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B2E1AA1C0;
	Wed, 20 Nov 2024 12:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107545; cv=none; b=ANNjbTFzaASJ58Qgstsw24qcGR+fQFusjn3DTwEivaB95JL6lZ8+koU2MHUCXrBTEM/OqIeSubGOU7yAbVm4SfCiC57gN9u4VptzQPcfGY52kTcb4VnnzE4OZTUPSw6Rh7E8HK4SFrAoJPeX59nTP3ahHAE/vpwuFboLXRAQj1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107545; c=relaxed/simple;
	bh=N+dsbha00FOXP+/2TWGucJnI1adjQNoLDQ8GQyBGVpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=roapS4dpWuRr34Qfs3NLt5N5XuBUdUH6mzKAbcl4Et8VcYLqCJExuxcaSlV3X7OgpmwYimtemADAhd5/ZwCQm1NriXbAOhn2o1OrdspcyZO9+Sj5t52W6GblsDa5XnApchAKBN/3D9sz62QMMgW0kvKc2NywaChiAsM9YmirgOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFbh8jH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFbh8jH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA89C4CED6;
	Wed, 20 Nov 2024 12:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107545;
	bh=N+dsbha00FOXP+/2TWGucJnI1adjQNoLDQ8GQyBGVpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFbh8jH3x78kmRHbaD2Yc+gBMw1gbgMXPGmwjnyGoLo/dr8A2B6tvVKg3GGl43JMt
	 hC60xShgoSOOy/fZfz+arU1geN/i1wQun4B894xBOvJ0as+phoUDe38mqnu3NFmZvi
	 8Y7Onoy9o/lb7ajXZdcUH2Cq8J8F9ikA0mZUxvWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Motiejus=20Jak=C3=85`tys?= <motiejus@jakstys.lt>,
	SeongJae Park <sj@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Wladislav Wiebe <wladislav.kw@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 034/107] tools/mm: fix compile error
Date: Wed, 20 Nov 2024 13:56:09 +0100
Message-ID: <20241120125630.449198847@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Motiejus JakÅ`tys <motiejus@jakstys.lt>

[ Upstream commit a39326767c55c00c7c313333404cbcb502cce8fe ]

Add a missing semicolon.

Link: https://lkml.kernel.org/r/20241112171655.1662670-1-motiejus@jakstys.lt
Fixes: ece5897e5a10 ("tools/mm: -Werror fixes in page-types/slabinfo")
Signed-off-by: Motiejus JakÅ`tys <motiejus@jakstys.lt>
Closes: https://github.com/NixOS/nixpkgs/issues/355369
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Wladislav Wiebe <wladislav.kw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/mm/page-types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 2a4ca4dd2da80..69f00eab1b8c7 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -421,7 +421,7 @@ static void show_page(unsigned long voffset, unsigned long offset,
 	if (opt_file)
 		printf("%lx\t", voffset);
 	if (opt_list_cgroup)
-		printf("@%" PRIu64 "\t", cgroup)
+		printf("@%" PRIu64 "\t", cgroup);
 	if (opt_list_mapcnt)
 		printf("%" PRIu64 "\t", mapcnt);
 
-- 
2.43.0




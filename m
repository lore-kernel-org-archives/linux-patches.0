Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894981F1921;
	Sun,  7 Sep 2025 20:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276413; cv=none; b=oQ8OtZAO7v/RwP+kQ0pGbPmbrOKUjsUIueWIpnToukPq3Pf10lmnRW8uvGGzzVibEcZQs0f9KWj2piSTL/WybbUpJBHOxIXerBFbLrZJhtDyER6Gw37Bf+aKe7K+U+DRTdZ0QaPppEfy2dZSEROb8tdswz+AGx0pgeEWU+QsPY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276413; c=relaxed/simple;
	bh=ALn8iuCKIURgAUONZTn6tdLLGrp1SgNh6/MZMT93LLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbvtKoZLYR1jPv4hB7NADtlHJdXUUS/njt3Jv6d0T0NdlfG8F77EgtaTXcdVppeo6/0UofUeCyj/QhX47cDBrLC6Uso8RZlGSX4xOPen5xE8ME3uAGcD6MMlp2t+uwE+F4gmBNNMist0CdTBCBOIV7Fbd68079VLLn2zwMH7Jf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpGtes8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpGtes8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109D7C4CEF0;
	Sun,  7 Sep 2025 20:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276413;
	bh=ALn8iuCKIURgAUONZTn6tdLLGrp1SgNh6/MZMT93LLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpGtes8uYrrO42slBI+v91/A23DYQqtMejHqYexNqG9koytU5pHeqSWnE1yvo/ViX
	 mlRNd011oEoVG0e7e9a/IDagtoQt7xDIPapAObb07IbudZBx1jmVaaw3IK7NjAi1cv
	 T7e3LwEOkiKitqzKetc09w7dKX8G0HcJJlC07n6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Jiao <zhangjiao2@cmss.chinamobile.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/104] tools: gpio: remove the include directory on make clean
Date: Sun,  7 Sep 2025 21:58:53 +0200
Message-ID: <20250907195610.153344395@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit ed42d80f3bae89592fbb2ffaf8b6b2e720d53f6a ]

Remove the generated include directory when running make clean.

Fixes: 8674cea84dc6 ("tools/gpio: move to tools buildsystem")
Signed-off-by: Zhang Jiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20250903063621.2424-1-zhangjiao2@cmss.chinamobile.com
[Bartosz: add Fixes tag, improve the commit message]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/gpio/Makefile b/tools/gpio/Makefile
index ed565eb52275f..342e056c8c665 100644
--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -77,7 +77,7 @@ $(OUTPUT)gpio-watch: $(GPIO_WATCH_IN)
 
 clean:
 	rm -f $(ALL_PROGRAMS)
-	rm -f $(OUTPUT)include/linux/gpio.h
+	rm -rf $(OUTPUT)include
 	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete -o -name '\.*.cmd' -delete
 
 install: $(ALL_PROGRAMS)
-- 
2.51.0




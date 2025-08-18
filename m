Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F86335BA6;
	Mon, 18 Aug 2025 13:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523629; cv=none; b=kaVh8TSttMEUGTKClR1yvNwkvPYKmSKJGm7XRAAsSNNCtQbMYA7QoXS5hDhvGFqSVtZjfzTvqykU01TzQ0NRm81uqdTjMiqrJM4BzEIcUqyVt6WrwTbtxWqsKadEy2zgK9rZfyOXmXHIigILzRq/s2hJlr6/jw4RzbnvW9y0ahw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523629; c=relaxed/simple;
	bh=lLGso3ymJJ52b2O2ZyrnT70WEPKqCPuCb5ejrw4VnYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CubHSYETVyDTJk5oHgDKX8aWGi5uHncwJpyOIx+n1/rfTyF2nx/J6FGdk3bOa00TpqngKg0YDLnev8cAoRwdAAKQWAglvJV1928cJLQmuTOghC5tY+HiCmMWNgaOkrpA05wpNztVPAHojA7ntsP5HccqmjVyXbm4liBFpwf+XIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+IwCMca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+IwCMca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F56CC4CEEB;
	Mon, 18 Aug 2025 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523629;
	bh=lLGso3ymJJ52b2O2ZyrnT70WEPKqCPuCb5ejrw4VnYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+IwCMcay8ySQMYtqPEIttcczXKUJirDNoXXXwMMPwqRFqqQDm/zuhv2CjA6MuwXa
	 F0BlHyoLo35T14953muQ9ihG0x45F6CZ9j2fYJnOAm1ANQcytOpWwTNg5oed66bHmj
	 YbRzegi8ah151VUVwsjkcjkNbcE/2tfjUxffzfCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 231/515] perf/cxlpmu: Remove unintended newline from IRQ name format string
Date: Mon, 18 Aug 2025 14:43:37 +0200
Message-ID: <20250818124507.268144411@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 3e870815ccf5bc75274158f0b5e234fce6f93229 ]

The IRQ name format string used in devm_kasprintf() mistakenly included
a newline character "\n".
This could lead to confusing log output or misformatted names in sysfs
or debug messages.

This fix removes the newline to ensure proper IRQ naming.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://lore.kernel.org/r/20250624194350.109790-3-alok.a.tiwari@oracle.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index d6693519eaee..948e7c067dd2 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -873,7 +873,7 @@ static int cxl_pmu_probe(struct device *dev)
 		return rc;
 	irq = rc;
 
-	irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_overflow\n", dev_name);
+	irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_overflow", dev_name);
 	if (!irq_name)
 		return -ENOMEM;
 
-- 
2.39.5




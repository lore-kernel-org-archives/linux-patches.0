Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BC330DEA3;
	Sat, 12 Sep 2026 14:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222768; cv=none; b=eb6tyt1lBVtrG4SN1JK1cxJYRUuDcfA8EqYp74MmDcngRGuJFfNQfEAgPkJtG8ZeaX8LOvJ1jn8bw0hX8TCboaywY4Uo8rkV5TN435KKBQ/Y0frBRHsyccrI+iBx85Cnz1W2BvSSGCOU9NSaWJ1ELkvpsymjUA1iSpWD1eQJIfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222768; c=relaxed/simple;
	bh=nt82R7ti/Q58Nb3cGgWxFw/87B2L9uosZDH0XySluU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yug2UzerOqLCShkZlxGY5wo5nOxRPrKRLJhuzqxC0gT7koQU8lTA57VkkRIDKbcMpzmPlZJrutkpLxoy5dGFlqWGTSmkMVgMaJV7tHKV7I7+x3+db2zqUkn/4bl2ze6nTPB1a4XVOnSik4zDLM3R/eQoFlJWo1I/t7iGLi2o6/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXSiv+X8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXSiv+X8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936F31F000FF;
	Sat, 12 Sep 2026 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222767;
	bh=fM+mA2wuwbtMVLEQhMqA1KVZtw/s7ViRMzOJ3jQU3vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXSiv+X8fQtixRiUhvjnlMaOgqV67KrGIv35+mWxCn1rxyJp+Gbxe1CzqIgRD32VG
	 0mZ42m0kiU8dfcY5PpP+7kHuWwR5K6HvduntZOwLNIKh+7hBEFndRuC9gzAIECQWr9
	 tCIHWK9a6bKVUXXt4KNUvoUXnnArFjWuNK5sEz2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0653/1424] bus: qcom-ebi2: Simplify with scoped for each OF child loop
Date: Sat, 12 Sep 2026 08:51:25 +0200
Message-ID: <20260912065621.915697367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 9c252f3c8f390fae4ca09de36c9262a35ae88ace ]

Use scoped for-each loop when iterating over device nodes to make code a
bit simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260102125030.65186-3-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 64774dea5896 ("bus: qcom-ebi2: Fix clock leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/qcom-ebi2.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/bus/qcom-ebi2.c b/drivers/bus/qcom-ebi2.c
index c1fef1b4bd89b..be8166565e7cc 100644
--- a/drivers/bus/qcom-ebi2.c
+++ b/drivers/bus/qcom-ebi2.c
@@ -292,7 +292,6 @@ static void qcom_ebi2_setup_chipselect(struct device_node *np,
 static int qcom_ebi2_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *child;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	void __iomem *ebi2_base;
@@ -348,15 +347,13 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 	writel(val, ebi2_base);
 
 	/* Walk over the child nodes and see what chipselects we use */
-	for_each_available_child_of_node(np, child) {
+	for_each_available_child_of_node_scoped(np, child) {
 		u32 csindex;
 
 		/* Figure out the chipselect */
 		ret = of_property_read_u32(child, "reg", &csindex);
-		if (ret) {
-			of_node_put(child);
+		if (ret)
 			return ret;
-		}
 
 		if (csindex > 5) {
 			dev_err(dev,
-- 
2.53.0




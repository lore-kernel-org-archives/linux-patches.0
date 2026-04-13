Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7CD27280A;
	Mon, 13 Apr 2026 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097044; cv=none; b=MWAX3+MM/4WNNAVhGrWox0Mma2AxjxKT4OuYL5InE4KD05NtNwd9cw1yhGFzPO4c8aPOZeR4edBVJqXBqZWIXY6mov2PCbAAnO8IKgujdzTZgEH7M06BA+R1agMhyQqtnXA73tXDkPVGc1AKcQZafGJwA0+TRu0w71gvZgNjJcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097044; c=relaxed/simple;
	bh=aJ1dODHIbyV5cQhzYX86Sua+WwUc3JpX3meZcKfyHwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rN+2gak8h0sgQ1CbErFqAk8f5LkhyAVZD3efYe6xaGgsV0G9YFs48LgLQAWWmrS/fadxje8RyvJMHb3XJy2cCG8xlmSqy8vpVfJ79a+gpDgcY9sWjDz8HSxIM2NPy08dLhvT5FyoHcj0cjf9QaipBC7QQAuafDoWW0N+bqDZMRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wFluMBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wFluMBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C3AC2BCB0;
	Mon, 13 Apr 2026 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097044;
	bh=aJ1dODHIbyV5cQhzYX86Sua+WwUc3JpX3meZcKfyHwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wFluMBpi8CRK0a+fJMi/fZGgYo5dJHJKQ3GZwBfaezfErjGweU0lqQxctu0MWn3C
	 1YF6exP2QY4L13EtQVCdj9JEJn7ZAjG/IbBRSQ0ZVU73sYfHh0v3Mwhc5chFK8dct0
	 bN7xvV9niCLJvfky3ro3VsRphwFGC+Ru403kdTIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 6.1 40/55] arm64: dts: hisilicon: poplar: Correct PCIe reset GPIO polarity
Date: Mon, 13 Apr 2026 18:01:14 +0200
Message-ID: <20260413155726.332719231@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawnguo@kernel.org>

commit c1f2b0f2b5e37b2c27540a175aea2755a3799433 upstream.

The PCIe reset GPIO on Poplar is actually active low.  The active high
worked before because kernel driver didn't respect the setting from DT.
This is changed since commit 1d26a55fbeb9 ("PCI: histb: Switch to using
gpiod API"), and thus PCIe on Poplar got brken since then.

Fix the problem by correcting the polarity.

Fixes: 32fa01761bd9 ("arm64: dts: hi3798cv200: enable PCIe support for poplar board")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts
@@ -179,7 +179,7 @@
 };
 
 &pcie {
-	reset-gpios = <&gpio4 4 GPIO_ACTIVE_HIGH>;
+	reset-gpios = <&gpio4 4 GPIO_ACTIVE_LOW>;
 	vpcie-supply = <&reg_pcie>;
 	status = "okay";
 };



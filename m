Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6FF19B3FF;
	Tue, 15 Oct 2024 11:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993096; cv=none; b=U1B6G/gi6+oR3FqQrl8HD1RXMhibDdUQWW1TeA8FWPVcJGigJSZdfAVyTvsoeMrtAtqoldfE5yeCXJlJ+dxyX9t0hczgMW57pP7uNQ0FMWFt3qUD/gzxDUx1zZ8M9XZbeTApECut0eLkhqZuLzMXFs3cf81Ch5JPtaHbIi6uYnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993096; c=relaxed/simple;
	bh=1vhQi0uqK/Zo+L5PTJzBYivvt9sHwTw0M+oNqt8OS4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bkl+jf6C4XUQnzlhQS73F6+AI1v8SX5NBFkKXpFIp978uiH+nnnCMpU65rVR6o+2ahJbSk3vJTGu9VwpxVAgQrzdiPdjlaNollApxNO+TOml9VEFyQGhSF+1un8R2sw+RTdOBzQ5NV1NZvCQq9qmtbYaPQBWYJHq+oTK/82Jz3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytacYVWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytacYVWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58C0C4CEC6;
	Tue, 15 Oct 2024 11:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993096;
	bh=1vhQi0uqK/Zo+L5PTJzBYivvt9sHwTw0M+oNqt8OS4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytacYVWnNrHMEiQumuA0floKHGqD9PwnwQXVpIwUM+n+sSNhb2dqtEoQwyKfx6tQv
	 5W0OkssEAACaIfvM2Z8ayaKgvQBBy4c/iJlKq0chL78v3R7U45/TVPPFN+YseqgfjC
	 HhG8Sr+V7Ka7/QTJ5HMG/mS3dGG1QgaRi3+45Nko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 308/691] soc: versatile: integrator: fix OF node leak in probe() error path
Date: Tue, 15 Oct 2024 13:24:16 +0200
Message-ID: <20241015112452.564806187@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 874c5b601856adbfda10846b9770a6c66c41e229 upstream.

Driver is leaking OF node reference obtained from
of_find_matching_node().

Fixes: f956a785a282 ("soc: move SoC driver for the ARM Integrator")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20240825-soc-dev-fixes-v1-1-ff4b35abed83@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/versatile/soc-integrator.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/versatile/soc-integrator.c
+++ b/drivers/soc/versatile/soc-integrator.c
@@ -113,6 +113,7 @@ static int __init integrator_soc_init(vo
 		return -ENODEV;
 
 	syscon_regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 



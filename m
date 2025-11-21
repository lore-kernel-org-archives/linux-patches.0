Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2830A34C81E;
	Fri, 21 Nov 2025 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732363; cv=none; b=BQ5XfDACypJuHr4yiMzdJoKW8JA1tIRQbJWs/3e6xwQ9Cx2Rxicu5RSFVepP84ni/Lky4EDoX338Hg3AJEODUfweD1Rbvmxt/FTZDbYxy27WFfZ2q8gp2tr4xcdxFwGcU1kiXcTj5mTRL7Ce5TF4MNfzCBSRo+pxmb3/kA1dUhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732363; c=relaxed/simple;
	bh=QvKQ42RIW8rp8Lijdn2GJ4hSUbgHFtTV5EROCpHcnfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RudEAwMawzbRTPPOJYBYbNkjzsLvvMnmKtP9VEuqIuZ5c2h1cOYEIkYlP2KBfrZcJKmkTI7czGSedoureL6BMCaSZyoZZG6DQ34nmsiukbwVM1l1V6fdbzQhAAmq/VJ/XLYojapY/X4pz/dO7QyZwQt7JubFgmbG4zf401gDkXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvlYlbs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvlYlbs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9992BC4CEF1;
	Fri, 21 Nov 2025 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732362;
	bh=QvKQ42RIW8rp8Lijdn2GJ4hSUbgHFtTV5EROCpHcnfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvlYlbs40jlpx7TOJm6lLz3IxZhyxAhYQZvWnZWbr9g8QZQE8gN/eZqWbiJ/OIbYD
	 gBtzOfi4lK3PCnL4v3n38F50U+UassUdDF3sIjYHBH68237WwR37Elty7hVxpIJmzu
	 m9CBByvCdquKbid5imy2tpNcI91ZxJqhKOq8kQog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Neal Gompa <neal@gompa.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/529] pmdomain: apple: Add "apple,t8103-pmgr-pwrstate"
Date: Fri, 21 Nov 2025 14:06:32 +0100
Message-ID: <20251121130234.338125431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

[ Upstream commit 442816f97a4f84cb321d3359177a3b9b0ce48a60 ]

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,pmgr-pwrstate" anymore [1]. Use
"apple,t8103-pmgr-pwrstate" as base compatible as it is the SoC the
driver and bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Signed-off-by: Janne Grunau <j@jannau.net>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/apple/pmgr-pwrstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pmdomain/apple/pmgr-pwrstate.c b/drivers/pmdomain/apple/pmgr-pwrstate.c
index d62a776c89a12..e592f819c8fa0 100644
--- a/drivers/pmdomain/apple/pmgr-pwrstate.c
+++ b/drivers/pmdomain/apple/pmgr-pwrstate.c
@@ -306,6 +306,7 @@ static int apple_pmgr_ps_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id apple_pmgr_ps_of_match[] = {
+	{ .compatible = "apple,t8103-pmgr-pwrstate" },
 	{ .compatible = "apple,pmgr-pwrstate" },
 	{}
 };
-- 
2.51.0




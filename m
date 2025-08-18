Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183CA350847;
	Mon, 18 Aug 2025 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525900; cv=none; b=Cw8C0c31PpCA7va2nWPAe5/e8Z5yCXv9WldctkHjdQphSorbjHZym2HXSAJ07HZyGGYFuMD73UZXCe6EhwQKK7k0cOph4YnsO+9vdqk2hwNZI6P8NiDJu9TPCaW9DscqtZpNjzhYr/zNujT1haI9wFO9OvKK2CmzX0LXrblQsac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525900; c=relaxed/simple;
	bh=SXgv9ja0pSBliALUJv/ohwNBp8kEGpaB40o93jtDHP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdbjawRx4+oTsikhTstqj/c75Wp15A2mq9aI3rBZYvJSPQhEqgeVJqHeGa8jHZg8TkmxYR8MODZuW+60BdK8fbqsd8XfXHrF4o2pRZ9XxNQz5gmqyUvdkFYalP+rvEb4lqgLueMLxNcQYNQqdGco4s1ql971aUOCuy+80QX133U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azhGRPnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azhGRPnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B31DC4CEEB;
	Mon, 18 Aug 2025 14:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525900;
	bh=SXgv9ja0pSBliALUJv/ohwNBp8kEGpaB40o93jtDHP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azhGRPnHzmp36JuZsGBOm1mGmKyUhYPOnjQSE6ViHc+UzslLvLZwWZ7l6gdQg80Tf
	 Zo/F94gplu3FTyWcGM5mxdHFODdyiQp+k3ylbf3L5uhs/9vPWj0pLy+zgfqPgDMHYs
	 nUd+Dx87iKZCDXusS3V0Y314RmaZ4+RdMhl0NUY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ernberg <john.ernberg@actia.se>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 399/570] crypto: caam - Support iMX8QXP and variants thereof
Date: Mon, 18 Aug 2025 14:46:26 +0200
Message-ID: <20250818124521.226415642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ernberg <john.ernberg@actia.se>

[ Upstream commit ac8aff0035fa58e53b39bd565ad6422a90ccdc87 ]

The iMX8QXP (and variants such as the QX, DX, DXP) all identify as iMX8QXP.

They have the exact same restrictions as the supported iMX8QM introduced
at commit 61bb8db6f682 ("crypto: caam - Add support for i.MX8QM")

Loosen the check a little bit with a wildcard to also match the iMX8QXP
and its variants.

Signed-off-by: John Ernberg <john.ernberg@actia.se>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 38ff931059b4..9cd5e3d54d9d 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -573,7 +573,7 @@ static const struct soc_device_attribute caam_imx_soc_table[] = {
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
 	{ .soc_id = "i.MX8M*", .data = &caam_imx7_data },
 	{ .soc_id = "i.MX8ULP", .data = &caam_imx8ulp_data },
-	{ .soc_id = "i.MX8QM", .data = &caam_imx8ulp_data },
+	{ .soc_id = "i.MX8Q*", .data = &caam_imx8ulp_data },
 	{ .soc_id = "VF*",     .data = &caam_vf610_data },
 	{ .family = "Freescale i.MX" },
 	{ /* sentinel */ }
-- 
2.39.5




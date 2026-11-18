Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029751;
	b=rHy5SqWh4dZ996/g98TcneUNf75ObIGvMdqVjcfqGyKf72MR+f7b/f7uhRChsyrUYYMS
	 oqno3RHI7h1/dSQoC0xMKN1hW0E4yV6wJL/JzCJYZMRxJ7UXOx2tDc5GZ4QHcPbL04Wdz
	 /I3Y6wfGHmk+ZP5HuzZuuACzQ7pw56tLLLLqb0GFjCO4b6HOp9GQaR2TmEvB1l5xYbJ/I
	 8nmWrOZxklgRiSx991E5DR8EGcdMpGkdUhk+cS5NRZcOJo6OMy/S+7BXvsazPDe5r4uwM
	 cjHmNia4fmIFiL/pYl1ch2q9Dr2j3n0DfO8YEY77yWJ7fBcsEG9mcKRE0NDZ1rmUrpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D09AH7cdeLr5R6MNlDqomCE9j4lXb6V6soMHS4CZflA=;
	b=NoUXdmTWEPgttOGgoew+nHgkDcuT5NVfwnVezt0OZCOvPFlTvaau5Q5b72DAnHsvow+V
	 SvAwQrpD60t1peYfVy43+zSdysdzQj3Q0Fa8K9UK84nRq5hkc4JtNgecodCUoCgM5gzHs
	 /zLGju+u3AFEXhj1/Pw7hd9IlnW1xAIs1xG8Qa8UugoGbM7vmYRxSY/JbOKJDYtZJV5aY
	 gDTBzKI74tkTB6FZtu46+mp3knozWzpScwjVFVvD3wtfqLwWQTpksc1k7pG/PbBG/sg1h
	 ZLN/QjGaxb7AsMo9m3e0DSOO5e7HAytOxjMvWfne2fwaMJUT2mFSWNhjIhk5VL1lnPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R211piBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AEB606A338;
	Wed, 18 Nov 2026 19:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R211piBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31491F000C7;
	Wed, 18 Nov 2026 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029751;
	bh=D09AH7cdeLr5R6MNlDqomCE9j4lXb6V6soMHS4CZflA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R211piBpNkTvxkQD3XNm6fZtGEJL36/Xt7UAW2Xx8JvvJ/S/Wo7BydiSDIfJGyNSm
	 ToiSSdgJguRgxl2EgvtU4koxOp1v2it1Bi306ByIP2btCwJNnyhVwWeWJxtE/nyDc4
	 mZXoCr40uzYOzVrL3tF209QfaTNJIFZCax45GV5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0460/1756] interconnect: exynos: Remove the PM QoS request on unbind
Date: Wed, 18 Nov 2026 15:43:07 +0100
Message-ID: <20261118150027.086977973@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 601a54f00723b0b653d76caf26a2a78482d95f00 ]

The Exynos interconnect provider adds a minimum-frequency PM QoS request
to its parent devfreq device. The request is embedded in the provider's
device-managed private data.

The probe error path removes the request, but the remove callback does
not. Unbinding the provider while the parent device remains registered
therefore frees the private data with the request still on the parent's
QoS list. The child's device cleanup does not remove requests registered
against its parent.

Remove the request after deregistering the provider, before the private
data is released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260911031750.8182-1-mhun512@gmail.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/samsung/exynos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index c9e5361e17c5b..1d3b4774f34f5 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,6 +98,7 @@ static void exynos_generic_icc_remove(struct platform_device *pdev)
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
 
 	icc_provider_deregister(&priv->provider);
+	dev_pm_qos_remove_request(&priv->qos_req);
 	icc_nodes_remove(&priv->provider);
 }
 
-- 
2.53.0




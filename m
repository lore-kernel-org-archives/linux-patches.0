Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039887;
	b=Jn1+uNKGHmS3Ue7vsYIF8Z72FjuEJ8tLbpMrmMwNb7ubxsXoDjnaG38UoLdGamCe/esc
	 3/Bhl4BBgQYhvp6RUIVMI7LPef7WPwIKYE3k6K0gA86R7EWyR2zQq8Jgudt+t7+5h2h+i
	 39BADDFwcUNu1MKFVCDrK40WWUGsS6Wt92jYarXN5PhrG1Sczi5vgpe7xhDdSkXQat7kW
	 0qZxvHf6vEulDhRCDx0oZLTCwiIr/dKfrYCLsuDzNRqAH6ENxiuZpjRGw6U+YncN6X47+
	 TcsWYaoKcEWkK6IqtR0xK4QCGXocV9YLtPwpIJ2xox5MlGIZEXDhBnMvoTgdX797N1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pFtTfS99t6V4CXC+1D8lI/RUN28fYUu88uwPqmCuP3g=;
	b=HvUD49OQ9v8AyQAvdSHBAfds4ceCHAT/19ECZdeaqmBXvM77M0MOHz6Jh35+b5CgvkNY
	 xx6pGST4D934BrZOj1LGl7kyrJPT1tKoQkhU/BUwRpEzyd9/KdTFmPiGpBd4x51Sho3+r
	 wGfcydWO/Lz128DnD9Cm0ojKBfW6htr7QuHov5NQJd+5JP1d7eTofU7uUwPU0bZRCC+lV
	 HT826BXaGupkzvTlvuEEy9J0jFX1lxPG1uT9u1unnmlCYXUpVwwyqtJA7+XINBZKxfKuF
	 hJLH20nJZSmgJSS2k/cyc80i1dxOYCugwDUtkGidt+sYKYdyiu9h7eQx+eH0RQ9oT/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdwlrGqq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B57A606A32C;
	Wed, 18 Nov 2026 22:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdwlrGqq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39A51F000C9;
	Wed, 18 Nov 2026 22:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039887;
	bh=pFtTfS99t6V4CXC+1D8lI/RUN28fYUu88uwPqmCuP3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdwlrGqqK/NEZWqGfV9x8zih8GdJwWofF4jCHPPqOCRjD8i0LV4tC3XZkIoZqhCFH
	 IDPn4mhQW5ZfITxlCtvhk9jQ2mpa7nCgCklNa/T6EZ7TgSvKNU5cTPMjZTvMQ6c64N
	 r0nAYL9d7PXdUFvShk4rpq643PnlAFswdY+0X6CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2260/3318] interconnect: exynos: Remove the PM QoS request on unbind
Date: Wed, 18 Nov 2026 15:48:02 +0100
Message-ID: <20261118150429.618289853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ebf09bbf725bd..25d6317af3d05 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,6 +98,7 @@ static int exynos_generic_icc_remove(struct platform_device *pdev)
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
 
 	icc_provider_deregister(&priv->provider);
+	dev_pm_qos_remove_request(&priv->qos_req);
 	icc_nodes_remove(&priv->provider);
 
 	return 0;
-- 
2.53.0




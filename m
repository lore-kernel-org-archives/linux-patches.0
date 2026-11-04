Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829434;
	b=MRw0vB68D7rWW8GhzUVgSJOBBPfsWp+ZQNNFXMzilqYPTAJGydlMkgsALD+fGjHf1gjF
	 ZThs1mopyxrLOncC/YcGIGsU0O5AFzykcMSl+8fvvEIpOXPXHSgT7V0NIF4F9suJvEVVI
	 lSdUZ2jSubpiVYbtIT+PLNP8MqA/Tuic8d1ZZMtwEj14gXX5oJG+IMpmcTvdOU4YBcjAo
	 OR1dKUZ2xiaThgptk7hY/yKHNLkrUzNa69gUE9IhQU1RP9w50RnCRin/j7tT185+Bp6xK
	 c2tSpUrUOkcQZa2SHLWHoG6cc/csYQKKO+3VxaEeLPAh0NQorHnui479t7lhBRDhZ0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9vY97DsVdxgDLezF79nrE3jwiIRSM4uYm0NPnqb9pA=;
	b=ZZQaxG/+c0cMEcVPP0sIz9ZQpYeWuOSa/Vm4znITYglU77LZ46LRWSPlE00o8fyyQ0Jo
	 I7OYrnjTFodqevkzPX4ekZLMbk7aAs8DXo4XiWbBdLcSlgL7u+CtUcFhr3apEGmoFRivs
	 rihWnfIUNgVr6DGFqTf13NLvWpvkELgXYDUh4ANC2p9BfJjfT8/b4Ib32yf1uJQnYiH+G
	 BBU3Kmp4w5TgQGi64TaxW9UVTAAoYgT/lVntk+kRZUk8kLLup1JXD8jmC9tSiAauS/iu2
	 goU+cBGOxkO5ipWw0paRhvsupxOI4eif2SY+O7T6wZoE6jeS5kYwKa7ANf5bHouiqCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TP7LXNeA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BB8606A863;
	Wed,  4 Nov 2026 21:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TP7LXNeA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE1D1F00A1B;
	Wed,  4 Nov 2026 21:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829434;
	bh=V9vY97DsVdxgDLezF79nrE3jwiIRSM4uYm0NPnqb9pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TP7LXNeAJlGZekYmDQ5hFcDh2OQls1oO1/H9b9dJVe02Isz1aN2LEVUzy5kJP++qj
	 KmETvbxQT/iseAbJVkm/JLHC6r/ShETuw2RVgZBgrnKvtNlMNGdg89vodTw3d439Sq
	 hCyhELmQpy7qDON7/SY0AmZqC1iRPa84Q6I3dGBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0123/1005] media: cec: tegra: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:57:36 -0500
Message-ID: <20261104211047.119131242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8dcf23edaf4bdf22259f6a47cfddc8bb1467425c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index 3ed50097262f6..fe66336e734f8 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -458,6 +458,7 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra210-cec", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tegra_cec_of_match);
 
 static struct platform_driver tegra_cec_driver = {
 	.driver = {
-- 
2.53.0




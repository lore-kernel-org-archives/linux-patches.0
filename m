Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034317;
	b=RPuJEQBgQnHkfK00kPNVrcmQYShN9/zfUyLZ0dBK4/t+nAQW0dwW8ZQToGIKMRp4bEaj
	 bNuPieB729Ccvql/JmzercAwWXAyjfaHiq3gtAFRI8FYUPJe1BQiFnajE+VtQkVcEbhXj
	 8hHIK42g9BUacoLRBum4TrPPcRrAZhUXnQMUtcORpx5k85vmbZFua52KCJT79CV6g5GRn
	 FyOJKktzeepQxEUBrhWkFBR0jI2ESSTCF2pD/lyZVPrjEc/fKUAVOLfXbM2bPfecBJGD0
	 HtCbNvtrXrmTMCIuvj9yOFyvVDYrYQ5VvAMwBcWUDnYlLd0DNHTJvWJeXr4STg+PO2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MPcCDLXdV38YYiwQmMCjrML36wx7WxEOX9z94qIb2J4=;
	b=RqJ9jbD93/zcsOVeYT05o3C1vu1Nh6pOxb8r7+bnCri/j5TXoaeAAUlcCII0tAnlAjsl
	 M3U+WYyhVDXdMDx1fuMWb23r+ufm7efNBCfUboPiGKzljBVzprQBOsQU8azx0WczvC2T0
	 xggXc31QaC3nkJrX5MkOegz6WY6kXK9xLy97DSBuGeAlY3seL64WNqeqPbhTUdEqYpg30
	 H1zRHLu+execQAj4z9Cn5Z3bFF3/+2r/1nJPcDVlO4QyY3NVkn6EWn5elsJJAkoA2zqsq
	 unmtnInbTPjKW9FLxO2icVjm66QlIumPjP2gH1LgNR7iKTUPr4kpuqY5szakRZYKjQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1qtCiwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D89606A31C;
	Wed, 18 Nov 2026 20:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1qtCiwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473091F000C6;
	Wed, 18 Nov 2026 20:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034316;
	bh=MPcCDLXdV38YYiwQmMCjrML36wx7WxEOX9z94qIb2J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1qtCiwEclYv2ikkcHFy7ZeQNHHUU6Co5h7UQ86PYeDb2ggsvp9Q2G9Kd5xXJ4950
	 1Tr5z9l3A197/p6TLBYOPVKZlDxtZSD7eyHs9etC1ZpbEOrvkFQVTOLKxgkmWlPP5C
	 9lKJpO3ArDkBB8cjjS9stl/2WiyTvgR+FRdYfLyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0324/3318] ASoC: amd: yc: Add DMI entry for Alienware m18 R1 AMD
Date: Wed, 18 Nov 2026 15:15:46 +0100
Message-ID: <20261118150325.599868032@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit fd8ed52ecea6b93e23d52cb2758fb4fb4029067f ]

Add DMI entry so the YC machine driver probes on this model and
the internal DMIC works.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221485
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260824130302.553419-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 39d5edf8d3216..5f93f8abbe6af 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -507,6 +507,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m18 R1 AMD"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831061;
	b=1F5TVcQc95D32rbuU/435dbUS5Ehp8nQVQKMErwWJzxhDGoT7INnjBP2T0DSUbYXlFdL
	 shvvZP0vQ2yHoItdKf7s1XKgfBmIebVXWPlvBT0O6CpUP6KmBaQvcNqOsJuJP6uqpee+T
	 T/ZN0YbXSgHc4cuIO3ULAKW4VpPgD7n27zKwd5r3UHvVTjBjPONvGcc14TdeWVXOIEq1r
	 ongRVG4w7kiAf6se/cYcbG4m7NiERCaiDiaqrV4j3xP3+wlIcVJQKUcNJdyqulVqcVieb
	 A3DEAXfrLh2Sb1PLTF1YfdFmiS84HZNksvk/9Xdjb6aJUTykL+79Gc5feahuauAn24A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZP7wQTag072pTMB4PE+JHnuQyLXWBzUgjMa4057cav4=;
	b=ujmj0jil1YDeIEUmBu1WcIDQyEnf/RdFAHVDJNThIKgFRV+4VRD0rBbYulvo0Bmdzekr
	 sFzgg77oxbIhD+1m/wmyl0Nn1rPVY1w2Wmk/+sa2oHb6KO8NWuNk8IghAw96KtEhkzGJP
	 WF4IU+VUWI+vZYDqEUY94pTFeARyXNd7i5bDvJ1a7YINvqtmSLYNn3bO7GZCqXp65XYlH
	 9oxHJx0H/lPZPSKNQwQXp7nYLkVwibl08b30+L2v5dOS2mqasEeLBeO4GoNzDCNF8u6Te
	 GLnURSLZNNH7dGWz4mQs01c7iptPLLSsbwj1JUTr8idvo5ESQ41xvRLFswrJFtDkUnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dub06Mo3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6500606A32C;
	Wed,  4 Nov 2026 22:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dub06Mo3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649941F000C1;
	Wed,  4 Nov 2026 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831060;
	bh=ZP7wQTag072pTMB4PE+JHnuQyLXWBzUgjMa4057cav4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dub06Mo3nOxpNymWGzxmqlzrw5uvJq/PlA4B9GPZT33mYH6GoNkyzDsN75Wv/b1fO
	 TTkQ/PlWFm4Cr12tzrWMShiXsl5uPcJYvnJSVtCecIJGyd3W933MVcOvL/MjOYFe1S
	 1PqTWECF8Z5mGmkObNsm+DSDcs8NoskUThH6Az0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Adachi <seiji_adachi@yahoo.co.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0482/1005] ASoC: amd: yc: Add Lenovo ThinkPad E16 Gen 2 (21JN) to quirks
Date: Wed,  4 Nov 2026 16:03:35 -0500
Message-ID: <20261104211057.489038621@linuxfoundation.org>
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

From: Seiji Adachi <seiji_adachi@yahoo.co.jp>

[ Upstream commit 4cae4ca34992d210d115e8e891f1e88c9df5f24c ]

Signed-off-by: Seiji Adachi <seiji_adachi@yahoo.co.jp>
Link: https://patch.msgid.link/20260917131851.2122144-1-seiji_adachi@yahoo.co.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 8e203c034851f..507c07efc069b 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -234,6 +234,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21JN"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0




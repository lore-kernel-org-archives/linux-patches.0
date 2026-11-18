Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029002;
	b=TghPvwrkWZD05mkoSaAMtgl48lw8iMoCwUs6ZIcWIHjqVktJS/TFWflw5c6eJYQ+aq3H
	 YMRSbcNIVzv7Usi0JfmugzHJlX7fZM0zsir7Ha6dHfxk7x//CXpQ+DwCJXGVKU5ZWcPDA
	 M98Lq0HfHSX4Nz0ZKwtn7TtYOjXfEx27aCP+9oBwRzwS+xKHZ5WCdgu2y2TULPr5j/aCU
	 lyFYTlfbTU9ebZKjSJYtdcZkSe+5FpfpCphJbNNDPrfvRjDyfWgaowSecZaFd+ZgCJMNC
	 zjlN0XxOL8m/F/EwQJq2UZs6zO34jBqsSg9shMoi3wslal6upBkPHBr366I3URN/LlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aDxvntBMJzEk9NfWyausEW+wmSEYQFA0diQuO30F0Yg=;
	b=BrnV/oz+Q5CMDqewT/YP9D5ZLcXCp1VBTLAraGiYS44fpht5hB1SCC1dDcJ8tMqUKfjQ
	 QRAmQ3gkieF6w18y5WmKbz+yJLVtEVK7V7gEtJo53uB5RyhKr8G37o7qK9NrHaJE3hUdJ
	 kIqRNp8Q2jdK+q1K0afIsGcIBKTBkVKG23Og4DObdbtJyBKLycjOg0biHUhD4S58uMwgC
	 TrgnBfriIeC9iSk/Fod6lQi/6Ubwm16MPUw4UDY59HfTRq3EXaUM95irC8C0VH2fLAR25
	 tafoBgeF7DdBjJmU/HErjPATwLK9Bi3hORbIGCHhQRMeZAbLzxQwvgOVee7yMCivhAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHI0LqF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190E1606A31C;
	Wed, 18 Nov 2026 19:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHI0LqF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F21F1F000C4;
	Wed, 18 Nov 2026 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029002;
	bh=aDxvntBMJzEk9NfWyausEW+wmSEYQFA0diQuO30F0Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHI0LqF0FETJwezrvgCycglXmUWFrXIT3RuTD1xKsq3UMvbO5wO49yEVJ9JTXcM0y
	 JWZZ9dQJTMc048RhVm2jq+uQTnkf/UNwo6V33Rfq0n79E1uOdY4Kla3r4DjQjHiKFL
	 PchaW9sLTq0Uhnz6HlHbKJYDNIkKmMDXtN5ht2hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0194/1756] microblaze: CCF: fix refcount leak
Date: Wed, 18 Nov 2026 15:38:41 +0100
Message-ID: <20261118150016.121155104@linuxfoundation.org>
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

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit aeedf85beac51c7cd8f7bf4c918a0104dfdb8b78 ]

Every value returned from of_clk_get() is supposed to be cleaned up
via clk_put() once not needed anymore.

Fixes: c1120542b99a ("microblaze: Add support for CCF")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260526184105.18962-4-grandmaster@al2klimov.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/cpu/cpuinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
index cd9b4450763b0..32c508e85408a 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -133,6 +133,7 @@ void __init setup_cpuinfo_clk(void)
 		cpuinfo.cpu_clock_freq = fcpu(cpu, "timebase-frequency");
 	} else {
 		cpuinfo.cpu_clock_freq = clk_get_rate(clk);
+		clk_put(clk);
 	}
 
 	if (!cpuinfo.cpu_clock_freq) {
-- 
2.53.0




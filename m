Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AC18494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81838C433D2;
	Thu,  5 Jan 2023 12:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923515;
	bh=P+HmmC5najFjyCLMNrVMrlepPo7hX89wWn2F7R1NYqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0f5l+oh9VdqQh9lptp+e8AUB+knbAf7Rj8EjqKYy633J0SRqNtcUBC1Tib/D0yhO
	 vNUFWsA2hITsVvkvx3YkoNIfvoggW7F0fFutx7nFGxdrLfFf5g/UvZzcCYzGfdTRRS
	 zJTY5LiGYuyCy694Kr1h2NpkqZIHEf0K55nSwuaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 045/251] MIPS: BCM63xx: Add check for NULL for clk in clk_enable
Date: Thu,  5 Jan 2023 13:53:02 +0100
Message-Id: <20230105125336.834871686@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anastasia Belova <abelova@astralinux.ru>

[ Upstream commit ee9ef11bd2a59c2fefaa0959e5efcdf040d7c654 ]

Check clk for NULL before calling clk_enable_unlocked where clk
is dereferenced. There is such check in other implementations
of clk_enable.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e7300d04bd08 ("MIPS: BCM63xx: Add support for the Broadcom BCM63xx family of SOCs.")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bcm63xx/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/bcm63xx/clk.c b/arch/mips/bcm63xx/clk.c
index 3be875a45c83..0b718a94656a 100644
--- a/arch/mips/bcm63xx/clk.c
+++ b/arch/mips/bcm63xx/clk.c
@@ -316,6 +316,8 @@ static struct clk clk_periph = {
  */
 int clk_enable(struct clk *clk)
 {
+	if (!clk)
+		return 0;
 	mutex_lock(&clocks_mutex);
 	clk_enable_unlocked(clk);
 	mutex_unlock(&clocks_mutex);
-- 
2.35.1




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062814;
	b=Dep1izwJjfvtuxiyzoapd1F4APuNhDeLmNqichnIvg3j6qOIuhY0r+rynIDKaycQ8ssv
	 j8cCo4YbyZJVrmjCi8ZcEUVGfhHl4fOc8zt/38uXN71iOM0JtFJbXMTWSdINRDZEnwiDl
	 LWoSfbcCdb0SuN4Wv532MWWkaSzhTKI4HFwFIYrdVKW9Cm2Y/GjUjCX2qnZOMLBjy52Zi
	 7CJHgI4T+kv7WHseBQjkLzvO1xlQE6H/KoxuqSDi64cR4+nG5AwJb4Q/dWGQBxO5szzLC
	 EncWivIA7TCOzsgTJ1kyKxOfuwD6bWBe3GwMXGpag7+hK9ZAd08GdGWsYi4LFL5YpsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6phHUxDV7JZGx4VJY6yvmxzVJmooWJuBGhlQG38Aek4=;
	b=CLJ+tkmPcq8fBWbfWXCi4cWATELUA3yUyHPCGBXIsMg8JyDwHbEs8sdS2jkDMctBMzfL
	 q32A7YZzveRByGO1VlsHp2qPdOEU+4gFbvn/dba+zHSPvV1xYndbEC7iFdBMoh/ZdQ5xC
	 niD6TjUfOWtZ/asPfabLaMKkAHEKuM9Nj951SoomdijZ1qcw4NnczV/jRhVB3GwMv7KFX
	 hZ1PPnFCSvrkkJQb4tvShVS0OCgZtF5rmhbgBcA/auWXc7zM4/jfsDq/n0pGX6NdRzMYp
	 ITrEUrSd2QtN6fsU1UhaS9VAqx4wix+2FWkB72VxsqcFJIxyZMPEMhOMc1WE+8TdlKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMPw5ib9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC83606D806;
	Sat,  7 Nov 2026 14:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMPw5ib9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829A41F0089F;
	Sat,  7 Nov 2026 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062813;
	bh=6phHUxDV7JZGx4VJY6yvmxzVJmooWJuBGhlQG38Aek4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMPw5ib96eXqos9cCVXFnqQw9Hapu7KpB0OREs92jjC17rUykKFxXEr9mTxmx7O5U
	 mqjJUFTXLHlZBzVvh5sxXnZT/2Hi8GV3vuoe2jeSAQWxNYafRo/0u8wRAQ8phrfEe4
	 E+eXMdVDCdrfQrS1tiLeaUA6UgV8qc3kyxkxlEyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/869] hte: tegra194-test: shut down timer before GPIO release
Date: Sat,  7 Nov 2026 08:46:34 -0500
Message-ID: <20261107134856.376172496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 30167fadbf87fa901a2fee49c30a5c5a506a43e8 ]

tegra_hte_test_remove() releases GPIO descriptors before stopping
hte.timer. gpio_timer_cb() accesses hte.gpio_out and rearms the timer, so
a callback concurrent with remove can use a released descriptor and rearm
after teardown.

Shut down the timer before releasing the GPIO descriptors.
timer_shutdown_sync() waits for a running callback and prevents it from
being rearmed.

Fixes: 9a75a7cd03c9 ("hte: Add Tegra HTE test driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
index 94e931f453059..4951049e00b09 100644
--- a/drivers/hte/hte-tegra194-test.c
+++ b/drivers/hte/hte-tegra194-test.c
@@ -218,10 +218,10 @@ static void tegra_hte_test_remove(struct platform_device *pdev)
 {
 	(void)pdev;
 
+	timer_shutdown_sync(&hte.timer);
 	free_irq(hte.gpio_in_irq, &hte);
 	gpiod_put(hte.gpio_in);
 	gpiod_put(hte.gpio_out);
-	timer_delete_sync(&hte.timer);
 }
 
 static struct platform_driver tegra_hte_test_driver = {
-- 
2.53.0




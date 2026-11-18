Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030789;
	b=rfickVfFar+krHz7a+tK36Vvfk3P46hRnTU85w5mFzcVix9GuFFPbW+A/UQHUlyUJOsv
	 D/cC8yglkL7mPVRi8V9ZrwKVat4lDEIKyXUCdmK6ktr3OL4RKx3cHjjL6u1Cs1NNYECJi
	 qsCR0yWZD2GL75o/w74qV0LF32eF21pZ2tqA8aDVOsgyOkpgO3UwlwIDreXqxhIqHbL3g
	 X83wpS7Uid7hwwbkuh7G0uYY9q+vRt/IB4TEHOL3ufbN4e2zRQDra3uxoZCuJ/78f1hcw
	 bapgyRntZNMeY8bl6CAknL4sGcgarfT36sjq/5huNcZ+efgKwLb9C+Dbj2sFzk+HP9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JrB8ykEAYAQYWti5zZn4r111TYVagZ66BTMeEpaOOxE=;
	b=3K0W8TiTXQXoTZiH/Io+J0ldgvouaTWKbYjPnzMurO4Ai9wv5o1M32ZUplwvvmdYbZXc
	 yr756Qq5Ie7jAS/SfIklCUfGWcwsFrIZw7Fq/fBe03wnFo8bjiaIS974HpKwHH+PNQImA
	 Op7x/FihCTQlga65cGrB/oie6lcwbd/QModtKu1fUmMFgLaIV6atDdvbPx4zq1+beykYr
	 eTMP4P+WMigTOYY/uHX3c8Q+hKhvqgW7PLO1ZQYyTuU0qNzPaTPC9kL2GmdX5k5m2ySMN
	 yOj3kMwqnLvLe+evZuyDPHiE86mwb6eWBUFdT09qzS3vCuAPG9peMzuEhPQBO5npCDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZSGTnIG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93756606A92E;
	Wed, 18 Nov 2026 19:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZSGTnIG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935181F000C5;
	Wed, 18 Nov 2026 19:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030789;
	bh=JrB8ykEAYAQYWti5zZn4r111TYVagZ66BTMeEpaOOxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZSGTnIGhojG5JKR6DqwaetvZUFahNXVhcPtDsB05cJOazR39l1Gfny6BQGEVnJKr
	 5/OGUcTWbixAKStNraq0H2rZ7Yrc1NilNlhHpaQPMzNr67yw8r0nerOLQq8DUGUxDn
	 AIw0l/t6atyEwbIADVkQURhptMqFz1E3ROP3NhhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0827/1756] spi: bcm63xx-hsspi: Disable runtime PM on remove
Date: Wed, 18 Nov 2026 15:49:14 +0100
Message-ID: <20261118150042.444077253@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 38232bd3cea74845c2064eb9f7eac77fa5a21d85 ]

bcm63xx_hsspi_probe() enables runtime PM before creating the sysfs
 group, but bcm63xx_hsspi_remove() does not perform the matching
pm_runtime_disable() after a successful probe.

The probe error paths already disable runtime PM when sysfs group
creation or controller registration fails.

Add pm_runtime_disable() to the remove path after removing the sysfs
group to balance pm_runtime_enable() from bcm63xx_hsspi_probe().

Fixes: fb8695e3749e ("spi: bcm63xx-hsspi: fix pm_runtime")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924112329.1566051-4-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 87ec22627c6d6..3cb643340b3d0 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -888,6 +888,7 @@ static void bcm63xx_hsspi_remove(struct platform_device *pdev)
 	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 	sysfs_remove_group(&pdev->dev.kobj, &bcm63xx_hsspi_group);
+	pm_runtime_disable(&pdev->dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0




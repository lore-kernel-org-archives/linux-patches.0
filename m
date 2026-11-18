Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024972;
	b=SKHlscwwQHDr4+RGF+SDzNn1nwl8/EN0dfjYYiQhzn4GI3pS3+7yceJ5G9CJ8s3czYgW
	 iO7wjr2CoD0FL7Lk8JYntEBapznB2Ktk/R/hSubbS1TyYWun03/egOtjKMKc6Sy2SS/H3
	 J1oEsYzaoiHs1kU/J1AyX8gzyS1Rt+/ZEZDN2JmvP3TfJ9C9EE9wv4JzOOUtgd8+oXq/3
	 qSs7QJNDs/zl3p8sShGWpuBuZ4ynIr51ZN8fBiO4KPOOksnEWx2GYJPM6Rwg/uHTn3UUJ
	 eBQlW9zV4WNDmSjIN6KeI6Yzp+kGBfXQTtVXuXGZL9GbKfr1vMUi8oUQQ4pOB6UKfwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XN+hnncIQ9JYb9Ork02QNWpSvldxXBIL5N/tsCObdFM=;
	b=dybfFAZZ7+FjluF3FX7wT0PJ7Usc4dR8ZCYMxVKz/lbM9KFkE5nKcwlL8NlluAS/iYi8
	 7/ohIyJA65FDj+VQAdqxvlaLO6GIUQwXBW2pAIi4I+DcDzbpDEgyy/NushO9Xn3bAdoh7
	 wsnjTU8ZxAc4/6hlTauLpUHqdJ+Ff/2+FFvue1ACtxR1cJtmvmC+f2+KRrfHkXrtr7YSw
	 RXVv0Q8y/z54w0t+wkddO4WV0VGIcYzto6mxjV3ToGlI1x2xW06I8sqipss16Jjb/xQGv
	 bW/bnCe42R6hnc2zae/gX+3EBrqNDvDxhfCanMeVI+Flixo0vRiUY6Rpqla/+KMvJ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wRT3lL/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF08606A31C;
	Wed, 18 Nov 2026 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRT3lL/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513DB1F000C4;
	Wed, 18 Nov 2026 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024971;
	bh=XN+hnncIQ9JYb9Ork02QNWpSvldxXBIL5N/tsCObdFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRT3lL/h27jVN1pRavXM9wSj1WR0K6oTgA6OKdIm9CP550xFxv03m3OBHzgmFObr3
	 bNzHTPUbkRa9WOMDFffmCP8ES5Yeoqiy1uzYE1C2NtdYYD5T1DiTrg7Cc96jR+M+KL
	 /iL2tiTGQIZ3hYepa+n10HGSeQLK0QYXNnEJHKWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0873/2151] clk: ti: adpll: unregister OF clock provider on remove
Date: Wed, 18 Nov 2026 15:43:28 +0100
Message-ID: <20261118150153.999202986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4c943ddfc24340f1b899762b1ff35c38306b7a35 ]

ti_adpll_probe() registers the driver's onecell clock provider with
of_clk_add_provider().  The remove path only frees the clock resources,
leaving the provider registered after the backing data has been torn
down.

Unregister the OF clock provider before freeing the ADPLL resources so
the provider no longer points at released driver data after device
removal.

Fixes: 21330497f303 ("clk: ti: Add support for dm814x ADPLL")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index 8885d28face50..0d729c9980a55 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -925,6 +925,7 @@ static void ti_adpll_remove(struct platform_device *pdev)
 {
 	struct ti_adpll_data *d = dev_get_drvdata(&pdev->dev);
 
+	of_clk_del_provider(d->np);
 	ti_adpll_free_resources(d);
 }
 
-- 
2.53.0




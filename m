Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE3C15A5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 12:34:04 +0000 (UTC)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 348CPr2P072801;
	Mon, 8 May 2023 07:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683548753;
	bh=RDz/QjzsouRcP6eQuX4xPWSD5h7MCVPLzBoVgB22EFc=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=pgVHqFu4ySWkdsll8EM2Zyw2y1B+0BiQ0evQe/leueGvO/Wc3D2zRGUEnOMhFuNjz
	 V9gwtJMUW6zoIbH9TdZE0z8bYWxF6RqCng3cV+rQhn9Kaf6kq390H/iQvJ9td9voX+
	 SBpFaALlXwxuUMzx0Oam1anoDNralc6CgXGkDVxg=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 348CPrrM012273
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 8 May 2023 07:25:53 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 8
 May 2023 07:25:52 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 8 May 2023 07:25:53 -0500
Received: from [10.24.69.26] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 348CPo3L111525;
	Mon, 8 May 2023 07:25:51 -0500
Message-ID: <0138fb50-507d-bccf-40bb-07340f3cbb33@ti.com>
Date: Mon, 8 May 2023 17:55:50 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 455/611] spi: bcm63xx: remove PM_SLEEP based
 conditional compilation
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Mark Brown <broonie@kernel.org>,
        Sasha Levin
	<sashal@kernel.org>
References: <20230508094421.513073170@linuxfoundation.org>
 <20230508094436.944529030@linuxfoundation.org>
From: Dhruva Gole <d-gole@ti.com>
In-Reply-To: <20230508094436.944529030@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Hi Greg,

On 08/05/23 15:14, Greg Kroah-Hartman wrote:
> From: Dhruva Gole <d-gole@ti.com>
> 
> [ Upstream commit 25f0617109496e1aff49594fbae5644286447a0f ]
> 
> Get rid of conditional compilation based on CONFIG_PM_SLEEP because
> it may introduce build issues with certain configs where it maybe disabled
> This is because if above config is not enabled the suspend-resume
> functions are never part of the code but the bcm63xx_spi_pm_ops struct
> still inits them to non-existent suspend-resume functions.
> 
> Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
> 
> Signed-off-by: Dhruva Gole <d-gole@ti.com>
> Link: https://lore.kernel.org/r/20230420121615.967487-1-d-gole@ti.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/spi/spi-bcm63xx.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
> index 80fa0ef8909ca..0324ab3ce1c84 100644
> --- a/drivers/spi/spi-bcm63xx.c
> +++ b/drivers/spi/spi-bcm63xx.c
> @@ -630,7 +630,6 @@ static int bcm63xx_spi_remove(struct platform_device *pdev)
>   	return 0;
>   }
>   
> -#ifdef CONFIG_PM_SLEEP
>   static int bcm63xx_spi_suspend(struct device *dev)
>   {
>   	struct spi_master *master = dev_get_drvdata(dev);
> @@ -657,7 +656,6 @@ static int bcm63xx_spi_resume(struct device *dev)
>   
>   	return 0;
>   }
> -#endif

This patch may cause build failures with some of the configs that 
disable CONFIG_PM I understand,
So to fix that I had sent another patch:
https://lore.kernel.org/all/CAOiHx==anPTqXNJNG7zap1XP2zKUp5SbaVJdyUsUvvitKRUHZw@mail.gmail.com/

However missed out adding the fixes tag.

I humbly request you to add
https://lore.kernel.org/all/20230424102546.1604484-1-d-gole@ti.com/

this patch to fix this patch throughout the stable fixes trees.

It can also be found on Linus' master branch here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/spi/spi-bcm63xx.c?id=cc5f6fa4f6590e3b9eb8d34302ea43af4a3cfed7
>   
>   static const struct dev_pm_ops bcm63xx_spi_pm_ops = {
>   	SET_SYSTEM_SLEEP_PM_OPS(bcm63xx_spi_suspend, bcm63xx_spi_resume)

-- 
Thanks and Regards,
Dhruva Gole

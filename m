Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590FD1DE4CC;
	Tue,  8 Oct 2024 12:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392258; cv=none; b=cIHYIco/vDhXs1Mo0klMjdpbTlCPxBPTnRqd5rcKeJg8d2kZgFLgunr4HlQlEQ8anOpfLESj1xlGbensd5mgr3IpY5WuJh/NAvPSExIk8tZMP4W6xfAG6IGKMO8T8oRIxXq2HxQTOhJ8bCQZjmSpiAn2TjYVhFntF1QX1xtDoLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392258; c=relaxed/simple;
	bh=XA6UUr0B9isJ69sM3glZTvYM6sNnoJHMIxjU8ySsthg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFuk6nS0nptwb7a+5Vhz9nTjgezACqdCy02Vk/oyvxEAx8FYX7sZnB9gMQZygWkdM/KnrKT3jBA/3ofcqdBDNWUVXSwsW2sa6QTYlQGT8+50F7uKcLXROQ3eUZbHiGpQDIPw95yhCC2P5wheHeUZLMgkDyKs3gDuWZErbOaYTpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xquzTN8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xquzTN8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC1FC4CECC;
	Tue,  8 Oct 2024 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392258;
	bh=XA6UUr0B9isJ69sM3glZTvYM6sNnoJHMIxjU8ySsthg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xquzTN8PtkD6eLQUNEpECk52FQMpqKkTzaj7sJdX9PmK7zwZ8xUTKAjzrU3f+dvgS
	 OzFAPT9WxfWVEOOuHh6VzM1l2u5PEag82ko6182EsWM9EzGXodfOnlQRhlvDO1g6GX
	 uXeyFewPYI7G0O9WXRAqmkpBnZ4VFJnOn29ZIFeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 362/558] spi: bcm63xx: Fix module autoloading
Date: Tue,  8 Oct 2024 14:06:32 +0200
Message-ID: <20241008115716.543547107@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 909f34f2462a99bf876f64c5c61c653213e32fce upstream.

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from platform_device_id table.

Fixes: 44d8fb30941d ("spi/bcm63xx: move register definitions into the driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20240819123349.4020472-2-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -466,6 +466,7 @@ static const struct platform_device_id b
 	{
 	},
 };
+MODULE_DEVICE_TABLE(platform, bcm63xx_spi_dev_match);
 
 static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6348-spi", .data = &bcm6348_spi_reg_offsets },



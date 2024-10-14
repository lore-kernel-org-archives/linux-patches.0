Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620481A76CE;
	Mon, 14 Oct 2024 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919223; cv=none; b=HfBS2E2cnQ24/6mblyyRMkYKCsYegz1CjBVs34eI2shtdkRMmhv9ngtl+5wJUmKY6znoum10zyTmDu9hs3YKxNPJmnptjkSOw3yIZpcSd8SxrUNaq2S7lkQxUcxP9zBZR67zY94tfFUTXOsNjTLjtm+567Jbb5735H3ClG4D+rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919223; c=relaxed/simple;
	bh=JNI0pt0V47aNS4YYfiYCFEuRnryuDTygf1KcdwAcKG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOGK9pYCPSnpXhdC50TX0f/FAjRW2J6s1mFg2rH7eYr7DZJttQFPuF/ifvUOjEluuAgb9z8EgeJKtr3d4Ksx/bsHz5bAfIyC8B2z9Kr6CTK4h+6gvW5og4caIqDCNQEDZTPF0roFr6sErDUeFuIRevZNJF0Kp7gK+gV8DPzLMZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WH5RXZMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WH5RXZMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56D8C4CEC3;
	Mon, 14 Oct 2024 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919223;
	bh=JNI0pt0V47aNS4YYfiYCFEuRnryuDTygf1KcdwAcKG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH5RXZMyXU515X1dKwplvNRGpHhdUDRke6+I0YsiB8ZJk3NdD98YA/X3Y1zQDzmMm
	 0+vFloZs5sNXOUQCYabrrZRhKa/v7jGQedrVNLjvaDLmbU0l6Ugfbd8K2hPAgfaRY8
	 F7b+NEQsQsilK1nAu4sZjbja8q5Sda67cQUhIzJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 530/798] spi: bcm63xx: Fix module autoloading
Date: Mon, 14 Oct 2024 16:18:04 +0200
Message-ID: <20241014141238.811434977@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -476,6 +476,7 @@ static const struct platform_device_id b
 	{
 	},
 };
+MODULE_DEVICE_TABLE(platform, bcm63xx_spi_dev_match);
 
 static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6348-spi", .data = &bcm6348_spi_reg_offsets },



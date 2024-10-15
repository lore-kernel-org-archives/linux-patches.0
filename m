Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072291EBA0A;
	Tue, 15 Oct 2024 13:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998047; cv=none; b=sX8AxVlek5fDI28CJkSOVFFXjWbp9+0JCl9OBVVOnODtOH1HINdWD4BbUDVZ6DZdCGzTvQ2+FlkkM2efTOUqqobfSClzBL3IPHqFbdbmrniWQDDwzcuM771ZcBb9PbprDrC5FgeZcoKTmAuYxByNFn/InwR6eBuLHK/3fHM5HGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998047; c=relaxed/simple;
	bh=5/dbaKBx3RrdrwlL/j7ub4bdPGt+lNYvP7v/l7NfRqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2jUD7jLzJajne96l3+ieyExsDh32Xlx2fGYHBRxkiaBy6yDcYdA0HdL6X5CckEtmWCKgGOnx9kvPMcUceQwCnU7MgLN+Ot0vVo3SdjCfBL/YkVo8YMH8ocvRBrTtg/Pm/CbNdL+ezzm3W5sEQYp03hTgDDkpI/I3yj5MGks85E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8h4lcHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8h4lcHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF26C4CECF;
	Tue, 15 Oct 2024 13:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998046;
	bh=5/dbaKBx3RrdrwlL/j7ub4bdPGt+lNYvP7v/l7NfRqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8h4lcHIKvOC/3358VWRJcYkTbe0bzPS41ijBJPtZGX+Hgwbi9qGsS3FRzIZQJz9W
	 qpQ5R+xWjUjfx6Y0D+P59JebSerMVpAsW4ncmW2hBIk789uIZFej+SumkpluRaB1mK
	 7N9MiREF/YWsqKl3gOVjD3Foj4KKvkdSjiHJdF2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 363/518] spi: bcm63xx: Fix module autoloading
Date: Tue, 15 Oct 2024 14:44:27 +0200
Message-ID: <20241015123930.981560353@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



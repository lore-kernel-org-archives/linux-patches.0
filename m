Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CA41D0BAA;
	Tue,  8 Oct 2024 12:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390489; cv=none; b=ewOrnGzBtdXcsdOJQXqqO+D5/TVYRyU+tF+C/1z9aDWnEIZuFCR3cPqcjRrnmf9ZbjcC2/8ny+Icz7f26orEdo/6M9nfnhmq1R0OgAqMbeKIeubQI5LRB5P7zh7TwNKfLhY3uS+kw6lAuQ7A3vIEzlW2KAf5+0BmQiWqUhM5xFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390489; c=relaxed/simple;
	bh=4CLSQHKh9QopS/WvDbUFgtRJodppadkMZJkPOo6hFSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io/2kNzdZheo9RkQzEvvX1EdQf8LF6LmiT+GfXT/SQatAP7lhlRqKKauM1LgLdrfi17HokPQ+XF1l81jmsRAiSR1RR/o82O3pEL8ESWm07j879qH9RALOxhkVZApfOyow6xUM77kOSl3EcUXkm/1Dvin0BRFtbqqG8R6SWBSz58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzix+9zQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzix+9zQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF37C4CEC7;
	Tue,  8 Oct 2024 12:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390489;
	bh=4CLSQHKh9QopS/WvDbUFgtRJodppadkMZJkPOo6hFSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzix+9zQGNKep7ImBrqeD5d3baTqXiiSi+mo/A7SJ+R8m/1vZbAmTmgrr51BdVmQ+
	 O5ASjPGLNQAFWqY7kNf4Ij9xZnpIKGdo9wvzXhPdmJM8+2aYGTRh1Vc1hUH0JfDLB/
	 Hd9v8FqotIxX54HgqdklVBWiaZm/Qqms7YJTduhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 305/482] spi: bcm63xx: Fix module autoloading
Date: Tue,  8 Oct 2024 14:06:08 +0200
Message-ID: <20241008115700.438625505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839FF1DF978;
	Wed,  6 Nov 2024 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898444; cv=none; b=NPE6FkXv32dYfOpH5T2aRqEoBckunHgJ1u5NbwYohsij3cFtnh96VLxuOK1ij8JOH/DgLhsiLE0kTVyI82QBDqAce5E8/HO7SAkw2SuFgIU/eduI7v4mli0SZ2srAR8Opz6tXE9BzmenxZ8wU7ZFM+VKmaM0qAHoWyV4E6z1080=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898444; c=relaxed/simple;
	bh=wCV+ScSpN/U7/Cg01j6XmOZT9KtNqFzpkeqW+KkVGIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUV09fREZ1RBMDLeWM2P95XPg9do+Kso6lI7BTgKaOVMlaoIknqAD9KAaEy80dABnR2O04IThi5PLsSy9etFCkVDwQ2vxYqVaivRptmi2ki8G0W0oB6xlsaZBIpV5+6xfBW2f0oeXuPoXQcgpJ+TYd0tzC1qhDdqmAZzVwoc0NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOqd4OGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOqd4OGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083BBC4CECD;
	Wed,  6 Nov 2024 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898444;
	bh=wCV+ScSpN/U7/Cg01j6XmOZT9KtNqFzpkeqW+KkVGIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOqd4OGbH4B+zYNurcq13zoPnIy6wyBcaBueta2cfEwQPXMs1gzUBcf3O4pHmLwo+
	 JmSK9lIP5fePSNWc3cQm51oeLQy394gRlWXUxv7qlHYFCMumdAXrJzVMUHYZ9F8Fo3
	 EavWee0ASfSz24umcvYbEPBN73/X7KuAmrmyhIkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 241/462] spi: bcm63xx: Fix module autoloading
Date: Wed,  6 Nov 2024 13:02:14 +0100
Message-ID: <20241106120337.475646212@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -475,6 +475,7 @@ static const struct platform_device_id b
 	{
 	},
 };
+MODULE_DEVICE_TABLE(platform, bcm63xx_spi_dev_match);
 
 static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6348-spi", .data = &bcm6348_spi_reg_offsets },



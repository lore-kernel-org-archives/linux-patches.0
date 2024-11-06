Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4F1DE4FC;
	Wed,  6 Nov 2024 12:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895335; cv=none; b=pczdB/kSRSJrKD2Bm88Ii7kHVFN/rWhgt2zE5hB05D66RcHeNPzWIcdyAgBUS9ASH09S3CfFYSzvdj0fTKKPZxQQkrnske3BTi2gxVyAx5WwIHzpjrSGKHm9O0PwjLLqRuuUkJZZWKXICgjuaR9pSXiAEVnRj3U2VQEYeNaKYQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895335; c=relaxed/simple;
	bh=h16Gz3SbG9TRbU/mmdjcZWGU9dh9wCV+N64z3ff1KGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RICKioIfcZSB9fE6a33xdb/k8k1+eTb6gbsbg9prVWUv1no1GQ9H30Hbli5bAz8wOie9w+cqfa0LdcaJ+VNetHggge0Gcnm+Wicb8zLZE4L6wNvHl8vdBhXrqZN9CLeeJkslh5T1Cs2Ysc/FFLReRWDfTkMRi83RPDd9wqWvPLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5iYgHXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5iYgHXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11897C4CECD;
	Wed,  6 Nov 2024 12:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895335;
	bh=h16Gz3SbG9TRbU/mmdjcZWGU9dh9wCV+N64z3ff1KGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5iYgHXNHmqz1vgpsvzXwQj5HKTfOhcxnDKIhOQk1kzLWXxx/tu6FnxioOOYoOveU
	 NXwhNKr5JN5npF0L+yfHFfvTWcX4cGR0V5YK3SlCgaOzy6z2Bh8I4W1zK+74BgQ8zW
	 51YHgkEfqufPt9hCq/a0qVNJo2vMxCV2qBZT2HEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 184/350] spi: bcm63xx: Fix module autoloading
Date: Wed,  6 Nov 2024 13:01:52 +0100
Message-ID: <20241106120325.491007023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -484,6 +484,7 @@ static const struct platform_device_id b
 	{
 	},
 };
+MODULE_DEVICE_TABLE(platform, bcm63xx_spi_dev_match);
 
 static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6348-spi", .data = &bcm6348_spi_reg_offsets },



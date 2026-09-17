Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B507C57266F;
	Thu, 17 Sep 2026 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660895; cv=none; b=nULQPsqYhxPAugb62hXuf/40Mgz8lLVKQuf7LvhEzfz493DSVXpvTNwHsnajil6TzM8BJDBeWcd2e5Of2mYpcojXhWLFtP1z4X1XIQ1wauFVw3AF8U4y3UJdhaUF4bf7xHRFzsvoPZgw5BCq3dtMptQ3983Gu2DHAyXEQJAZ4jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660895; c=relaxed/simple;
	bh=56xKN3kQQm+skV2c1O1sGlJxUjp54MJWCuCItQ3ZwKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+LntXQQO8TYYYbHPC8CDrpIUujZwT73POw0kjA5qagD2Zv/7S6meqYLIfdOjwJGS0f52DdftCusnjCzTRcUsULlKq2tf/9LdzYwe1yDFBDNO9iign0n4KLjt7sHx7yhJxSpIDaXVNhnLmxVBCbdZHLHGVmDksXvD5JeSNcZMng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1/bs+2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1/bs+2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3FD1F000FF;
	Thu, 17 Sep 2026 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660894;
	bh=p0N5UUmMSGj9i8p88QAJNtHBj66AZMkw1/9jKtZhXFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1/bs+2gsbbc7H/GGj02etRAkyXcSq6iXrzAb2D7mwq/U4R5Ov6otM00pzxz844av
	 06tByhAAtiU/GUF6MxUMklSK+mKOLjkwOAywXj7qrQLMzW9QvkA8QzpcmA/nEvp10o
	 anRQV2LK0YxMlGZH5NSK0QK31Q7UDA+ijr2AHApA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun T <arun.t@intel.com>,
	Vadillo Miguel <miguel.vadillo@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0014/1250] gpio: usbio: Add ACPI device-id for NVL platforms
Date: Thu, 17 Sep 2026 15:56:49 +0100
Message-ID: <20260917151552.311030024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun T <arun.t@intel.com>

[ Upstream commit 5ccb19ae1cb3620a76254db5c60121d092d9a0f6 ]

Add device IDs of Nova Lake into gpio-usbio support list.

Signed-off-by: Arun T <arun.t@intel.com>
Reviewed-by: Vadillo Miguel <miguel.vadillo@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20260410140858.585609-2-arun.t@intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-usbio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-usbio.c b/drivers/gpio/gpio-usbio.c
index 34d42c743d5bc..489c8ac6299e1 100644
--- a/drivers/gpio/gpio-usbio.c
+++ b/drivers/gpio/gpio-usbio.c
@@ -31,6 +31,7 @@ static const struct acpi_device_id usbio_gpio_acpi_hids[] = {
 	{ "INTC10B5" }, /* LNL */
 	{ "INTC10D1" }, /* MTL-CVF */
 	{ "INTC10E2" }, /* PTL */
+	{ "INTC1116" }, /* NVL */
 	{ }
 };
 
-- 
2.53.0




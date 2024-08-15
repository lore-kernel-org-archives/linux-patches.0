Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F807210FB;
	Thu, 15 Aug 2024 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732421; cv=none; b=cLCzomCV/FtKS6TVnigzBvF5bh5b3pMHRwjLTwAsR2qsoMWdKVLM4HjpbMJxp6/QJ062ssq1k52lyMj8P0bGNuLVlxv7jJ3AY5OZOZMSRA37DP/do9I53Ms90/wFjXB854RNcoGsTj/PfKcAHv1r85XvylBIVQDD1gmLr+hikn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732421; c=relaxed/simple;
	bh=eGp2SLQCLMEoaXlBue1qlmI6ODmY43tfWmLXL/yO2fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDImQT/LNxRV9KM7V4xt0Pa1etgyzBUhhF4lOxRkEd7/ur0XwrdRVnWWUd0Wm52+sjSG0kGIzCkk0vJXV3IK+wYMzD65R87ikmwUtq4CiO3F3EL2LqiFd+1AHYhACs3QYCULlf1lds14+6bHl93BHbI5N35sfaW2jw+9hOd2WBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQxM66nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQxM66nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0B0C32786;
	Thu, 15 Aug 2024 14:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732421;
	bh=eGp2SLQCLMEoaXlBue1qlmI6ODmY43tfWmLXL/yO2fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQxM66nd5M9u0eLlhDOy6/W8cQNmkrAwGwOS5rNe89mfCMFWt/TxQwJ7Dn5yQlVJR
	 QQbWXk4UPXRALZ3iDm2Hl9EMmn8ShBDDQ6NYW6RGUP7VNjhdUCK879FsgqsdpyiB7A
	 5AJzmxrc75vpBbTXTKEEszx1CeK/Eo2Szx787Ycw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 174/352] platform: mips: cpu_hwmon: Disable driver on unsupported hardware
Date: Thu, 15 Aug 2024 15:24:00 +0200
Message-ID: <20240815131925.999523168@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit f4d430db17b4ef4e9c3c352a04b2fe3c93011978 upstream.

cpu_hwmon is unsupported on CPUs without loongson_chiptemp
register and csr.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/mips/cpu_hwmon.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/mips/cpu_hwmon.c
+++ b/drivers/platform/mips/cpu_hwmon.c
@@ -139,6 +139,9 @@ static int __init loongson_hwmon_init(vo
 		csr_temp_enable = csr_readl(LOONGSON_CSR_FEATURES) &
 				  LOONGSON_CSRF_TEMP;
 
+	if (!csr_temp_enable && !loongson_chiptemp[0])
+		return -ENODEV;
+
 	nr_packages = loongson_sysconf.nr_cpus /
 		loongson_sysconf.cores_per_package;
 



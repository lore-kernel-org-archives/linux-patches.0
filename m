Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264B1E526;
	Thu, 15 Aug 2024 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731426; cv=none; b=IEowznLTnb78dkcY/jw1gQtCWac8zVYo7LNsaxrBLQrpMBu8a89XZ22vrFrI8oFOLIYd3rprlkk74b8xOPIv73b+zAhsANXW1/UuR/ncNlk9eSRIvNPgrset2a57ro+qmos2zNT9xsX+B2zdsftOW0DU8LW/WXF32Bt0LaANu08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731426; c=relaxed/simple;
	bh=YMBbXb1iFwKais5WCRCoMm0WnwsVxccB0axx9OuNf4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgdWug45rZf5nP3orFKyddusT09+ILov7jf71uhCF5+DpGmbzKoadQyZBb/hDhpkda0h5mhJQ8Pbq8/1ZtW2uerdzpI+GZ1GIQbsuBr0dDmIpK5wh4s5msSiholZD0pAgQ0PvkwYHhs0hQ8k6hWuGcwQujUKKee0srBx14J8RJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkhyn1LZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkhyn1LZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07A9C32786;
	Thu, 15 Aug 2024 14:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731426;
	bh=YMBbXb1iFwKais5WCRCoMm0WnwsVxccB0axx9OuNf4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkhyn1LZYOiA6568nkSLqsolheKGHrb6Zkyk+nn3Vo/mroJMYfGMGCTuke/Iu+OBY
	 X8proXwI64m7p46PDvEhvAGzftc/nMMIcYS1sE6Nz8VLwxlqWTgdiyY1weWal+Qpbf
	 2UiSL9+xcYxhk+xPORxWbc+M9y/23/jj5OESeKDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 124/259] platform: mips: cpu_hwmon: Disable driver on unsupported hardware
Date: Thu, 15 Aug 2024 15:24:17 +0200
Message-ID: <20240815131907.584924335@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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
@@ -166,6 +166,9 @@ static int __init loongson_hwmon_init(vo
 		goto fail_hwmon_device_register;
 	}
 
+	if (!csr_temp_enable && !loongson_chiptemp[0])
+		return -ENODEV;
+
 	nr_packages = loongson_sysconf.nr_cpus /
 		loongson_sysconf.cores_per_package;
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4D51494C5;
	Thu, 15 Aug 2024 13:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729891; cv=none; b=Kr7AwbcYbblavkaP+wxQjJG1Y3v1399uAsrJUT/olEsT/eauaPKG9+Yne7NVqRUty2tPqy6gquBHn5TLQ+rD2rhZEt27Yj53ZAsLBtyf2OrtKxUApIuXPj4p7/I7lGkzQHtUeVgzODzlOtQG7LqlU6mKdnRHU2agAj2exgn+NVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729891; c=relaxed/simple;
	bh=m5HKYlk2RQN55Fw8QrQ6WdAZb5TrolQI1I6CAIZ/iU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g73EFfWyAxqNA34uVcIm+4wp8g9lqKnExCNBoo09bmQBFgupap6fj8DpU7D6HWzdTpxg+WrqU5WxhVudvnZMKTQ7rqqP+nOJFDdXZNOsgkNDCk+xRNLzANwKR+Da+dPdqtH/5jwi7bPjkitcg5P9dzpvvyQz2i+GLp7osPMdkbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZViK+gtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZViK+gtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28991C32786;
	Thu, 15 Aug 2024 13:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729891;
	bh=m5HKYlk2RQN55Fw8QrQ6WdAZb5TrolQI1I6CAIZ/iU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZViK+gtl55ujYuw97Lizpq5XdO9AbSH+4gnC8g+I+F78H3GrleWSemZ/e1C3M21UM
	 DaUmutMectAVwVZZDvgwyamE/w6n+IgtpegN0YqPVu2JTbr9ERz9lDq0gsxiqkmm4O
	 L0FXHKbMRChX1V+lzkt5dXTDMmiXKz5N4tSmSN58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 240/484] platform: mips: cpu_hwmon: Disable driver on unsupported hardware
Date: Thu, 15 Aug 2024 15:21:38 +0200
Message-ID: <20240815131950.673902659@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 



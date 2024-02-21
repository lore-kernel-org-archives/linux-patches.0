Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053F969E00;
	Wed, 21 Feb 2024 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525402; cv=none; b=QkGjMTTKu9iMy4FF5Fj/a1zBs7XYQ+UUe7o8NmwQHpLNRfpCZWjpDLKWnOK+iYZEXapIEZB/mUFmW1ZHJcAy1Uwautss1rLu43Q8Yo6NNvNjQPJwAofKMeZ5soC7Dar2DqWN2BW3VUfmoHD+poxBKdtGoq9O645BogvJlM+vKZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525402; c=relaxed/simple;
	bh=oYumFGgQYTznrV+PU+BEBiMiWhIr6If6PBPYeTnRQwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUyFWlVfYz4MQfVwfwzliAfZuiDgOKkjRet4/NttdAdNUn0qNFbYBNpy2FwKp3VYBxY6dNJcwQSQZpvJWDS9qqmo+5D6w/SkplTuH+spimkDScuy2LRELQ1IZwASYCDWpUhfW9f2vyjDfYsqUIMQIAcpjynXQ95LePwFUAelJhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+HxzJzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+HxzJzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A18C433F1;
	Wed, 21 Feb 2024 14:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525401;
	bh=oYumFGgQYTznrV+PU+BEBiMiWhIr6If6PBPYeTnRQwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+HxzJzUn1w9+ikNgwNADowb6Q/f52UlO622xwGN8KKU93/glKLCVp4YFR0J3r59r
	 NdNIcd1axa7wMyD0N12Q1AWrpZHdikj7xmJKVHzZjAZnp7Gh0+wu13r5iFEegtuzuk
	 XOVkoG4btW7oFLwqRYcSn13kxvs+Ke5djCFLWlN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/267] mfd: ti_am335x_tscadc: Fix TI SoC dependencies
Date: Wed, 21 Feb 2024 14:08:06 +0100
Message-ID: <20240221125944.611309746@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 284d16c456e5d4b143f375b8ccc4038ab3f4ee0f ]

The ti_am335x_tscadc is specific to some TI SoCs, update
the dependencies for those SoCs and compile testing.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20231220155643.445849-1-pbrobinson@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 43169f25da1f..385db201fe9a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1299,6 +1299,7 @@ config MFD_DAVINCI_VOICECODEC
 
 config MFD_TI_AM335X_TSCADC
 	tristate "TI ADC / Touch Screen chip support"
+	depends on ARCH_OMAP2PLUS || ARCH_K3 || COMPILE_TEST
 	select MFD_CORE
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.43.0




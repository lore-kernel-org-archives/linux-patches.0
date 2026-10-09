Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43954E5356;
	Fri,  9 Oct 2026 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557239; cv=none; b=Umv0zC01ilTsIAOgT6W2kP+COdHXl/xbG67lYRtezRysxEovpwZi2xfzRCHIoOpQrBii3ulABiaSNUPGSVHLhSNq6+XN0qlEfYOz+sruaZquIvUJKITfa+yX9Q128XG8ZtMY+FXsC+2Pj5nYXe7wFD6xTTllDhNLr2blPlLMIg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557239; c=relaxed/simple;
	bh=j4DBnaaVXP8JndTZPNoTzzGB8sV8hcLt/hfsu2tlNSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8WR/FAHd1pD7Vhh6C5HnUM2ZkgPhXbpHOlOhqlwFrrZfqWLjpV8cMxa+wldlN5yDr85SVSSfYY4aZsgcv4yhC0/z5iCUzenEdz5a9rAW1kVosXlbKuwDoVV5fvm6YwXB/Y3gTxmMqklYdm8Exl1BwBnbCstY9yCcULMQtB8z2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02HPPL3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02HPPL3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8381F00893;
	Fri,  9 Oct 2026 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557237;
	bh=QaPNn9+HjGxzS0zLkdp80bROqN3pv1dlWdcDn+oaLBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02HPPL3Xe4DWp6Y/XxZhE/64GtSUa2doDUQIDZxw9MsGNCte+ndhzdk6T8fanJduk
	 cewuOjNL84VQUKCBkVO4PVPCcMSsZexlnh0JTnI/KyXTprLHVJnqzl8IWU6gOAA3ka
	 kGubfCaOrNT8xzKaYL8QlfW5xfTmaiZ1yR2Sc05Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/403] units: Add HZ_PER_GHZ
Date: Fri,  9 Oct 2026 16:12:10 +0200
Message-ID: <20261009141000.930525859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5083dba0fde5446c00ee1a82a3911c8f88a2c72e ]

The is going to be a new user of the HZ_PER_GHZ definition besides
possibly existing ones. Add that one to the header.

While at it, split Hz and kHz groups of the multipliers for better
maintenance and readability.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260112134900.4142954-2-andriy.shevchenko@linux.intel.com
Stable-dep-of: d61521056420 ("iio: adc: ad4030: fix invalid oversampling_ratio validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/units.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -25,9 +25,12 @@
 #define MICROHZ_PER_HZ		1000000UL
 #define MILLIHZ_PER_HZ		1000UL
 
+/* Hz based multipliers */
 #define HZ_PER_KHZ		1000UL
 #define HZ_PER_MHZ		1000000UL
+#define HZ_PER_GHZ		1000000000UL
 
+/* kHz based multipliers */
 #define KHZ_PER_MHZ		1000UL
 #define KHZ_PER_GHZ		1000000UL
 



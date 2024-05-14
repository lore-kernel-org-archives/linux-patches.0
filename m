Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD44A13A256;
	Tue, 14 May 2024 11:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687074; cv=none; b=GTzDM5BVS9Zp0g4gi7aPIAXVwebfenfdhvwTEshZiGNgi/porcSWp5W7hPP8tZWydHagX6rQvfkTdCp2C7iCvd5NA8d72XL4MoVw8gvRn5LUDpqDmfzoqRT+gEUVDToIMtjVkOBfug+QNKVsnF97rGS64vpFZnMwTEao+L4OHLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687074; c=relaxed/simple;
	bh=uhdHzBUGw/TgZ9hfRgtUExWz8+5Oawv4AoZJnKtwVuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCPcEb7pHxjygCK7FEigKhVpgR6IVchca/Ompcz0VplteyCnlucTvgfedWwIaIjvOkGPhGvjsI+YOn0BShgF2jr4iJvGt7i79VU/k0QQoWG41gzGZQgYIle85W3afkpeYtu1D1yxTpQrX+agBem4N7GmrHuFRjMgRgN0TnSfSoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoXuYnal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoXuYnal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603C7C2BD10;
	Tue, 14 May 2024 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687073;
	bh=uhdHzBUGw/TgZ9hfRgtUExWz8+5Oawv4AoZJnKtwVuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoXuYnalS5ztcsSl665G+xnZ3uiqS7l/BAkuKGXm8UjCLi3Qfqy3kKqvvudgj8eWc
	 h+h5uve3dzwv8pCjFcEMmT7CI5cng9BEGa/OzOFuNYHkAo3fRLib+4bSmoo+Xb6gI/
	 Qlv22Ao391O6G5/KYO0gVhAkC9nvSmEvT/tKdzwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/84] gpio: crystalcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:20:06 +0200
Message-ID: <20240514100953.754962769@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ace0ebe5c98d66889f19e0f30e2518d0c58d0e04 ]

The GPIO library expects the drivers to return -ENOTSUPP in some
cases and not using analogue POSIX code. Make the driver to follow
this.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-crystalcove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 14d1f4c933b69..8b9c1833bf7d4 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -91,7 +91,7 @@ static inline int to_reg(int gpio, enum ctrl_register reg_type)
 		case 0x5e:
 			return GPIOPANELCTL;
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
-- 
2.43.0




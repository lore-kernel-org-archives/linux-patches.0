Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CF2168C7;
	Tue, 14 May 2024 10:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683422; cv=none; b=qEKPIZKNMAQKmzQGcsdCf4TNa3ge0nZyG6bvOD0UK3Mn3PFwn0xND/HstzmDiQ14KMeLedgWcKzObhJjcST4bjUgDHDiW9A++JnH+7zJ4+7bVm5k0MXqMO625dBChlvHAa3aBj08SVqGZUfTP7gUTkFqW4lHcjaJVAQ2K50IReU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683422; c=relaxed/simple;
	bh=H+FTk8DH4mEarzjNJ/4zYSrq2BDlRHmJX4psShBBtPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwEZqyo4YODDALmr249dGLA/x/Vr6R0AzVmu/ViivLWMJYqwd0mF9X6hsYXGCYmh4Sbprjw9J7+s52ytA26BM2tucjjD/Bws+wbTh1GDvF6Si92JyBxMsTb1ob+ua2W0Fz4kEhkaSSuaLWKJE1Oo3iGX/UEWQdaynOegSmVe9TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKAtPOWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKAtPOWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1680C2BD10;
	Tue, 14 May 2024 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683421;
	bh=H+FTk8DH4mEarzjNJ/4zYSrq2BDlRHmJX4psShBBtPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKAtPOWXdczHykzD+mlTug1vqZ53wtMMHAguetCgzUS8idwHJfZC/iUg0Da23cS1A
	 P6CcuzNxPOO/ymz4AIshHAhX7aYAFVjnOYGC5czWCETPTxb2t9LbXFOFMXwNHNWo7z
	 iA9JH8E5uZivl+1sVKAUzh9crzYa4wZvWMrYoo5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 183/336] gpio: crystalcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:16:27 +0200
Message-ID: <20240514101045.511442390@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 1ee62cd58582b..25db014494a4d 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -92,7 +92,7 @@ static inline int to_reg(int gpio, enum ctrl_register reg_type)
 		case 0x5e:
 			return GPIOPANELCTL;
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
-- 
2.43.0




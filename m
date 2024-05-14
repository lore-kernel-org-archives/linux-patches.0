Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3A14205D;
	Tue, 14 May 2024 11:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687354; cv=none; b=E+15Oed46xJvRkedvola2YO6cYaWMRsJQq/EohQVoXthmskhcDsT5BIzQtQQBs6Le0ajE8Q4d7vj3hyjVzayub8qY4tsIbKT7TCfqMTT3oyFB/b2ev5fpar6hjkVQKs9njuQbnd4bgtxiwH98tQilWhU9TttOu8cn/ROg1s/Sbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687354; c=relaxed/simple;
	bh=866v8iD4QyufnQUZjA63Okrc8mKxgV0vlneY5hovnTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3KWtJ4La8IjhrW/dz/r9ogw0hrBJyX6iJaLZQQcbGNnhLQzUSx47UWnFRAVQS4z1OkzglLCUaD6A7DbxEmIrDa7sVsGWLNnCRT/mADbTHpRCZNhXMjPXwGoyEZLeWhOZxWiiHMVi8TNhE5EXSeFiKm6UwApaghmzO8EaU3MRrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MI1BwbYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MI1BwbYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03C8C2BD10;
	Tue, 14 May 2024 11:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687354;
	bh=866v8iD4QyufnQUZjA63Okrc8mKxgV0vlneY5hovnTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MI1BwbYroOSAL88L7TjnlFEwtffrvY4bADORgW5bhG8KqmQn4nvohj9dz8AyH+N7N
	 wuA/Fosi2T5yjuG9mfv1OM1On5d23pAA/OkPPOeTyAurJ4u/V3eLAYNzV8Bm4jGAzJ
	 84xTNaPLF8tHxFTEcf+VXcwJWoVLjUiTCbaAiXP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/111] gpio: crystalcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:20:06 +0200
Message-ID: <20240514100959.718459459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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
index 2ba2257200865..0f0b4edaa4865 100644
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




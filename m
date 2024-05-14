Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49F413D2A1;
	Tue, 14 May 2024 11:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686845; cv=none; b=opyQqsvmRUyON3kJYrzkbkuFUjxnUbCc55zVtVto5e/FC9rsBUQJlYNiXxmbW7LtomX0DCuu5Tw4mYWMTiNR76tcKwYYz1IUBxdTyw3SWMJbonIzZjLpBh8KdVcpnSQLNaziK7VCproJOpRzzg2GQ2ypiUHZhlQqWxzIHanPdQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686845; c=relaxed/simple;
	bh=iF3JVKe2B51ZnzdzY0isQpITVxNrfgL/v9XAL468Vx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpWS9mO+Oc930FVQIflJAT+WzPMQGuMA7N8qFAudIIfU8gGPpCrbe7TLRsK161t6NLO+6sT+Ez2g9IFTkJuIf3s32cZKYeaQ2X60JGKp6/9Go+vkIbncS9aMbVjW6JjFv9vO0OxAjy5AHk8Ktx5LgA7DoqmN2fcxupN5smVAhGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7KQhc7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7KQhc7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6C9C2BD10;
	Tue, 14 May 2024 11:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686845;
	bh=iF3JVKe2B51ZnzdzY0isQpITVxNrfgL/v9XAL468Vx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7KQhc7mRG0trjU7zO9uMKJ4lHW7f7rkr0dPfmAsaPIFXwLVRW0a8RFZXWrawlv0z
	 +vU3AJgDjfIwn4M8MzS4OwIeUUVzwvAXxtwD742wIEeEo5+xgaglgoIJiENcwzG/5H
	 4MFSA72UJTnQw96Y5NG33BCMhft5++A9PVR4gOYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/63] gpio: crystalcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:20:02 +0200
Message-ID: <20240514100949.566198278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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
index 58531d8b8c6e4..02da5113c0f2e 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -99,7 +99,7 @@ static inline int to_reg(int gpio, enum ctrl_register reg_type)
 		case 0x5e:
 			return GPIOPANELCTL;
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
-- 
2.43.0




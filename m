Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D998921ADB5;
	Mon, 23 Jun 2025 21:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713216; cv=none; b=j/Q3Paq8tcAYC9cjnj/93kQl45LY/kGL33PBby1TBoqWDGAByFaF+jQpY6HAiOp+EWW9gtNBLd69LF80+duvLTqEKRgDj+F1tg3mgfRbkHrZnmMoOuAp1AbOWqxOVtLaI1NPrQBDQExtNXglFukPFGdsFXA2B3prVaaPE4pRSmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713216; c=relaxed/simple;
	bh=oVYHCcjC3FeKZenQVu96hDrZC7M8+yI3nSzKK/leF6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQtUP3lct+7i2+WhuYjXAmPk/hBMes/fNPbgHjSkiMOmv7Q6OHGf7xBe4U7jo6TNRvvABEvD8hGx6O6c+vvsrHMxJGdw2eZUugWQZUlx1/85mukz2hV/ltgDQIm00IinMrzAeS5aBdPsHfENXeFSYwocrHGKX0mUkp4m5DjP3VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLkjVng0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLkjVng0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF74C4CEEA;
	Mon, 23 Jun 2025 21:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713216;
	bh=oVYHCcjC3FeKZenQVu96hDrZC7M8+yI3nSzKK/leF6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLkjVng0ubVFQdQ3jQRGH1Bz87pSo0eyhUSaAP6NRLWJvF/I7T25YXv5yepGBKvwc
	 NlX9XOZss2vMQqwTqsVYfdJqkHPo4Gs7U7F1lkWj4+JA0xxoioi7vOppQGj4+LBMK1
	 yJ+YfqJam4UrmNBAzoq9DQrRJWNDVMaQxr4xFOnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/411] vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()
Date: Mon, 23 Jun 2025 15:04:15 +0200
Message-ID: <20250623130636.319587738@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nicolas Pitre <npitre@baylibre.com>

[ Upstream commit c4c7ead7b86c1e7f11c64915b7e5bb6d2e242691 ]

They are listed amon those cmd values that "treat 'arg' as an integer"
which is wrong. They should instead fall into the default case. Probably
nobody ever relied on that code since 2009 but still.

Fixes: e92166517e3c ("tty: handle VT specific compat ioctls in vt driver")
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/pr214s15-36r8-6732-2pop-159nq85o48r7@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt_ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 58013698635f0..fadecf3485862 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1103,8 +1103,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 	case VT_WAITACTIVE:
 	case VT_RELDISP:
 	case VT_DISALLOCATE:
-	case VT_RESIZE:
-	case VT_RESIZEX:
 		return vt_ioctl(tty, cmd, arg);
 
 	/*
-- 
2.39.5




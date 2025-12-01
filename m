Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CC83081C6;
	Mon,  1 Dec 2025 11:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588481; cv=none; b=mYxUAbOaULjNzQ0dQDQQIwtSt53mg26t6Ay/eC1jfG2gTf8iSDDjIljkZQ0ornVNCHIhoUrTFytGv60j2XbVM3BuVLzZiEWC7ByLB2TvOwpAyH6dlPCzmjZKO/98ZEdLQiuvfz++nSX9vrtZdOqp3vTjvbMYBPaY9V50jEx2Fd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588481; c=relaxed/simple;
	bh=bAdCD7G3Ui46TMqiDZZy0qZg20J2ciEtUX8fV9bShrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9dONRMYgfKVy6JKkL8qK7kX4DrioE72jMkHfneBxLUE3+ZYm3Ltahu52PxJ0nNfC9S+X3zsBmIlKsMd1017Ud+x8eQKzaikgG3DjRahC65x84jhyNQ2A7UX2b86PAx238u5ATtLiHfuNMB8F+7nZqBUpH8CWwxeNZSfQ/D5Ag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQT708JH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQT708JH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4A2C4CEF1;
	Mon,  1 Dec 2025 11:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588481;
	bh=bAdCD7G3Ui46TMqiDZZy0qZg20J2ciEtUX8fV9bShrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQT708JHpIJMyd3AiWn0jywPinRp1ku8POcf7lU2QgivY6nlSnAcG0RxQ4WU72RWL
	 RJhTYX73DapGzDvVxdngjUYa13wp7ogHz3TC7hk9QnoLEvFgoYP/90zxlyZqKKgHe8
	 ZrblLgngcgZnj3hdS905M4B0L4fY6yT93xjYKAA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/187] mfd: stmpe-i2c: Add missing MODULE_LICENSE
Date: Mon,  1 Dec 2025 12:22:34 +0100
Message-ID: <20251201112242.911873589@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 00ea54f058cd4cb082302fe598cfe148e0aadf94 ]

This driver is licensed GPL-2.0-only, so add the corresponding module flag.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725071153.338912-3-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index cd2f45257dc16..d52bb3ea7fb6f 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -139,3 +139,4 @@ module_exit(stmpe_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMPE MFD I2C Interface Driver");
 MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
+MODULE_LICENSE("GPL");
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E9E1DFE25;
	Wed, 19 Feb 2025 09:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956069; cv=none; b=kGlosE0nspVJMOvM3xuNXE6TcfAq20xA2ju7K+ZQVibxFaXix4qB9e6w5q5GVp3LZ7wX/BH6S+vDhVsba7TGVkieEGAyNRNguPAu/wPAWqulXzDrU3Mj12j9j3Z9Pbk/VhPyiM3hlIvPRD4vlxIjLebgSEBDxGTCUsxFIYWTsLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956069; c=relaxed/simple;
	bh=1JzB/313ZrNoCVRQCsP6ygDGZ2fwRbjtO/Nf40gR3KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5Il8HNsSdb24eAcOX8PRScHhwuxp0YLFKkM6uPogFwNp/uOf7radm8yy6/PAJGiHLTOiHktGxB8AyJO0/MAmU4vBIa5zRTY4sx15zwCBG8fZY6MWLYRBjOqrp7WVerjTNvXHf3L9xbuR0EdCrKQ+oagCQNHnPXcdRdONBWAgaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VQpQ7sa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VQpQ7sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF23C4CED1;
	Wed, 19 Feb 2025 09:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956069;
	bh=1JzB/313ZrNoCVRQCsP6ygDGZ2fwRbjtO/Nf40gR3KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VQpQ7saSLqecxcXcGLf+GuTJCq/jf9syoEebW60pLYkm9EZByz5u9Oc/KhRiD6L1
	 LDTKoEY1DIx4jhHNso00FzAEou7yX4RPbiUCIc7b9my8xpgb8JPDheGzzTgd/ET4Wg
	 r1OvadQu5tS51ygaFS7sr1dSqopH7SqOdE/QKgZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	=?UTF-8?q?Ulrich=20M=C3=BCller?= <ulm@gentoo.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/578] HID: multitouch: fix support for Goodix PID 0x01e9
Date: Wed, 19 Feb 2025 09:20:58 +0100
Message-ID: <20250219082655.017327304@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 8ade5e05bd094485ce370fad66a6a3fb6f50bfbc ]

Commit c8000deb68365b ("HID: multitouch: Add support for GT7868Q") added
support for 0x01e8 and 0x01e9, but the mt_device[] entries were added
twice for 0x01e8 and there was none added for 0x01e9. Fix that.

Fixes: c8000deb68365b ("HID: multitouch: Add support for GT7868Q")
Reported-by: He Lugang <helugang@uniontech.com>
Reported-by: WangYuli <wangyuli@uniontech.com>
Reported-by: Ulrich Müller <ulm@gentoo.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e62104e1a6038..5ad871a7d1a44 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2072,7 +2072,7 @@ static const struct hid_device_id mt_devices[] = {
 		     I2C_DEVICE_ID_GOODIX_01E8) },
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
-		     I2C_DEVICE_ID_GOODIX_01E8) },
+		     I2C_DEVICE_ID_GOODIX_01E9) },
 
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
-- 
2.39.5




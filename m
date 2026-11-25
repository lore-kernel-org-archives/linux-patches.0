Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618934;
	b=gGdG8MCl81rm1tU71NH+vPVyClrvF3oiHLTJG+WwyZ5vLeoPRLjRjLKYGjMJkStmeIWL
	 lBZN1MCSWr/eTn1tDAVCuiSM2RNgAHh15zV3GWgDcW6ZrcTA5g0ZIGFKWSo1IvwVg5U9S
	 bcpLMhK8cKHJOBkws13hk6qt4DR/sA2QcAF86/aft25yMoqfgX97cyZmbbel4tUrpzi0j
	 5AWlJyN3jr2RhbavGiPoquBdke99/9g38EP8Wupit34T1C3TrPdOb3GKCECOKQ9w+C23f
	 BRzGWSFz+/HHdKVDJCWZU9HkmLsfFIyKQE4uUaqpW1WlC8wEy1SLpz088OUGkoglfBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HZYPwWrXHvqrhOirEL85I0QqLSFfZuLhp0b6bN6zUpU=;
	b=e10boWSqkPT5UYuo18KkO6bYW+yE3eJAeM+JKMOU64BpCHPDdWJjr4wJQo9SAw3xePhk
	 NRERh+1maD0tYYmQBcHCeX7jMeBk6qeE3S5zugpWhFEVrrMx9Wl8WcJA5yJTAl1TVvg6P
	 Rs7sNwR0F9cox6ZWoqaaXB3KbVwzlfTfWkONdnQYjQvHlVSqCmfvLmicnKFQNZO8p8Ecz
	 yv3qcGBqYfTJo4931MMKQzKwzJU2J0G0o3C02Ev8PoH5L55zvN5/LvqxTvz5foX6jhrIf
	 wl+VtwbCK5RdytvVgEQ5VCTpw7murgBD7Do8hD4HnOLKH2wXohkwNeuGYw0IJM/aung==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZsEJKdzm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9517606A321;
	Wed, 25 Nov 2026 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZsEJKdzm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE3A1F000C0;
	Wed, 25 Nov 2026 15:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618934;
	bh=HZYPwWrXHvqrhOirEL85I0QqLSFfZuLhp0b6bN6zUpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZsEJKdzmYxelPJmWqMMsN/oy7mc8GLOGp/F1YQJNjtJ5dcu4dvfKF5lt0G9T4UNQY
	 QppIDYcCGmmV0DyyGDFHTTEdMJfCbCfF1YbOz/ReEYNw27nAYtfoILj15olie3vjti
	 /IW0wICzpfFcXSLNAr8nUcJl/ugNHZ48qw/1IKTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0408/1005] gpiolib: fix fast-path cancellation in gpiod_get_array()
Date: Wed, 25 Nov 2026 15:29:06 +0100
Message-ID: <20261125143831.309803848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 51c85306270972f672737dc5e28332e2b41b26f1 ]

In gpiod_get_array(), when a pin on the same chip is not in hardware
order and the preceding pins form a contiguous block, the fast path is
cancelled by setting array_info to NULL. However, descs->info was
already populated with the array_info pointer during the first
iteration, leaving descs->info pointing to the aborted array_info.
Consequently, subsequent array operations still use the fast path with
remaining bits set in the masks and wrong hardware pin numbers.

Clear descs->info alongside array_info when cancelling the fast path so
callers do not erroneously use the aborted array_info.

Fixes: c4c958aa64f3 ("gpiolib: Fix array members of same chip processed separately")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/20261105-b4-gpiolib-free-v3-2-bb47ad58642d@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 3d2b2919dfb71..e5cf5e2a795e8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -5287,6 +5287,7 @@ struct gpio_descs *__must_check gpiod_get_array(struct device *dev,
 			 * hardware number is different from its array index.
 			 */
 			if (bitmap_full(array_info->get_mask, i)) {
+				descs->info = NULL;
 				array_info = NULL;
 			} else {
 				__clear_bit(i, array_info->get_mask);
-- 
2.53.0




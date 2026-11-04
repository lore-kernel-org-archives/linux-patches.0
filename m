Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826831;
	b=UzkGiYIn8N0DFcfhWMAykjnSiguE/bzEZHP+GkzlgsRC1q+/iM2dV/K/sOEa6xINYRK/
	 ElRitUUbjj+nbMVBZWntmc5+/c9gDPlzVcJXgpfj/x3xXvnCF+uslPBEg638z7Te/YDdR
	 kOLNaZu1KlkKkn/6jMf7SU9MZPP2D8yRIyYWgteY6Id8O57wIkvS77GNkCLysRfGj/Qxy
	 Jk5tvs9+R/NqMKT+CEbejha6aDKsH0dePhZh7CyNEihlHRexoxlwc7v3i44bUo9sud7x4
	 RqJlLkFjBZ2nU0gQ++OwXL+7Nt+/rGzgY0Ly5lvH8/nQmnN2ZbMaHka7lE6V81Bo4Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tAAkYG1LegUGH8wAZ6N9sW1GKLDLqURq03ED1oepuRQ=;
	b=2aC/pZdJpL0xuTxzjC1TbepmeIZRvnPI7NukzCyCMrQuWdptwA1rgnfj0ecGaobdxhIM
	 x27kGgljw7dmxAEAM4IvXeMf6mTusd4bEhFEd00Xq3SfRyVikQ7fyL0QdpZoz/JwqF8wN
	 MtZotTqzoma3x0qbRK/BxjuoMXrrBc1JIjM6LktFRntJ0lXumbKaN3EVNDeZmVmJRh7j5
	 O8BJ7GL00Zevn6CZvgXNV5lV6LNnLlzUYOqU3cOrL5bjlA2mCjjXuZn4rUS0Db9R/FyzH
	 WjqK+uuETICEbzJIk+YsQpTeQInJu6cZBh8R2bF7CjmuatHsD5ToWFgDGBC0LaRLGZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZDUssJV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ADC6072640;
	Wed,  4 Nov 2026 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZDUssJV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40921F00A15;
	Wed,  4 Nov 2026 21:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826831;
	bh=tAAkYG1LegUGH8wAZ6N9sW1GKLDLqURq03ED1oepuRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZDUssJVkUUs6sZbzZKf7XAxzPWIA2aDGM1bm2rZ2M7Qb5+qkEox7hQpQt7QoYXp0
	 k6922o0606ZQd3FXm4MRn5pkV8e9l5mpT0edqge2UlEfFxJbXJjxjAdBvq9CfMAaWM
	 OK6SAKy/OR5MXVmKtqXhKgebNgQhdcjQrzxt2t4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 016/547] platform: cznic: turris-omnia-mcu: Add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 16:03:20 -0500
Message-ID: <20261104211038.837934606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Ridham Khurana <khurana.ridham222@gmail.com>

[ Upstream commit 59797443846bc2451c35816026bbb79d281c9f23 ]

The driver wires of_omnia_mcu_match into the i2c_driver's
.of_match_table but never exports it with MODULE_DEVICE_TABLE(), so no
module alias is generated and the module is not autoloaded when the MCU
is probed from the device tree.

Found by code inspection. Not tested on the hardware itself; with the
module built, the alias lookup

  $ modprobe -R 'of:Nsystem-controllerT(null)Ccznic,turris-omnia-mcu'

reports no match before this change and resolves to turris_omnia_mcu
after it.

Fixes: 992f1a3d4e88 ("platform: cznic: Add preliminary support for Turris Omnia MCU")
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260921204204.797294-1-khurana.ridham222@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/cznic/turris-omnia-mcu-base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/cznic/turris-omnia-mcu-base.c b/drivers/platform/cznic/turris-omnia-mcu-base.c
index e8fc0d7b33434..f0416302a1f3c 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-base.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-base.c
@@ -403,6 +403,7 @@ static const struct of_device_id of_omnia_mcu_match[] = {
 	{ .compatible = "cznic,turris-omnia-mcu" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, of_omnia_mcu_match);
 
 static struct i2c_driver omnia_mcu_driver = {
 	.probe		= omnia_mcu_probe,
-- 
2.53.0




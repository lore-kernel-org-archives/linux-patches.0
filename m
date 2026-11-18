Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029274;
	b=Ixa2UOhTY0cyphNWcwF0A/a4JRUjxEP80nw5JmdIkjGJ3E3Iql2gaScVXZQl8DHnPI6m
	 GxkE7NZ+pMgDlHEFl642jywUgY0rGMe6v8KX6n+OR8t+rXRGENyaHHX5lB77j+HHfqOZM
	 uOAESwnvu6nH0t2IChx+6zvmN70oAEt5ot6aHk/v6fUpC/423x4L82Kq2RpfepAu7LnTj
	 1DYE9M8kMA9/rVP7KItX38sdvAg1Il5aXu07n7JBM7c7cPbC4msvUYDAeAjeloX0LKnqa
	 iscmdpGrPQSZFEVwrfI4YMq7UJEBks3nX/apyqUIWSdhCdjZIczRxPljAGJn2APuNMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zB0jQZzUrjz7t1Jd4k6PZsQUcd04iozps09JA1L4Qro=;
	b=cY58XwziEDdYgn5tTYPDn5zPSV280Z/1PFazpJ2HXwrKF8Q62JZtWuBwDwiX+pv5DoYO
	 6Ur7xeURLJqc5FbMYbtJR45y5BCurMKtMvrX8ZGlwAFt5nSyeMxubssPWAQy4gsqjj9a2
	 iv8wPQKNIw2cmfc+AEYxEe82eHDgI7n6mCBokFuUkclJjOTGMBtOEtrDIglz1xdOp6ECR
	 Q9PnSK5hgY6tZ43qpDV1V2aH8yc6+SBYTJzjfaVJFtcaZ/opOOjuNPG1nyR5DL/Ftj2gs
	 U8BdOM5JW26T5tqVH9sxcEDIpJdOoUlhohf8KsGKyvtLEdPygw4yk1gHDxdSzD/1C9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Za+83V1d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF19606A325;
	Wed, 18 Nov 2026 19:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Za+83V1d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA241F000C4;
	Wed, 18 Nov 2026 19:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029274;
	bh=zB0jQZzUrjz7t1Jd4k6PZsQUcd04iozps09JA1L4Qro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Za+83V1d9G0YwPUOmoUslhkDQTpsOJq9lHqRiGln2Ryy6qo37GRDzzQ65zgPJYfEo
	 FXj/uheANSxoquS9bCwaAb2yV0zqJc+GQrds+3iAZy96T8BDisOmBaQEyHZA+L1SsI
	 UDFjoq1HslEi7/Svlaspx/4ghjuQHcgAQ6+I5aY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0292/1756] power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document
Date: Wed, 18 Nov 2026 15:40:19 +0100
Message-ID: <20261118150020.001978180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 1101833121a447999309a01f03d5b35bc1652e09 ]

drivers/power/supply/mp2629_charger.c creates the attribute with
DEVICE_ATTR_RW(batt_impedance_compensation). The ABI file documents it
under the truncated name batt_impedance_compen, which does not exist in
sysfs.

Use the full name.

Fixes: fe27f04e0cdc ("power: supply: mp2629: Add impedance compensation config")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260905101849.42830-1-kmehltretter@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-power-mp2629 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power-mp2629 b/Documentation/ABI/testing/sysfs-class-power-mp2629
index 914d67caac0d7..a85f926ce9c26 100644
--- a/Documentation/ABI/testing/sysfs-class-power-mp2629
+++ b/Documentation/ABI/testing/sysfs-class-power-mp2629
@@ -1,4 +1,4 @@
-What:		/sys/class/power_supply/mp2629_battery/batt_impedance_compen
+What:		/sys/class/power_supply/mp2629_battery/batt_impedance_compensation
 Date:		April 2020
 KernelVersion:	5.7
 Description:
-- 
2.53.0




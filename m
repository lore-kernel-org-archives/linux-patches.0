Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040713;
	b=h9SToy57LxvRWtzl/ItxpgQK4tdQ7wXi8mNidnUU3IkP4xz6GabZdMuPLX9MFYpcWPH3
	 jeieTHCVC/gzCrk9QU3kcCXeB+/rOf8dLYdS2ebOi919wi0CWvMYx9Qx/MTRaKcC53h5k
	 ic+xEUfELM68kBzD9YuTTuTf5M1x6s582ox1sEREHq77vFU5LCVN0a74jyw/DNeHksJzE
	 W/GcYhpxKbmLq56Gvf+EuIrLhCEqRwdlZnXar3a7tFERGuri/U+kUmQUjvvw49Tt2uEhr
	 gxf0fOnBhGnMroIo/TYwR4+hQDjCD44tPXYcDfez2w22ixTt4He31Oy22t+FQx9ywLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FZwlxpRzhuSV/WFjbuoHIMHXFWQNuhJ4rD+ojCr0mcA=;
	b=M5NjsajPs2UYwz2Ri60/rhbJHRmKhclgzkrMR0L20kfTyFq6Crd2+j8WdkFeilU6TPTM
	 dxYQ1WU3NlRyrQAdiKKd8LPdOzYjQfjIiXxsD1DiiAibwNS2oP2OsKUKSSCunfYkLXxIj
	 ULda9HZ5X/hbT1udp9N+oaQz7LJHMgXuX5q+Bn//j25mumGQgcz7y+9UEfhNeZFjyqaE6
	 SN9rqoRX0RrfEWN/47jBS0282HmH8FSbIsaQ/8hZ7eDI0WTPW750VeImgpHtmp64wh3t2
	 wpB0sGzfVKso55LkV/kL980ssefV4BBjin8EwZR/Ed0jRW9reAO9qP8om5RGaBvoBdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OX8wiQ96;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB17C606A32C;
	Wed, 18 Nov 2026 22:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OX8wiQ96
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2A51F000C4;
	Wed, 18 Nov 2026 22:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040713;
	bh=FZwlxpRzhuSV/WFjbuoHIMHXFWQNuhJ4rD+ojCr0mcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OX8wiQ96vxf70DrEBaovv9Y6tZT/fR1/mdPhy0jTZcX4ZyFcN4qqkNFZOsrisGdyz
	 ZJ47KnPna7BFgB0eL3jzbADzueNywysUfaQyp9AHjuqKNv+cuw3YLADpIDYV7yP5bE
	 3jbh3bADXlCXovm6Lwtc8fC141NKJp0vOM4vpzX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2556/3318] power: supply: ab8500: Preserve battery termination current
Date: Wed, 18 Nov 2026 15:52:58 +0100
Message-ID: <20261118150437.954052316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 3b33eda4067494658d51db0792377fef98787e3f ]

The battery-info parser uses a negative value for an unspecified
termination current. Testing the value as a boolean instead replaces
every valid positive current from the battery description with 200 mA.

Apply the default only when the property is unspecified so batteries
retain their described charging termination current.

Fixes: 9c20899da46b ("power: supply: ab8500: Standardize termination current")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-6-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_bmdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_bmdata.c b/drivers/power/supply/ab8500_bmdata.c
index 3e6ea22372b2d..0a6ea935fdc0f 100644
--- a/drivers/power/supply/ab8500_bmdata.c
+++ b/drivers/power/supply/ab8500_bmdata.c
@@ -174,7 +174,7 @@ int ab8500_bm_of_probe(struct power_supply *psy,
 	if (bi->constant_charge_voltage_max_uv < 0)
 		bi->constant_charge_voltage_max_uv = 4100000;
 
-	if (bi->charge_term_current_ua)
+	if (bi->charge_term_current_ua < 0)
 		/* Charging stops when we drop below this current */
 		bi->charge_term_current_ua = 200000;
 
-- 
2.53.0




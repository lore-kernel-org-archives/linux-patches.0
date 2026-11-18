Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023991;
	b=4iiHQff4jRm4cSIqn/HC+WEP6SN9ZhMid14Gih4GTvaoPXuIchHeGwZbCdraa8GaG4LE
	 Qv0cmOw7uuNp9tlU93D2w3FAEfJmroOL8krqwBkqe4q9upOvKnm9qKLQUFwUJpJsrDGNQ
	 nityW7KQk+6F4QSmlV5UMnHE3MRgRfv++5QrLz6UlE6mLdFggKXM2jfFcPuOxyd7+tAjr
	 NbwH7xgv36TGl8X+wVcKD4sxYGksC9CFg62MtyLd8+uuJExIwMhiacTqkxS+UJAovwEMj
	 tHvgjG2osQtmMG9P13z/RyxhaRugeORx/VT9HEyHYPYV83ypPbzz6nT3obKVYM07+1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kWCR/4sxFFB9Jwa2CmbbmaQuAtISVVfcYXhyJ7X6gy4=;
	b=ehXSWppqX3P2Q01K/y0tIXLomt2Yci8o67aQcnKh5osiqZ6W7ELO51QDG0Q5XW33ZijA
	 nW24+t7vDC0QXvcySizH1vorvr/GkYIA1NWirIhXoQSWH6DbNj7l0b+8fJL/vCgGqgpjC
	 G3NuHnxyheZqWPUpQjlw1G1hGqcIuJhjI6Aia+VC6+pmxToWwLGq6MPBDn5hA5r6kd4Yw
	 yuWu5DxuTVYqYPu5wLuXRvb9Ey260aoqgDFZ3S/UMXWgvkXkLKg3LhI5zKhcxWSUhrAZj
	 pyyIom8bn7ciaKPLeUtrXJnD8dzbhYR7hydyg9jL6DMvrtWMtPssaBgkNLuWZQfdI9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AMtRL6hZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849C3606A320;
	Wed, 18 Nov 2026 17:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AMtRL6hZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FECF1F000C4;
	Wed, 18 Nov 2026 17:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023991;
	bh=kWCR/4sxFFB9Jwa2CmbbmaQuAtISVVfcYXhyJ7X6gy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMtRL6hZ6zd1FHRgwX7L0Y18wGFOCKi+IYDD47OATCDaqfdOpMeJ5wKY+ALJ7lXC+
	 CyhhgPCc+nEcO1nyrEV0A+VRLkj23t/8zIHvgEE1OnmZM+u9jupNP93kkOhRNIGJMD
	 DisGXRcHUtbCFW9qFT0ldo5c7UkWKclkcCpjGm18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0559/2151] thermal: renesas: rzg3e: Remove stale @trim_offset kernel-doc entry
Date: Wed, 18 Nov 2026 15:38:14 +0100
Message-ID: <20261118150142.317695741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Madieu <john.madieu.xa@bp.renesas.com>

[ Upstream commit bf746e2a41efd98668c97759e06d436ae5af5a82 ]

The trim_offset field was removed from struct rzg3e_thermal_priv but
its kernel-doc entry was left behind. Remove it to fix the mismatch.

Signed-off-by: John Madieu <john.madieu.xa@bp.renesas.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260409125916.2244241-1-john.madieu.xa@bp.renesas.com
Stable-dep-of: aa1bc39e45f2 ("thermal/drivers/renesas/rzg3e: Fix runtime PM handling of compare irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rzg3e_thermal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/thermal/renesas/rzg3e_thermal.c b/drivers/thermal/renesas/rzg3e_thermal.c
index fc42be7f91355..b797c367ae44f 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -88,7 +88,6 @@ struct rzg3e_thermal_info {
  * @info: chip type specific information
  * @trmval0: calibration value 0 (b)
  * @trmval1: calibration value 1 (c)
- * @trim_offset: offset for trim registers in syscon
  * @lock: protects hardware access during conversions
  */
 struct rzg3e_thermal_priv {
-- 
2.53.0




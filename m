Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5506E359FB5;
	Fri,  9 Jan 2026 12:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960101; cv=none; b=R5YFQxvxXYfqJQ+BuBT1EZOUExDBMnZp8sf7jM0EC6xJyAGE/8q9qTPbo7DWcRU5zQlRaejjWv81fVnIHBg3tVhKzPR8T9IqlVm1RXv5MrX2eu2sY8DzCXHAb1PlMEC1EE515Qb1vJPiTwZgtdoMsrJi285aSf20z+Tlg2cbEO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960101; c=relaxed/simple;
	bh=woyb9rQUKDR6ARE7Uys+1XOTt5ngZrKtJzwn3x6Mivc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoYzDitgGW1KV5DMYtwxwPobYLbVvqrJmJ/34RovZb2bg1j3DJVLdP9oUMlfpmRsqbjmrTKMn4ySa41hHXJwQtQbvxCO3LLUlkT2PrCILmCm1XMHXSP41sDxqXvAmh+o3GtT7vc3BoOhcQIrA0rmSG5hE1qd3R0fde9GFMAWq4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPw22Yj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPw22Yj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA947C19421;
	Fri,  9 Jan 2026 12:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960101;
	bh=woyb9rQUKDR6ARE7Uys+1XOTt5ngZrKtJzwn3x6Mivc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPw22Yj1GUIdzBpnYDt0bnj3NPWolO6YK3DTgkGjUwgb8X0KVW0wdXhCwi6lZBOr/
	 j3+A11rT0/SQVWJQKQo5lEXUgvDXopfhGIGxC1zj+l2beZ3kRCh2fIlt4NCCDa8V5S
	 48Hpk+HSOTqWWiInsI/MC4kn6rDkPZme7oi7y7+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/737] clk: keystone: fix compile testing
Date: Fri,  9 Jan 2026 12:36:31 +0100
Message-ID: <20260109112143.471345110@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b276445e98fe28609688fb85b89a81b803910e63 ]

Some keystone clock drivers can be selected when COMPILE_TEST is
enabled but since commit b745c0794e2f ("clk: keystone: Add sci-clk
driver support") they are never actually built.

Enable compile testing by allowing the build system to process the
keystone drivers.

Fixes: b745c0794e2f ("clk: keystone: Add sci-clk driver support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 18969cbd4bb1e..8d572021977fd 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -95,8 +95,7 @@ obj-$(CONFIG_ARCH_HISI)			+= hisilicon/
 obj-y					+= imgtec/
 obj-y					+= imx/
 obj-y					+= ingenic/
-obj-$(CONFIG_ARCH_K3)			+= keystone/
-obj-$(CONFIG_ARCH_KEYSTONE)		+= keystone/
+obj-y					+= keystone/
 obj-y					+= mediatek/
 obj-$(CONFIG_ARCH_MESON)		+= meson/
 obj-y					+= microchip/
-- 
2.51.0




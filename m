Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018221;
	b=ysYT1eza8JRA9cpNYHaYQMAxSrG4QA+JmyDJRFabGMP+hAq/y/4KO5wALVLiuq5+qcR9
	 rgPG5Sr1zBWB6GvrYJmN6EAsoLfS0nh2oJLIe/zPrGlABbl5m6PT5lF5WsCxaRDrkiTW4
	 /ByAXcjowGmcSkiW9PWAhC3hit/g32bnV3EQTjp7lyiPjb/dKTD85TCeczdeoEaABcG0J
	 gMgN/4d26FYWy3QE0Z1WBbqLs+xC0b83/A/da0ZgBa/sz5FF4WEKNDva1FAEhBzxGTadR
	 9aeMTL9ALYFlLXjfpk4H3Bo7bMufp1ockI9AsaorSxrnERrYKh4v4FKM8P0YQ6St7JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eNGFg+0GgnkXIET7TbWjwcvehOa2KAJe3+6oIvfghEg=;
	b=YRV6eI00J5260rFOwExhDg/QyK6ib6Cg1GSTFuMWZGj+RS8WjUXDinGvRZNjCHoOa9Nq
	 s/AK+CkAbi9I0Ixm5xe1hwUvJ+jnzQCmvr+1ZvG4tW/lpuVrc0VfIQxYv5sH1gLeMXokR
	 oZFq0xk6uMG9eQ+9kS9nnXsmviqFmPuy1dJD5D/jbi/0QiuNXbE0jFisg28VaC+YKt7Y6
	 dNrDrnqvT6PK/OLG4WFE31moTDoK/HGlxuhzMaN4hVyzdCIk6VTqkmueHilXXOBeGzlD2
	 gpMBxlaT1+83HieqecCvfijcQCsm7LQypTS1NQaP993RAnXqg84iy9RGldON6GkEFzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JN/yIzQS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E49606A325;
	Wed, 18 Nov 2026 16:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JN/yIzQS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACC51F000C4;
	Wed, 18 Nov 2026 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018221;
	bh=eNGFg+0GgnkXIET7TbWjwcvehOa2KAJe3+6oIvfghEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JN/yIzQSA0OKt1iHbjOWNP8he2ZW3HwCUZ5QN5waDcKIoH4OWT376smHHTMbEUQmW
	 m+KjRSB4T3lxqaK1PvpWkR9N286hrx0jCXFRWDkV7RYQiMu2wQldrJ5yn9rU84bLcs
	 D0qf+iIhzch0tTt86FW7DCaBM/2kAyvtp2MwMglQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Legoll <legoll@online.fr>,
	Iker Pedrosa <ikerpedrosam@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Jennifer Berringer <jberring@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1162/2651] riscv: dts: spacemit: set console baud rate on OrangePi RV2
Date: Wed, 18 Nov 2026 15:40:02 +0100
Message-ID: <20261118150329.847726024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Jennifer Berringer <jberring@redhat.com>

[ Upstream commit 789eed2d8bfa83d79e24d185f736b038a121b3ce ]

Set the baud rate to 115200, matching what is used by U-Boot on this
platform so that the console is usable even when console options are not
specified in cmdline.

Fixes: bab8dea259100 ("riscv: dts: spacemit: Add OrangePi RV2 board device tree")
Tested-by: Vincent Legoll <legoll@online.fr>
Reviewed-by: Iker Pedrosa <ikerpedrosam@gmail.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Jennifer Berringer <jberring@redhat.com>
Link: https://patch.msgid.link/20260929120227.1791356-1-jberring@redhat.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts b/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
index b907a1396b21f..3844f0577c10c 100644
--- a/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
@@ -22,7 +22,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = "serial0";
+		stdout-path = "serial0:115200n8";
 	};
 
 	pcie_vcc3v3: regulator-pcie-vcc3v3 {
-- 
2.53.0




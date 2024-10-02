Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B171D26FA;
	Wed,  2 Oct 2024 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877604; cv=none; b=ruGMs7J0R0OoSbIDuXTrxE3tZzWt5STcjkefMr18pU1GivHp27xpEIC9Rw6WpKFuow2qsg39vpXKgL0B0a9N0CnTUm03sIdGrK8i4HUqPfKv7SdLokXhRlI5TLtDmk4YgThqOL04sW17BazqlCo5rdL+nOqZD/8f5yrPTzVYdcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877604; c=relaxed/simple;
	bh=bzR0BQq2/6eeqd0RQON+Y6KVbUflxn+68H9kfDkXfvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUPR7XtaCxQsHeW8y7jyBSoXIQCu7CWNjQct72R1NsV3glpWRsb1bH7mIJMTvFj4scN7b5HT/RiT/gQBAWfgvewECGRvH4QQlbh9H8pe9ZoNkoqmve4udPbuiRUgP6z2+3hYAxAZgbfagODTrlWaY2/zT5d8mrTAQkP1ho6i9uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANyjJLNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANyjJLNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B07C4CEC5;
	Wed,  2 Oct 2024 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877604;
	bh=bzR0BQq2/6eeqd0RQON+Y6KVbUflxn+68H9kfDkXfvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANyjJLNs+YX0JGESYN+Nk8xP/rqgtloMDE+J5+UxcYKcGR7CQBXC4kMKCiRsHcWjZ
	 8Jze9r1otXLJzPOvqm+m6QqBS2XakMgJYuV1et3fI0mfW9D0WfkytTo4hfDcMj2/Q6
	 z+S5xHs/0ftaTm52qyAwSFjkpfV6Bt9TOQzSEQvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 130/634] arm64: dts: rockchip: Correct vendor prefix for Hardkernel ODROID-M1
Date: Wed,  2 Oct 2024 14:53:50 +0200
Message-ID: <20241002125816.241787726@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 735065e774dcfc62e38df01a535862138b6c92ed ]

The vendor prefix for Hardkernel ODROID-M1 is incorrectly listed as
rockchip. Use the proper hardkernel vendor prefix for this board, while
at it also drop the redundant soc prefix.

Fixes: fd3583267703 ("arm64: dts: rockchip: Add Hardkernel ODROID-M1 board")
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240827211825.1419820-3-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts b/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
index a337f547caf53..6a02db4f073f2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
@@ -13,7 +13,7 @@
 
 / {
 	model = "Hardkernel ODROID-M1";
-	compatible = "rockchip,rk3568-odroid-m1", "rockchip,rk3568";
+	compatible = "hardkernel,odroid-m1", "rockchip,rk3568";
 
 	aliases {
 		ethernet0 = &gmac0;
-- 
2.43.0




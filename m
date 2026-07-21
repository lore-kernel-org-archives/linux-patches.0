Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A593F46A5E1;
	Tue, 21 Jul 2026 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648564; cv=none; b=Rgi5NLu8zerfcQ9evQTVY9tI8OZ0f0Uiq5Dg3ont0zcsra4CFrkONrXmBWnHZpGUiEgp524Kjs3gnIu/S3e/1SyYwoNiivAsGmV1+5hnWRsmQoDY+omcJ74/lo39sDeE5PFMTUdY6HJvnt1OZV00Rwi+8EAB0/9sy4vaonGOjSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648564; c=relaxed/simple;
	bh=HD/8XXsTzkCYeGjDaUirzPXH6AEXLS26r5NccKzWtoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFZRH51agdOZbVlE9ZqI6Yg92hm87qLV9YqAQfkAv+Cu03+sCzVdCz5XDPZxnv1WmhLkL74+s14h76iPUmDNjE6iBBUjyh8rABQ/aFG/Pzwh27gOEi8IUMvE4sZSgOu4NMibQjBeUMDbqvd5uLLKC2geWFKAp2tsOt7CJp5EGQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtLlggYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtLlggYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2511F000E9;
	Tue, 21 Jul 2026 15:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648563;
	bh=kHPu57xry/1U3M81C+nPyCW8zWbQtX9KUjjJDLFocjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtLlggYpmDaIzqo6oXNcK8/iquow794Y3Lko6vp+k7FmyfjFsI4hcBJTvb5jq34/3
	 zL40W11ta4RiJr81U4PUGsgVCYaHhjXadPN7ES85tOow78Zq2IiUgmN0zbC36INFWZ
	 41RWu2xtMAXuIhau+WO70GRVj6lKpcVT2A6Ik21I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0247/2077] riscv: dts: spacemit: fix uboot partition offset on Milk-V Jupiter
Date: Tue, 21 Jul 2026 16:58:40 +0200
Message-ID: <20260721152558.505534889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit 6edd9a0d32e1ef81133b8cb5b3bb3157a44da4d1 ]

Correct the uboot partition node name to match its actual offset.

Fixes: 2829823956f0 ("riscv: dts: spacemit: enable QSPI and add SPI NOR on Milk-V Jupiter")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260519041458.3287843-6-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
index db98dbfadf00ff..c47bfb1597306d 100644
--- a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
@@ -367,7 +367,7 @@ env@60000 {
 			opensbi@70000 {
 				reg = <0x70000 0x30000>;
 			};
-			uboot@a00000 {
+			uboot@a0000 {
 				reg = <0xa0000 0x760000>;
 			};
 		};
-- 
2.53.0




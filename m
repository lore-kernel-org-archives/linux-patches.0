Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7828048CE0;
	Mon,  1 Apr 2024 16:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989863; cv=none; b=cRnjqyqjZ4GfHFtyVHkoxDV+TAJpT4sjfzVZchUlcskxpQK1+TO1AV/6jh+GHHSzebaTyFNxYqB4pyIRd/9ZfGWMFsoF9CB6GSfrzms3oEyxvYlIiQOogPHJtGhZiJNyjDZC5091UkNAvrVphXhx8dQNgW5/zEFilXEAVtYHB/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989863; c=relaxed/simple;
	bh=KdGIFt49J8bg8Yta/vH8yjwJ7datniddRppMhzr82jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1RIe9cXD81LoUcy4dBuV7zXoJwMUC4Z+mxJ5kBaRAp76XcBhdPwXc8DiiyDqcn8mqMLTtqqRSdAW1PJ2uP3XOJxCGTkFI2GoanAiWFMr0AuxaEJHkLezErSXHyLXmF9vH5Evd9rrb/lD0U0+FbJKffqjnpLGqL/mQNdywrQMOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDTNCOMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDTNCOMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0272BC433F1;
	Mon,  1 Apr 2024 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989863;
	bh=KdGIFt49J8bg8Yta/vH8yjwJ7datniddRppMhzr82jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDTNCOMd6CoatL/Qdq7X7hgJcZZGsgKfLub6EcIY8sa+uPb66ksJOfLmzAmhBND2Z
	 guuVC8XVVi/zevwqWSljP7kMlRnChXmYgIRn246sC4iOWTNwkCAAuIX03wwjZz3LRL
	 V9hX4TpwBc4+EjXNy6TYK5GGFmGoIRgbtk/SMtjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <git@xen0n.name>,
	Wentao Guan <guanwentao@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/396] LoongArch/crypto: Clean up useless assignment operations
Date: Mon,  1 Apr 2024 17:43:44 +0200
Message-ID: <20240401152553.161245334@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuli Wang <wangyuli@uniontech.com>

[ Upstream commit fea1c949f6ca5059e12de00d0483645debc5b206 ]

The LoongArch CRC32 hw acceleration is based on arch/mips/crypto/
crc32-mips.c. While the MIPS code supports both MIPS32 and MIPS64,
but LoongArch32 lacks the CRC instruction. As a result, the line
"len -= sizeof(u32)" is unnecessary.

Removing it can make context code style more unified and improve
code readability.

Cc: stable@vger.kernel.org
Reviewed-by: WANG Xuerui <git@xen0n.name>
Suggested-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/crypto/crc32-loongarch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/loongarch/crypto/crc32-loongarch.c b/arch/loongarch/crypto/crc32-loongarch.c
index 1f2a2c3839bcb..1e8ff57a46ca6 100644
--- a/arch/loongarch/crypto/crc32-loongarch.c
+++ b/arch/loongarch/crypto/crc32-loongarch.c
@@ -44,7 +44,6 @@ static u32 crc32_loongarch_hw(u32 crc_, const u8 *p, unsigned int len)
 
 		CRC32(crc, value, w);
 		p += sizeof(u32);
-		len -= sizeof(u32);
 	}
 
 	if (len & sizeof(u16)) {
@@ -80,7 +79,6 @@ static u32 crc32c_loongarch_hw(u32 crc_, const u8 *p, unsigned int len)
 
 		CRC32C(crc, value, w);
 		p += sizeof(u32);
-		len -= sizeof(u32);
 	}
 
 	if (len & sizeof(u16)) {
-- 
2.43.0




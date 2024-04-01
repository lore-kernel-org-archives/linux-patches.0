Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7081F4776F;
	Mon,  1 Apr 2024 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987249; cv=none; b=a85gnf/07dGkjmHtrrOWu4USmUnxflqoyp2M9HkeVhZJhem6/cGRT63Mr6NB2qXr2qTmk3QGB/d1F2EsiGwx1eQrikpadjYF4HJH8I0YNjKW0lncSAljwgTUryF3TIUvxpZt/7IL8gCM7R7nPoQ1Q+4iLj2Za6gqvTjjQQXCmyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987249; c=relaxed/simple;
	bh=Bw6/oCFmZT4rlToPgN6LGIBfHzTTwlRNPn9tA7LnV/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMYFcczrsuQv/Etv82fQ/U+1s4sLLd/XDy/4T0DSC9FccYDrgVmFmCIeielDvKUeaO29To2ahVYsztD6TRlVOesd8MYyL+XtGQ4h6Rflp10Jma7Z9XUTDoJVw3UdGxpZ5aNaW2NbjOs6gIbHpVZhNF5TUjt7F71v3S+HLd0JylU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMh28avd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMh28avd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9957AC43394;
	Mon,  1 Apr 2024 16:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987249;
	bh=Bw6/oCFmZT4rlToPgN6LGIBfHzTTwlRNPn9tA7LnV/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMh28avd7hz2cZl5HN+RxmyA2EfMqJ6PIG0KqXruPXiyuI8dPNnHhksE6WeR9vJMt
	 caTfF0CKJkVHkKTFxA43NV2MVzHYSwbnVh/ipNFDZtb1ZfqqSiG4tCcE8VFwX2qHFj
	 LxZkiNHOHZqCwovdFj5dnWrEc25ZfbA1XXHCu4ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <git@xen0n.name>,
	Wentao Guan <guanwentao@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 200/399] LoongArch/crypto: Clean up useless assignment operations
Date: Mon,  1 Apr 2024 17:42:46 +0200
Message-ID: <20240401152555.150321509@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index a49e507af38c0..3eebea3a7b478 100644
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




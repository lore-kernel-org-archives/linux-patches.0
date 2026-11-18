Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025644;
	b=YQuMw6r/GWFsNmdWGzVK8vIkGrUdi5760IP0oHXITnENMZYRUR+jGdlS203tNlu/XWKy
	 MKOrlrsMGKSMTdUWNN/CepM8d4JGPtNxusupw8xLcd9kA9fZsgEn6EiUyhvUX8r/Lt0Np
	 Yuc1N4/jU+C0W7iLPhfbVPehAUttpuqaaxs68dyGJTOtv4bXforb7gPUBTAdi4bRhX9la
	 tyYKu5ftr3GHGHqf4MiKqiDiCbP/LH5W61sA7xpd/W6nzgvZRsEPkc28QGg7KsS69Tk+f
	 iACDZdPqMqOkMyYvFv9AEBlYxoXi8/uo3GCs0UuKGK8S+0NE4JBLiYi7PfFuM2AWr3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rl/DSCNXWO1e5wWnxXdbRwpGdZKEL0lu3Dps2IsGNwc=;
	b=gmDvKpCfhiSxtHxDag/h+Nn0Psf/6ds5/n/nSveg6tOMZ6oeFS2aR2qWWVUfkAo+fPzw
	 5KaNFCR3J/xTwIoLA8m4+Q/Tl2DLECEOHw6BxUOg/JdED1XVy4p7OpBnOS13dfMuZFWUj
	 S/Lts93SHekZimZ9m74I3b2dLpWEhyQgO9Nh66H0wf0w4wljNmElJSv4hwt1RDwJ7xNU/
	 rLwa08bZfreYbh1TrnpJTEoEwB3QjGv/etGygErh69wj4gkoPbzqYF6zx6UG9XLZW7uhg
	 to2LEzK0w+qMGnXArqnrkPgl4NLZWZ5vdtM+eDsQ9DAQhokmYRqsV9NNy/A7T8cWpcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SA9amNe3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFC8606A320;
	Wed, 18 Nov 2026 18:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SA9amNe3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9F61F000C4;
	Wed, 18 Nov 2026 18:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025643;
	bh=Rl/DSCNXWO1e5wWnxXdbRwpGdZKEL0lu3Dps2IsGNwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA9amNe3ZylM8ioyltQMGpzwL5TkneggvZP2SXoidvoDy4KJAr+73jMtrRiAD5Mgf
	 nBIlDxwnu2VeUSzICMQpO9pDQoFLKPipYXLhq0OmFakd92hO5vm4L77tGT+05wCknV
	 M70F0p9LQTWPSRuEbxzDa8MpWZTlxdeCcGVXgsiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1150/2151] sh: Fix built-in DTB build with generic rule
Date: Wed, 18 Nov 2026 15:48:05 +0100
Message-ID: <20261118150204.075576646@linuxfoundation.org>
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

From: Florian Fuchs <fuchsfl@gmail.com>

[ Upstream commit 642c9b8ee61dd492eb75b347f9e5f0ce6bf24281 ]

Commit 21bcc49974c2 ("sh: Migrate to the generic rule for built-in DTB")
selected GENERIC_BUILTIN_DTB and renamed the Kconfig symbols, but left
arch/sh/boot/dts/Makefile using the old obj-y form. So convert them as
well, to fix the build error when using CONFIG_BUILTIN_DTB.

Fixes: 21bcc49974c2 ("sh: Migrate to the generic rule for built-in DTB")
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/boot/dts/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boot/dts/Makefile b/arch/sh/boot/dts/Makefile
index d109978a5eb9c..16e281b859ae2 100644
--- a/arch/sh/boot/dts/Makefile
+++ b/arch/sh/boot/dts/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_BUILTIN_DTB) += $(addsuffix .dtb.o, $(CONFIG_BUILTIN_DTB_NAME))
+dtb-y += $(addsuffix .dtb, $(CONFIG_BUILTIN_DTB_NAME))
-- 
2.53.0




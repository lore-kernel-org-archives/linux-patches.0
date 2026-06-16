Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD8A38C437;
	Tue, 16 Jun 2026 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622838; cv=none; b=VqKDOi1fbogzpizLcctN1Fd24//fXWxMJ5zf46pnfGqyrxVbuZI7oPMVw60zm7KY+s7zzAyUTxUzSrzqLDRzAMRvLIyHA0blDbEF09zY8mOZhVdzdF8JIoWZObHPyGVxzTCuuRwtAbiPD0gzjOaZPH5g7pv0bzA7SacuwGJ/l0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622838; c=relaxed/simple;
	bh=837pyMGqmzIAzhLaDLswmZFwLBZY40zCO0egB7sA6MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4lEzU1KndPn4LwGnZgKqWPf9H2CvC2KF4bZxi4y6rlfM3FU6SFNIwm5TZ/DydIp9emt9bUUf8AZHnCR3POzcvy4y69zbYQNBwpyIGy2vnK2SUHqQMpxwkPDfKNAjrNuIGR5G8dW+8941fnIzu1t+iJXCm+j75MSr2M9QQWgHFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKbZZg2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKbZZg2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EB81F00A3A;
	Tue, 16 Jun 2026 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622837;
	bh=8wJwcOMeXFRLq0fDCAC07UdBR42DdUg2k/ET6SxC9IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKbZZg2w3z9TjzS+auPP+6XEBmmOQbZ/bKWX8Ht3WuEQBMj2q69LUvvUP9KdrsZ4U
	 7bMpoP6f9NDPDSfQdd6Xsl1vJfxmctN/7G6Md8lg+jcpab4PjL0L9jQR4AcZDEeOP6
	 mrSscY/1D+hfSS88thZnIPrwAkzdnTgH5drHAAaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 015/378] ARM: dts: gemini: Fix partition offsets
Date: Tue, 16 Jun 2026 20:24:06 +0530
Message-ID: <20260616145110.606655860@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 66ac2df408ede627aaae588d4ce7e611dd25b4f9 ]

These FIS partition offsets were never right: the comment clearly
states the FIS index is at 0xfe0000 and 0x7f * 0x200000 is
0xfe0000.

Tested on the iTian SQ201.

Fixes: d88b11ef91b1 ("ARM: dts: Fix up SQ201 flash access")
Fixes: b5a923f8c739 ("ARM: dts: gemini: Switch to redboot partition parsing")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini/gemini-sl93512r.dts | 2 +-
 arch/arm/boot/dts/gemini/gemini-sq201.dts    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/gemini/gemini-sl93512r.dts b/arch/arm/boot/dts/gemini/gemini-sl93512r.dts
index 4992ec276de92e..341dec9b636a8b 100644
--- a/arch/arm/boot/dts/gemini/gemini-sl93512r.dts
+++ b/arch/arm/boot/dts/gemini/gemini-sl93512r.dts
@@ -146,7 +146,7 @@ flash@30000000 {
 			partitions {
 				compatible = "redboot-fis";
 				/* Eraseblock at 0xfe0000 */
-				fis-index-block = <0x1fc>;
+				fis-index-block = <0x7f>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/gemini/gemini-sq201.dts b/arch/arm/boot/dts/gemini/gemini-sq201.dts
index f8c6f6e5cdea6a..bfd1e8581ad67c 100644
--- a/arch/arm/boot/dts/gemini/gemini-sq201.dts
+++ b/arch/arm/boot/dts/gemini/gemini-sq201.dts
@@ -134,7 +134,7 @@ flash@30000000 {
 			partitions {
 				compatible = "redboot-fis";
 				/* Eraseblock at 0xfe0000 */
-				fis-index-block = <0x1fc>;
+				fis-index-block = <0x7f>;
 			};
 		};
 
-- 
2.53.0




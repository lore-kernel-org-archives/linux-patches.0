Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F2A14D2BD;
	Fri,  6 Dec 2024 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498423; cv=none; b=cLzuQwnk8e2rGdy4fcXIbRukZNSsl0vm071H/4DdQV0gLxsV2ZXSaLU4TxTks+S1ITKea18yBpM1ksPLJw+JcEsGfWeLZ6lDILmTwNHf50BxoM4QBEYmYEgL9VwZoPZlgmLQGHU8VaKRnlpX5S3ix8iEuyyRvrlkVuFz0Wx/68o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498423; c=relaxed/simple;
	bh=gSU6tfE8p3PuWVQB/NbtxBID3HBZDKtffI+9rQoTzGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvM4D5M6PWIpjPJz8EDjc7ykZ/StXtmYRmNXt1MGbpzjBsXOABx9VwRiwzUUdwdWm/wEyqINNL+SyFJTLFxKJ1z99vpqu3aDJCeh5DkiBzVYROcr91WjF5MchPZWSMTLd6TVlzksXFpmsZAXUDBVu1UtQDOdWr4u5GS2h7Fem5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ks5Dy6Oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ks5Dy6Oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2FAC4CED1;
	Fri,  6 Dec 2024 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498423;
	bh=gSU6tfE8p3PuWVQB/NbtxBID3HBZDKtffI+9rQoTzGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ks5Dy6OzFVythX6PPNG95QkGvhgm0HOS+8zQhzZ6m7Uod88ESBicyzHPstJTsEabZ
	 5GhyUfoankXB1J5jXh19ECuDrKJWFGVx3Kp6RfZX9QFLMJHY9DWB5DzPCU+ZW+MWby
	 QCazgXnU9xQY33K+ZS7om0E8u9SXaB2JehZihKTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 580/676] modpost: remove ALL_EXIT_DATA_SECTIONS macro
Date: Fri,  6 Dec 2024 15:36:39 +0100
Message-ID: <20241206143716.016610088@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 3ada34b0f6559b2388f1983366614fbe8027b6fd ]

This is unused.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: bb43a59944f4 ("Rename .data.unlikely to .data..unlikely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 828d5cc367169..f6cbf70e455ee 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -794,8 +794,6 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_INIT_DATA_SECTIONS \
 	".init.setup", ".init.rodata", ".meminit.rodata", \
 	".init.data", ".meminit.data"
-#define ALL_EXIT_DATA_SECTIONS \
-	".exit.data", ".memexit.data"
 
 #define ALL_INIT_TEXT_SECTIONS \
 	".init.text", ".meminit.text"
-- 
2.43.0




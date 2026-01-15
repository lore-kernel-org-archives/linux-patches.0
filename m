Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4263ACEFF;
	Thu, 15 Jan 2026 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496216; cv=none; b=jnDd/YOPlilMnDkpR9shWca3XIbEDLD84EA8q4XLI9qD7KjHOrLRoBbfcZP9Y7E6TeRUjzRtc0zTCWDhhhdZ0MDwSEBqRJZAaSq/JLhaUoz5LCnWoxtzHpSX94M9HOIQcrdikhjpBI9Y8JlyXehyvzz3tguZ/lJ5+aizMhp16lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496216; c=relaxed/simple;
	bh=wa0p3jEafoSiT296yRGPkzamI4oW5x4cZJ86HoH52co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YuK3BZq1QldQa0D3uZqafNYu7r3eoFz1XnEdTU6IZaFXS1Xdm3Lak3yGyqP5y++pHQc1gmJwTFNUCr1ixoLxeEU4rhQd3F97sDM+AJVlm8dStTC4kIi+0rlvnMxmaGMiqf1KSAYYLcAqJZv67Ms5rD2PbuLAJER6TNqxKmn6yhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYRV8JLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYRV8JLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE4FC116D0;
	Thu, 15 Jan 2026 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496216;
	bh=wa0p3jEafoSiT296yRGPkzamI4oW5x4cZJ86HoH52co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYRV8JLSBgLjgwWv7FuRiudJ6Eb/OXa+pZ+FdAEl1dUhIGuy/ctIYDqyf5jUmhfaj
	 FB7vvBXnf52UrF+hBvKNn5jJW4Zf4DkmPbdn717J2oggiEyqBDb3d6EqTC/nnLu16X
	 2ta0KhWs0DU0hb9d8jJ7i7cita0Dm7MiMTvphs1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guodong Xu <guodong@riscstar.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/181] riscv: cpufeature: Fix Zk bundled extension missing Zknh
Date: Thu, 15 Jan 2026 17:47:36 +0100
Message-ID: <20260115164206.609662404@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guodong Xu <guodong@riscstar.com>

[ Upstream commit 8632180daf735074a746ce2b3808a8f2c079310e ]

The Zk extension is a bundle consisting of Zkn, Zkr, and Zkt. The Zkn
extension itself is a bundle consisting of Zbkb, Zbkc, Zbkx, Zknd, Zkne,
and Zknh.

The current implementation of riscv_zk_bundled_exts manually listed
the dependencies but missed RISCV_ISA_EXT_ZKNH.

Fix this by introducing a RISCV_ISA_EXT_ZKN macro that lists the Zkn
components and using it in both riscv_zk_bundled_exts and
riscv_zkn_bundled_exts.

This adds the missing Zknh extension to Zk and reduces code duplication.

Fixes: 0d8295ed975b ("riscv: add ISA extension parsing for scalar crypto")
Link: https://patch.msgid.link/20231114141256.126749-4-cleger@rivosinc.com/
Signed-off-by: Guodong Xu <guodong@riscstar.com>
Reviewed-by: Clément Léger <cleger@rivosinc.com>
Link: https://patch.msgid.link/20251223-zk-missing-zknh-v1-1-b627c990ee1a@riscstar.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpufeature.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 72ca768f4e919..2367e9755524a 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -279,23 +279,22 @@ static const unsigned int riscv_a_exts[] = {
 	RISCV_ISA_EXT_ZALRSC,
 };
 
+#define RISCV_ISA_EXT_ZKN	\
+	RISCV_ISA_EXT_ZBKB,	\
+	RISCV_ISA_EXT_ZBKC,	\
+	RISCV_ISA_EXT_ZBKX,	\
+	RISCV_ISA_EXT_ZKND,	\
+	RISCV_ISA_EXT_ZKNE,	\
+	RISCV_ISA_EXT_ZKNH
+
 static const unsigned int riscv_zk_bundled_exts[] = {
-	RISCV_ISA_EXT_ZBKB,
-	RISCV_ISA_EXT_ZBKC,
-	RISCV_ISA_EXT_ZBKX,
-	RISCV_ISA_EXT_ZKND,
-	RISCV_ISA_EXT_ZKNE,
+	RISCV_ISA_EXT_ZKN,
 	RISCV_ISA_EXT_ZKR,
-	RISCV_ISA_EXT_ZKT,
+	RISCV_ISA_EXT_ZKT
 };
 
 static const unsigned int riscv_zkn_bundled_exts[] = {
-	RISCV_ISA_EXT_ZBKB,
-	RISCV_ISA_EXT_ZBKC,
-	RISCV_ISA_EXT_ZBKX,
-	RISCV_ISA_EXT_ZKND,
-	RISCV_ISA_EXT_ZKNE,
-	RISCV_ISA_EXT_ZKNH,
+	RISCV_ISA_EXT_ZKN
 };
 
 static const unsigned int riscv_zks_bundled_exts[] = {
-- 
2.51.0




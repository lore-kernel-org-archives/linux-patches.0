Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9657217727;
	Mon, 27 May 2024 19:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838395; cv=none; b=NPE7FFD32Ori1y1hlyJT/v4CkV1fbtI7F9RjBNK1mGMUlGes0SqB0SV00rthssOO8AMBVgGkaCT1Ag1s0zeDt31sct8NPfytcDdDumrrrI8oQED9HXnZzgzuiAB6Bb7MxM7+VUDhOvkPHIy/qi6votR1o1lkW4gYZC9QmuG9zCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838395; c=relaxed/simple;
	bh=SLveVY67oqrNZUg98dT+OenlfAcErMk0R1pMViK5Flg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZF+8bnBa1RRCF0lRvl5kmC8nr1Sik4GDmQYpwl/h7D5dWFLE0K7XFoetqMIFcc8c9VlZNlQ+mgVORa2VQUxGMpXZg+13hm/vQWkggwgUND42B0g7N5DRUptlSBG0nfoevN0wrJvu73mojF926gL+1R8FSmA67yaM03L83Grs14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvhETcXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvhETcXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2C7C2BBFC;
	Mon, 27 May 2024 19:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838395;
	bh=SLveVY67oqrNZUg98dT+OenlfAcErMk0R1pMViK5Flg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvhETcXCPA0vLhUna78d3cQpLihbvaZ9DVtbzLOx4IvAGsHRyCEfJB9ZSEg3fYhjd
	 FXdEHidcY91wI8TqgcMZSyDL8KBqKPop8P7AhKckAtXgWcbAWA46rK1jwFKvEJB6gW
	 +bFxpIzX+J7Ee1Qlg3G+HELCdcEqv1SjXFYHbHlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 376/493] powerpc/fsl-soc: hide unused const variable
Date: Mon, 27 May 2024 20:56:18 +0200
Message-ID: <20240527185642.577500673@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 01acaf3aa75e1641442cc23d8fe0a7bb4226efb1 ]

vmpic_msi_feature is only used conditionally, which triggers a rare
-Werror=unused-const-variable= warning with gcc:

arch/powerpc/sysdev/fsl_msi.c:567:37: error: 'vmpic_msi_feature' defined but not used [-Werror=unused-const-variable=]
  567 | static const struct fsl_msi_feature vmpic_msi_feature =

Hide this one in the same #ifdef as the reference so we can turn on
the warning by default.

Fixes: 305bcf26128e ("powerpc/fsl-soc: use CONFIG_EPAPR_PARAVIRT for hcalls")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240403080702.3509288-2-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/fsl_msi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 558ec68d768e6..60a2c5925161a 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -566,10 +566,12 @@ static const struct fsl_msi_feature ipic_msi_feature = {
 	.msiir_offset = 0x38,
 };
 
+#ifdef CONFIG_EPAPR_PARAVIRT
 static const struct fsl_msi_feature vmpic_msi_feature = {
 	.fsl_pic_ip = FSL_PIC_IP_VMPIC,
 	.msiir_offset = 0,
 };
+#endif
 
 static const struct of_device_id fsl_of_msi_ids[] = {
 	{
-- 
2.43.0




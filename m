Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829428;
	b=hvifb04BWUZtyWDjbyMHGGuXqBBm6S33ESjegKDFk/PaTsjvxGlZRtIjjygjhUWUbabN
	 2cNXi50JSglL3w7PGecSodJ9zSEp2DViwD5LNPq9dnkPc99Ep6aAfcAQtgO5kH8bxgC6R
	 Ey4KobPw0kqGb05W2L/cekDAirC2ZgYpCys3CQRHLkJgjlTQo3pZEyQ0qxRrZxSUgpzTF
	 0MP0wqGq3BGA3eqwj7S6K0C4xk+Tl70UX3TEhXUesoPZZ1WJwgEAv+tGOxDGo5VtUbUtJ
	 O8NOUOJmtSvrYS51dYZWdVcSdJO9IcJKatxhdATxgUTgXgUniyFwNab2DKqBuvyl3iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DA0/TPGOvT+FfKC1/jxiYbkGT776i30UbcQU97MHoCA=;
	b=Jay3FKtrRhAdsu0cbM4zccSumu5/7kUoiHFQ4g/W+hmFE+eYwlAF8ZFX2rYV336kWrud
	 OtQ+8wVke4lXkF6Yu7KjYcUsbXkNAx2XL2SE5vOnQR2JO18akT+ghZK42v9X0Zvvs+ZrK
	 usKBhWqh6ZZpHDJQLHZFFSltuoEwjsTxQx9hrx/SO95vsvz6sTOUQYLlpXFOeLFbRXdmc
	 Um4Jzl8VZ+bl42hQxnNfe17l+zGT4DRA0hApX/ERSTMfTtvri+jnj0x2YWqDCC45b1ePj
	 ZzxNBZJjDDP1QF9AnBOGJd1Crk63yX+owIzqn7K6ab+mAZL+5s6RFi1b+c48wJyd6WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ia7+2ApV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880D60877C7;
	Wed,  4 Nov 2026 21:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ia7+2ApV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C57D1F00A18;
	Wed,  4 Nov 2026 21:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829428;
	bh=DA0/TPGOvT+FfKC1/jxiYbkGT776i30UbcQU97MHoCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ia7+2ApVsBaX6h+/iPheF3i/ku10PN6OKiCyOZdsro6J3lPmRB0NsSel4pFbCMelC
	 kb4XMiK08XHeTq5Ps06TPWoukc0D9OdFuqFjpk3y61AWaR62sj7U7w6kfqfGCnz1kW
	 ftOgZgICc7XE2PZgyXG1qK/XYK0s2ow9f0Hg6Tio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muralidhara M K <muralidhara.mk@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0120/1005] platform/x86/amd/hsmp: Validate _DSD mailbox sub-package element count
Date: Wed,  4 Nov 2026 15:57:33 -0500
Message-ID: <20261104211047.028592076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muralidhara M K <muralidhara.mk@amd.com>

[ Upstream commit 0d7a2664494534d6152be9bd9bf1cb1d089c67d3 ]

hsmp_read_acpi_dsd() dereferenced elements[0] and elements[1] of each
mailbox sub-package before confirming the package actually held two
elements, allowing an out-of-bounds read on a malformed _DSD.

Verify package.count >= 2 first, then fetch the string and integer
objects.

Signed-off-by: Muralidhara M K <muralidhara.mk@amd.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260625123337.886435-3-muralidhara.mk@amd.com
Link: https://patch.msgid.link/20260629155634.1807598-3-muralidhara.mk@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/hsmp/acpi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd/hsmp/acpi.c b/drivers/platform/x86/amd/hsmp/acpi.c
index 674be31654776..8f297d52ab5e3 100644
--- a/drivers/platform/x86/amd/hsmp/acpi.c
+++ b/drivers/platform/x86/amd/hsmp/acpi.c
@@ -152,12 +152,18 @@ static int hsmp_read_acpi_dsd(struct hsmp_socket *sock)
 		union acpi_object *msgobj, *msgstr, *msgint;
 
 		msgobj	= &mailbox_package->package.elements[j];
-		msgstr	= &msgobj->package.elements[0];
-		msgint	= &msgobj->package.elements[1];
 
 		/* package should have 1 string and 1 integer object */
 		if (msgobj->type != ACPI_TYPE_PACKAGE ||
-		    msgstr->type != ACPI_TYPE_STRING ||
+		    msgobj->package.count < 2) {
+			ret = -EINVAL;
+			goto free_buf;
+		}
+
+		msgstr	= &msgobj->package.elements[0];
+		msgint	= &msgobj->package.elements[1];
+
+		if (msgstr->type != ACPI_TYPE_STRING ||
 		    msgint->type != ACPI_TYPE_INTEGER) {
 			ret = -EINVAL;
 			goto free_buf;
-- 
2.53.0




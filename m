Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6985326B6;
	Thu, 17 Sep 2026 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664503; cv=none; b=Dwj6fMBxIiix88Z+zD2uT2D7HfGOiPYwjI86U/b+tmP8lJELA5RNzvzngZ9SqPSex3sXs74YjpiQXsGE4nUJdPc4jCBmbjkV5+5ND3szPhohbeTsQOdo/E+NLnwx9EDPLuPpMOnmhGec0f2XIahEfbRSws8Gs7nepJT2fUr9Xoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664503; c=relaxed/simple;
	bh=wDe+/5QR/34LuK2zihlshB3chxyEknXpVJRguy5lcZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oegT384XYZc/gIN9f83LhC7xx7Ubnf6RSKMj2OdzApZpczB0E2+z2W7v2SGV72i9ANpWK6Gz0qXCJR1pLff5mG2m8Ze6rv95Tc8nsMazE4/lx2wkt8oGocRgEMULIf7xUJvjqlYYXDwIfuWstBAeTnVzZE6mVamyORQPfy4uSfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyYLy+45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyYLy+45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAC81F00898;
	Thu, 17 Sep 2026 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664501;
	bh=CE5ARa+T2WkGQsFpE7AjVuaKWu5lQdjrQAJ7oqIhnTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyYLy+45GHVxPUmkdZ45AbRsCh8sYEZQbXrV80ddSEAwitbgs4uZ/ncFGrLZ5Su6J
	 s4BOooBj77orqzsCmQiLwkexvC7lXupR39J/y0dfb8/Zv+MJQhdBg+Pf0c3xDMegaZ
	 qLuapxkJL+SyxXxrqi3Dsj0BBh+D2CuHkO7C+m0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis de Carlos <reskoldo73@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0362/1250] platform/x86: msi-ec: Add support for MSI Pulse GL66 12th Gen
Date: Thu, 17 Sep 2026 16:02:37 +0100
Message-ID: <20260917151601.877505769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Luis de Carlos <reskoldo73@gmail.com>

[ Upstream commit ab7be7ed913086e076bfd8aba79f614f415cd6dc ]

Add the firmware string '1583EMS1.109' to the ALLOWED_FW_10 array.
This enables Embedded Controller support, including battery charge
thresholds, for the MSI Pulse GL66 12UEK (MS-1583) laptop.

Signed-off-by: Luis de Carlos <reskoldo73@gmail.com>
Link: https://patch.msgid.link/20260527134750.25263-1-reskoldo73@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-ec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index f19504dbf164c..0157e233e4300 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -823,6 +823,7 @@ static struct msi_ec_conf CONF9 __initdata = {
 
 static const char * const ALLOWED_FW_10[] __initconst = {
 	"1582EMS1.107", // GF66 11UC
+	"1583EMS1.109", // Pulse GL66 12UEK
 	NULL
 };
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29553803CD;
	Tue, 10 Mar 2026 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141986; cv=none; b=FXUdiazQjTmn45uxTlTBA2zHvqglnqGyzcUKdE0cCvSUcVVuBQdiTEpZ4vOhStyAuBdLznE75pRC6hn9q85bBmjljNnsY7R/L98wlLIhmPxFwlLYyr4yAnn6EK5k9kIdid3UVXtFwFKXIFCWhSlqLSy+TjyinkzwWuvRC0AyvU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141986; c=relaxed/simple;
	bh=QMxaRUlVabi34OyCOXORv3iiRgPz9G5S9PbMo/DrPzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZuKSZ7UDQDltiiqRRpH1QHsk0c98up93bsaQ53n/mP5zmJu5VW6ADtdDfpH8FW4z/DkXUpNk83n3KgQR/SuzOokxedIUDzYN21Snm731oXBlFcyoW4Uu0A/gwA1dgsnX+UKouyw69amjbgQgsddU8sbuRhUT6/9bjgO0DCq7m4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaQMJIDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaQMJIDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5DBC2BC9E;
	Tue, 10 Mar 2026 11:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141986;
	bh=QMxaRUlVabi34OyCOXORv3iiRgPz9G5S9PbMo/DrPzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaQMJIDVUME5NZJ2rrB/rY9hVkx6FkaDg6oSk/Zu5YTGh3K+6LH99fBPdRK0mBTWl
	 kri6HJVLTqWlOKxu3Z1GHqCKO0FW1bb0XHo/9C28pm4QGfJLvhHNB9NE4k4zMCsFNG
	 p11WyRqj6VMZS+CJ2qxCxdGU9rFAVnYmzaq02f/QDZVJqdYcg77zh9t0jpoeZVT7x7
	 KxYX1UoBeTxtkviBCy033PX9NFa0wXYYRZYR9MxFS3zQ4GDKRH0VNN6Tdl0h38Olhm
	 IqLFLULAIXBj7VhXFcbVYkjgpgnsgDQP43WiE5YKAkBRRcRS0XqZIn4xTPXoRwg5R8
	 OueSKOZpCEYtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <csokas.bence@prolan.hu>,
	Andrej Rosano <andrej@inversepath.com>,
	Andrej Rosano <andrej.rosano@reversec.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/314] ARM: dts: imx53-usbarmory: Replace license text comment with SPDX identifier
Date: Tue, 10 Mar 2026 07:16:10 -0400
Message-ID: <2358e692647ad9071f82c4442957347c874e1949.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bence Csókás <csokas.bence@prolan.hu>

[ Upstream commit faa6baa36497958dd8fd5561daa37249779446d7 ]

Replace verbatim license text with a `SPDX-License-Identifier`.

The comment header mis-attributes this license to be "X11", but the
license text does not include the last line "Except as contained in this
notice, the name of the X Consortium shall not be used in advertising or
otherwise to promote the sale, use or other dealings in this Software
without prior written authorization from the X Consortium.". Therefore,
this license is actually equivalent to the SPDX "MIT" license (confirmed
by text diffing).

Cc: Andrej Rosano <andrej@inversepath.com>
Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
Acked-by: Andrej Rosano <andrej.rosano@reversec.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 43d67ec26b32 ("PCI: dwc: ep: Fix resizable BAR support for multi-PF configurations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx53-usbarmory.dts | 39 +------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx53-usbarmory.dts b/arch/arm/boot/dts/nxp/imx/imx53-usbarmory.dts
index acc44010d5106..3ad9db4b14425 100644
--- a/arch/arm/boot/dts/nxp/imx/imx53-usbarmory.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx53-usbarmory.dts
@@ -1,47 +1,10 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR MIT)
 /*
  * USB armory MkI device tree file
  * https://inversepath.com/usbarmory
  *
  * Copyright (C) 2015, Inverse Path
  * Andrej Rosano <andrej@inversepath.com>
- *
- * This file is dual-licensed: you can use it either under the terms
- * of the GPL or the X11 license, at your option. Note that this dual
- * licensing only applies to this file, and not this project as a
- * whole.
- *
- *  a) This file is free software; you can redistribute it and/or
- *     modify it under the terms of the GNU General Public License as
- *     published by the Free Software Foundation; either version 2 of the
- *     License, or (at your option) any later version.
- *
- *     This file is distributed in the hope that it will be useful,
- *     but WITHOUT ANY WARRANTY; without even the implied warranty of
- *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *     GNU General Public License for more details.
- *
- * Or, alternatively,
- *
- *  b) Permission is hereby granted, free of charge, to any person
- *     obtaining a copy of this software and associated documentation
- *     files (the "Software"), to deal in the Software without
- *     restriction, including without limitation the rights to use,
- *     copy, modify, merge, publish, distribute, sublicense, and/or
- *     sell copies of the Software, and to permit persons to whom the
- *     Software is furnished to do so, subject to the following
- *     conditions:
- *
- *     The above copyright notice and this permission notice shall be
- *     included in all copies or substantial portions of the Software.
- *
- *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
- *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
- *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
- *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- *     OTHER DEALINGS IN THE SOFTWARE.
  */
 
 /dts-v1/;
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE671BA870;
	Tue, 30 Jul 2024 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354721; cv=none; b=kFGlHMwUfUyLwSUYjbJHTZDDtrM7XLvygNDbe+BbvxXQLPxa3FrCs5tvej6TUU+PEm5vi4xech/HV0v9uwEwf1bv0OZUwyOjnGfs5uotac+aV9+T5HJrIBcczy178al13AElYoWAsRzOoTOsbKPbvEM6yJtgz2NdrXLbADSn0r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354721; c=relaxed/simple;
	bh=z0xyBXh0MIc+IcFB0XMx638dl9tvXgwGLEcHNWp1luA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooTGa46UXugVPnDGIT2m+3d1HXbny72EROK9d3nNXjbWloOpBui3bwWRossANeCr2gXneHZMIAbLf6x3zmamMTabPTi4F4hGIDdvNLFAmoQW4mPQianFtXg0MPXpdwOMIulc0XEL5LENhkCG1zwm2TaL5TnMRSeLc21E/LELs9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrRNyff3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrRNyff3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B983CC32782;
	Tue, 30 Jul 2024 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354721;
	bh=z0xyBXh0MIc+IcFB0XMx638dl9tvXgwGLEcHNWp1luA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrRNyff3dgQZJ9AIpcTKxBAe4Ap9kCx1/apGBZcH5hDyvmvFekK+0I3gUCHQ0w90U
	 +8TQpjFz8+ElH295ZdTOrT8e6KWBct2Z3LCx+s7WQUAH3hzhlrNRnZG6AUyF7y9s/Y
	 Pwzsvcjqo0kLSRYNCgoNL0tcm6HOSXzBc03Ypnn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 001/809] spi: spi-microchip-core: Fix the number of chip selects supported
Date: Tue, 30 Jul 2024 17:37:57 +0200
Message-ID: <20240730151724.707322827@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>

[ Upstream commit a7ed3a11202d90939a3d00ffcc8cf50703cb7b35 ]

The SPI "hard" controller in PolarFire SoC has eight CS lines, but only
one CS line is wired. When the 'num-cs' property is not specified in
the device tree, the driver defaults to the MAX_CS value, which has
been fixed to 1 to match the hardware configuration; however, when the
'num-cs' property is explicitly defined in the device tree, it
overrides the default value.

Fixes: 9ac8d17694b6 ("spi: add support for microchip fpga spi controllers")
Signed-off-by: Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://msgid.link/r/20240514104508.938448-3-prajna.rajendrakumar@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-microchip-core.c b/drivers/spi/spi-microchip-core.c
index 634364c7cfe61..c10de45aa4729 100644
--- a/drivers/spi/spi-microchip-core.c
+++ b/drivers/spi/spi-microchip-core.c
@@ -21,7 +21,7 @@
 #include <linux/spi/spi.h>
 
 #define MAX_LEN				(0xffff)
-#define MAX_CS				(8)
+#define MAX_CS				(1)
 #define DEFAULT_FRAMESIZE		(8)
 #define FIFO_DEPTH			(32)
 #define CLK_GEN_MODE1_MAX		(255)
-- 
2.43.0




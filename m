Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFAF2561A7;
	Tue, 11 Nov 2025 01:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824382; cv=none; b=D4msO09Y3JjvNKQ0M/aSS0JN1rG0FtyN0j/XaJ0TK0dNplIxzSkzNHnUWIPlPP7K8DHavmUHkkqslX69XVLGnUdqlrztrzrEo5jJ4b4E6U94DsuW+sp+qpYhFJ9hgojVxTEXdARGsU3v51+Gut18xVRUKT2An+TMKxXQkNnmrV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824382; c=relaxed/simple;
	bh=LNA7VhGLp9fF1Zx+k1Bw5lwboeTJoSxzfVCg3Dpvg38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DprxXcKYr4PKGsUpbaL+xUIxiSJJhWrU3baf2ccl4+W61ycf8q3QGvChjl6N8B0pWjATnuDBwC8+o1XwG+ILsGjGTY6m7WTZxbdZe/JDmSHE2sBbU6WA4JyKWnCygcGeIcRsGZQmkBQpQdosrOu9M3lCU4ScnKJl5PNGbi9aRp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXcfM+Q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXcfM+Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1283C4AF0B;
	Tue, 11 Nov 2025 01:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824382;
	bh=LNA7VhGLp9fF1Zx+k1Bw5lwboeTJoSxzfVCg3Dpvg38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXcfM+Q94uUe8eEexEhtPJi5b4tENNscJCudWKwJqzumSUanbDoSGhyvc//vuNZVb
	 CD6EQsGDTIvaixk97xABX/NAtub4okWnaNOkQZ399kercWes/ORrj7Dlt8MxeEFYKa
	 282sCtZ2iGUHMTkzRztSn2gjLyzFoogr4UVpqKFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Hans de Goede <hansg@kernel.org>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 484/849] media: ov08x40: Fix the horizontal flip control
Date: Tue, 11 Nov 2025 09:40:54 +0900
Message-ID: <20251111004548.141717101@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Yao <hao.yao@intel.com>

[ Upstream commit c7df6f339af94689fdc433887f9fbb480bf8a4ed ]

The datasheet of ov08x40 doesn't match the hardware behavior.
0x3821[2] == 1 is the original state and 0 the horizontal flip enabled.

Signed-off-by: Hao Yao <hao.yao@intel.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Tested-by: Hans de Goede <hansg@kernel.org> # ThinkPad X1 Carbon Gen 12 & Gen 13
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov08x40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov08x40.c b/drivers/media/i2c/ov08x40.c
index e0094305ca2ab..90887fc54fb0e 100644
--- a/drivers/media/i2c/ov08x40.c
+++ b/drivers/media/i2c/ov08x40.c
@@ -1648,7 +1648,7 @@ static int ov08x40_set_ctrl_hflip(struct ov08x40 *ov08x, u32 ctrl_val)
 
 	return ov08x40_write_reg(ov08x, OV08X40_REG_MIRROR,
 				 OV08X40_REG_VALUE_08BIT,
-				 ctrl_val ? val | BIT(2) : val & ~BIT(2));
+				 ctrl_val ? val & ~BIT(2) : val | BIT(2));
 }
 
 static int ov08x40_set_ctrl_vflip(struct ov08x40 *ov08x, u32 ctrl_val)
-- 
2.51.0




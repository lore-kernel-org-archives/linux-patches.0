Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064042;
	b=T1T5NYKnQUexhLj4IxWLaheYH0fmFSvNP1IAYkpMNj2UxUgwR0Ic54ljKOge2NSmHnj4
	 gH0/WgFK+W7vQ6a5FUqqFw5IkSBm9OUcpVFdGx/FVgpWFNKp658QE4tSwheGgiDfT4XYR
	 cKkr7uZmRG+2ugMdx/C8Vlup7+O5gtqvA6fKPGL2qSEidcDkG/+lCJrCGdL5x6LiFB46U
	 culC3/27itEJ3dKUqT7GZGOBMk8m/XDlHtbRscoDFvf/tb1g5fBFM/TARNJYIkO+6Zf/t
	 EnOzXpNcKOWzrRt/e7ILYybPICip5c9V1MYLvJnvwr8aLQNkv7JQAU4R1EvEEZdf5ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+j9oCcNfa73HFS0CYowTCGj5SD9DzSJuv3CDPXRnI4=;
	b=DWJhbIcK1Fypq+eL4xqvJ7Xovn+FOibd/RrgXL1HMF2h+IMNbgte7xGqTqLl498/TGNX
	 budbvUzhLP41WGiS+Ho6D9gI2yt3dAG6XXjSCoelGu4Of1lEFM1TxOV7kaOywuR8Dza0O
	 6pmB+pWujKf8ZdaLNv+Xc/nPqIVKneYcPvQegi45ZIYGaLcT423ywJ5I/JvshgU8LUuV7
	 WiCFRt1/aK9h6Nri6FuhLnf8qkdrBiWTFQLKxw2DD7BzJ3WFAcZVlxfezuaPXGcUSCZuS
	 XCnMcS3+4vs9k0ffPM27Kb1MguyvLUAeKB81+K3/RdF0bbhvIUFJpbzW2WR9T1vZH4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rr77XtPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0D3606A9D6;
	Sat,  7 Nov 2026 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rr77XtPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3AE1F008A1;
	Sat,  7 Nov 2026 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064041;
	bh=Q+j9oCcNfa73HFS0CYowTCGj5SD9DzSJuv3CDPXRnI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rr77XtPk3evAtGr/9pgEqTYfCm7Ny4bs3BuL8AIvcmjXJwx/YyWyRFc0aEbfYqCHT
	 JaJLuIzp4UZrL0xNgMlesxoBWAK4ipsln4Y3J4csUs433u9acF885W8Rp3iQbT/CSX
	 W60IcDrX8tkEznsuZorVHqan+lFMfRZ+ggFae6eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0208/1257] fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs
Date: Sat,  7 Nov 2026 08:41:44 -0500
Message-ID: <20261107134945.288345911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit ac02245b0ca28388ba16273f2fa683c90da2e5dc ]

The fpga_mgr_lock() comment lists of_fpga_mgr_put() as a source of a
manager pointer. The helper which obtains that pointer is
of_fpga_mgr_get(). Correct the reference.

Fixes: ebf877a51ad7 ("fpga: mgr: separate getting/locking FPGA manager")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260912100937.86316-1-kmehltretter@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/fpga-mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index 2672070ced026..5a0b7780b3358 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -744,7 +744,7 @@ EXPORT_SYMBOL_GPL(fpga_mgr_put);
  * @mgr:	fpga manager
  *
  * Given a pointer to FPGA Manager (from fpga_mgr_get() or
- * of_fpga_mgr_put()) attempt to get the mutex. The user should call
+ * of_fpga_mgr_get()) attempt to get the mutex. The user should call
  * fpga_mgr_lock() and verify that it returns 0 before attempting to
  * program the FPGA.  Likewise, the user should call fpga_mgr_unlock
  * when done programming the FPGA.
-- 
2.53.0




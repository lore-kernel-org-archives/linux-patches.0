Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91202080FC;
	Thu, 12 Dec 2024 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015780; cv=none; b=mlGLO/LlTa2GDgF0abLJ3NdR+9dl+5hkMGUM7bQ+fOpKlhgkw1UXXfphAwsFGmmHglQCAMO3FgpHTixl1Q6i8f4BQ5iTGDQ0v4+v9BqfstGwrbSzvKFNBeeqYDmM0uHWa4fVQ51ikkSMsdSpdS7hc1MeMhimDWLjC7t5Ixep0Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015780; c=relaxed/simple;
	bh=OVWAtteasVZpCpOu6TfxgbMoP7H/3jR5QirrXMfTX8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUg1WwS2Fbj3oig29YIwas4Xz7P+G2KBt5HYCbagc60qDuqwR2nb7xSsJxyfz7P253f36AV9bZOlVrHHj0+IqVhR7S4PfYRWhWnn/QnJXLZqVUgFDcwFZXSG190pelkF9NdMggQPIA+rvUfdNjUMwNklNArahEWE7IoOCVl9c4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSyJqfuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSyJqfuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48157C4CECE;
	Thu, 12 Dec 2024 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015779;
	bh=OVWAtteasVZpCpOu6TfxgbMoP7H/3jR5QirrXMfTX8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSyJqfuL5S9pxktKv4EXjy7Ljzc+1v3DlKg5IVqbEbjV/1SmU06VzVFvrhLmBhiLb
	 jMBn1vHRc+b036IV466v3QapS7rvz7QEOR2KZKZ3jrhuuCtOPJCw0kEnsVdVxtGkWJ
	 G6ffZPB93zMO7z+480b2QecoT6JT3ASqJ4zvuMPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tore Amundsen <tore@amundsen.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Ernesto Castellotti <ernesto@castellotti.net>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 043/466] ixgbe: Correct BASE-BX10 compliance code
Date: Thu, 12 Dec 2024 15:53:32 +0100
Message-ID: <20241212144308.388076423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tore Amundsen <tore@amundsen.org>

[ Upstream commit f72ce14b231f7bf06088e4e50f1875f1e35f79d7 ]

SFF-8472 (section 5.4 Transceiver Compliance Codes) defines bit 6 as
BASE-BX10. Bit 6 means a value of 0x40 (decimal 64).

The current value in the source code is 0x64, which appears to be a
mix-up of hex and decimal values. A value of 0x64 (binary 01100100)
incorrectly sets bit 2 (1000BASE-CX) and bit 5 (100BASE-FX) as well.

Fixes: 1b43e0d20f2d ("ixgbe: Add 1000BASE-BX support")
Signed-off-by: Tore Amundsen <tore@amundsen.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Acked-by: Ernesto Castellotti <ernesto@castellotti.net>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
index 14aa2ca51f70e..81179c60af4e0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
@@ -40,7 +40,7 @@
 #define IXGBE_SFF_1GBASESX_CAPABLE		0x1
 #define IXGBE_SFF_1GBASELX_CAPABLE		0x2
 #define IXGBE_SFF_1GBASET_CAPABLE		0x8
-#define IXGBE_SFF_BASEBX10_CAPABLE		0x64
+#define IXGBE_SFF_BASEBX10_CAPABLE		0x40
 #define IXGBE_SFF_10GBASESR_CAPABLE		0x10
 #define IXGBE_SFF_10GBASELR_CAPABLE		0x20
 #define IXGBE_SFF_SOFT_RS_SELECT_MASK		0x8
-- 
2.43.0




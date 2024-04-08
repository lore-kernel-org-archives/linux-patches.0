Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3FA81741;
	Mon,  8 Apr 2024 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582956; cv=none; b=PPxo3ciVvX+LzK8FO5lRl7+GjLm28zEHpv3cu7HE52KEE351CkNteyNTG5DZAutM+5CrGfaKYniu3dmQ19YFnYHG6d5BMPEdXNK+o9rC3EkIa2ulHllGZW4rXDR9joh2O+waLJOy4qndCIHRfbusxARlqMCyq7wtVcVBvvP0Sjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582956; c=relaxed/simple;
	bh=yYONrwwH4ykAM3hZzwi2yoG+A713hRh+GNUXjzRhTRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipDHQkp5FyFOeGy0z3g8D6l3K/15ExTythWl/mk7Fggq2odrY+hm4fDW8gh3dMXl6f7Lg1QYyd3UW4rXGhWXXtYvLeP03+LGtJDEZeMC6KjubQYnEjXX/E5nKC7EJFWFzj1aWPPYCMC029bMclw9sY08keJBGwmUxhgo/LfZoik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyxL3F81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyxL3F81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B767DC433C7;
	Mon,  8 Apr 2024 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582956;
	bh=yYONrwwH4ykAM3hZzwi2yoG+A713hRh+GNUXjzRhTRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyxL3F81nIQQO6Y0gAGwwPQmHn8QfuGwCUwIcX01QBo6SkFgQOXGVRawATSIXKBbn
	 f1LVWpD46rh9BORd/x5FiMtwZBD1rb2iiJ0Zrat7KBg0ftCOFXSyp8uINUy5b/l2jb
	 GycLN9juqwxl0OVNFHyLvkXBzZdNGfDvn/AQWhs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 142/252] i40e: Refactor I40E_MDIO_CLAUSE* macros
Date: Mon,  8 Apr 2024 14:57:21 +0200
Message-ID: <20240408125311.059396702@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 8196b5fd6c7312d31775f77c7fff0253eb0ecdaa ]

The macros I40E_MDIO_CLAUSE22* and I40E_MDIO_CLAUSE45* are using I40E_MASK
together with the same values I40E_GLGEN_MSCA_STCODE_SHIFT and
I40E_GLGEN_MSCA_OPCODE_SHIFT to define masks.
Introduce I40E_GLGEN_MSCA_OPCODE_MASK and I40E_GLGEN_MSCA_STCODE_MASK
for both shifts in i40e_register.h and use them to refactor the macros
mentioned above.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_register.h   |  2 ++
 drivers/net/ethernet/intel/i40e/i40e_type.h   | 23 +++++++------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 694cb3e45c1ec..989c186824733 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -202,7 +202,9 @@
 #define I40E_GLGEN_MSCA_DEVADD_SHIFT 16
 #define I40E_GLGEN_MSCA_PHYADD_SHIFT 21
 #define I40E_GLGEN_MSCA_OPCODE_SHIFT 26
+#define I40E_GLGEN_MSCA_OPCODE_MASK(_i) I40E_MASK(_i, I40E_GLGEN_MSCA_OPCODE_SHIFT)
 #define I40E_GLGEN_MSCA_STCODE_SHIFT 28
+#define I40E_GLGEN_MSCA_STCODE_MASK I40E_MASK(0x1, I40E_GLGEN_MSCA_STCODE_SHIFT)
 #define I40E_GLGEN_MSCA_MDICMD_SHIFT 30
 #define I40E_GLGEN_MSCA_MDICMD_MASK I40E_MASK(0x1, I40E_GLGEN_MSCA_MDICMD_SHIFT)
 #define I40E_GLGEN_MSCA_MDIINPROGEN_SHIFT 31
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 658bc89132783..d4c6afe84fdd2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -70,21 +70,14 @@ enum i40e_debug_mask {
 	I40E_DEBUG_ALL			= 0xFFFFFFFF
 };
 
-#define I40E_MDIO_CLAUSE22_STCODE_MASK	I40E_MASK(1, \
-						  I40E_GLGEN_MSCA_STCODE_SHIFT)
-#define I40E_MDIO_CLAUSE22_OPCODE_WRITE_MASK	I40E_MASK(1, \
-						  I40E_GLGEN_MSCA_OPCODE_SHIFT)
-#define I40E_MDIO_CLAUSE22_OPCODE_READ_MASK	I40E_MASK(2, \
-						  I40E_GLGEN_MSCA_OPCODE_SHIFT)
-
-#define I40E_MDIO_CLAUSE45_STCODE_MASK	I40E_MASK(0, \
-						  I40E_GLGEN_MSCA_STCODE_SHIFT)
-#define I40E_MDIO_CLAUSE45_OPCODE_ADDRESS_MASK	I40E_MASK(0, \
-						  I40E_GLGEN_MSCA_OPCODE_SHIFT)
-#define I40E_MDIO_CLAUSE45_OPCODE_WRITE_MASK	I40E_MASK(1, \
-						  I40E_GLGEN_MSCA_OPCODE_SHIFT)
-#define I40E_MDIO_CLAUSE45_OPCODE_READ_MASK	I40E_MASK(3, \
-						I40E_GLGEN_MSCA_OPCODE_SHIFT)
+#define I40E_MDIO_CLAUSE22_STCODE_MASK		I40E_GLGEN_MSCA_STCODE_MASK
+#define I40E_MDIO_CLAUSE22_OPCODE_WRITE_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(1)
+#define I40E_MDIO_CLAUSE22_OPCODE_READ_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(2)
+
+#define I40E_MDIO_CLAUSE45_STCODE_MASK		I40E_GLGEN_MSCA_STCODE_MASK
+#define I40E_MDIO_CLAUSE45_OPCODE_ADDRESS_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(0)
+#define I40E_MDIO_CLAUSE45_OPCODE_WRITE_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(1)
+#define I40E_MDIO_CLAUSE45_OPCODE_READ_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(3)
 
 #define I40E_PHY_COM_REG_PAGE                   0x1E
 #define I40E_PHY_LED_LINK_MODE_MASK             0xF0
-- 
2.43.0




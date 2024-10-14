Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A09025632;
	Mon, 14 Oct 2024 14:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916673; cv=none; b=nsIyKIMQOH0mhqavH/onLfsE8wHgFEhuUsw+YqtdNu18VK6/v/8vDeZ8iOlyJNHthQR5A8+H8zhhyoOFYSHkkiob2soB6r4gx7Jsq1M9jIAZibbZMLOAiT6XveNVg6iBfVrh5wXr6g48StfAsQxJAWMjPmRiEKyPcIuG4oZhpNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916673; c=relaxed/simple;
	bh=dtxJq9TtleoRczsxhBJpkSh0napwXjPvw3i3KLd65vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhSYaKG7PySVCPksAU7yfV1cRGv9RSyft93ZPU6Vur4QSxBhQzQovpTWJ7emi/zIBW+kjRHE4GUEA4B0bxmXIRhVdwTBKGd8obBp9tN+j3gQtEVbipFh1/uBTkeoMcWYno5UbIhdEDbjDfS1RM8cJAajkvcwAtIoU2mo1sjfFEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=galEPMjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="galEPMjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC30CC4CEC3;
	Mon, 14 Oct 2024 14:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916673;
	bh=dtxJq9TtleoRczsxhBJpkSh0napwXjPvw3i3KLd65vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=galEPMjyb99vI7ZfQZqkkKOmv9/kEpKr7uAx8UQ+oquwFF2sEbPTU0WySMZFG5f/V
	 uFdmvokFgzgTYimrAgArGESuEH/XQQD1zDwBYhZxNW/UqsUYAcBsy4RcXcvivOsLgN
	 WthjHskMN9ZTKyIwpGqeS6I4jiDuBPx8Ww2STxks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 032/213] i40e: Fix ST code value for Clause 45
Date: Mon, 14 Oct 2024 16:18:58 +0200
Message-ID: <20241014141044.240827479@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

[ Upstream commit 9b3daf2b0443eeba23c3888059342aec920dfd53 ]

ST code value for clause 45 that has been changed by
commit 8196b5fd6c73 ("i40e: Refactor I40E_MDIO_CLAUSE* macros")
is currently wrong.

The mentioned commit refactored ..MDIO_CLAUSE??_STCODE_MASK so
their value is the same for both clauses. The value is correct
for clause 22 but not for clause 45.

Fix the issue by adding a parameter to I40E_GLGEN_MSCA_STCODE_MASK
macro that specifies required value.

Fixes: 8196b5fd6c73 ("i40e: Refactor I40E_MDIO_CLAUSE* macros")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_register.h | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 989c186824733..d3c82ba3835a7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -204,7 +204,7 @@
 #define I40E_GLGEN_MSCA_OPCODE_SHIFT 26
 #define I40E_GLGEN_MSCA_OPCODE_MASK(_i) I40E_MASK(_i, I40E_GLGEN_MSCA_OPCODE_SHIFT)
 #define I40E_GLGEN_MSCA_STCODE_SHIFT 28
-#define I40E_GLGEN_MSCA_STCODE_MASK I40E_MASK(0x1, I40E_GLGEN_MSCA_STCODE_SHIFT)
+#define I40E_GLGEN_MSCA_STCODE_MASK(_i) I40E_MASK(_i, I40E_GLGEN_MSCA_STCODE_SHIFT)
 #define I40E_GLGEN_MSCA_MDICMD_SHIFT 30
 #define I40E_GLGEN_MSCA_MDICMD_MASK I40E_MASK(0x1, I40E_GLGEN_MSCA_MDICMD_SHIFT)
 #define I40E_GLGEN_MSCA_MDIINPROGEN_SHIFT 31
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 4092f82bcfb12..6e7cb2081ab37 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -40,11 +40,11 @@ typedef void (*I40E_ADMINQ_CALLBACK)(struct i40e_hw *, struct i40e_aq_desc *);
 #define I40E_QTX_CTL_VM_QUEUE	0x1
 #define I40E_QTX_CTL_PF_QUEUE	0x2
 
-#define I40E_MDIO_CLAUSE22_STCODE_MASK		I40E_GLGEN_MSCA_STCODE_MASK
+#define I40E_MDIO_CLAUSE22_STCODE_MASK		I40E_GLGEN_MSCA_STCODE_MASK(1)
 #define I40E_MDIO_CLAUSE22_OPCODE_WRITE_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(1)
 #define I40E_MDIO_CLAUSE22_OPCODE_READ_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(2)
 
-#define I40E_MDIO_CLAUSE45_STCODE_MASK		I40E_GLGEN_MSCA_STCODE_MASK
+#define I40E_MDIO_CLAUSE45_STCODE_MASK		I40E_GLGEN_MSCA_STCODE_MASK(0)
 #define I40E_MDIO_CLAUSE45_OPCODE_ADDRESS_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(0)
 #define I40E_MDIO_CLAUSE45_OPCODE_WRITE_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(1)
 #define I40E_MDIO_CLAUSE45_OPCODE_READ_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(3)
-- 
2.43.0




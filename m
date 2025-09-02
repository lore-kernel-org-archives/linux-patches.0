Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D36330F533;
	Tue,  2 Sep 2025 13:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819554; cv=none; b=keEEVQEzl167RSiA9Yg0awuRvAYAyKCNojvaMaevjhbDe44c39OUTSCrVhbtn/Qm/LxCn4dkmP5/ykmPgtRa5Y0udf+V1huTmootliWefvG+JmnSpWwyNHSG5ekDKiCG+fUKInO6kQSM2kq78R8vIRuHFcNkAmfQO5LpQZy8Vtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819554; c=relaxed/simple;
	bh=x4prJZq/Uj33Qv6NiJLyvlibqOPRFGTdugTcBgcOWGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZ3XTNipP49+lOpDyZfn4VOkyU6V+b6qQ4Vgu1ZCUxL8h5qWr/f7f3ZNVeBO6WomrkLqdszU8gEo7XxGCuXvLa/HM4t9KBWustpfVk4AV4KLmrsav0Vi+YKYA8Zw8fvLq+RHKvw52rEUBPajdhA9RBZWxrdQCfIpac7n/pZcIXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZooqWGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZooqWGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AC8C4CEED;
	Tue,  2 Sep 2025 13:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819554;
	bh=x4prJZq/Uj33Qv6NiJLyvlibqOPRFGTdugTcBgcOWGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZooqWGDp4KuD3c5nB6hQ779/soqB7D9MtrrI91S/pSW7r9mg6uNKIdEdmHKAlYgN
	 GpVgIebDbuy6n64wnuQgZGgpp5kGJm/d2RjZ3psMd8ETNbZ4ChUgq+Ocrym4nGkEfG
	 Al0pinLESupCIBisUq4/DacEnhpOmlxOW6rn/OEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 061/142] ixgbe: fix ixgbe_orom_civd_info struct layout
Date: Tue,  2 Sep 2025 15:19:23 +0200
Message-ID: <20250902131950.588172002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit ed913b343dcf9f623e7436fa1a153c89b22d109b ]

The current layout of struct ixgbe_orom_civd_info causes incorrect data
storage due to compiler-inserted padding. This results in issues when
writing OROM data into the structure.

Add the __packed attribute to ensure the structure layout matches the
expected binary format without padding.

Fixes: 70db0788a262 ("ixgbe: read the OROM version information")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c      | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
index 71ea25de1bac7..754c176fd4a7a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
@@ -3123,7 +3123,7 @@ static int ixgbe_get_orom_ver_info(struct ixgbe_hw *hw,
 	if (err)
 		return err;
 
-	combo_ver = le32_to_cpu(civd.combo_ver);
+	combo_ver = get_unaligned_le32(&civd.combo_ver);
 
 	orom->major = (u8)FIELD_GET(IXGBE_OROM_VER_MASK, combo_ver);
 	orom->patch = (u8)FIELD_GET(IXGBE_OROM_VER_PATCH_MASK, combo_ver);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h
index 09df67f03cf47..38a41d81de0fa 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h
@@ -1150,7 +1150,7 @@ struct ixgbe_orom_civd_info {
 	__le32 combo_ver;	/* Combo Image Version number */
 	u8 combo_name_len;	/* Length of the unicode combo image version string, max of 32 */
 	__le16 combo_name[32];	/* Unicode string representing the Combo Image version */
-};
+} __packed;
 
 /* Function specific capabilities */
 struct ixgbe_hw_func_caps {
-- 
2.50.1




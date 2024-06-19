Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35B3147C7B;
	Wed, 19 Jun 2024 12:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801918; cv=none; b=E7jCdCWm1Id25DyvJoDmEUhTc5lSSd+O5taCebw/D1uZmBiCPUDp0sXJKuIwYDbp0MhYlTVb1NPGUkVcr8F5jxi2EkEfr7Fb965yNdPc/u47Ki/P19AKbIWeF2XAEr2y7dJLvvJmH06qrQtOEWvz4DTrgyeFLmmW6cKmFWQpY+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801918; c=relaxed/simple;
	bh=Xnj3DbtOC3LjwYBCGzysPk59lM6LSyvomaXa55o7Fl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+RWOWdVPzzdLxtOcEu1bxzUYds23i9DzZK137TE2X3gq7ETABOTqQLUwtOJ7kS4C/Wi4g/4GGd8ugjJj1cwW2Zh0/yFmMaSUXh+Si41cNFmTIx51W4KepL6Lz4DZyHjKUlVf/4+4en7NzLc1hvIVBNIvLC3sDCL5jhT/HDIw0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3/P6kti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3/P6kti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58179C2BBFC;
	Wed, 19 Jun 2024 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801918;
	bh=Xnj3DbtOC3LjwYBCGzysPk59lM6LSyvomaXa55o7Fl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3/P6ktiy/e6zyoZkTJPhdpICMIXsahU2FqEtGl2s4zcW85LVmIZfJBxRpaMkVFE/
	 iiCkejlcNNEIqUoqKDzzqIGtaXumFrXfuarqjizEWGbLBukg+v33PLVekLZqGKaErl
	 Xj33nQ9xBvun3J9L1taBpRArJdsHoJdXT1tm5M40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar S Matityahu <shahar.s.matityahu@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/267] wifi: iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef
Date: Wed, 19 Jun 2024 14:52:40 +0200
Message-ID: <20240619125606.710460743@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

[ Upstream commit 87821b67dea87addbc4ab093ba752753b002176a ]

The driver should call iwl_dbg_tlv_free even if debugfs is not defined
since ini mode does not depend on debugfs ifdef.

Fixes: 68f6f492c4fa ("iwlwifi: trans: support loading ini TLVs from external file")
Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.c8e3723f55b0.I5e805732b0be31ee6b83c642ec652a34e974ff10@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 8faf4e7872bb9..a56593b6135f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1824,8 +1824,8 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 err_fw:
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	debugfs_remove_recursive(drv->dbgfs_drv);
-	iwl_dbg_tlv_free(drv->trans);
 #endif
+	iwl_dbg_tlv_free(drv->trans);
 	kfree(drv);
 err:
 	return ERR_PTR(ret);
-- 
2.43.0




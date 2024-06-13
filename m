Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3420143C48;
	Thu, 13 Jun 2024 12:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282863; cv=none; b=VQPgnwSsjEJOccPNiXfWhwYRdXX3dhuE3uDBeCGYQdCFPue5kmBgHgnGwIfcqfLUkdilhN1cPcrIKcpDYIHWLakmBnmEhE5r7PEhRsixXgvt82bDRGO2WhrxoGhroTXxvp1Ivub72RVKvCpzCQg/6MZrEgPYKGmBG9gN1gioUds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282863; c=relaxed/simple;
	bh=zFR6MRw5F125K6VMJ5dvvx3wSJrfxfyRU/sm9/7HlTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNKSkF6XLhuui7veBGrVLpsxFMZEhIew/vq1vaX+ffiHD2y6peKGXHviL5IUhh3EO4c/X5FVRbPoS+zcoBMrDd/2Ak6M2AmALyE0HqksHBe4Ic+aMLN1AnvrCQnZ3L0KYRlqAxulg3pszty7cZ71kmXvdP+n8ATTxykzP4sK6YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNWXs6L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNWXs6L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7A7C4AF4D;
	Thu, 13 Jun 2024 12:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282863;
	bh=zFR6MRw5F125K6VMJ5dvvx3wSJrfxfyRU/sm9/7HlTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNWXs6L2YgZZgZT3t6zoKGhO+/nNuj9x6/MCH7z9AT6CyqSJocqqnnmpT9qg5b7VK
	 4H6D4ECvmeBQ7OgT+vGdHl+TZg4WhAc1zGVSIKC+BzG2+8aGTfA+qACzL5eOBiRDH5
	 YZk4I7mEt1W0+k0/7S4iL0muoA3DXxi4Yyd3eNLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Gora <dan.gora@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 03/85] Bluetooth: btrtl: Add missing MODULE_FIRMWARE declarations
Date: Thu, 13 Jun 2024 13:35:01 +0200
Message-ID: <20240613113214.269286241@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Gora <dan.gora@gmail.com>

commit bb23f07cb63975968bbabe314486e2b087234fc5 upstream.

Add missing MODULE_FIRMWARE declarations for firmware referenced in
btrtl.c.

Signed-off-by: Dan Gora <dan.gora@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btrtl.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1074,19 +1074,33 @@ MODULE_FIRMWARE("rtl_bt/rtl8723cs_vf_fw.
 MODULE_FIRMWARE("rtl_bt/rtl8723cs_vf_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723cs_xx_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723cs_xx_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8723d_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8723d_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723ds_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723ds_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8761a_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8761a_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8761b_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8761b_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8761bu_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8761bu_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8821a_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8821a_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8821c_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8821c_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8821cs_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8821cs_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8822b_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8822b_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8822cs_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8822cs_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8822cu_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8822cu_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8851bu_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8851bu_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852au_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852au_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852bu_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852bu_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852cu_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8852cu_config.bin");
-MODULE_FIRMWARE("rtl_bt/rtl8851bu_fw.bin");
-MODULE_FIRMWARE("rtl_bt/rtl8851bu_config.bin");



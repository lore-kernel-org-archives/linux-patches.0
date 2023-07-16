Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1428F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EA8C433C8;
	Sun, 16 Jul 2023 20:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541044;
	bh=XKhboenT0MFVRIUp7LhKTkQn8giMCXaNcKSsbD+apLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1mQnenPt7+ZuNe5IfBHB4cGWi9UwVbNDU6usymmTErW6Ear3hCgr09ec4KoeFXry
	 ZBon+vYgDFNfOmUQfqHlD2qBtUW+pF/J+FecRRpLIRhkFaO/rAHd890dV2LlGcXChx
	 Ci6Bm6MNm4URFsxvr2Se8/RsEgDrY246CWTpRIUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Ajay Gupta <ajayg@nvidia.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 552/591] i2c: nvidia-gpu: Remove ccgx,firmware-build property
Date: Sun, 16 Jul 2023 21:51:31 +0200
Message-ID: <20230716194938.137559327@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wayne Chang <waynec@nvidia.com>

commit 430b38764fbb931c6dbd1af13c8b2e4508994662 upstream.

Now the Cypress CCG driver has been updated to support the
'firmware-name' property to align with device-tree, remove the
'ccgx,firmware-build' property as this is no longer needed.

Signed-off-by: Wayne Chang <waynec@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Ajay Gupta <ajayg@nvidia.com>
Acked-by: Wolfram Sang <wsa@kernel.org>
Link: https://lore.kernel.org/r/20230131175748.256423-5-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-nvidia-gpu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-nvidia-gpu.c
+++ b/drivers/i2c/busses/i2c-nvidia-gpu.c
@@ -259,8 +259,7 @@ static const struct pci_device_id gpu_i2
 MODULE_DEVICE_TABLE(pci, gpu_i2c_ids);
 
 static const struct property_entry ccgx_props[] = {
-	/* Use FW built for NVIDIA (nv) only */
-	PROPERTY_ENTRY_U16("ccgx,firmware-build", ('n' << 8) | 'v'),
+	/* Use FW built for NVIDIA GPU only */
 	PROPERTY_ENTRY_STRING("firmware-name", "nvidia,gpu"),
 	{ }
 };



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9118F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3173DC433C8;
	Sun, 16 Jul 2023 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541013;
	bh=NLZR25QJSigmbKiKVtzphOS3zszyWHrZyGIn70fSIHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJHiEg7bLF4lfdRx8v/TByqIPifJK6MVY/4ZSKeusxPXnNZ4JDzQqFn1F7Di1/CxZ
	 dEierj1En0rzVtpgDwb+fu/boAuCoxahZjB8MeRoGX0t5G3qPSNiJugMzmKp+36das
	 SBLOHp6dz7z7EQvmdRIeQjnP77ivEqxehWilJfio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Ajay Gupta <ajayg@nvidia.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 551/591] i2c: nvidia-gpu: Add ACPI property to align with device-tree
Date: Sun, 16 Jul 2023 21:51:30 +0200
Message-ID: <20230716194938.112623983@linuxfoundation.org>
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

commit f510b0a3565b9231e828e23a7e0f9790b97edf96 upstream.

Device-tree uses the 'firmware-name' string property to pass a name of
the firmware build to the Cypress CCGx driver. Add a new ACPI string
property to the NVIDIA GPU I2C driver to align with device-tree so that
we can migrate to using a common property name for both ACPI and
device-tree.

Signed-off-by: Wayne Chang <waynec@nvidia.com>
Co-developed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Ajay Gupta <ajayg@nvidia.com>
Acked-by: Wolfram Sang <wsa@kernel.org>
Link: https://lore.kernel.org/r/20230131175748.256423-3-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-nvidia-gpu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-nvidia-gpu.c
+++ b/drivers/i2c/busses/i2c-nvidia-gpu.c
@@ -261,6 +261,7 @@ MODULE_DEVICE_TABLE(pci, gpu_i2c_ids);
 static const struct property_entry ccgx_props[] = {
 	/* Use FW built for NVIDIA (nv) only */
 	PROPERTY_ENTRY_U16("ccgx,firmware-build", ('n' << 8) | 'v'),
+	PROPERTY_ENTRY_STRING("firmware-name", "nvidia,gpu"),
 	{ }
 };
 



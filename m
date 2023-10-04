Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8ED20B37
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVENym5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B17C433C7;
	Wed,  4 Oct 2023 18:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444329;
	bh=bQmsBUqo+TcQdZkFnjg5CCSQQnR+zMMg9eGAJXyP65Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVENym5BnegYVjCCyhqGZBKUPnEK2SimoK4VyLMBBzxyxUSOmuxXKZueYxOIGVAXz
	 M3aqBVgH5htDenw7Yx80aubQSSxOWMtFtcmRfusiBJuoEydfPfz5j1Xy/Yt6EMhQvP
	 +YtwFai2mumkpmhoZ0k1LMUkVRWLDRKETJo7dkQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Thompson <davthompson@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 183/321] platform/mellanox: mlxbf-bootctl: add NET dependency into Kconfig
Date: Wed,  4 Oct 2023 19:55:28 +0200
Message-ID: <20231004175237.713957483@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit c2dffda1d8f7511505bbbf16ba282f2079b30089 ]

The latest version of the mlxbf_bootctl driver utilizes
"sysfs_format_mac", and this API is only available if
NET is defined in the kernel configuration. This patch
changes the mlxbf_bootctl Kconfig to depend on NET.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309031058.JvwNDBKt-lkp@intel.com/
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20230905133243.31550-1-davthompson@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/mellanox/Kconfig b/drivers/platform/mellanox/Kconfig
index 30b50920b278c..f7dfa0e785fd6 100644
--- a/drivers/platform/mellanox/Kconfig
+++ b/drivers/platform/mellanox/Kconfig
@@ -60,6 +60,7 @@ config MLXBF_BOOTCTL
 	tristate "Mellanox BlueField Firmware Boot Control driver"
 	depends on ARM64
 	depends on ACPI
+	depends on NET
 	help
 	  The Mellanox BlueField firmware implements functionality to
 	  request swapping the primary and alternate eMMC boot partition,
-- 
2.40.1




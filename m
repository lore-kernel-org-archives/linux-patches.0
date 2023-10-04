Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B431D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeG2cnX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB76AC433C7;
	Wed,  4 Oct 2023 18:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443534;
	bh=GzXWsTCluJz2ev2zQghT4s9SvbTM1kp7DZaAHclSug0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeG2cnX/snr60O/iTcD7KW1NAAHGmQLxkkOoNC5i1hLHOfr0b6JMLqVjjrY4WEdUO
	 zURA1ZazoMJGznhq4r0OmRI0Bt9wY3hfOCteR3wKMEA0FoBbz0/YhTF0AlkIiffrBG
	 owDlKosn32bMlP+9fEux2Y5MLmLhIDW6JbE2iiqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Thompson <davthompson@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/259] platform/mellanox: mlxbf-bootctl: add NET dependency into Kconfig
Date: Wed,  4 Oct 2023 19:55:35 +0200
Message-ID: <20231004175224.726453844@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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




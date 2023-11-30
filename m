Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B4D524C2;
	Thu, 30 Nov 2023 16:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2iVVVci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A38C433D9;
	Thu, 30 Nov 2023 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361557;
	bh=DFLUmi/lz2ZhvbFtCxhkb/jdiBsjSDKD4GnjqilQRFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2iVVVci82BGl1RrtuUGVGnTvrI/6HajoE4BbY/ZLiUoCJw6H1p7vchgNxrwXu1F4
	 wpc5QFiHGDAjXkwti1Km6mNpAMMUahcNofZqPFy7r+qi6tKLVySqbptwbe7NaXWFJR
	 cCX7VdirzfvFi+Kxrodu/4WciA5QVINJuFHBFwN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/112] nvme: blank out authentication fabrics options if not configured
Date: Thu, 30 Nov 2023 16:21:39 +0000
Message-ID: <20231130162141.976871850@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit c7ca9757bda35ff9ce27ab42f2cb8b84d983e6ad ]

If the config option NVME_HOST_AUTH is not selected we should not
accept the corresponding fabrics options. This allows userspace
to detect if NVMe authentication has been enabled for the kernel.

Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 8175d49f29090..92ba315cfe19e 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -645,8 +645,10 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_TOS,			"tos=%d"		},
 	{ NVMF_OPT_FAIL_FAST_TMO,	"fast_io_fail_tmo=%d"	},
 	{ NVMF_OPT_DISCOVERY,		"discovery"		},
+#ifdef CONFIG_NVME_HOST_AUTH
 	{ NVMF_OPT_DHCHAP_SECRET,	"dhchap_secret=%s"	},
 	{ NVMF_OPT_DHCHAP_CTRL_SECRET,	"dhchap_ctrl_secret=%s"	},
+#endif
 	{ NVMF_OPT_ERR,			NULL			}
 };
 
-- 
2.42.0




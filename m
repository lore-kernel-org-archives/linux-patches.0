Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBABF746C
	for <patches@lists.linux.dev>; Thu,  1 Sep 2022 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662061402; x=1693597402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zy92vzhKsP6d5wheJJP6Ba24kfkFA7i7Ka9Ina5Ye9M=;
  b=Ni61SD48KOwOIWFon3IXLyda2F0VZxuwyuzcxYesZidDHePp+8k5wPOV
   BiiE3yJCP+NkUIK1eqnYrh47bW3cR/RxkxKXQMMnyYuwaj2dXmmlHqLnD
   zP2zmDDPDLxd8grcmzzjgQA2y5bfFznc//TwoNR5TrFVXo7ZlTL/sF0JI
   5gaJ7OK/ozi+Y4eBdmyDOKMEnVk3LxXqQBuQ41/8IrYSIppY4MJJk0t20
   X+OfBNp1O+h+MiH4dMkWx0u6eaEOBk6Y7DQ6DnWaZrRfBEbENCBn3j1Z8
   pZjLZxHzDijBSDmywMAyarQ7Gttd8+w0fcIht3vmqlfKAaIE7UlXxAlxW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="296595790"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="296595790"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 12:43:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="674020253"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 12:43:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: linux-edac@vger.kernel.org
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Aristeu Rozanski <aris@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Youquan Song <youquan.song@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/3] EDAC/skx_common: Make output format similar
Date: Thu,  1 Sep 2022 12:43:09 -0700
Message-Id: <20220901194310.115427-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220901194310.115427-1-tony.luck@intel.com>
References: <20220901194310.115427-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

The decoded output format of driver decoder is different from the
output format of firmware decoder. Make output format similar regardless
of decode function (Align driver decoder's to firmware decoder's).

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/skx_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 9b10c359849b..16ca3de57c24 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -600,12 +600,12 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 			 mscod, errcode, adxl_msg);
 	} else {
 		len = snprintf(skx_msg, MSG_SIZE,
-			 "%s%s err_code:0x%04x:0x%04x socket:%d imc:%d rank:%d bg:%d ba:%d row:0x%x col:0x%x",
+			 "%s%s err_code:0x%04x:0x%04x ProcessorSocketId:0x%x MemoryControllerId:0x%x PhysicalRankId:0x%x Row:0x%x Column:0x%x Bank:0x%x BankGroup:0x%x",
 			 overflow ? " OVERFLOW" : "",
 			 (uncorrected_error && recoverable) ? " recoverable" : "",
 			 mscod, errcode,
 			 res->socket, res->imc, res->rank,
-			 res->bank_group, res->bank_address, res->row, res->column);
+			 res->row, res->column, res->bank_address, res->bank_group);
 	}
 
 	if (skx_show_retry_rd_err_log)
-- 
2.37.1


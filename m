Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6AD146A79;
	Mon, 16 Sep 2024 12:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488689; cv=none; b=sjwXVQLZxCBKzjnP3TCq9qk6hy/4UA0omvsUzZuB98V3IWjYts80L/+jHCgzOVTSK0oafzI1Kd1ZvtVoxsQ0+BZu6OwTX6YkVKFby0yXz5Hn7kP3bYjP65or4gxoqL76kSxA46XX3NNW2fuQEjk+km6p3/4ydIV+xIioLv/kcyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488689; c=relaxed/simple;
	bh=4ymNFRocG1Kj7aE7+OCGKK2H6JbAeUtMbdvfs97718M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOLVI6ye23FBtKOuhQEW4kXyZi+Y/horw/Dmr/gcYOdxa6EfTeoYJsz/qEWASnbKHCE+gStw8KOPeTQOK9PU/r5gclPsQOCeqXYG2Djs36f6K6TkgzrKTh2O/VbouT1WJbJXQaWbV6TdP/ukO4KqLA6gjFP+i/m1CnctLEkOnK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/uDQ4hH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/uDQ4hH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C5DC4CEC4;
	Mon, 16 Sep 2024 12:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488689;
	bh=4ymNFRocG1Kj7aE7+OCGKK2H6JbAeUtMbdvfs97718M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/uDQ4hHFpGXRkrTnU3kl136iEszqhml8+wIxeqfAylnRJr3bLufb4ttrD/Aimcu2
	 q+GBuYbjIe7Ou6IDzC9stAzD4pbZCq8L/OYtTOtXk+dUVTQIhYR5qvXh2zv+0aGrKN
	 3yLLflngwSKIxJ5hyhfQtyPG2cHQ9DGTeBhXDYCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	peng guo <engguopeng@buaa.edu.cn>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/91] cxl/core: Fix incorrect vendor debug UUID define
Date: Mon, 16 Sep 2024 13:44:28 +0200
Message-ID: <20240916114226.226372345@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: peng guo <engguopeng@buaa.edu.cn>

[ Upstream commit 8ecef8e01a08c7e3e4ffc8f08d9f9663984f334b ]

When user send a mbox command whose opcode is CXL_MBOX_OP_CLEAR_LOG and
the in_payload is normal vendor debug log UUID according to
the CXL specification cxl_payload_from_user_allowed() will return
false unexpectedly, Sending mbox cmd operation fails and the kernel
log will print:
Clear Log: input payload not allowed.

All CXL devices that support a debug log shall support the Vendor Debug
Log to allow the log to be accessed through a common host driver, for any
device, all versions of the CXL specification define the same value with
Log Identifier of: 5e1819d9-11a9-400c-811f-d60719403d86

Refer to CXL spec r3.1 Table 8-71

Fix the definition value of DEFINE_CXL_VENDOR_DEBUG_UUID to match the
CXL specification.

Fixes: 472b1ce6e9d6 ("cxl/mem: Enable commands via CEL")
Signed-off-by: peng guo <engguopeng@buaa.edu.cn>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20240710023112.8063-1-engguopeng@buaa.edu.cn
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/cxlmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 59c7f88b915a..edb46123e3eb 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -538,7 +538,7 @@ enum cxl_opcode {
 		  0x3b, 0x3f, 0x17)
 
 #define DEFINE_CXL_VENDOR_DEBUG_UUID                                           \
-	UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
+	UUID_INIT(0x5e1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
 		  0x40, 0x3d, 0x86)
 
 struct cxl_mbox_get_supported_logs {
-- 
2.43.0




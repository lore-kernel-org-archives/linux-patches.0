Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25A783CDA;
	Mon, 16 Sep 2024 12:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488382; cv=none; b=bJ0cot/Rrsq9XJx2T18u1paZKKaTm53K4gTMtqoPTxXlazs7gionM7XRpeHaLuhvleACkMRAQpBbJscIrHFDU8qApFRoQCgw6PwnD/aj5TxG+fP6hM3kPM7nxoA4HyM6g96QJHh6X+QUDslMJ09RVc7J8dyurvwUBxRTU36+BGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488382; c=relaxed/simple;
	bh=fRCOFHd8ZYU+D4vPuz651jBccxtQu/qX7ivmrjYZVAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmXjkAAdki696iE8T2/5xocuxWJGkd5Ah40TIOro6cDAxTDjRb2PFlGREqv1FAX+7zXcM/mdqOFeNXCDoRpQfSFWxSILATytt/SRXnI13p0bvpb9T1QfICHyqYNKh3fFrd6FeOuLSdovCCZiIxEUJp4r+fvxAWuk6I1sl6rAhE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrERhg4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrERhg4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E471C4CEC4;
	Mon, 16 Sep 2024 12:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488381;
	bh=fRCOFHd8ZYU+D4vPuz651jBccxtQu/qX7ivmrjYZVAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrERhg4AZWwStfr+iArAaAFTsU1vEmiyv//mcmuxLZ/5E4IGlhSmj1XOjYJeuldul
	 6JxTgM50PdCNoowWMHmiCihBqPobfGwbeOuRgd+VHWovSfexmae5LT+5icVfJ8HDBV
	 P2iI8rpCiqZqhxwlVBqDtt9ZV+dQShBAbLaxV8S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	peng guo <engguopeng@buaa.edu.cn>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 066/121] cxl/core: Fix incorrect vendor debug UUID define
Date: Mon, 16 Sep 2024 13:44:00 +0200
Message-ID: <20240916114231.352939974@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index af8169ccdbc0..feb1106559d2 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -563,7 +563,7 @@ enum cxl_opcode {
 		  0x3b, 0x3f, 0x17)
 
 #define DEFINE_CXL_VENDOR_DEBUG_UUID                                           \
-	UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
+	UUID_INIT(0x5e1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
 		  0x40, 0x3d, 0x86)
 
 struct cxl_mbox_get_supported_logs {
-- 
2.43.0




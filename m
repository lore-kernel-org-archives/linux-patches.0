Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD87A95E;
	Mon, 16 Sep 2024 12:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488034; cv=none; b=dt6E9TBPMGBk3SSvdJjIGCcdIf+bx9D1GbJfu3+ZTAxWoYEGwpokjaWgD+iyGMATaHwR3K3W31JeA5C0Xa7Co08Lwyb9KeIHzDg8spODdSMPnmwAOtimMVJ7Y+Y3EDEnXIWMF0AUWEWKlPLtwmnbDWJc4OqjNlHXqq+w//lQR/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488034; c=relaxed/simple;
	bh=SZxWRBS7wKKsM5ty4G5dRKKhgZOuzk5H7ryLPH5JXws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK1s115/riiyEUEqI4aRQkQlGnLxDbY4T9ZpoBvhEcmRJkYtZ0YjTdl++uXhRAynv9H8fOlnzpK0K0yaubfRR0hW1N40riGPWUFhQAXN66w7jrq6vVmRPnQ0gpXmN8Xk+G7+PvPIE0Nmu5kBtGkLXcnw6NcaxcNmCZML251zTBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgGknqSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgGknqSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BC7C4CEC4;
	Mon, 16 Sep 2024 12:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488034;
	bh=SZxWRBS7wKKsM5ty4G5dRKKhgZOuzk5H7ryLPH5JXws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgGknqSrP+T2Y6HTuBZ07EmitHwBpAJsbohea6dPMnPQgkG2eM3MaiL3qYP1LC83F
	 Z+3Zqvn4XvDASXNy/+k4FP8bqjqcB4AZExp+I7MdeRvFVF2AvDwM6NBks6PWaEjRqt
	 5A1mJhHuEkloLXQCwoPDuNYfvq6YOGt7xIlQXwGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	peng guo <engguopeng@buaa.edu.cn>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 35/63] cxl/core: Fix incorrect vendor debug UUID define
Date: Mon, 16 Sep 2024 13:44:14 +0200
Message-ID: <20240916114222.306515474@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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
index b58a5b782e5d..0be48441d0f2 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -293,7 +293,7 @@ enum cxl_opcode {
 		  0x3b, 0x3f, 0x17)
 
 #define DEFINE_CXL_VENDOR_DEBUG_UUID                                           \
-	UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
+	UUID_INIT(0x5e1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
 		  0x40, 0x3d, 0x86)
 
 struct cxl_mbox_get_supported_logs {
-- 
2.43.0




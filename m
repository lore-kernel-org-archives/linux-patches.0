Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062889;
	b=cm9KsQwKHXHK4L3yRhixhuyOrex/+QnwIHqiXBkkWqLJrPGbQL9+Fu6p/obgfpsXpsyy
	 J/kpcsdsDHanToNxqJJgcQLbuBJsZDywCblLPxTSqZ+Il8vfa83oJMrmHcsopxW7R+a1A
	 4dGBalQ3WHZgei+f42u0DvYeW0s0+c2PQjGFsH72DSI+6wzNibZj6d/C/ZSnYH2OMD296
	 gyCWgFj0lhokuBB+871RuJmwT6KstGzf4vakf9UX3MEP/1SUatx5Ro246glbzmtBEoco6
	 kT2TzOgjfdon9hP80wrW56zEDOe+enqH5SuwVbBjp1JEXN7lmFFQHP/hnRyTQ4ULYxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZftNqLesApGLMBVlEl81Bd3uzX8cxO0qTvO5RYJuHRk=;
	b=zGc7l9pSlXzGl1r602ILZqpW/YuA+b9IeWSJ9lDdz28kmgHSzdx+eueOkCUOvtJrW918
	 3EueiXSZcf2zk2ybY0j+lMo4hPhbBGWhvu3uxnj1tc1rmeKYk3DXVALabvT7TZW8oXcit
	 IbBgr6qnEtloMqb/r/RRHLLfU5z+TsJsUV5dpC44jpmMvj+DS01roBFX35xdGQaOQKFxv
	 loGIj7TfPIHHetXUoO7GT+nnoXEY0kG6ry0gihgsAVoBWyUh+HEc0g42XFDI9zXjYqQac
	 V9zfUMfHoOWdkQFNlkaZc7xjIH9A0gw4pXOwQwNL5VFYv7W0HbUn0rAMiiM/1nLJ0Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+9F8gp1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1A4606A32C;
	Sat,  7 Nov 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+9F8gp1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876ED1F0089F;
	Sat,  7 Nov 2026 14:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062888;
	bh=ZftNqLesApGLMBVlEl81Bd3uzX8cxO0qTvO5RYJuHRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+9F8gp1OQsXU4xzApu/f/3SrI+r1bn7QBuscyGB29GWv++zSxZCXGN/0tp55ozNf
	 4MGYuzr4qNU0U3y/DKO9OwDx9fKX8jwSMUAD3Y/n0qQmEn1b7c35A3EIb1hdbA66Tp
	 j9kUt4jUVdOfW2s8wZFlpNNwN+HLhZfAk2VkR9mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/869] fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs
Date: Sat,  7 Nov 2026 08:47:29 -0500
Message-ID: <20261107134857.900816455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit ac02245b0ca28388ba16273f2fa683c90da2e5dc ]

The fpga_mgr_lock() comment lists of_fpga_mgr_put() as a source of a
manager pointer. The helper which obtains that pointer is
of_fpga_mgr_get(). Correct the reference.

Fixes: ebf877a51ad7 ("fpga: mgr: separate getting/locking FPGA manager")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260912100937.86316-1-kmehltretter@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/fpga-mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index 0f4035b089a2e..f6856aabf27d5 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -744,7 +744,7 @@ EXPORT_SYMBOL_GPL(fpga_mgr_put);
  * @mgr:	fpga manager
  *
  * Given a pointer to FPGA Manager (from fpga_mgr_get() or
- * of_fpga_mgr_put()) attempt to get the mutex. The user should call
+ * of_fpga_mgr_get()) attempt to get the mutex. The user should call
  * fpga_mgr_lock() and verify that it returns 0 before attempting to
  * program the FPGA.  Likewise, the user should call fpga_mgr_unlock
  * when done programming the FPGA.
-- 
2.53.0




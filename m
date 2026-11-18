Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058224;
	b=q5ea7fGweT8+VsgehwD2SN/S8xh34R3N7QfHBXZmSq7nazUdnCxGktu8UX5NMr+i5oOL
	 Wgyt4WR7bDiiWmtWNcE4DgTrcaZje4u7DWxaJEsEFepXiPa4QL1LgrvmMxegWK4Md6NIO
	 4MPbgPAAFS7bth0w2U1KMukYlo+pnXu5b1njpP5lqAW3R1crxp8iOFWY5Mb3UHVX7tVXx
	 3gTRT8mzu/i2XISTSOlN3R87teb3mQ1srkgEKjiMIIZFee6EQ1//IMX6XMg3PPTeCOYT9
	 6r/ZvgecaZ3Q0UI0yWI+ZPx31B5cPT5v/srZXKAe3cddLcq2/3d3tmei85aeO22G5mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vcEydXQhciUtrvKWFd9O/WujiNFT0SehLjp8nPF1YM8=;
	b=IL9ecP4Mo13MAOonItwxkxh3WR7UJouMIYZSdwwITIKCcUCXK67jZsd+DhzFD/6RuYkQ
	 HJafLhX0WLRDJ3uqszdN2XkhEPonPFW5/E2EpimneE5CtC6hzxl2ECX+jmzQEpwkyRitf
	 jtcOui/deZcvCgjYgT6Cde47OqGHwAnGSu3cbSfL7dgqZsk5aAvGfIRjUgH91wDUDUXpO
	 rkeyCPOtgcNAK5+bV7thGxQkyjzeaXDAppBFUIKVyqDC7mYzbtWR33jRaapbwoyZLbIzi
	 fEhC09yti9IqKBUOFM+YR3sisNbkjR4A7xlF3V1CcOs3yCwbdMx2Ob33pg+LuYDHMNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6QAyDa0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC98606A320;
	Thu, 19 Nov 2026 03:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6QAyDa0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2179C1F000C5;
	Thu, 19 Nov 2026 03:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058224;
	bh=vcEydXQhciUtrvKWFd9O/WujiNFT0SehLjp8nPF1YM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6QAyDa0SfV1eZNcH2yiNgJmkz0XYaJxIpOBk1xSeprLLm6IACnBQJzuNTAaapiex
	 NAMs8z4zM1rNb8kM0wbWw0jSRgXAQWjdCuFDE3cp76D5ViU0Qc0/hZcSJR3Vb7JPd8
	 QSma3wyfDc0IaVEaAJ/MgzVKpfs3NwduUwpFDFeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0411/1848] fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs
Date: Wed, 18 Nov 2026 15:40:49 +0100
Message-ID: <20261118145931.120085396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f38bab01432e2..de96d6100f928 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -517,7 +517,7 @@ EXPORT_SYMBOL_GPL(fpga_mgr_put);
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




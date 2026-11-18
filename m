Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052283;
	b=fnFMAs5rrV+MgiBlW6PZcYLnx+hfopEWTZV/D/lbB3XExlAceDGRkh9YGYkneMap8THv
	 Lr0bJaHzrPEWMC2Ib8U2On0AyOc0rH6Xi4pX5M0lhlQc2aJCmKPEuqEQuVVgfw+81X4h7
	 3cAEAQ4subwpQFM8vZMJB4ghTvLhmjBcrlUUBm/eKMt0lqxN/Zf3m3SZ5arpC1OPqRavE
	 F8FS3fLJOzwnNcFBvlHBvdOCBD5MrR0k1q3yFbBw6SRTZRzL+6/VAEzUs/cK3aDN0A2+o
	 osBUWZMhF/fmNF99GAPsOMSc4foCdrWW3Ec0fNi3K48kv2saGCfV6Fe6nyLTYnHNaLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kdXEeyS/VBJ1LB8QyT2WRkYk40wpj0jnWztYeOXB9jw=;
	b=LsEo+rGxgc+N0LPdmW59bbHsWvR5Y1/FVc/9YyO0szRD49aVAXzNM8PV5gXMGbf0JZ00
	 itKyR3FDpCEwH8WQ3r7V1sk1AVlJYhbrq/4CVIPdziNTVP5LkXGjgprbMmlU1DAgYQeFR
	 o1UFa4LfuRua+yRcIuRh1x4gsqdzdS5jsKq4tNwmVvTYliZP3k7l80MmPcXX1nqQ2aUKQ
	 udtECkUJixGmuQUP6Qhlf4nm7blRmKUbGw7JLGnwNa5zRXAOKJA2YvfdJ/62+fWBsQp2N
	 EliaXcvoegtiPhyGHKrQX1AfNfqpmH+CXUbejvFBNYUBlHOwzhSTT1eESyPFiCsR7/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2KMU+4HO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711E6606A32F;
	Thu, 19 Nov 2026 01:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2KMU+4HO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758081F000C5;
	Thu, 19 Nov 2026 01:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052283;
	bh=kdXEeyS/VBJ1LB8QyT2WRkYk40wpj0jnWztYeOXB9jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KMU+4HOdcjJNou6hkc1tEL8E0nrl51tKCBaXpAMWUHsjhDEvt8oB5lRedvu0IjMn
	 LwN8cjfO+STNBDedfZPsAXig4qKsopz0ZVYFsNB/ZFHBwa/UnUkZAfYnKRNVNjhJz5
	 8GHBn20hKJsKblhA/Po8LVcmT4cJa5JmQQ3mtADc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0507/2214] fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs
Date: Wed, 18 Nov 2026 15:36:23 +0100
Message-ID: <20261118150031.414819995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aa30889e23208..579cc84e44dc3 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -563,7 +563,7 @@ EXPORT_SYMBOL_GPL(fpga_mgr_put);
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




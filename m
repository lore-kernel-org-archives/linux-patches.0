Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829512;
	b=s2xE42Cf/1x2x+QIHPHCBwwVxUcQ3eYQgbZWFdsnAsatb+6jn8kY0MnQvlD4zeC6qUQN
	 Ay9ivSvTYisNeAeNsIHZRSlmxy4p/ROcj7+rDwu7crAESBtAcZvTOPjCux6BiGfcA3vkr
	 8KUaLJ2/oowpno8p3QwT11od4vvJYEhJ3tpPBJSLJkYM1SAqUxG0M0i2Rx7TbahDT5PiR
	 9/gPxj82mgtZi0ex6GQnRKD1hn3WFjl2NlQmjQgzLaxcCIw9qAJHzUi0nd1nAxaU5123I
	 AujKrpU4X/mGDng/6xFbGN6RrZSUTi9GiFDP6wxPVFEWBRqc2vdpu2AnkeTb8X/KgUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ne8oUjs6D+KF/ejO/6mXlkGPQ/M3OYTebqvOoTWyJ/c=;
	b=eFRtSfcdoftHwNU6Wcc7C2rzY2Sm7ltHxzE42QXtmKDlf/alK3WvbwU7bcsX/dxE4TV9
	 0d93/c/UtMAOS4BIqsKLbkHTx0ptKC8n7mVKnPQffx7yJSTHCuEMwt2Wm48CgdTeodCU5
	 /3fbgqbaVBzcZgkydUaFdRx13zNkmvPeMuKSIoJt+nTV2YPz3mCwP+dlpMih5g04Ec1Qp
	 hi/NjMiXUf3CR6xsnVSjD5+PYczCnv+cmVDmzoPCnieGIydIlmz+e8bWsbGaocXOKV+1C
	 aF1xFhHE3gqHTGWCY/XK5BtzgEgdAMSacrGLzif0g8i+or6E6YNPdsIIYQgzdZQ2q5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc7MOKRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4771F606A87C;
	Wed,  4 Nov 2026 21:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc7MOKRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D674C1F000C1;
	Wed,  4 Nov 2026 21:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829512;
	bh=ne8oUjs6D+KF/ejO/6mXlkGPQ/M3OYTebqvOoTWyJ/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rc7MOKRoBY9EgenYtrl0JjpDaTup1cH9rofxz9EKPfd6Ny/clhBp67wui5L3yc9SK
	 kY2YgtMTWSaoFWFar080OqCJPGerJ/cCcZTqSYHjJz5HudQCoaUPQmHR27v3/fsryx
	 zi5LVn/LRzKnAURksJZVJk1VTdLtQbw6R+MxPyQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0171/1005] media: cec/core: drop cec_post_state_event call
Date: Wed,  4 Nov 2026 15:58:24 -0500
Message-ID: <20261104211048.561410741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 2ff4b91e82bd76e1a6e1ff22bfc9aeda08e12a61 ]

No need to call cec_post_state_event() if the next call
is to cec_adap_unconfigure() since that will also call
cec_post_state_event().

This fixes the case when, when the physical address is
invalidated, you get two CEC_EVENT_STATE_CHANGE events:
one with a non-zero log_addr_mask and one with a zero
log_addr_mask.

You just want to see the event with phys_addr set to
f.f.f.f and log_addr_mask set to 0.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 84eaf9780db25..4d2262530c94a 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1708,7 +1708,6 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		cec_phys_addr_exp(phys_addr));
 	if (becomes_invalid || !is_invalid) {
 		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
-		cec_post_state_event(adap);
 		cec_adap_unconfigure(adap);
 		if (becomes_invalid) {
 			cec_adap_enable(adap);
-- 
2.53.0




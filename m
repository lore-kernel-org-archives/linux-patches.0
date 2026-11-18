Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039748;
	b=kIzsga+a+l5Oo2p6GEZUgiknoFOabyuFo+Yr5ONCd9VjyqD83FTkcnvgjpHDoESZucxC
	 5/jVUyww5WZ3vGn0zns2kZypR4fdJIf6Okapq4rGrY86B+VPAiwpogiIuceDgRjRy3JpP
	 k8+Pla29ooSV4PmYRR1nMnNbCGJnsn/Nwabu82eplFpbBCdKrKjNK4DEwNBHzVrdsA+eq
	 4q3ESByKzP0ynTxw764stvpz9k66U1r4rCeZumOH/ceGLDpTohrrMTRHd6UMmMDWPq/8+
	 oJuPQOcwdW9bPkQ+wD+KWO0c0K3MDrchG9vWVCLVGELlXEFSf+8AVH7baIC1TbhVyAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=54NfT7xZi8Tp5hofrzW4yLqK+b2X6sdY3AYmv5rN2G8=;
	b=SEYjNhWCzGnEUVys1hM/xfjE/RDd2M+12NW7UEVSSLGKz3kikR+ajJX6jwL+F5pDvaT6
	 KYi/a9ylJltmYWHAo2BONCKSH7blMSVRy6o2BJu7Q2nIBUFvtVhxCnmZzGXcnCSbjwmvN
	 KrIeDbursqeqD1TK3WfpfOM09dC4BxlqbgYJ2hkxaBcsXwEgR5MqlpiNcZSrrsrBeHWKF
	 JPBLfVgOfWbud5oPTdoT/jx1zestO1AAnCiRowKY1BAIbsTH1zYBvFiXvm6szc9BmFsmU
	 m0AkcXMQWqPV9+/E+GpSz5ha0vqwTCwH+NcxiENNKp5fCfBxJtExKuqr4M0d4SA+oEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1swB56BM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C4E606A32C;
	Wed, 18 Nov 2026 22:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1swB56BM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57A11F000C4;
	Wed, 18 Nov 2026 22:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039748;
	bh=54NfT7xZi8Tp5hofrzW4yLqK+b2X6sdY3AYmv5rN2G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1swB56BMm0gA2BJSVlBBsGvaj7EO3AK7qGrQ8PBH9dhSPFqoKNSll0y7BLPMgIYlY
	 e/hGFJPyz9Y5T6arQxTqF8WNQzaaj3E7LGuz4SXe98xUOGeKLODvI9UkGOeADNKVro
	 qpHpe8dsqHeJouk6ijqzIhvO/v4yL8A0WF8ioE04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	David Gow <david@davidgow.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2211/3318] microblaze: uaccess: Zero out destination on failed get_user()
Date: Wed, 18 Nov 2026 15:47:13 +0100
Message-ID: <20261118150428.242383601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 54c35131e628e1a18f02365495a24a73a1fb515e ]

On failure get_user() is supposed to zero out the destination variable.
This is documented in the kdoc of the microblaze get_user()
implementation and validated in lib/tests/usercopy_kunit.c.

Currently that zeroing is missing.

Add it.

Fixes: 0d6de9532663 ("microblaze_mmu_v2: uaccess MMU update")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: David Gow <david@davidgow.net>
Link: https://patch.msgid.link/20260914-kunit-microblaze-v2-1-7d5756e858f8@weissschuh.net
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/include/asm/uaccess.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index 3aab2f17e0462..ea6653dc2e68a 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -95,7 +95,8 @@ extern long __user_bad(void);
 #define get_user(x, ptr) ({				\
 	const typeof(*(ptr)) __user *__gu_ptr = (ptr);	\
 	access_ok(__gu_ptr, sizeof(*__gu_ptr)) ?	\
-		__get_user(x, __gu_ptr) : -EFAULT;	\
+		__get_user(x, __gu_ptr) :		\
+		((x) = 0, -EFAULT);			\
 })
 
 #define __get_user(x, ptr)						\
-- 
2.53.0




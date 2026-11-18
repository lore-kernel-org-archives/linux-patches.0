Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029816;
	b=3NOCUfj8Q5P/S1URDBrkmO40xvNpSp5Of/OWYMfJCMNH+tzxo6lGkyzJTMiEYmUJFV7e
	 gu4cGr53NvQR3GWT8Utg+/Ux9I3I7jqQBHJ5nvhpSjDH/TprXUcddASZkKBdMCBaYBbrW
	 WP118xhUCSQ52sV3XKBZYRiyOvZBhgT7odS1vzjOynV3fkUPyJDPCiPbtUbmYHTn90Kp+
	 3OD2E8PIDua2SZPKDp/A0pcRQbnxP7+CFBGBvArqISxsIRrFxnBi+8NGvqurz0J8KtdYF
	 fTRreTkexGFwEoN2XsSXpqQ7fjVE6a5j4K0KtgKBF/9N7xtPYynksKAW8bo6KGMSMMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nYiso/lEnn8iEPMeV02dh2t95tnJoh51wxdduA6UDiw=;
	b=x2HeNBlmO1Re460NyGBZRM3SSPJejoQUh+NkwkGbo/lW+1zfphLWgoKPwD3uHzEgb4mN
	 ltCSM2rSRaTBZM108JIHtdcl617SRCDHMm6a1jx0jMyyBQuwQrqXZ34aptF+l6SmS+2sc
	 ChvFN4zlmf6MjRIg1eaDnPpoBWJukP0LRfFvRjpOuqRP+UDca/wLLtVmHoPX0SWnMoP+2
	 geynWWpldh/89BNXizXwm/CXvtg+9Jb+zjWHnTAZkhJg7DJrWOr4Y9t61zR4dP4uW01MR
	 xi/G/1U+hjwJgkvl86ipUsoA7s8CpBNVbvjE7kiCaa3+bGVpOqGnX5jSiQk9C7v1njw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHiHNrHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B69E606A31C;
	Wed, 18 Nov 2026 19:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHiHNrHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0B81F000C4;
	Wed, 18 Nov 2026 19:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029816;
	bh=nYiso/lEnn8iEPMeV02dh2t95tnJoh51wxdduA6UDiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHiHNrHAStHeMR13K17pokFnH6HG6M+SZq7zOQuQAbAK9QDzBHwsbCYjiclDKxPSO
	 KQuxTyWP+YLlHKhbMN8Vl2/e3PxhAB0Iv80ugEU8beahsfrlUOkqKw3xjPh1g88H44
	 pXJzyvxLPEXOXPk2Xn/XsEZ8A1zs7tjwb4/24+R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0485/1756] pstore: dont leave an ERR_PTR in the ramoops zone pointer
Date: Wed, 18 Nov 2026 15:43:32 +0100
Message-ID: <20261118150028.309403153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 70fec428c845216da98041b1ae9f16a8f54b3d68 ]

ramoops_init_prz() stores the result of persistent_ram_new() in *prz and
returns the error without clearing it when initialization fails.
ramoops_probe() then cleans up through ramoops_free_przs(), which hands
*prz to persistent_ram_free(); that treats the ERR_PTR as a valid zone
and dereferences it, crashing the kernel.

Clear *prz before returning so that cleanup sees a NULL zone.

Fixes: b5d38e9bf1b0c ("pstore/ram: Add console messages handling")
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260921202317.70595-2-parri.andrea@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 4311fcbc84f29..4657503e47120 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -605,6 +605,7 @@ static int ramoops_init_prz(const char *name,
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
+		*prz = NULL;
 		dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 			name, sz, (unsigned long long)*paddr, err);
 		return err;
-- 
2.53.0




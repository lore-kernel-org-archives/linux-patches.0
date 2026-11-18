Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016715;
	b=pDzQNvL5xiEw7Squ8/Vo70nR7PSyqTLE8t0JcrSbU186VcCTXsO15Clx1x4l87WMGgoV
	 5MS6Wtwz8B2H2459o4HqEWOq8Gbj0ZlhC/AV51oVcMR0aLgFiKx/9G3hVaQMRYu9LTWJU
	 94yDYEnbpdBflHz6fwcduAGC+MdIGFIiv3YfbPcTeybhizlm2B8z2+qtWFEYvUdhhcRNj
	 cE9fzoajiMC2shsDeI5F+X5T6ak4070T/OJ5V9tDQzUhFkzf2ZHuahp23gYisXu9Qtmah
	 0i710W/JVqnhLlrGnRhHyWYG6vXWSVMh5b2eIjjPegpLXgvyjBKFS2aSwYdyOfIoq5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wif+88wFoKB8qkCKBO0hZoK4vfhbNkc0o8VEPN/Hstw=;
	b=rSUtbTk/PZhBTojfE2FDZfJLA8AIOXD4AkPvqbS0nIlUb1GoyPMMWeYW7OEXLMtnKlml
	 rdsyJdMCaHehuNwxZDpQZGjwosxltLFm+a/zAtzZt435+KUuQEXoZRMZIzvcoNWM4lknm
	 42P1i4MvVgR1OhCOuuy1HRGSFnxzXEMGSV8dwQGfwhllDdm2WRZriLwF3R8+ckYalioz8
	 ah6kh3khl0UDxdGKS92aXHcXR8q4nWeLr8DDhzugYdU0AxZ7P8HD+hRZ1xXoOFXTywyGZ
	 TD8RnhhN/+aABp6e/nAlEVS87OcftqNhOzgU887s1Q7ZHbfrJpaMyINIABoyAwd+C2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WgiaFYbH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD6F60A2606;
	Wed, 18 Nov 2026 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WgiaFYbH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F209A1F000C4;
	Wed, 18 Nov 2026 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016715;
	bh=wif+88wFoKB8qkCKBO0hZoK4vfhbNkc0o8VEPN/Hstw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgiaFYbHWIuPibSbU4jv2KomCzBRObbebh8+RH4TA/+3QVtp7H/X1PVZdDQwC4nlm
	 RsviNQj4QaEeCcdtUTPZSi5qd9ihfDK8Gpq+GaSocftFRVwgiNS14eGUBe+W8ZVyfh
	 4MUUEV32zw5780ikvDeh3YOOGCyrE+PpylL/4ZuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0627/2651] pstore: dont leave an ERR_PTR in the ramoops zone pointer
Date: Wed, 18 Nov 2026 15:31:07 +0100
Message-ID: <20261118150310.265080068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2eb0d4fa21869..aa056d0395a4d 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -604,6 +604,7 @@ static int ramoops_init_prz(const char *name,
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
+		*prz = NULL;
 		dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 			name, sz, (unsigned long long)*paddr, err);
 		return err;
-- 
2.53.0




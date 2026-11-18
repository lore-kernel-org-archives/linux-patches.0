Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045114;
	b=lChOd3/p81Qt7GS/yyY4B491x4iTvH/Vakt5pXWziXrfIUuEeRJqNfI+/BjoPj3u8H+u
	 i7+oLlS9FpkXKU3KEPepAKYUMqD+30SF7Jf9D62wkENo1UivN9PdSVqGJQiu9YKV/21h+
	 v1yUBrzo7om2quNelvcGUOxytA0yOWNjFLvsX7Y92Z0Cn7CuoP/jSZQg6h88rTlpQHXin
	 z++Od0UyQaM/9mSoWG024diaeSpWvbb7wH9lhU/oSfE4VAuVVEGQrixsWCKzXxCbpTidH
	 0y65r882NO+K7qvwrdE6CjSdxxeJhfYH2FhoHlBOGvOi4wCmid15ss3jUncpSpfqMJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oybIzWm9NNad5kqOUu702s1g/ZtYwQlzMWxtayPeJ0g=;
	b=c9dlcVbRlO3ylNuHO/8/9WnM5/03IM/HtoM1gBKf7KXwSbiBDz+IkqqobQSnfxHHIaoI
	 4iLWVUQh1GGYDU9r9Im4+VxB9I0EYas+0fp0ZzawHOkoxxBNAW8VF96UOnaLQIyRWTzQ1
	 RwPrCIbX0sa1FlVtjMOF4+HcM5O3XuBBL1cezQ2uiRs4edM/Zba4r20OybW118SdzUGU9
	 4wFnTKuL2pfVcALY3UXLFGjBYW0gmOXZEngA7k3EXd+I27fNJhxFTmOoRfuMkWvDQA1yj
	 Uvj6Yuwa7AcHidWDwOhMjAVXwVzltWbNNKgr/7rE4H4nMJvX1ak6LC3J5zQ54WWumCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEqFsEIy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDE3606A31C;
	Wed, 18 Nov 2026 23:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEqFsEIy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3BB1F000C4;
	Wed, 18 Nov 2026 23:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045113;
	bh=oybIzWm9NNad5kqOUu702s1g/ZtYwQlzMWxtayPeJ0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEqFsEIyWb4qLWbuwoj3jpXQpdC6TY6pUikQevOMvnIEYboUFQe/+YVup5jbaLxvg
	 tMLQ4gqNRv8941vgCDviU0eVqN5neVShLGKWWFTbaIongII0T3gCfkEIt2Ql0B/zYb
	 9b6TssDgD0YvLqf6Rc46t9bZyKbAbiQsqHTlaX1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0808/2857] media: tw68: balance PCI enable on cleanup
Date: Wed, 18 Nov 2026 15:30:42 +0100
Message-ID: <20261118150230.664482206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit fc02261fdca3ea95e4dcb6b38ab77f0f197c3750 ]

tw68_initdev() leaves the PCI device enabled after a later probe failure
or tw68_finidev(). Use pcim_enable_device() to balance the enable reference
when the driver is detached or probe fails.

The managed disable runs after the managed IRQ has been released.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: e15d1c12c587 ("[media] tw68: refactor and cleanup the tw68 driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw68/tw68-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index 35dd19b2427ec..577035fdd7c2d 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -228,7 +228,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 
 	/* pci init */
 	dev->pci = pci_dev;
-	if (pci_enable_device(pci_dev)) {
+	if (pcim_enable_device(pci_dev)) {
 		err = -EIO;
 		goto fail1;
 	}
-- 
2.53.0




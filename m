Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829719;
	b=lMWu5h59CSp8h1z33S6VYqNn2oNcgocg5IZ2ciznTNtefqR1Gn5ugahazUlsy3L9dFu/
	 RpufpTt0sSicwAn8cXtz+RKsTtKROOvZeVb1nBrLQogZroQEowZQA6I0/urKXpyCJCWzu
	 5wg4MAyN6AycYPmtiCFy9MUFAs7t6KrAc+KGvYRAZoNnFicRLseAXV0K8pW+H2yZyQt69
	 5s+vArgX2M5KjMoph2Q2TYA70XVp98X+2X4ityHGtCvKIdfrpblIBNn9rx+M5v7jZDV1W
	 Vl342/f4FHRVXj5WaMXi3VUcGkz8LMZW1PTOgaKERvdaC/yGUhwn3MbvJLt+7AWErlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mSsg02hBVyWhyOueGzwSRGtM9o46m9YsC5iRP4Gn3lY=;
	b=nO8SW5+mXbkKD/1woDDITJcP10uj3531GaV4qB99xJcjg2045r+FxDC8iTtuSU5934ve
	 6KcCU8q5FCShByq0cJlUUTOv4LxZxXaL3/6AMtvxIzLW7z4A55P6hBNsMNg/EogYhbshN
	 LPSaQMoXsl4POWVOj4yO18PvTwmiYY8jQyFKelktHdSdk8FsrVtQJSOEj+o+OemSeVzU3
	 dOxdagfgC3Nrd7sofpdGk0fHYrSWrp7E6Ra9K5ioZRmuz5jdXg8woT/Zy7sbo5WKSk1TO
	 847D1uOphKhVA1P1Pez5+SOHVhDsMHFQ/ygDQZyQOdmD+ooHw2ji3qnX+mbAyPAnasg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7iB9gMY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADEF606AB3A;
	Wed,  4 Nov 2026 22:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7iB9gMY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEF21F000C1;
	Wed,  4 Nov 2026 22:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829719;
	bh=mSsg02hBVyWhyOueGzwSRGtM9o46m9YsC5iRP4Gn3lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7iB9gMY5LzQaQspHxfHWibuqB37x75RZ31Lbl9Tt1zUOPSRoLViQD6LMj95f8250
	 tKV3vTH+JIhZb7fMG+VGT1f2rYHt0A4uVYhXQZp41u3BJt30/KO8vrQ7rTI/I3om9o
	 ilo0xKVORnF9qR/EfOz8boNcIPYXGDuuxeVsjC50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0263/1005] media: cx88: fix memory leak in cx8802_register_driver() error path
Date: Wed,  4 Nov 2026 15:59:56 -0500
Message-ID: <20261104211051.235181912@linuxfoundation.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit e228b8b1a5b47a72b265671dc6d864c0da5528d0 ]

In cx8802_register_driver(), when drv->probe(driver) fails (non-zero),
the allocated cx8802_driver struct is freed neither in the else branch
nor later in cx8802_unregister_driver() (which only frees entries that
were added to dev->drvlist on success). Each failed probe leaks the
driver struct.

Add kfree(driver) in the else branch to fix the leak.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx88/cx88-mpeg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 2c1d5137ac470..bc08b35e247e0 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -640,6 +640,7 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 			list_add_tail(&driver->drvlist, &dev->drvlist);
 		} else {
 			pr_err("cx8802 probe failed, err = %d\n", err);
+			kfree(driver);
 		}
 		mutex_unlock(&drv->core->lock);
 	}
-- 
2.53.0




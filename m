Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060829;
	b=zpDFOfRpXePagab6tzn6oKjligAEopFPIk1HMa16Spn++Mrvd2nDiyhAcTmLLcJt2ZJu
	 PSfc4a0Oz4jlqUzkeFC3AFIzZu6YbaGA8ncy1xEkEDuC/ZG8h9YH97y4FanbjCo9UVxZ7
	 wg3eOFy3Q5UXos0ooI1tPKObDspsWS3XUjrgurzrEnmKz5u9eatLRCm7drGoh6eHYW4GQ
	 L0b8Xi2Yhk74v5kAyA3YH7e9z4KqTX7X74wYpUrMbjpo4ae7j5cnlJhHoFEIXW1f+ArEK
	 a6nXdV0f9b1AGcpFd/wizAzKIoVdS09zN2mKZQCFrC/Ynk7PS10EzrFNY66BAOat9PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bkHT1/HNA+ffN9OMzn1fK137Z9s3jnwnUCrVi/CnJNo=;
	b=KOV1+nWmGURpu/dmHT+YDKw2BtcnaN5EBmTU2AZM9lLYuCRgMrOoqQQ5eDzShcoxbKFh
	 EQVy9KcpVOslJ1TLZBMr0k3AjV2KOt+sp1e8k+cGxMpWR8JDRyWz7jy4IBcG1T4kMX0Ro
	 DRRaPzs+svw6J0LWwJXnBz9FCMU0zr2iV1iPm3HqSkaz1GFvSHP7O6a/MeUii4OStbvRQ
	 rftd/Na1YX6ubzR5p5RdGcB38blOx01bl6rxWfPNjkrZVYd5JaZ5F2VyygHQ0D5Nrzth8
	 FHiic4C6OQu97+091v7cYXYpZyyfY6eFmAuurhExJXG7OEq494S2nPWcb3SNwYeIYEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SG6uNlvA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614A3606A326;
	Sat,  7 Nov 2026 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SG6uNlvA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9FD1F0089F;
	Sat,  7 Nov 2026 14:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060829;
	bh=bkHT1/HNA+ffN9OMzn1fK137Z9s3jnwnUCrVi/CnJNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SG6uNlvAalsenUjCp4lwUkzn5JZh7GMky0VMbvPELcBhJyTaaHUnzSgn0rGTj58jx
	 8fvvSSRYjEi9bphISn7kkjmuYFm0rlsAt8wCDUOaGLh4HQCZ7w76XeD/3tx40rj1Pn
	 kuXt4zEyLylgW79Zs9dfZwQqn8xXXNcR1HcirYTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0224/1536] media: cx88: fix memory leak in cx8802_register_driver() error path
Date: Sat,  7 Nov 2026 08:37:20 -0500
Message-ID: <20261107135003.956738277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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




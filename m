Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051261;
	b=Og9fcF4jl/K0cKekYMsu+HZw0nC/vy04/AekBuCvXuX0EIcoJksX+4tE+HEvyyAPpQUD
	 oOuv3me9dKnG6D4fzsgmp8ON0ObUj+eSBYANSH21d1JYL3R1aeNFXBrXLlOJyIlsS/C8q
	 +K5r66F1dXoszKSAcm6rLRyg7A/hltX8hupOvb7Qhbcw3zWxGc1Q+ymfxxo67KKAunrQu
	 8bIfVl22opnv96Sh2YiGVMFbjQrrjXGHfeG8HQxDi/r4b2M75U4pcQ1ft0qRdiNMDIEb0
	 PMpTnKXrx7TB324qYfhFqeIr5hkcFshwmeQileqNEhMnB2D77Lk1+081ZxLJb3nVxsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k1SZ4qU1bDcnLCY0wFmDZACg6rW/cVVqkXKsZEFdDoQ=;
	b=4jKqb0nqwi11z6Z+jEjMK3uM+PcN/AdW5hBG1zNit7nzgavnY9VMjTKlylgCqiwzBFxA
	 ZGWju6VIflX0ej7ABRBirWeNIH5Argb1t45vVZ7PT0H+t4VGERiNSs9KoRwLqeXe0ITXt
	 NQF7SeBVH4cBvklC6vuExdDMXC/4m/mznL4ZPblbhfwvRU+Bz0sKyHGzMqDh3eIpvCKo6
	 Wvb/zUu3nZzFJGkZN9DhDi03n0Q7LGDN1vROcys3XtkRKnZVDv6S7hSZE+H8zEwNHD3Vn
	 spggauDkpX1D9aRdp2cOxuM1cMoomOapNM5fQWymyjJ4vA9bayAJ3G39mvfwFBhfqrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaHzaa+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96625606A31C;
	Thu, 19 Nov 2026 01:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaHzaa+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47321F000C5;
	Thu, 19 Nov 2026 01:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051261;
	bh=k1SZ4qU1bDcnLCY0wFmDZACg6rW/cVVqkXKsZEFdDoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zaHzaa+WTNp1Fiz0IaYyKRbF/LTUeegLjjHTL8jq/9iXVqqc1M04taR4ZYIwCyeO2
	 KAwWFxpyYsapQwlHhsLAs3LBNTrQVRmnCqFmrBGY63gA0ewX9KBrZRN/7MlDiCMR4r
	 bo1jbmr4YQ7UVfQJbAXBsJIIZZ9XP1yam8z1IUKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0146/2214] media: cx88: fix memory leak in cx8802_register_driver() error path
Date: Wed, 18 Nov 2026 15:30:22 +0100
Message-ID: <20261118150016.000187825@linuxfoundation.org>
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




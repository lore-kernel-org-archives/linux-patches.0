Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043298;
	b=nlJFmrfgD7EXRRx4rZuuJSpzJiFTtt/qUwZkywNVFDHPVo3SPcAA10LCRI2mMxUovAdE
	 7lfeRqZKbZ6uBFcstHgAl3yAcuEPsTEBCpRvDfcD2SJse3N+r4JAwbGjG5ZDUYcBmiL+J
	 F+q4pKhHcTAdj0Ao8GFDXrYxIL+uuwRMJuFvbjbhLc2dDrCUU4o9MpBpznb62Q97neuPm
	 Zbr6Ssn1rPOUCiyZ0Mov/V278FuWvWvc8GFtVdpeKS1CuuW38jSD2rNa/eAtXi6qrq6SC
	 8qYcKRY2rZ4rg4eQmji9NgnkMLRDvUcIdCStpoVmILZS4XDCtEm6VaJuYRpWDMN8fpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q80fgkTRyHzb3FVQzVTokg5oRT+eygdsiQaXtngMHQI=;
	b=17srRohr+6+d+V3hslxMN6lFu5QOvDyDSCo8co23sEL8l3erJeubJg/hXerIvZEWp8NJ
	 95IIUCRyZCIow/gcmtg7/WTNfuGfO30j1OwRfqKKUvI22675vQDMYCi2A3Pd+ecuBVBPE
	 kD7Sckx0pPVqKWpZlMxMohIYEwJQT5jnhMFHy7C2kSWpYOkh16oU/4GpTP03RoeyZF1dR
	 +wz/8JdG+BXwU+hjRfq96BEU2m4UR34cZR+bf7tPy+ta2FtPvpRUTZYrANnqtDdM7pAvI
	 UEIlhfAxgTyHasU6QPrOREYf5WGiTd1fKxhglCCfCktp8/ujL4zUup7JEYKMtsem7WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHkAFjWb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC9C606A325;
	Wed, 18 Nov 2026 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHkAFjWb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DF31F000C4;
	Wed, 18 Nov 2026 23:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043298;
	bh=Q80fgkTRyHzb3FVQzVTokg5oRT+eygdsiQaXtngMHQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHkAFjWbhMerS+OiVqb48OLEQjZncK0OKhZtEm0oGqa7PC889od9v4H7kjDbPRaZu
	 MVxieqfkI/RNVLQB41oKCWDuBnk/bzmgpoBEiTSM12hycmQ4he9WT8xH5lMz2dX03o
	 ZhQgz5zFIo5S6XhME90N2IbkFfCeSzxYxUMaoiP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0162/2857] media: cx88: fix memory leak in cx8802_register_driver() error path
Date: Wed, 18 Nov 2026 15:19:56 +0100
Message-ID: <20261118150207.184306202@linuxfoundation.org>
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




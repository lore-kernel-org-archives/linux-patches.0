Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057430;
	b=j4QuYhT5NJGc8CCt9JnVnU0hl9U1/4iGwwvCz7JP3/RqcPCsniJkQ9hrUkRrqaDCYq69
	 W16TRfAVWrYAWRskSHl/F0aSEm62rKECWcpvxegoD4N6Iu+QCyKP5IhhJz9mimJkSKikC
	 vbhcGMOXlxBMLbrkHdxxTLCpirZuOlpZOaMWSBJkJ665Q4LJi4GbqopTUJsRT+77CdLCJ
	 5giI4bnL7Mfwszuts5/LrzYk6TBlaL8EjX0XsnrNOmG1RYKd+iFPekW4HEHjoPavnSf4Y
	 l9cuYwV/mrWGE2FDolqAHf8hq3wJN3nO9ls6XXuZB+sm1cH8d4GdDdA4Dlwr79zIynA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U86K2ECc2XPLpv8BC0c7M8p/kMLDeseIMrcPdLuFn+Q=;
	b=Nj/eZBz9uGNioaynAq4rBz9HdTTudEs9sfVPount0mCvLjCPixFyDwbwF3YLTVKSyQ0J
	 a7FNkT/Pvi0UE1HT9oTx+JGrtSAryUE54Ysyu+vRO1Wzk+Qp/JzkvWQBba5efgfw/Z5R3
	 pP754hNGFnq10Of793Ohsdh2MTX8gUJVnQlxs4GkiYDNaBlNyrkiop1D2tDkF+LM1xoCB
	 ki7pXr5fJSBVjLacgrRK4yUx1XKoaixOi1dpsB0aiG+O7quxCmegxMDiJDp+8vkUalFFI
	 mBLC49Hyn02VdPNz5QDuY+8DEAm+RiivEFj4w3jFDAest/+WGOxQmcTU9x6JQo2XWnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwteRf8I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A9160A260D;
	Thu, 19 Nov 2026 03:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwteRf8I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318661F000C4;
	Thu, 19 Nov 2026 03:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057429;
	bh=U86K2ECc2XPLpv8BC0c7M8p/kMLDeseIMrcPdLuFn+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwteRf8IQgXQfta8o9MaLJM4qONv1583SAsSM17SAI0aWr3fQeeuRM+C2B+Y1HFvx
	 BkkUXNXutI/HyBwMBuDZKnpvLWgXX6rwoA8JBNkXhWWF6eGTSBM/XI2u0oxWVZE0PG
	 YigCS0QbZcUypaCNzAZFHS2uR74AQQ8lRE4x7ixg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0126/1848] media: cx88: fix memory leak in cx8802_register_driver() error path
Date: Wed, 18 Nov 2026 15:36:04 +0100
Message-ID: <20261118145916.353505786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 10d2971ef0624..8c676d89d91a1 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -641,6 +641,7 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 			list_add_tail(&driver->drvlist, &dev->drvlist);
 		} else {
 			pr_err("cx8802 probe failed, err = %d\n", err);
+			kfree(driver);
 		}
 		mutex_unlock(&drv->core->lock);
 	}
-- 
2.53.0




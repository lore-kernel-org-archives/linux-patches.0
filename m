Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060683;
	b=bJBIyxVmF6p//Y6mybf5CjkTVSj0NYmLdo3fPW4lORNrv566GsC3ZXNUYL2SsD/37d0V
	 Vw5+TPtOR/RPqpsPB7G61UNkG0vEX/THsPEk6+Pc4+/452Z5bKd4x6Tapfsq4tjRiie//
	 VBeHQA513XPKiL07rkyZG0ET7DwS9Y63RkBmwC1WvEe6H6XGco9eL1v7qKaQ/PQYSQ3yS
	 brSdfBoOX7ATOiGsE0kMfPnHWB6oh8iSzVilMlFoMQUckQ1iEJDbaceUvCpFN4+um05MI
	 3wjgp7d5uveNYyxP799uGtQI02VJ6Wn0JiBHc0yobmJR7+swduYjhqE82ZYuYbnidiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7K7yZBw2bis2us9il336LAfULxNieqpD4/ehviwLXTo=;
	b=5pOL5u1n5oduUfObQfoe6gEuz+ecqFtIalY8mvEuD0J4VpwdtzIV5j7qs1M6dYo5kByG
	 eWgPvzsuMHZOI4oCG4JJH4al89LkEM0XG93mfagP7+M0pY8eJtkNghXsaNsq/JYTpDF72
	 3JgFB1Neubj5xbYyASTVIMPdby+vQILum+c3wmV1ThEdQdRe1PFB9mKYp2rbgmihbqM6f
	 4XSWlI23EENGOc40xk3euTR40KNk2p0VdtBB26td9Uww1DVqI9nka2NWX37jHEwSXBOam
	 sYzlGWBdukGoJr8diWSjvL+qz62oZ25Zzw/YoNc6VyBNUZVhJcgEaxoURJsWHMhWz0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vy2WIWw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C8E606A32C;
	Sat,  7 Nov 2026 14:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vy2WIWw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAD51F0089F;
	Sat,  7 Nov 2026 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060683;
	bh=7K7yZBw2bis2us9il336LAfULxNieqpD4/ehviwLXTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vy2WIWw7zlnvfvQnikRdff5UCf9O4Kcvnk6VlCZpxShbJ+airWXXfuzyvs41z7jcy
	 Rma/8R12uJu0czjkTHd5tDSmAcYRdgTREYYZqSanLSIA7zMfqOCbvq0BPJMgciRt5B
	 xBlV0FRopH41/V0yGibRqg5emvidfB0iIFHzVWDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0115/1536] crypto: keembay - add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:35:31 -0500
Message-ID: <20261107135000.912832723@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit b73b71df4cb4ca241165ad31218c82dfe489147c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index 5e24f2d8affc6..ab2b69e675a43 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -987,6 +987,7 @@ static const struct of_device_id kmb_ocs_ecc_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_ecc_of_match);
 
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_ecc_driver = {
-- 
2.53.0




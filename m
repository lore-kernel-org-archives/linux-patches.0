Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055124;
	b=5mUdyq/wTp/rFiNUp3ltxxLJmmHaA4uhNvAjwEMhrTjacQvNheBzRVLNillGVmsLh4FM
	 bzfvYPLUX2UGlAiLt9yndXTyPvXYAOi+rpyZgH5+jL+02MdnNFT5CUcMSl34mrKymru/d
	 RD2XDlYjoqNLCac05nJDTNb7Wt6exn9JQwcqGS3hUHRr/2fd9gA/2MjGqy0IkFXu7kTFi
	 1+usH5LxY/0UfsnYHIUoxLts4Tk4Es+v4ISB5D88p48DY26fAAN3phPJVw8HIRRuMJTFt
	 gYv1wipTiQup8ixvrM58+yhu/dJWNbVFqBlw8ZjEKvIOdcF8jVHSWkFrnkq7X8XegGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YLFV+MkKiKMPVcpJAO7LLi+UTYZ4mcfo8ivZqlbdVHU=;
	b=j6dgJDn0LUT2gFI/vYWf5QvuvLswwSIFnxdy63jN9cLO659ZmSW68g/HBGUXbsc8cCws
	 5SXgB0VFMe9AueXKHLvmIU3SgByrEn2LBEWfv6Ul3vp6pSKE6jdj1qROljtiD7wP/dUrY
	 tPdELT61UUVD6zxHOwba+3YNarXKTW/ebNyKJAw1WUdUlfyUtMG2562O+3gCao+v+L72Z
	 O3csU/dOq7bB2gZJzZ4H6Gz8mONfC9xqUBPekWfCUC3Q4yaBlXlLJPlyWo4D7r6PHL1kz
	 JeWTpZQ9fn403/tNZ373cB+5RgGnAJoYMo0+RmMQIPLVRONLjSg9O3TFw2f6n2vnLsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u24TQmFu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65206606A320;
	Thu, 19 Nov 2026 02:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u24TQmFu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2411F000C4;
	Thu, 19 Nov 2026 02:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055124;
	bh=YLFV+MkKiKMPVcpJAO7LLi+UTYZ4mcfo8ivZqlbdVHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u24TQmFue7JjwaIzt13n8cvQqmlElkSzwGOzyRai8U2p3VckZZAeDbppURdJW+ddj
	 66xUBj8Vn/YdVaECmYEKgWgC5OsdL+iNrLD7rEguQouuEsEftgwawAGXV9/x/eZ212
	 xPnQbgZA4MMRx/vZ75fcUPWwZFSriiBThrUDk1pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1520/2214] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Date: Wed, 18 Nov 2026 15:53:16 +0100
Message-ID: <20261118150112.930065907@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit eba5f518701b1c7f2d883504f89c41611bd2de46 ]

For raid5 setup_conf, if an error(eg. bioset_init fails) happens before
'conf->mddev = mddev', following error handling path could trigger a
null-ptr-def problem:

 free_conf
  log_exit
   raid5_has_ppl
    test_bit(MD_HAS_PPL, &conf->mddev->flags) // conf->mddev is NULL !

Fix it by initializing conf->mddev in advance.

Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging implementation")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://patch.msgid.link/20260915081731.122933-1-chengzhihao1@huawei.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0017e530745e7..d5e5e3b4691f8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7228,6 +7228,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	conf->mddev = mddev;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7300,7 +7301,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
-- 
2.53.0




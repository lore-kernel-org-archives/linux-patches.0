Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048333;
	b=252Xs9oWuMAE8VceC4bz+WmynQ3Ze/XVVdrF/ypGvbQg8zc9b6Aft6pL3oAF5OsN/40Q
	 ZSoQQF26uFJYqxXW+85brYSD9Ks+nzgjcmmduvxjOc7dgdYqViGsgsSmhheaVt+FSxZw4
	 rBFEVotCMYpHI10BqLSRG9kyZdEKqzvy3PDnuaS/iQMtdL3HwubzuirVSck3V2mAXqEAk
	 TBKCMtHJcKX13d43xf5B43YvfKxofp7C7HuSZtBe7cJrHN/Yq7b0v7wwCafmIBvpTpCbf
	 GQ+vgNHXfwNtwYZXOAtI4DahYWsI6nYjkISnJz8fdcvIoeMs92JkQzI8a+nFkUCn25A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XOre3hM9Wejo1cTd0o0wLod1pQpkjxGhG/niq+/b0Uc=;
	b=g2O0s49yFWQTnqz0JhmXfldufUvl6FfodJT1o6VhpxukpFqJ6JwGtQ939fzZysvruu4g
	 FWGHrOjNg7VGjbXMoxhhK+WoFOKPl1QueT8nh/j1ixY2a5G8J94QODmu7J7CV353Tlm89
	 QE1QtKBKIUYOaW3tEUB5K1XSWLFqnt/phK56SKgdDfOWXMqv4E7gq+m/qBjq1EJ48lqay
	 G3n7QrWlIkP21PXYI1rplY9drGYnRmjiJkWG+T19Hlg7QUU9lGUWbKpc7LLEUqKK/lDw3
	 n7MlnifOFYDtBAoftzD4nVVMafvf4r9zyeVwHtZJogUdNII2BWCv1ua2f+SeCE7gfnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vvg7XWHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB1B606A32A;
	Thu, 19 Nov 2026 00:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vvg7XWHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B47A1F000C5;
	Thu, 19 Nov 2026 00:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048333;
	bh=XOre3hM9Wejo1cTd0o0wLod1pQpkjxGhG/niq+/b0Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vvg7XWHA1+nuBmWhyRPhh0rxunwPcdbvCHCCz67n9S05sn6qB5Ycxi0wvURgBwafh
	 1xM69rrcz/A0nSar6pKV8/L9W+xcNIk7OxrluOG+0tLxkmBLvo/sYI8QYF58cAP1HT
	 0XvQC0/2tmuWVyuNgN3jGK6q2H+kQz/6u1I4bah0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1958/2857] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Date: Wed, 18 Nov 2026 15:49:52 +0100
Message-ID: <20261118150311.906915786@linuxfoundation.org>
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
index b022df9fdca0d..cbcca76b5b1d3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7544,6 +7544,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	conf->mddev = mddev;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7617,7 +7618,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	ret = -ENOMEM;
 	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683E21D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6F9C433C8;
	Tue, 25 Jul 2023 11:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283094;
	bh=lVb9P3WrInp7+yGTFvEGQcLlrKopVv0U6+cKuQqqQxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M13jix3Xw6hGld4gYyaDC91G1Zi3rX6Dv73MABusBPVKZr1gBw6CruRRc9ZV3W6Mk
	 QE/ae/nWIAKwQ0hpe07qVKOB7aX6OGELHjfiWhRSnBupIzvxJrdKpEVKrUxuyNHrod
	 mv0Fpr7BTEDvMqEBUbg3mx/8JlKO7rXQxqrVO8v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/183] net: ipv4: Use kfree_sensitive instead of kfree
Date: Tue, 25 Jul 2023 12:46:05 +0200
Message-ID: <20230725104512.853139596@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Ming <machel@vivo.com>

[ Upstream commit daa751444fd9d4184270b1479d8af49aaf1a1ee6 ]

key might contain private part of the key, so better use
kfree_sensitive to free it.

Fixes: 38320c70d282 ("[IPSEC]: Use crypto_aead and authenc in ESP")
Signed-off-by: Wang Ming <machel@vivo.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 52c8047efedbb..2d094d417ecae 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1132,7 +1132,7 @@ static int esp_init_authenc(struct xfrm_state *x,
 	err = crypto_aead_setkey(aead, key, keylen);
 
 free_key:
-	kfree(key);
+	kfree_sensitive(key);
 
 error:
 	return err;
-- 
2.39.2




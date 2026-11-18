Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060210;
	b=WLloxPfzJdWKS443xFhpvg1lfpcZS56ycKWUDNtzqyCuIVq4bbKUlEzpF50DZOAfA5Y2
	 nGsvzsKbUvi6MM+4JgdwvDtNYPpGePbNAOaDx1wzLHADPrOiIdV1Jycgo+3AGC+eK8jMf
	 /B00Ew+faNAKNU1gGUjSu3A8HlGS5HeA+zrRXLL+VSarJ6manJ+bSmJ3i8CKoBjvowYEi
	 /n+p4tDuGsPLy//RVggzxnV/zrLRfA8OLrsPaDBYCWCFwGYhPjJdr4bk6D1kajplF6Dsf
	 m00OngRWge4AOcQ9TqDj/sNR6mq+xfjHn3E3W/oHy6ItTsY2ZCnZp37HOakJGrR0Fdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1B5RG3kA8lRoNfdQ5vFksoqoxXDqibshra3X2MyelmE=;
	b=XwzcwJmOM4B/cNIy8LEt1CiZrNF9Oy8JkDhK4pDUKiCL8plXKQZx80IGWbC5DLphM1Q4
	 dprxlcJUOItcmUpGJECM3BujuOeKe2uoadif+6CVL8aoKyQRxogjScaEa8dBMHWpDguCF
	 lbnTlFFBhMecTwlWGtlw/TTKj+Q+X/OTQkvoaBnW30Ma0S64giXrjNQiC3D1/F6/FigEf
	 dJSFbWufy6HXRIZtbGpwUT88vZLdufK4wOtFHvjcj9IsfQ8zaV7KCzFuV93Hs8ItF4quN
	 a8XfUv/P+bFRQTQiUc8Ai27vqjPaKx9W/mj8SwsqV4ArvUidR7aCMqgrQUviM9kTXpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cp5rZoof;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96032606A326;
	Thu, 19 Nov 2026 03:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cp5rZoof
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D261F000C4;
	Thu, 19 Nov 2026 03:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060210;
	bh=1B5RG3kA8lRoNfdQ5vFksoqoxXDqibshra3X2MyelmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cp5rZoof3a8f6JZgynMvodT2pOb0iB4KHYEVNJHFr/P97g+U2f+UwXLsLoXKKCOSz
	 6g6lqzXl5IS7TozrXgj9gpnf3/xhNvCAXdxVRIJo6OrFCDmCgt7DV0TROTdvj2R0DU
	 QgY0PxSiaJDHJyFVuEyg9ez4RzaRWVoePf6dKyWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Vandersmissen <git@jvdsn.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 1118/1848] crypto: ecdh - explicitly zeroize private_key
Date: Wed, 18 Nov 2026 15:52:36 +0100
Message-ID: <20261118150006.138133618@linuxfoundation.org>
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

From: Joachim Vandersmissen <git@jvdsn.com>

commit 73e5984e540a76a2ee1868b91590c922da8c24c9 upstream.

private_key is overwritten with the key parameter passed in by the
caller (if present), or alternatively a newly generated private key.
However, it is possible that the caller provides a key (or the newly
generated key) which is shorter than the previous key. In that
scenario, some key material from the previous key would not be
overwritten. The easiest solution is to explicitly zeroize the entire
private_key array first.

Note that this patch slightly changes the behavior of this function:
previously, if the ecc_gen_privkey failed, the old private_key would
remain. Now, the private_key is always zeroized. This behavior is
consistent with the case where params.key is set and ecc_is_key_valid
fails.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/ecdh.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -33,6 +33,8 @@ static int ecdh_set_secret(struct crypto
 	    params.key_size > sizeof(u64) * ctx->ndigits)
 		return -EINVAL;
 
+	memset(ctx->private_key, 0, sizeof(ctx->private_key));
+
 	if (!params.key || !params.key_size)
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);



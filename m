Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829417;
	b=TvsID+L83bYPN/y4xz3cE1+qs9N4QN8mGraypcFlVjqF6MmUDLK+lR1BLubCsJGcfX9z
	 J6xGjeaEDllMWfk0uO8dm9Sv1VFNqXim7SCibaI7kLRqk1+oyFNrQPa4UkWlg5suJk3qG
	 /BQvxNePx6J+43x0MCvko4GVK8FWnSNVeVxwJ1/Vo1ZyZJG633OKQxB4EcqxYmCFFBVaS
	 BNDfZWjwlRTuN/NF8ufMArxK3VO3XbIF+k+9dmoyxwB6wc+PI9pMAMMJtKbqrIJOaOHCP
	 Uy0JNS5td1M9FmaZJmz2fFe161H5IuAVUuXKaAWV7fYzgYOy++0kqf1w8PBsgR6EWGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B/gdxULOVgXWPni79GvYrS+LjBFjEwHWRzerM6nSdjA=;
	b=FBOTcWf7KmkrKPbC48vUFn/tsvdhlB+P7FGffx6uddO3wbRaY/OzN8zQrmUzEybTq4xK
	 q9CZ6kxLdvTPRCtncEQCaTbofeymkryKtxdkXFXyA6Bj3yZyoCTl2F/gYqNwxiqE8CocR
	 52j2u6P5F3CEtJzejJndtX7CrfH+MKkOMnGxiKCYzd7zzjGZ7wT0ADPbWtkcPzGvv7wQk
	 q+Tk/s+IkRxJdOysuoTuMR8ybFiTblnY7VW1FyA4uK8Yys8OlPYsF2kHE9Zg4598mY1Tf
	 YHZHBKH2MBPEZdZ7TXEmo+ye6Ezf7R7MThzfoEsh1E52bZk3SmM0iKM9C+9XfGaC6CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KYrLkYc/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A90606A85A;
	Wed,  4 Nov 2026 21:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYrLkYc/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5F31F000C1;
	Wed,  4 Nov 2026 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829416;
	bh=B/gdxULOVgXWPni79GvYrS+LjBFjEwHWRzerM6nSdjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYrLkYc/Kj6eVgC/L7fE1s/4Ht8yvgd5hilRnFPPSc0mrVUxJilJ184SByjWT4TGH
	 sUA66xI6tz0ek0hAYfV3s5r0VTAVzXjsvbGbkI9M/qlL/ZTGTyn9+8cOrgu2aq/73h
	 XnPz8l7jS3AtHnnF5wyJjoVrd+gOq6cKzZQCGkEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0113/1005] ASoC: codecs: uda1342: Leave cache-only mode before syncing
Date: Wed,  4 Nov 2026 15:57:26 -0500
Message-ID: <20261104211046.818404536@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 29da72e58fde87e632f2fa43e448fcd1e3ab31b0 ]

uda1342_suspend() puts the regmap into cache-only mode. uda1342_resume()
marks the cache dirty and syncs it, but does not first leave cache-only
mode and ignores sync failures.

Leave cache-only mode before syncing the dirty cache, propagate sync
failures, and restore cache-only/dirty state on failure.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704072140.67222-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/uda1342.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/uda1342.c b/sound/soc/codecs/uda1342.c
index b0b29012842da..c21919bef4d72 100644
--- a/sound/soc/codecs/uda1342.c
+++ b/sound/soc/codecs/uda1342.c
@@ -308,9 +308,16 @@ static int uda1342_suspend(struct device *dev)
 static int uda1342_resume(struct device *dev)
 {
 	struct uda1342_priv *uda1342 = dev_get_drvdata(dev);
+	int ret;
 
+	regcache_cache_only(uda1342->regmap, false);
 	regcache_mark_dirty(uda1342->regmap);
-	regcache_sync(uda1342->regmap);
+	ret = regcache_sync(uda1342->regmap);
+	if (ret) {
+		regcache_cache_only(uda1342->regmap, true);
+		regcache_mark_dirty(uda1342->regmap);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0




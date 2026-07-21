Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD48A47127E;
	Tue, 21 Jul 2026 18:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659182; cv=none; b=ts7Je91ysvjh2swQykTx1JfYXPYX4d/YzlBha+iGsotSHUAI1E7PMMER3EvN3PAYY1pXnpeXr5lIx2ISFgqG9RV35B+arwgYKqBKxGcZbkfPi1w8kNPYFmtldIeNpeKNBS5HmGFbsiaWCnWiM3IXfupo57u4QwHUY1RJo39SrYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659182; c=relaxed/simple;
	bh=E4h6Ori+DgOnxGEEY1x33+oHkNCIo2nsKqle/stEEV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOakrrXJ4TKKoNqxGoqrFRn0diifSxmmU6voC5qnUTlCnr54bNgXultvXdilRV8jZyEC1Pklkw68IrFLEQHhMiUxQIi2ZXSVlDjbPOxgMb3OfUhrFhGmfTJTXnoOxWAWegvaBcSWiM3C6jd7xw2WNCh3UP+50Z9Y3QJtGG9FZw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmYRyzdk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmYRyzdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA201F000E9;
	Tue, 21 Jul 2026 18:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659181;
	bh=qPS5wN4U7l+vIoBFN7CcEZ+CvfklanXHKgYzxKzm+Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmYRyzdkjmzZKRtVzW3tT8EX6FD3cQw+YAEzvVLuz7oCaDEzM/Tx7TsfTCPFTWkvk
	 S3bMi3ls0Ui19RCcDkO4ei+nDTcskvQI7dbZga/1TgsQ5ESErtG8sH7pYoGo3IQRDF
	 F2lnKsAmwBvt9i20NpxiI1M0E/sz0/FPMZ69VdHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 1423/1611] LoongArch: Fix nr passing in set_direct_map_valid_noflush()
Date: Tue, 21 Jul 2026 17:25:39 +0200
Message-ID: <20260721152547.444526058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Wang <wangxuewen@kylinos.cn>

commit 70378a710598432f13509bdc16a1c0f06b3ecb53 upstream.

set_direct_map_valid_noflush() incorrectly passes 1 to __set_memory()
instead of nr. This causes only the first page's attr to be updated when
nr > 1.

Other architectures all pass nr correctly.

Cc: stable@vger.kernel.org
Fixes: 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -234,5 +234,5 @@ int set_direct_map_valid_noflush(struct
 		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
 	}
 
-	return __set_memory(addr, 1, set, clear);
+	return __set_memory(addr, nr, set, clear);
 }



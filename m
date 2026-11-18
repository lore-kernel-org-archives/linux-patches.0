Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058379;
	b=d1kPZiEeh45HmTXJc6VaUyTzLIjUTUxxwemQFDbnaACE5eGmOmCW6aVFkh6PIHTBXdeg
	 bJ6j88XAVPFiOxUX0zJzCryd0oaj0rC2+pjnXzxcrukHYn3SpQLRj4BJ8pyVgz9tc9HD2
	 oB+LBHcO7xyvcceHhJkvHDkeIO2ZjDr70uf4LR7Re5XxLUo4qQTYhD1+3mkt/DehdTowp
	 C09IXa6z6fRH4zJAZcbOkR5PM4SXRo1pzKp3chL5YuzRr0qzxjnOIgewGxmH3iGh27o6e
	 GllBN04ROdU79PV9gAq0ngC1sD18/kZ/Fn5gPoI9bZkZIlkvkIubd1RHL+V7DHR1uiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UAQfL3/69fIIs9DvbjXpILVCKw06mI92jN0Ri4ut2OI=;
	b=cwj0R/+VYCGENv9YL20SyixF4yW1TLH7ffufPmKnJDDgP0Y0fjI4PbpvZbxDYX1YLzmU
	 PcOYQKQKdunxmhA5E0SaTCMHQcEbMgHd4yrC9nyMhQQasysU/ANaR3tolfo6Xf1Lvz16C
	 NYCqefdxDyuE+MA6gZyjtpzd7lioHK5ztwygmAEJEm7ny+5+whRRzZWYCqP5vS5bzVF4m
	 mWT3Gl7+NdtqXRc7tIWLn91a8exPhuCpGlHJ5+edo6MoxoDpc3M0M4CSzdgZGXAMIoUmQ
	 AonUKjss4LxEt/kY+s6Z3y81YQ/X1oYgixJmYSq9eVTWQPjIddKeB9kSvd3eLwkvGWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNLOaxor;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6C5606A31C;
	Thu, 19 Nov 2026 03:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNLOaxor
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847511F000C4;
	Thu, 19 Nov 2026 03:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058379;
	bh=UAQfL3/69fIIs9DvbjXpILVCKw06mI92jN0Ri4ut2OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNLOaxoruP38hRF/IXH/uO7VqTqP3NIFco7UjwfhhAA0rXQUtxultyZT1f2Mx7cK+
	 yUh8EzCBbTkkz5elauB7AyIWCof6jYN3RPEGIwqZIeeYqt3iiJIATOzIh56IBPB3GG
	 EcmI2EqAc2rFv+c7ztw461WXkEgti5r15MEFTl48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0464/1848] crypto: nx - validate ignore before subtracting in decompress
Date: Wed, 18 Nov 2026 15:41:42 +0100
Message-ID: <20261118145933.817533344@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit b5c2df42977390a71f1940def5be9bd5c69ac2e0 ]

The decompress() function subtracts the header-supplied `ignore` value
(a u16 from the compressed stream) from `dlen` (the number of bytes
produced by the decompressor) without checking that ignore <= dlen.

If a caller decompresses a crafted buffer where `hdr->ignore` exceeds
the actual decompressed length, the subtraction wraps around to a
near-UINT_MAX value.  The subsequent memcpy() then copies gigabytes of
data past the destination buffer, causing an out-of-bounds kernel write.

Add a bounds check before the subtraction and return -EINVAL if the
value is inconsistent.

Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 2ab90ec10e61e..62ee11c8fe184 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -416,6 +416,8 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 
 	slen -= spadding;
 
+	if (ignore > dlen)
+		return -EINVAL;
 	dlen -= ignore;
 	if (ignore)
 		pr_debug("ignoring last %x bytes\n", ignore);
-- 
2.53.0




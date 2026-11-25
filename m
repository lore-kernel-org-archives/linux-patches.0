Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620158;
	b=YnI8Pxn+Q1Oe2biQwZEbL0w9gl/MXABviHpHkK9l9uE6enwQynKhBUmuCdNzUJNQlm4X
	 m9xaUDx2ljMX3kEQBmnc0iLIMc/SALAm6Bsds4xRDjsASrAAa1JOgtojBls/YbjeD5zAb
	 PWQEiztZJSO6cUORrIk6nVBcRGQvQ09N2JB4cWkQrpQrXJm9Do11ldTjYA+OqxlZHyxGl
	 bWFco5VHcmROxgVNtxrVcplCP1H/WkMoZnPIFY8pExDgg2GH4HgxC58kQr5W3F9urh8KP
	 U1RJ10SCTjJ8joCVHtGR9/dAm28WwSlwOaefwZhRq1bHMrb3Lzo5X2fQ7f5P9cqvJ2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DGZV4PzpB5FjbnV7D+uxeJPe0fLvJAtbuypyc4F30ow=;
	b=BDVBHouJsDkOm6zJIh7ThZ8V391SmK9mHa3zkA/4dMd5oMyw3qpynUqjO52h3DPJkBTS
	 Sx6fJ6Ux8LQpsPVCp2g4OYk9IbKVb1zdAZLh6KvEIvh9zKVoMct5Z0JylpbhM0KHtprlZ
	 qSB8uM1lJ97BjzMyv/Xf6GklRkbOtoGD/HIS2awAK3KlV0F9HGDQyuB7Ic5uIgvAfAgAS
	 5Dx5raWR+tib6xStnrI5SefxUV6G1Yc2zGg1oYbVvFf3t9by3Z/65yCYeY3wcZA9y08On
	 DbzgTkkxSCA1r+9fU56xmjbdBoU4nVxeRUlqPxY51XCp2B12VDFR5XdeVSCa0390BZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IH5BMaBL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891C5606A327;
	Wed, 25 Nov 2026 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IH5BMaBL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD981F00A00;
	Wed, 25 Nov 2026 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620158;
	bh=DGZV4PzpB5FjbnV7D+uxeJPe0fLvJAtbuypyc4F30ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IH5BMaBL5Fopyy+ytMt5D15xMjvFuuhqIwOGfdEoNtwRu96RvqhLqkbYid/GM/LUy
	 y4EDJYKyMskDWeZCitC7WRbTySCTCm21vnJKQMbdDajhFiQP7DuJ509e2Kr63w4je0
	 jaoxx75HCWwDVag4qzz9yPi7A/OgYGhM4Pn9wVfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 0827/1005] ovl: return EIO if the lowerdata is missing
Date: Wed, 25 Nov 2026 15:36:05 +0100
Message-ID: <20261125143841.096097319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Scrivano <giuseppe@scrivano.org>

commit 0d5e729c515f4ae4eacc179dbcf350d9b499a161 upstream.

The data of a metacopy file that redirects to a data-only layer is
looked up when the file is opened, and the error of the lookup is
returned as is.  If the data file is missing, open() fails with ENOENT
even though the file is there and stat() works.

This can be an integrity problem when using composefs: a data file that
is changed or has the wrong fs-verity digest is reported with EIO, but
a missing one is not reported, the file just looks like it does not
exist, e.g. a configuration file that overrides the defaults.

Return EIO as it is already done in ovl_lookup() when no lower data is
found for a metacopy file.  ENOMEM is not changed.

Fixes: 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in data-only layers")
Cc: stable@vger.kernel.org
Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1046,6 +1046,14 @@ out:
 out_err:
 	pr_warn_ratelimited("lazy lowerdata lookup failed (%pd2, err=%i)\n",
 			    dentry, err);
+	/*
+	 * The data of a metacopy file is missing or is not a regular file in
+	 * the data-only layers: the layers are corrupted.  Do not return the
+	 * error of the lookup (e.g. ENOENT) to the caller, it would make the
+	 * file look like it does not exist.
+	 */
+	if (err != -ENOMEM)
+		err = -EIO;
 	goto out;
 }
 



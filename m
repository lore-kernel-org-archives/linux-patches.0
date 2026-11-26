Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704576;
	b=ucXEsRzSkWh949mbKeRsq61BpLpXCS63nu5WVMPa53l89atPHpWkqXN+IibdQMwWSGzO
	 45ADuGOi6U0hCC99s10oNCFZ/xT8Q3j2fkG2rUSvle7m1DPnB6gNvGQDSXhAYLGbGWHw2
	 ORa6aTEF6Pfnol+xxtksggQPeewu813wJ22Bb6LRAm7rU8NvLYMjNcmWTmlIKdvg61mg5
	 Wjhn+aWvfMWPfcC9lo82L4zVe+8JmgWuku52tdI5DnXizdVe0r0ZQyQSxAyTZCK/roBKv
	 sLFP0m8MYaFdaYaZfeYogwFJoCrzAZZ9AxR/5qjKLb2JIqvXROonGhNwuqAcDWsUJtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+XVCa6OMG3bl9HtH7CfFsomCkutltoSAoel4xZa6n0=;
	b=1nWXY3emAzqiCh81OdDlEmMn1KLvWuu/T3hhlCXa/uTze7kGYFiOWJY8RfdE6gkNgrFw
	 D09mAiFZQc3n6zgBOX1ygRX/qm13Yk1ui1AGRZPwDZuAJb/xX1Q4qyxc6aejD3W+uxcr4
	 /YrF0juneqDOoxP+qdZm9gWPtZbHAqJxKn4NN8snTrXBaXyXkNGANP3V5uroJhF4ZGUWY
	 bCs0Jem0tkYi8W/IZjFaDzXoEKgEF3IL54AgasysaCdaD8OIILDCKz9+I0yjq8BAdAes7
	 ZVEKX75KmtfZDKzFADsbDUvwtQ1Cq5cqMmQPv8FesRAWpW+3WjMun3/v0BbiCbJZU0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2q23X4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE3E606A31C;
	Thu, 26 Nov 2026 14:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2q23X4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8CF1F000C6;
	Thu, 26 Nov 2026 14:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704576;
	bh=v+XVCa6OMG3bl9HtH7CfFsomCkutltoSAoel4xZa6n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2q23X4eSJ/FhxXqZcgiiVdYwju+bYHkWchdPjODMm7TuyGFXfgfeaPCCMrKJuMlt
	 66fIZNljhS/ITxJJ60UazclY756e7S7pGDqyp/sZIFDeV96z5JaNuA1GGg75Ol+dRe
	 FpzpGrtfVPbanI4vfSfzxB9BQ38JLiIjPIHspsSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 171/265] fs/adfs: bound directory entry name length in adfs_fplus_getnext()
Date: Thu, 26 Nov 2026 15:38:21 +0100
Message-ID: <20261126143617.125753668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit ebf5025b0d989f95542fc9da899b7de2fec499f2 upstream.

adfs_fplus_getnext() reads the per-entry name length bigdirobnamelen
straight from the on-disk big directory and passes it to
adfs_dir_copyfrom() as the copy length into obj->name[], a fixed
ADFS_MAX_NAME_LEN (260) byte buffer.  adfs_dir_copyfrom() only bounds
the copy against the number of directory buffers, not the size of the
destination, so a crafted image with bigdirobnamelen larger than the
buffer overflows the stack-allocated object_info::name that
adfs_fplus_iterate() passes in.

adfs_object_fixup() may additionally append a four byte ",xyz" filetype
suffix, so the accepted length must also leave room for that.

The old-style directory parser (dir_f.c) already clamps names to
ADFS_F_NAME_LEN, and adfs_fplus_validate_header() validates the header
name fields, but the per-entry name length in the big directory format
was never checked.  Reject over-long entries, using -EIO as elsewhere
in this file for a corrupt big directory.

Reported-by: Hyungjung Joo <jhj140711@gmail.com>
Closes: https://lore.kernel.org/all/CAP_j_b9BqyQrk3D5nj6RSa=eGcs2HkRYsWc3WdXeXp9O3=z4nQ@mail.gmail.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260715115231.1585166-1-sammiee5311@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/adfs/dir_fplus.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/adfs/dir_fplus.c
+++ b/fs/adfs/dir_fplus.c
@@ -192,6 +192,8 @@ adfs_fplus_getnext(struct adfs_dir *dir,
 	obj->indaddr  = le32_to_cpu(bde.bigdirindaddr);
 	obj->attr     = le32_to_cpu(bde.bigdirattr);
 	obj->name_len = le32_to_cpu(bde.bigdirobnamelen);
+	if (obj->name_len > ADFS_MAX_NAME_LEN - 4)	/* leave room for ,xyz suffix */
+		return -EIO;
 
 	offset = adfs_fplus_offset(h, le32_to_cpu(h->bigdirentries));
 	offset += le32_to_cpu(bde.bigdirobnameptr);



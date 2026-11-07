Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061626;
	b=QDoHifGQ8RG+Q5P9dntWHtNgBqyRa9HDILIsFXM4G4pujw1Ux9I0tVuXH7MouXPGJB8S
	 zt50g/t2qbl/RUJva3ke+vCwxl9BMWGkUFducClQeSWNMeyjzwSckn7ePO3HF0+lxSLGJ
	 w+qsQfpgVypF9eQ8QfHE9B9XT0etshliVS3C5p6f/8ZaFtFN0f3DblHc1Qrxl1sMThS8i
	 rfIfm2VzyTZDhe4lvE9jrtnb6pDUnNgvBHQfETbEyiRGlcUFHlc7RlXPqaRWd5550K8z3
	 KYykY2EivT0+rCPNzJ4WC93X0hOi2RO8BxLCIVEgU2dwHKEfCB8iPmYr+vrScwP+41w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxh/BVfFDwljPrIpwPEytxwF0eLGkKPn+irH+1IUTpk=;
	b=ZB78Z3Tr7OFid+w6w/VUEHifrCAjApkh0ucwKtgPiEY+jV8vU8pA5JzbHa+qen8dl67r
	 xk6lsQYZujBsBIn3ldutxWyjWrOLllEwwzTYK0PNahWbxYE8FC3QGb9osXwl5/Q4+BBu9
	 07eFs9i82Xc5aCw/UCugM8p5R9FLRXaHM3iUsaD/f681z21rqm3Ufc+BRY9k83gKp7OzB
	 808mNnLM3DQIRynJxbMhcKo1M7E+MUgnt/Yzw2MlB11ytxqu+qnABJP2ZrjnHGq+z36z1
	 GP0dekrezfHb2BMOhq4aBOuLtQQSTM/lmPHJib323EOB59oLMqPPwMc5ti4YJkjHrWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8z89A1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EABE606A32D;
	Sat,  7 Nov 2026 14:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8z89A1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1411F0089F;
	Sat,  7 Nov 2026 14:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061626;
	bh=nxh/BVfFDwljPrIpwPEytxwF0eLGkKPn+irH+1IUTpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8z89A1E3zGFlUHVYRadj5VEjCBVK0zi7LB+WwWaob0CUk7wv18DZCDNmDI2VOvJL
	 7yi3oeo2AvKrfNLqXRANLNLD4RRyT0oXB3KD/JG4/8w7BmAievh5mkYkKOAEoI7Tbt
	 W3TQfa4l8URlbxu5YroSxvE8LvF6gEspVph3VTPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0692/1536] xfs: fix buffer overruns in xfs_ioc_attr_list
Date: Sat,  7 Nov 2026 08:45:08 -0500
Message-ID: <20261107135016.925559953@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 0b9081a774ee7b9dff1e9ac3765b73c1d6bba5b2 upstream.

When we converted the al_offset array in struct xfs_attrlist into a VLA,
the size of the object shrank by 4 bytes.  Unfortunately, the buffer
size validation in the attrlist ioctl wasn't updated to notice this, so
the al_offset[0] assignment blindly writes off the end of the buffer.
LOLLM noticed the omitted check and complained.

Cc: stable@vger.kernel.org # v6.5
Fixes: 371baf5c9750a2 ("xfs: convert flex-array declarations in struct xfs_attrlist*")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_handle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -433,7 +433,7 @@ xfs_ioc_attr_list(
 	void				*buffer;
 	int				error;
 
-	if (bufsize < sizeof(struct xfs_attrlist) ||
+	if (bufsize < struct_size(alist, al_offset, 1) ||
 	    bufsize > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 



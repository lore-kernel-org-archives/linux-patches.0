Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831835;
	b=xkv1IUsRtg4rYdPIvqpgs5e9kR1z4jeY+9xhYNz73CgZgtDo7+CUo0rbXdAVn9JtQ39G
	 pcTV2NfCRrjY9EDFmO0cn/Kgq8FC1H0n64n7PSfqEL1HpYuVa/pS/at9Zvh8qT78XJeSm
	 xwY7FMSfY+KaxcPdZ+WIyeKCkiwltzKl6qwk5x04KHSN9PWEi9ynlrvBD7K45eWmiCl+j
	 3/oTvYqLcTzZaREubcccYyILXu+pBCEhe6+sh2uqAQTJhq+sbApanDysIrvDYeWzzG9sd
	 cl+kLv2+AW1rE7mLsIjZlNTpW2vkYOqtDbouaWn+uwGo70LKb+abm9odeq72V/B4GHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JGRFZ3JCPW+MXZtXX87D7NOyORlCsj8l5XKDnjPc2iE=;
	b=LHJK2Q3w2aAmi/+ZMb6ek3yTBXiEqtn1UA9lrBGU17wG9rDB2E6041zZNA//76oFGt66
	 cE/V8dBDC7rFbyVF59mh/TwdJBjyjquHwPqZ87hNZKSShGBxSQL9x2UKLiu+l4s+rMeJK
	 Sl7N2UHh6rghamBEcTZWJQ/cTe8NZFDJS8tphFQ1+m81/FCXmmOxQovhgiJNIYZUd9oEC
	 OTw2l0iGcXL30fy2CrK0oG0TglXQtaflHNkutFPCGZF2TeTwwcr/5ikCYMr3Tm7B9jVH3
	 x/cb7cjqXZwDwEdfPEMcKjswABFl+ZHoQNwxdOR4bk7jFSHbaVbjWd2B4MNt88KV8+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTkggpW3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF0C606A842;
	Wed,  4 Nov 2026 22:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTkggpW3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBF81F000C1;
	Wed,  4 Nov 2026 22:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831835;
	bh=JGRFZ3JCPW+MXZtXX87D7NOyORlCsj8l5XKDnjPc2iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTkggpW3qZiNtGq2NjYmjqyngwZSW8Dr77ee6RpUdNj6Bsi5HDjdo8XK6GdSVhiOA
	 PqaDuCamYdC3hU4OejfRbyqceemF65MmG31HMDjRcfh9+GfppxEb4qHbJON3sAYjfZ
	 RhtdiSlrtSNbX+7kgHwd+FpGfC5wa3HtZ62Zz/68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Flynn <david.flynn@hammerspace.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0892/1005] nfsd: fetch direct I/O alignment for files handed to the filecache
Date: Wed,  4 Nov 2026 16:10:25 -0500
Message-ID: <20261104211108.202524590@linuxfoundation.org>
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

From: David Flynn <david.flynn@hammerspace.com>

commit ace72c3d263294df7111477caaeff37438aa10af upstream.

nfsd_file_do_acquire() fetches a file's direct I/O alignment
attributes (nf_dio_mem_align, nf_dio_offset_align and
nf_dio_read_offset_align) only on the branch where NFSD opens the
file itself. The other branch, taken when the caller supplies an
already-open struct file, stores that file in the nfsd_file and
leaves the three alignment fields zero.

NFSv4 OPEN with CREATE takes the supplied-file branch:
nfsd4_create_file() creates the file with dentry_create() and passes
the resulting struct file as open->op_filp, which nfs4_get_vfs_file()
hands to nfsd_file_acquire_opened(). The cached nfsd_file therefore
keeps zero alignment for its whole life, and
nfsd_write_dio_iters_init() refuses direct I/O for every WRITE to a
file the client has just created.

Observed on an export whose backing device reports a dio_mem_align of
4: all 16 of 16 1 MiB NFSv4.2 writes that followed an OPEN(CREATE)
took the buffered path, while 16 of 16 writes to the same file
reopened without CREATE went direct.

Hoist the nfsd_file_get_dio_attrs() call out of the open branch so
that it runs once, for both branches, whenever the acquire has
otherwise succeeded. A getattr failure now fails the acquire on the
supplied-file branch exactly as it already does on the open branch.

Fixes: d11f6cd1bb4a ("NFSD: filecache: add STATX_DIOALIGN and STATX_DIO_READ_ALIGN support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5.1
Signed-off-by: David Flynn <david.flynn@hammerspace.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Link: https://patch.msgid.link/20260908163448.30841-4-snitzer@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1197,9 +1197,9 @@ open_file:
 			}
 			status = nfserrno(ret);
 			trace_nfsd_file_open(nf, status);
-			if (status == nfs_ok)
-				status = nfsd_file_get_dio_attrs(fhp, nf);
 		}
+		if (status == nfs_ok)
+			status = nfsd_file_get_dio_attrs(fhp, nf);
 	} else
 		status = nfserr_jukebox;
 	/*



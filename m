Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831576;
	b=XLKk7OZdS2hPnIm+IFSw2lxODCcfryyMJn849R9zfqHqMaCVdSaa3mn5u7j5bGj21CZt
	 5YVDydqv7hW8qTLUon3nCRtmLyAxHEhn61IDftC5+kASyfop174feZphl7nGIxgk0x9I4
	 iNI6r4AL3Q3+OBhNUNr3y7ekt4kwNTBQY81pzKblLBjkkD4VgxKnltaLbUC+N1sXInw9Z
	 botbxf1I5QG6WYnX5VXGd53kXcU2C3TIgHcjeb++jUTFNpqOM9LXpgtdPMxA/B4XXNXzg
	 TwarwUYmw/Z6onYMNkb0scFKySo2UPulLopSH0ai1Rs/O+CniI24KeXKjIZ6s4HAVPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TK9yB2fQaPbby4dwYMoIPdBQPkMMc0OLEXvpoSnNAEY=;
	b=ZLaWXIp1b4j07nWBkooseUXHvzVHvM0mumR+MfqfU0YQeSuSDV2bmWIHrueGcVGdGJWt
	 FPacGJZ0afSwogjdUW9q/bhgpQDyDcdWrCvgu+MuJuiJxkwIvCBjinRrA85Npvf3TC9Uo
	 KjeW/pIedPYK+Jb2MOYGncG/zE1gVzcgvnsAZlxkIgPMqWDTNqVytbchd1l3U+IlqJjIw
	 nj/QzPi4Zo0tjBeNIZ7+S7XjcbuFdHrnqLNe68I2hhw2Zc7W3FWRUM9cW48+BxbLAqOSn
	 LG7Nh1NnUi8rrDmae+4q4xFfbhJ57m8z5S8wqj5hZ5B5ABZtjC+IaZ6PJ1vsDUhCNsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3vxoR1s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4B606AB0A;
	Wed,  4 Nov 2026 22:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3vxoR1s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC551F0093A;
	Wed,  4 Nov 2026 22:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831575;
	bh=TK9yB2fQaPbby4dwYMoIPdBQPkMMc0OLEXvpoSnNAEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3vxoR1sB0MUs6wpuS0iLLgeWyJDE3viiwNDLQWFNVPb0xhYAnoKTTt8OxybNwrFD
	 mvHP/CUHz5Grv6QwAGZZLV44oS9YolkR5EgeQadfOcJCn5A8vj7Wi/ReazOZjcZfm0
	 PtmfGhOwm1uGRASENpwmZegWQiGka/Lfs2Vcm90k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0785/1005] xfs: actually report corrupt xattrs as XFAIL during cross-referencing
Date: Wed,  4 Nov 2026 16:08:38 -0500
Message-ID: <20261104211105.338828081@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit b339cc253019518c61b8b150fb7ea727fdae59f4 upstream.

Some LLM reports that xchk_dir_parent_pointer really ought to report
xattr corruption errors as XFAIL (cross-referencing failed) when a
directory scrub tries to find the parent pointer for a dirent name.
Let's do that.

Cc: stable@vger.kernel.org # v6.10
Fixes: 61b3f0df5c2358 ("xfs: check dirents have parent pointers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -155,6 +155,8 @@ xchk_dir_parent_pointer(
 			&sd->pptr_args);
 	if (error == -ENOATTR)
 		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+	else
+		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error);
 
 	return 0;
 }



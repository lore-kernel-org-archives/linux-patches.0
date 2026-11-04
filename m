Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828931;
	b=aKnBiER0yA8kxLb4nNw6PuBd9gaFLFa+hJAITkdl9r6HcKgyFGNjsO3vyzgxSlQxMyv1
	 u2xmRDdRXGDG1MYDaeH5K8MnqJ6TqWmVZ/ykwPcr87nmri2/ojS/p6RD7vmkFuLTKCeZp
	 5DoXtPp05v9HxfRKdolHTXNnrigAfsp19h1ffqhRcjsCsRQmtvDTD0Es2n6UWKLcPVink
	 TbhsHAyXG+Cb6MRUmduFhrJ7C7Cq4chkC6dB6A9ETekMJK6HBYBuwwKkesbrHpjvljDEB
	 droq3GEVCfLZJ3SjlW/AJWLhZwxio7alJoWmaIa4lmw1+z4qhxKH041PZ0DvEmbTMSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pQJVeSs9knAdQ9GD7IVtrJygvlXgF/yu/t4siXvWhSo=;
	b=vXQ7ZfzX7zZolhPiuIyHxrmljZwkuoAPoOY5z+9C8Ff26O/JtjGVWzoc5omuj6t0v0M1
	 BYhvf0dUyImTI3cCIQUO1VAkGV3AhjzBAPtpFv+5S8rYWZX7eaU0XDDXvJ+Bt9STTczjJ
	 KCYs/o+TQPGTIylHKpIZKoV/H4uCwB+ZNHBfxFRQ+dIqs/7LtlV7rUfHoz5volP4EElka
	 RDl1qJf6zFj52/2zPOjvl+qAeidjdZHDuXY3dn5Zb2EUki8eXtSPfApyJYNCRGpW55Lak
	 JQF/yiWIjzalYV6bGfiQ3UHhkVF8TJOzI1hG/Si3mJTFjfboxGBHoIHl9eQcnmm8HNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cy82fDLu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D2B6078713;
	Wed,  4 Nov 2026 21:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cy82fDLu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FC71F000C1;
	Wed,  4 Nov 2026 21:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828931;
	bh=pQJVeSs9knAdQ9GD7IVtrJygvlXgF/yu/t4siXvWhSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cy82fDLuxGzJOCT6JiMkTU3a+RznxBsBp7IVZzF9DcPVDiAZ8lspOfd34adxd+y9a
	 JhAqUL5kJeq7uwDbva/3rFiemkFgKNTv+yqPV3jpx1Y9xrBrptBSto83oK/b0ioYe+
	 GX+GZDizrZzN1gHJWD+fT7c6UlW1y6Elz7WxaTTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 333/547] xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null
Date: Wed,  4 Nov 2026 16:08:37 -0500
Message-ID: <20261104211047.691977482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 6b8d60784b61a17bd591cb4c6e8aa9ed29c24f5c upstream.

LOLLM complains that xchk_stats_estimate_bufsize underestimates the
buffer size by 1 byte because scnprintf wants to store a null byte after
the newline in each line.  Each call to scnprintf overwrites the null
left by the previous call, but we still need the null byte for the last
line in the file.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -168,7 +168,8 @@ xchk_stats_estimate_bufsize(
 		ret += field_width + 1;
 	}
 
-	return ret;
+	/* null byte for scnprintf */
+	return ret + 1;
 }
 
 /* Clear all counters. */



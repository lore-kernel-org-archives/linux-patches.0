Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061654;
	b=jcKBoMlfJV5k4+ti/o4/Dx3mK8N1Ti2arw3HNZVMLs+We6NE4/tNt6v664mIg6fBRBnn
	 tEbctBagmqKdZgKiPclz3hDDoZdXv6eylG9rf0q9aOn6HUwO2TQ487XZuKjevYV26Qaxh
	 xLMMkw/D81JAuZE9X04yK/OOP7Jo9yr9A2cYgWa2xnzzJ2bSIdsgM1xAaD2Ft/LiGPTjr
	 Mj0rYd74XrLjfZ8URyssaIzd3uSMGYajWqNi/9ikDwgCjfQIWCpS6GKCZnRWUmlcSayVm
	 u6/7KXSJBHhibV9vsILERx3X0K2d/5n4Cxx/YfV7X4SURzm/atE0e8v2fVLYFmJGRig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u2LvDyIZ1+HJ+Fy6VEZlY9Rqbv21TVSC9LP9ucU7HOM=;
	b=KsSrpyb5TXc5VxC7jWA9LkatQmhiNIuwGl0Xwkxk4r1oHRNud88KGVV1+ILxuOSjcBEu
	 vAUKGgZg+AvMSX7YTyqdy7p0jb87qbQufACTPWeCyYUmMNtBgX7SlT5Nu6/bCSLWOuYQU
	 FLGkL+4OsRd5G3bGbGT5cAyEpg50TygYqmL8QjHh3QoVLO0wJeCi+Wzj025LqiSX7qNhm
	 SlEGOqHQnYuvZlXMpjTlfaAU8LkXB63VZjZlv0jAjmsGAlT3ZeUjjb0ocHvGbop18RdC2
	 0+jzTXloOOhhlUUBciLWSV9h53Vur3+l9k4FWXXfV78V+EqJBgjAeo+ubKyQeliNhJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pfQwfb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3F0606A32D;
	Sat,  7 Nov 2026 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pfQwfb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241AC1F0089F;
	Sat,  7 Nov 2026 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061654;
	bh=u2LvDyIZ1+HJ+Fy6VEZlY9Rqbv21TVSC9LP9ucU7HOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pfQwfb+WXCVI3HLTMUHkqJ8Lquc7si354mNiujRJ39XNxpO4OHsl95KWOsTHrPJM
	 VvhTDFbw0fDRyJqi8FhPFtDZheuFMzmmOKEkiPp45lOPiyj6LSlkWvGC6e0tDJkpDF
	 8IzDRtVhn74NASaSDhmQObEUgHVNFtzwv4pgQ50M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0714/1536] xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null
Date: Sat,  7 Nov 2026 08:45:30 -0500
Message-ID: <20261107135017.554159903@linuxfoundation.org>
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
@@ -162,7 +162,8 @@ xchk_stats_estimate_bufsize(
 		ret += field_width + 1;
 	}
 
-	return ret;
+	/* null byte for scnprintf */
+	return ret + 1;
 }
 
 /* Clear all counters. */



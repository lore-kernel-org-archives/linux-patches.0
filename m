Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591170;
	b=LfCAyK+ZUBSyx7MPEmBq6lJhDrFJLSjnRUH8e0I1niUC56RO+2s5iX7qXk9nfJq5o/E6
	 zjhs0Zl5YTT+QPz/+fpZIRf1T8pT565V74d+5BZGj/Vx1o+OGH1d9hGYPaJ5G5RAkGsmz
	 GGJ8lJgkesCrzmLx2+4phKVGRtXUhLWEx3izCdTaQ/tpblIVGvCNfcykEk2EevIXAIaZU
	 e2NNzpCp5m8/WLDNfxvbEXpCUToWXBFZ6v0WjmjGCqSY5m/6LvAqK4cIErHn6pTyopOMr
	 RlBGS1siT97m5hFEFLzK1VKM8lBY4Tq0kq/2fcQMzbSAvCZb98CRody5oxVVDIZcXtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bGH3eEcTiP+3aT8/s19ltJ7j1gq9Zg8mCtWt/q58cqA=;
	b=NCvb2Wd1IKMnKWfdotUueRFC5XWbNQDjeJCm4AHXSks0u5s11DbGQJvHtSgyjxjNcokA
	 fhQ3JrrVO59cARdYSAk6uxBwnbXj5QqDV7LvJjuE31aS9dEbpolk7AkAd0MzsFdguXNaz
	 He9dhWtJ63ccpdm/8FBuZEXRNAETBYKi7XHuhAQVS1MP9AtGsIyIWM6u+Vs3tMOt0VCiZ
	 XHXgtRAP4jUihJCHZ+K7FTPwqzStLo60GzcYw61QnwVzKrTsNXEKVrPvtmc4nWbhnsJcM
	 mXPDBZkpBQnqcqlf3xYseRytBHKv3rmg+3eLPX6UdnHPdLhxKUV5bRZ15wNMz4PTFew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJFCAKlm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B13606C0BB;
	Fri, 13 Nov 2026 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJFCAKlm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F19C1F000C6;
	Fri, 13 Nov 2026 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591170;
	bh=bGH3eEcTiP+3aT8/s19ltJ7j1gq9Zg8mCtWt/q58cqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJFCAKlmI1Sl5CejUcLrvOxp1lri0LfJEiTH7r1h5A72UUeCBBa/92WtH2zcl1QUe
	 f0755kJPK0MStSsX/N5pR+o101R9i/ShH2TXU1RUf9OTcB2XkTQ+IbeYeD3h0U/euY
	 Lc8YUTmF8v9P0F2P3++aeSVAgsKa4c0/Dzj5Ei20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/670] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
Date: Fri, 13 Nov 2026 10:47:55 -0500
Message-ID: <20261113153822.448482551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit d8c2bc88460f89e543ab3af622fc8f34c7011d71 ]

xfs_fs_commit_blocks() adds the client's length to the offset before it
clamps the end to the file size. A large length wraps the sum and
reaches xfs_iomap_write_unwritten() unclamped. With the previous two
patches the LAYOUTCOMMIT then fails with -EIO and converts nothing.

Clamp the length first.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ca3d085a3e781..a222410812ac4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -302,9 +302,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
-- 
2.53.0




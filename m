Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B6F223E87;
	Thu, 12 Dec 2024 17:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022999; cv=none; b=rM56L9ZCy0Hn0Av+gE9jAmFQ1sP8iqqEphuhUXlTUO7idZtOe1bab4ej00hOlXlKxoM1FvVW8e3MtdjhBf16xzfMPYN6CdLZC1KByYt4yLUXe3a0rKShlzxGJPLFMWHIATSLYmNchAPSCz1B+dCgC1HpojRQB1Dx9OVPCQ7tonQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022999; c=relaxed/simple;
	bh=WduUDU8HGWnVnLXijDbaAFupOgEHngwGcsmkm53BS2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9BdMMWbuSUxZqEcKKp4LkBxE41MJM3grM5ai+ojn69+0K6IZ9D3ptCEkHrqa2ZmIHS3LflBFWpLgvLcMjvrTSuphuPHOyVc2Oj7Uewn83cWicQTsNqEp2+1Ejf1wr5UdXMhvlqbJlx6+YNVmwAaEQ8xO6jraXpvho/QMRh3PrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwIUAial; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwIUAial"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C70BC4CECE;
	Thu, 12 Dec 2024 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022999;
	bh=WduUDU8HGWnVnLXijDbaAFupOgEHngwGcsmkm53BS2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwIUAialBc0pCSTr97cxORGcy8ZTM9oFh1D2jVYrapCnyEW6NX2q+85PXfRwm6P5o
	 NYTK9+ngSMUWgqPeK0x35UtmXqvL9rqeCEV7nGKMJd59yuU/ojQ4TsrKM/N9HtQ4pK
	 1DnEM7QOBO0fhNBn0ehur2PtWT50fW3sutD4lOnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.15 393/565] btrfs: dont BUG_ON on ENOMEM from btrfs_lookup_extent_info() in walk_down_proc()
Date: Thu, 12 Dec 2024 15:59:48 +0100
Message-ID: <20241212144327.182257867@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit a580fb2c3479d993556e1c31b237c9e5be4944a3 upstream.

We handle errors here properly, ENOMEM isn't fatal, return the error.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5099,7 +5099,6 @@ static noinline int walk_down_proc(struc
 					       eb->start, level, 1,
 					       &wc->refs[level],
 					       &wc->flags[level]);
-		BUG_ON(ret == -ENOMEM);
 		if (ret)
 			return ret;
 		if (unlikely(wc->refs[level] == 0)) {



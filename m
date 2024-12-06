Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCB91465AB;
	Fri,  6 Dec 2024 15:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498705; cv=none; b=ULZILdBGnOR4rgDTrbbNDb6I1Ev+K3G9xwWc/6ztoPvkU5k8dE2dxa2rsg721xOUFqs667rP6NcZM9UATz6ngAjVa1Litgb9/3Qxy6hVz3yyjEorf/hdQ+ofQm5M0WgNFTmRtybZy6bE15xc1bLmfW5ciwiRPTZo7l8KLWTX4Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498705; c=relaxed/simple;
	bh=URZoPM8NR8rcMjrTAONQKn5SheyB/zaFKnJ7ANwHx2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qr5paZLx6iCiGbRrgR3jykIw1979AtJSJzx6DFOoEDn0BSUiZ1MTFcaWTY5N6ERbkVs6n+nXmrCTHr/5OgqzXbW0btfYBtTUb3Sappm08uJpum+UmF4XDYBbE9eMZv5ygm8qazicu0ks91qFoBExNwgGEv8kaNYaZ3QUlYvhBCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5dvnogg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5dvnogg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48846C4CED1;
	Fri,  6 Dec 2024 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498705;
	bh=URZoPM8NR8rcMjrTAONQKn5SheyB/zaFKnJ7ANwHx2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5dvnoggqHvjAOaHNU+T8QBY+fKIwajSkrIPannuIq22ggo0pGuwYSdiQ6fA3CWzf
	 khxsd6ZpsS35nx4mxSpqYxsyoUiGtLMDa6ZvKLg//TO2DsJlPh7kx0UaFwX4SUbls2
	 CmDu9sA+6+xvdxF8n/VRzUDDASvBO3n4DhgSD6SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 6.6 664/676] btrfs: dont BUG_ON on ENOMEM from btrfs_lookup_extent_info() in walk_down_proc()
Date: Fri,  6 Dec 2024 15:38:03 +0100
Message-ID: <20241206143719.309158263@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5170,7 +5170,6 @@ static noinline int walk_down_proc(struc
 					       eb->start, level, 1,
 					       &wc->refs[level],
 					       &wc->flags[level]);
-		BUG_ON(ret == -ENOMEM);
 		if (ret)
 			return ret;
 		if (unlikely(wc->refs[level] == 0)) {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77000226540;
	Thu, 12 Dec 2024 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020564; cv=none; b=uHEJ/enMvuaGavd7XQGcF5IzZelcS3HpsigW2e80m1ytFJnwHcVQ612pf4TGpdxdd5vqTuaKfnfahFDYaTW4HDfiuyu3RpRUKv0t+61I74ki17/Fd3MlFBBrxFrYb1fh6a85imBthsZ3IQAbk0kIcaY5xOa1GNRSFRIuPRK7N2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020564; c=relaxed/simple;
	bh=aNzwj6o+JzOaGDdn2lO3clE+32/lYvZzuzxoS+GkCVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Onw3SlDjLgq9Fq47wULEeM59ut6Bu40PZ23NjcQ0JpTMxFapOK+94LGSL4rW6W8SHGI6YS5yj71AYRlunCMpOqVWt5skuYdzbUXDqe5v1F+HITHcgwYvSH0IRAp/J6U+wtYWrIJ0vzpU1Yki6PU2AZXApz6rxyWIebaJ/e7ANd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpU1A4Y9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpU1A4Y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64BFC4CECE;
	Thu, 12 Dec 2024 16:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020564;
	bh=aNzwj6o+JzOaGDdn2lO3clE+32/lYvZzuzxoS+GkCVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpU1A4Y97NqTNJmybFo0sZcwucOXudQlzE47RNg3pu67x+QbmUJz0lxDoqJHRAyvp
	 /vqPZxGISp/mW4P+hTGhbPI+X8lpfvHhuWDe1eVeBVjO4f3MrRuPcUMLj2PjobSEkV
	 gGp1J6ZsghaXUIXsKtJDfkby039QDNp1mHhtOKqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 6.1 501/772] btrfs: dont BUG_ON on ENOMEM from btrfs_lookup_extent_info() in walk_down_proc()
Date: Thu, 12 Dec 2024 15:57:26 +0100
Message-ID: <20241212144410.664413789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5213,7 +5213,6 @@ static noinline int walk_down_proc(struc
 					       eb->start, level, 1,
 					       &wc->refs[level],
 					       &wc->flags[level]);
-		BUG_ON(ret == -ENOMEM);
 		if (ret)
 			return ret;
 		if (unlikely(wc->refs[level] == 0)) {



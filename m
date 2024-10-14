Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE7F1AC885;
	Mon, 14 Oct 2024 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919632; cv=none; b=FKvihIai34WTtvKldrtsj2gGZCgDWbQ82pyoCNhX0rAZ6y1yKhpcbZt7ppUFjrdASbF074egetnHaBKPBjSnf52dyL4Nf+9ZzaaaaFFe4I9MQ8oK+zUSRJX3lLT9653KDJEj0JfG+a1T+7zcmifVpwzIyW3vDDdlCdOJiIwsD70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919632; c=relaxed/simple;
	bh=Qda8jM2e5+1spywJIihty1F54WOJj4DpBCeltHmj7OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAa8Plb1tRFwI/7Yds/JEd78r+gbTnLWD75g1iC1rP3pf8pvZxmEsRZhbikL1N+eDk/FEa4qlhC8OI8ify23rcyEqfFOd459ne0ax5WvtHcu/u5tgRcRH2IqbfvuObeCpGWIexF15jsCVkpU+EENCZAMOGXd6kcdREaeUOrjr2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVjbN74o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVjbN74o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD52C4CECF;
	Mon, 14 Oct 2024 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919631;
	bh=Qda8jM2e5+1spywJIihty1F54WOJj4DpBCeltHmj7OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVjbN74ou0hzOSjq/cA5GaQBglfD54MRlQAT4zE0zou/spxTmFmRxNYtaM5nw9hsq
	 mP5NeL6Dfpg892olllKkpvipfgFBndWzZjtfyQ98BgvKp0bL5FZXkWVc5BjpITGxaT
	 nh6wmisKnYGjZLVd4co43GsW/rIXr+L8SdwW6rso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 661/798] fsdax: dax_unshare_iter() should return a valid length
Date: Mon, 14 Oct 2024 16:20:15 +0200
Message-ID: <20241014141244.020694119@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

commit 388bc034d91d480efa88abc5c8d6e6c8a878b1ab upstream.

The copy_mc_to_kernel() will return 0 if it executed successfully.  Then
the return value should be set to the length it copied.

[akpm@linux-foundation.org: don't mess up `ret', per Matthew]
Link: https://lkml.kernel.org/r/1675341227-14-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dax.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1247,8 +1247,9 @@ static s64 dax_unshare_iter(struct iomap
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = copy_mc_to_kernel(daddr, saddr, length);
-	if (ret)
+	if (copy_mc_to_kernel(daddr, saddr, length) == 0)
+		ret = length;
+	else
 		ret = -EIO;
 
 out_unlock:



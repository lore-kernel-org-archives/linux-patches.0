Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD7634DCDD;
	Tue, 26 Aug 2025 11:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207709; cv=none; b=l0dsBYzrYXApG9Oe1PtavVVyweXsKVnNyVmHzVsDbeE0ovzWD062lmCYsx+Bc3f/QX5kUZ/mnuyKbs3LvByXlq600362mC0HR0Jgw8omVy0mdvkF9f6KJVHcDbpUcYVwRuMdO4QgBc6MTmRMdN+bDLx1XyLA0NiYub9AFxq4Y+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207709; c=relaxed/simple;
	bh=u/Ao3pCRiwYEM6zkJmgRIDbGTre0A7iJwRyQhMYffn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVOaLehgnI08w4CS6ydiWTVZY8PkLootxAB2VDcWy50uhseMBViKJPNmF9A0hnK7/4QLjimFQhmSZ4dlTSWpAMLNyRdu6azgEj1ZITtY9ETEpAzlTt/97lMeM9ZGOzraODnNVLo6tj0pOfnfxuIKIXHxb1h/ZLvd5HBfeYsWSXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9h3+L12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9h3+L12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE8DC4CEF1;
	Tue, 26 Aug 2025 11:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207708;
	bh=u/Ao3pCRiwYEM6zkJmgRIDbGTre0A7iJwRyQhMYffn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9h3+L12nFRmptHAh9P7OYEjiF7A5SMs0W2DUdnMC4b/n/EnsYTwBnn9CBxD6l1L2
	 rOS7I9ujmy4Q6reGXFkSgERFH8JfrmY1euEml074npr85JZARpF88X+ShpNPyO5rcy
	 pgwmK3QviEC3NnJrevm+/A3EgqIuJS+rQ2PMY6vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 246/457] mm/damon/core: fix damos_commit_filter not changing allow
Date: Tue, 26 Aug 2025 13:08:50 +0200
Message-ID: <20250826110943.450022633@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Heon Jeon <ekffu200098@gmail.com>

commit b3dee902b6c26b7d8031a4df19753e27dcfcba01 upstream.

Current damos_commit_filter() does not persist the `allow' value of the
filter.  As a result, changing the `allow' value of a filter and
committing doesn't change the `allow' value.

Add the missing `allow' value update, so committing the filter
persistently changes the `allow' value well.

Link: https://lkml.kernel.org/r/20250816015116.194589-1-ekffu200098@gmail.com
Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -881,6 +881,7 @@ static void damos_commit_filter(
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
+	dst->allow = src->allow;
 	damos_commit_filter_arg(dst, src);
 }
 



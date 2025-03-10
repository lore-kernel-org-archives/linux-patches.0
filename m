Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2670E190072;
	Mon, 10 Mar 2025 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628922; cv=none; b=pUPwyVhdyfYmanalX14UqXtWYNlLsX5Dm6vy7MHtTkCkv4qV+nMYPd8InEnCaePztY6Slvfr27VbkoB99qFruvb2ohKm77okQeUPE+Jwh+KW4Fzunz4Oo5v8uLCrpV6YavLxDwx0kbhRr4TjpsK4A0hbejkCH7K4hp2OuePrdC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628922; c=relaxed/simple;
	bh=n7ebw0cvCW4lReObTO2zz3IsTXGDVqiExXbrNBWJTNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+dYEz24v2eSM+EdXomklRJF/UjoH0sBTRRxwUHtH3aPRsXskSZqYXuTbWzBFQJH5X9Xb1q0FGroyt9ktSVbwynJfHnxwpQ6ngNIkKA8YX52pmPB5kTIjHaAY8OPzAw+IdMRLC46Vm0g5a5wUF/QTjVKwqJV/vibWeGwwbFx2dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqgpwHYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqgpwHYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4058C4CEE5;
	Mon, 10 Mar 2025 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628922;
	bh=n7ebw0cvCW4lReObTO2zz3IsTXGDVqiExXbrNBWJTNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqgpwHYoyPhvodEa2qnlaxBh8JaYpvx+8v0TgQD7d5eyYyAtDvD4RXERhDxA9eM0O
	 SyodvWpQvJBKE8ecDElWdmqe8HDhRSGYivq3+WPoOjIN8o58/lTRweezyCnlX0jrvv
	 0BhDhGQGZesJLu6qW89Xs6bs9ZFsBZ+B9CU5fHQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ba Jing <bajing@cmss.chinamobile.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/620] ktest.pl: Remove unused declarations in run_bisect_test function
Date: Mon, 10 Mar 2025 17:58:50 +0100
Message-ID: <20250310170548.901041981@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ba Jing <bajing@cmss.chinamobile.com>

[ Upstream commit 776735b954f49f85fd19e1198efa421fae2ad77c ]

Since $output and $ret are not used in the subsequent code, the declarations
should be removed.

Fixes: a75fececff3c ("ktest: Added sample.conf, new %default option format")
Link: https://lore.kernel.org/20240902130735.6034-1-bajing@cmss.chinamobile.com
Signed-off-by: Ba Jing <bajing@cmss.chinamobile.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 99e17a0a13649..f7f371a91ed97 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2939,8 +2939,6 @@ sub run_bisect_test {
 
     my $failed = 0;
     my $result;
-    my $output;
-    my $ret;
 
     $in_bisect = 1;
 
-- 
2.39.5




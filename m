Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3E6188CD8;
	Wed,  5 Feb 2025 14:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766486; cv=none; b=ZSbnmuKmtEHo7VmTkRyYA0gDpdjIeb/lzGhSHyg9/B4M8WN/4tTqHX57BNoJPPAizz6mv6AGgSBUFqql7lt21On2ZCO6SdHEUcoAtJJtOoHUMM4IFjCO7gh8eEF4/i34Ycs7zHkV0s77G3yNGxpaWgUjpNGpvvYWattfjAwzyUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766486; c=relaxed/simple;
	bh=kMXMUpf8I93kOf1QU1eUHx2XWTYjvBusmfjPZUC7QFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDv06lBNf/sagaSVVIru9jUf/FQN61bywpcqoVhg1ghA7trm2/t6EHFW46EW7CQJaTpV6slyvVDutRBJy8IeqsY7ENR8ZDQgEHyPMRaaPWfif35qriFH0+iB5QW1mfLWSSPENOhyyPh9SIVXx4pRjGN+YJJ0mLzR0mxXQRtFTNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0JyKyks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0JyKyks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5D0C4CEE2;
	Wed,  5 Feb 2025 14:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766486;
	bh=kMXMUpf8I93kOf1QU1eUHx2XWTYjvBusmfjPZUC7QFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0JyKyksO1OeYUDsH7S+L1JVe1ssXZa3LiyCxvchJHThWhkX+XegSPgdEs3CZArcG
	 xP4NxDjBk2LVs58PLqdJ+Tx7lBJ+2GXaui3Hmjp9iVqm/vOL4ZM7QgD/3AtFbw7QVl
	 88e0P759luLufOiiCzX798EnJad9+uzX5nU6lZCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ba Jing <bajing@cmss.chinamobile.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 274/623] ktest.pl: Remove unused declarations in run_bisect_test function
Date: Wed,  5 Feb 2025 14:40:16 +0100
Message-ID: <20250205134506.710085603@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index dacad94e2be42..ecb22626805d5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2960,8 +2960,6 @@ sub run_bisect_test {
 
     my $failed = 0;
     my $result;
-    my $output;
-    my $ret;
 
     $in_bisect = 1;
 
-- 
2.39.5




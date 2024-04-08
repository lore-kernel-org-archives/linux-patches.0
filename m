Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865DC7F47F;
	Mon,  8 Apr 2024 14:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585072; cv=none; b=o0xL4KCzmIg/eJQ3RDPVuwjcqmk1iQcr/NeQvjeoIV9C5XI28OegwZwExoq/2WxS9JxPekapy9epC5rb98/jdfUdQafVpImRiuJKnGsYN0sAoWuarrRw1oWfuTrPnzhArDCSjZF9Et/33SwGWiF+D8VyB0GjDOPb+HKEqDO7RjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585072; c=relaxed/simple;
	bh=Ay6u+A8/arVcTLKZ4crBxJqdgtH3AnvApgNygnNa8lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVqrLm+Il/7t0fZZiOr+iR/hfQZrWft0rLxabApyxVaWrrfvWTRFrJiRYfqxTb8P3+wQhl6gj3vI1DXKbyLHmeBIdt3Am5RFSQfB/NVFjRkzB7gSXKSsMZeCZ9eQAk1JRdvK3hWCn2riMncYnRr9XYSBIks8C9H81oi2au2LHXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFEWqA2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFEWqA2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F8EC433F1;
	Mon,  8 Apr 2024 14:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585072;
	bh=Ay6u+A8/arVcTLKZ4crBxJqdgtH3AnvApgNygnNa8lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFEWqA2IIm64h9GT4csiwu9zAerdjrGnK892FLxjEpo9kRCgQzrSb3NuIxOOF8Fuu
	 AnL6c/6uQhc1ShtAKM4BhZgjjek0k0B3jACXRjCQS3ttzyh+MeeEkmGJo+KT4rdBCG
	 JPpfltmMTGSm/0tYMtdjptgo8uUKd3lFBNKJaBrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 646/690] selftests: reuseaddr_conflict: add missing new line at the end of the output
Date: Mon,  8 Apr 2024 14:58:32 +0200
Message-ID: <20240408125423.051479027@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit 31974122cfdeaf56abc18d8ab740d580d9833e90 upstream.

The netdev CI runs in a VM and captures serial, so stdout and
stderr get combined. Because there's a missing new line in
stderr the test ends up corrupting KTAP:

  # Successok 1 selftests: net: reuseaddr_conflict

which should have been:

  # Success
  ok 1 selftests: net: reuseaddr_conflict

Fixes: 422d8dc6fd3a ("selftest: add a reuseaddr test")
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240329160559.249476-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/reuseaddr_conflict.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/reuseaddr_conflict.c
+++ b/tools/testing/selftests/net/reuseaddr_conflict.c
@@ -109,6 +109,6 @@ int main(void)
 	fd1 = open_port(0, 1);
 	if (fd1 >= 0)
 		error(1, 0, "Was allowed to create an ipv4 reuseport on an already bound non-reuseport socket with no ipv6");
-	fprintf(stderr, "Success");
+	fprintf(stderr, "Success\n");
 	return 0;
 }



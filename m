Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A09146A9D;
	Thu, 11 Apr 2024 10:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830996; cv=none; b=H+FwyKrB4mgL1IzTK0NIWJEAcEB6L4JxL+QxPFdXTzXf57DaByHuD/OO6bXACGxGI8cRgWAB8wAATOpfjhuTPylhKcYzJ/qlsWFpjd9VOZaOYCrHJrJSjC+rTqcfiObsPffZnX/0UC8CZwF/6GOhmlnDCg1id3UKLzMkJr/sNck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830996; c=relaxed/simple;
	bh=8G4TDd/RO5GoPAXiKcIJP45TF6VqselMZOGteGO+s18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMsbAUGqIvM73LU/bEZq72doH3u7TYLSvBFouA3qlAY3GFuCn/1lOzs3zz9TbBUG2Z5/uj9IMi7voXjMHJ8zh5R/xk+IQqoOLY5bTJRgszCiyaVmzd+rMatbW2WqZbhuguyCV810M7RS9MCmsKG5nJDXVrzR4JLXzLJYlQPEvF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgGgSZoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgGgSZoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3F4C433F1;
	Thu, 11 Apr 2024 10:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830996;
	bh=8G4TDd/RO5GoPAXiKcIJP45TF6VqselMZOGteGO+s18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgGgSZoM772QVsi7wO+rBJnDi56us6M1uPhlJjb9dXxv7PW7+nobApA6XKQ6AleeJ
	 YQKBtwXfe6xlB26aYV1IusgVVdPVBkouInMovS32ZPM69ORf/e1zWwgyBZqUvDqpdx
	 2CTHglPmQnX0ATRGzBeOm966S1DJ0+S8YFEYuFMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 151/215] selftests: reuseaddr_conflict: add missing new line at the end of the output
Date: Thu, 11 Apr 2024 11:56:00 +0200
Message-ID: <20240411095429.423353184@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



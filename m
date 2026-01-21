Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964033A0B01;
	Wed, 21 Jan 2026 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019758; cv=none; b=SXhVsCIF3KdrZiUcYlzvES2rhNEmmrpVKDVm7VaLl8KFWXy4ZYrWP92XzGJn/rXdRZZvzTQz3BRtLFzQ8WPk9SstrkHeypi6IWm27JcjBb3H0LxPdXC8yw6cfy3iN9rbPDLpFGC3toPlFS12ri+b63Z7S0cAGnIr1NcenDO1ZgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019758; c=relaxed/simple;
	bh=Unl4+OjvN3f+oVtq66oP3SK04fDJ5yJBnsus+G7TwPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0WcK3+VykcoHPKHgmPp57GLEBRQssl26rALxKLSUhQ0IMi+bsNauf7WkoyAor8PK3tY2++Vv4ETjXi9jIKNiEVhzBLycclc9ZTPkcoslhHTTmHpvcDP5jEY4K2z6lfB+sqLFxF3kUBejbJp/isPJbPvZYo5ymxcqMAxvb9G+dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIAFVqoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIAFVqoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B6FC4CEF1;
	Wed, 21 Jan 2026 18:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019758;
	bh=Unl4+OjvN3f+oVtq66oP3SK04fDJ5yJBnsus+G7TwPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIAFVqoXdcYKRNiUX+p6fZVfkG5+PheAxUAlFpQMuPEgYOSwGAahm2OI8Xzl9X0Vq
	 FemAy+Nyj8UHUHmIuGk3gefkWq1K/PKTCS/PPUXzdn/3qVFkU8cXDUPTXxykDuebjW
	 zFh1/8ZDu59fUP+QjnHDJKwvyK7+Sos9NxycloOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/139] selftests/landlock: Properly close a file descriptor
Date: Wed, 21 Jan 2026 19:15:04 +0100
Message-ID: <20260121181413.470781316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack3000@gmail.com>

[ Upstream commit 15e8d739fda1084d81f7d3813e9600eba6e0f134 ]

Add a missing close(srv_fd) call, and use EXPECT_EQ() to check the
result.

Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Fixes: f83d51a5bdfe ("selftests/landlock: Check IOCTL restrictions for named UNIX domain sockets")
Link: https://lore.kernel.org/r/20260101134102.25938-2-gnoack3000@gmail.com
[mic: Use EXPECT_EQ() and update commit message]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 01bb59938dd7a..c781014e6a5c6 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -4189,7 +4189,8 @@ TEST_F_FORK(layout1, named_unix_domain_socket_ioctl)
 	/* FIONREAD and other IOCTLs should not be forbidden. */
 	EXPECT_EQ(0, test_fionread_ioctl(cli_fd));
 
-	ASSERT_EQ(0, close(cli_fd));
+	EXPECT_EQ(0, close(cli_fd));
+	EXPECT_EQ(0, close(srv_fd));
 }
 
 /* clang-format off */
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C179A8634E;
	Wed,  5 Feb 2025 14:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765457; cv=none; b=gprdxfeYi/VB4AeM5IyKSDH0vA8sm1m7lnUJbxGwNXkGbNRWR9Zj+lTTnIPK6CL4jvpm4uFaCjBIp8BG6Zy+9lszFnudHHeTb23KMHe2839bg0J57fU0C/sEu/TuiHEQbsN+Zj5Q0T54YkxZgVER6yK0e7FdXIY/g4W6pzQEktw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765457; c=relaxed/simple;
	bh=DbmAQf5j3DppfLGI+GshXXjR91AwCqXeKZSN6fTo6MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7m9bspJf6vKtzgq5ojqc6qjqDNbvbI7ZY3NSnY13BYMCF/ruuoMuhRH0HPaKwiuiFuzMY5uko+MTuuIjbgUdxoFmBg4xopaLmPQ5Im0dHToSfOjxDcmnqLeCnVO/r1ItRLESqRLFDVo+JgRqmJBPD7ghXaGGoxuFuiLu2afIZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZyisqxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZyisqxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBB1C4CED1;
	Wed,  5 Feb 2025 14:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765456;
	bh=DbmAQf5j3DppfLGI+GshXXjR91AwCqXeKZSN6fTo6MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZyisqxawkkrwoqOtG0N3kmg7OHJuCoxYrYeLUx69F8hJQIgiPY60GXOoZkHTvjuc
	 DWRhXhnnSggJRm7uN1pudVt1zfDe6WhqXaqo5zLSiPW+BhrrjNMFh5Qqgc1IPNrDbD
	 MUeW8Bmd2CEEs5NHXnNN4lQabAsSvqbwgnT3zAsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/590] selftests/landlock: Fix error message
Date: Wed,  5 Feb 2025 14:39:36 +0100
Message-ID: <20250205134503.739015183@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 2107c35128ad751b201eb92fe91443450d9e5c37 ]

The global variable errno may not be set in test_execute().  Do not use
it in related error message.

Cc: Günther Noack <gnoack@google.com>
Fixes: e1199815b47b ("selftests/landlock: Add user space tests")
Link: https://lore.kernel.org/r/20250108154338.1129069-21-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 6788762188fea..97d360eae4f69 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -2003,8 +2003,7 @@ static void test_execute(struct __test_metadata *const _metadata, const int err,
 	ASSERT_EQ(1, WIFEXITED(status));
 	ASSERT_EQ(err ? 2 : 0, WEXITSTATUS(status))
 	{
-		TH_LOG("Unexpected return code for \"%s\": %s", path,
-		       strerror(errno));
+		TH_LOG("Unexpected return code for \"%s\"", path);
 	};
 }
 
-- 
2.39.5




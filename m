Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1684D154BE0;
	Mon, 10 Mar 2025 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628787; cv=none; b=YIR2T2iN5/8jberKP4amMLpSgV2eRLFL6tFUNqyID8FI1T6U92aNkoZwj4Kf9R05GLZuf1tKkYcr8ynVluMnGb6px9fMBru2lpXOYnyRWlmukm222jqIT6VcVeMkMG2LKML7o6CR30mUQiG//szHOfxiA/TfDPHkPgEQDoak9CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628787; c=relaxed/simple;
	bh=iDIyf7jmr18Y+6W5OqfrGspFGu3zexluvrjtI0YxLXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xz7fRdFsM5itb/uUGknmgE9j9XQe+dw1TYv+81LvCEC77IcHV10CoDcddMS79yNotAPgt64j/h/uFO75dLEpmkt7KNVuQr17jqMxByWUkbcWOiSSqHLVrsQjQg+mLloxCFp875yti1hSnbDol85fH4im2vfjFU3PzNcAq8U77Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muMzYLv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muMzYLv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF2BC4CEE5;
	Mon, 10 Mar 2025 17:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628786;
	bh=iDIyf7jmr18Y+6W5OqfrGspFGu3zexluvrjtI0YxLXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muMzYLv+HAmJQihwK6XArpsYPpT9TLlei7T1HISJmo5FYTm6j2gXaAf1DIjA6Md70
	 2AqmUKUGRjSta0flg+iY1PpKS+NZy84FqeHpzfIZDVnkE3hsgp4BCUYKNd7Za99lNN
	 0zIZ5zTmOqcaO40GI3L0zvqm9Z3IkuYM4iTyjnvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/620] selftests/landlock: Fix error message
Date: Mon, 10 Mar 2025 17:58:34 +0100
Message-ID: <20250310170548.265147026@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ea988b3d6b2ed..47fc4392f412e 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -1767,8 +1767,7 @@ static void test_execute(struct __test_metadata *const _metadata, const int err,
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




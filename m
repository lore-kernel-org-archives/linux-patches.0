Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FD11DE4D7;
	Wed, 19 Feb 2025 09:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956184; cv=none; b=proaZLehnGUS1N3cWfix7HEzA5GYBtB95oRY5Xmt373T2AugdcG3nwUMONKx5hupwbDSRc3uIIUn9/uNm56zNEoQv39/JxAgdnn9ftMIRE0xnNG9KVQQXsGdOW4i5K3LI6mf/F2+/41PiUmYaM7IpmNrIFRUFYSuNVS/bFCI5CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956184; c=relaxed/simple;
	bh=0fzxeKSMcFM/ip9RHDJhnw5KT/Vz3OhXtlC6IoPVvCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9RkXAPWFAFbOSaxmy2MFpMaGrZidwPFVfdQVzRmwi6/mOu4vqXx+CPpTUt8F0TEV4VIcp8dat44xfRyMC60qyUY9VW6EEs0N5ku/9TP5OL1HCrYa6AesWlQrVO9eaeHq16+HAU1DxqTwF+KxtGDycNJMFc0Bq9kiSBa1K/bL9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8st4Bdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8st4Bdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38AFC4CED1;
	Wed, 19 Feb 2025 09:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956184;
	bh=0fzxeKSMcFM/ip9RHDJhnw5KT/Vz3OhXtlC6IoPVvCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8st4BdvFSJ+bkOQJtCsQq/6VV6/BMlpDh5gpiHDn6hXJWFVwo0DvmIZV2D3tXSxI
	 oozfPy+YM/HP0V+ARqiaaoQrPqGetEonnVvsTFQZQlNokWKeef+JwMCsQkUmVZgPXm
	 JydXWiRBaH3dIhWU16U3yp98szVEDVcTtfl8QIyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/578] selftests/landlock: Fix error message
Date: Wed, 19 Feb 2025 09:21:37 +0100
Message-ID: <20250219082656.617536185@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f2c3bffa6ea51..864309ebb0b4c 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -1775,8 +1775,7 @@ static void test_execute(struct __test_metadata *const _metadata, const int err,
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




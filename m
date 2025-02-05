Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94DF1519AA;
	Wed,  5 Feb 2025 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764899; cv=none; b=ADK2Shpr0i0xsQjaxn6YKgX5wB3WLiLK0lyN0mHV/tkFSLciFRd0dj9a36XcM60XvXxWuK/I+ZHNgtd2epEcogTeib73lZJsWAWpmAqTqmKl/xLjlqBMUBckoUcy8Han38G5wl5yeQh6AJ+vKQ0h36xf+QF9AF6MruYJ2SLsngM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764899; c=relaxed/simple;
	bh=z3KUtzS4Gd9k3jkBm2wrCXT2y6r/6BHF/Ft15X5pFLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BGynisnMRlQarAw9EY1xMSiTsbPcsQzLmVHdetzlLBaAE4dAiz9Zwgevhwo4pMDr0ykHnrq2WrXvJaT4Al6T7gZVQJOd5diNEsC86D4TIfnYWbshsesN9WLSWuzMJkLbg5DHiUd+dKElIEtxkKdZxQroUvGR2NqVWjw5Ijk2kfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jy3KTxaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jy3KTxaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D01C4CED1;
	Wed,  5 Feb 2025 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764899;
	bh=z3KUtzS4Gd9k3jkBm2wrCXT2y6r/6BHF/Ft15X5pFLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jy3KTxaaDdfUhamKkuStPR1bN4Gy/nmT12JcLvk3ACxqIcUpBHwypEs5iHf+b50b2
	 8xi49g7fWzDHXSYdPeIbly+HJzjRdW549jeWWHqJRE9Y0cgDkNNMwDXpb4zL3vkAdj
	 IVZqTL7Q4BimEbD7v+yhjdG9pbw5KlfGx2awGpu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 123/623] selftests: ktap_helpers: Fix uninitialized variable
Date: Wed,  5 Feb 2025 14:37:45 +0100
Message-ID: <20250205134500.926865177@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 3e707b07f582c12ed78fa5516a97bf701bf0634c ]

__ktap_test() may be called without the optional third argument which is
an issue for scripts using `set -u` to detect uninitialized variables
and potential bugs.

Fix this optional "directive" argument by either using the third
argument or an empty string.

This is required for the next commit to properly test script execution
control.

Cc: Kees Cook <kees@kernel.org>
Cc: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Fixes: 14571ab1ad21 ("kselftest: Add new test for detecting unprobed Devicetree devices")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20241212174223.389435-7-mic@digikod.net
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest/ktap_helpers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest/ktap_helpers.sh b/tools/testing/selftests/kselftest/ktap_helpers.sh
index 79a125eb24c2e..14e7f3ec3f84c 100644
--- a/tools/testing/selftests/kselftest/ktap_helpers.sh
+++ b/tools/testing/selftests/kselftest/ktap_helpers.sh
@@ -40,7 +40,7 @@ ktap_skip_all() {
 __ktap_test() {
 	result="$1"
 	description="$2"
-	directive="$3" # optional
+	directive="${3:-}" # optional
 
 	local directive_str=
 	[ ! -z "$directive" ] && directive_str="# $directive"
-- 
2.39.5




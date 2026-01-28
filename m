Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EEA23E358;
	Wed, 28 Jan 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614407; cv=none; b=EVccb+fpdKJfQzzZBOYFLEA9Ie/2dlSSY3SY90E0e12dD5IddDql15cZk3W1eJknOq5UU8llZ4rl9G6cU/sT8vkmNLLwsfjMo3ySMPwqdqZ7jEoWc7Ef2/k5WimJ2mV2lGFk+P7wtrAiKGcgf/j7uSnJ7yjfWF4QSibZJiLdy84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614407; c=relaxed/simple;
	bh=jvkhm7Vafs2GaFoib6AnszyUmdT3IyVQPF6coQlqR6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npn3aSMIFhiXB4HAOxiM/rRCX1gykDqS1aYx1FV6ccOxx/aOxPxbGbqRtR28DRZzx5OkGLC90DGxgTNw4r2Qexu5BQeVyNy+EQfTKJpY391A1IdSZnx6RlieRMTiomVO1mnmGihdboniPgX0dKnnojsnAzBeken3ZfwwqhB3wt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0f+jbpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0f+jbpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A152CC4CEF1;
	Wed, 28 Jan 2026 15:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614407;
	bh=jvkhm7Vafs2GaFoib6AnszyUmdT3IyVQPF6coQlqR6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0f+jbpoPU3DwQU5coUE+DZtRvlUdh5G2U86AJChYPOA0z0Zc3UcLLyKD0W0i5W9a
	 ZTYigR3phEGewf96Cyr2thtN3rlMrCWvRypRN8o7QVjOJN65DX85gpTVWDslbEN053
	 6MkKEp1bJqEWBm7s9F1DKDKre7qAezjEetWQwCSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/254] tools: ynl: Specify --no-line-number in ynl-regen.sh.
Date: Wed, 28 Jan 2026 16:21:42 +0100
Message-ID: <20260128145349.354917397@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 68578370f9b3a2aba5964b273312d51c581b6aad ]

If grep.lineNumber is enabled in .gitconfig,

  [grep]
  lineNumber = true

ynl-regen.sh fails with the following error:

  $ ./tools/net/ynl/ynl-regen.sh -f
  ...
  ynl_gen_c.py: error: argument --mode: invalid choice: '4:' (choose from user, kernel, uapi)
  	GEN 4:	net/ipv4/fou_nl.c

Let's specify --no-line-number explicitly.

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260115172533.693652-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ynl-regen.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-regen.sh b/tools/net/ynl/ynl-regen.sh
index bdba24066cf10..88bd42496cac5 100755
--- a/tools/net/ynl/ynl-regen.sh
+++ b/tools/net/ynl/ynl-regen.sh
@@ -21,7 +21,7 @@ files=$(git grep --files-with-matches '^/\* YNL-GEN \(kernel\|uapi\|user\)')
 for f in $files; do
     # params:     0       1      2     3
     #         $YAML YNL-GEN kernel $mode
-    params=( $(git grep -B1 -h '/\* YNL-GEN' $f | sed 's@/\*\(.*\)\*/@\1@') )
+    params=( $(git grep --no-line-number -B1 -h '/\* YNL-GEN' $f | sed 's@/\*\(.*\)\*/@\1@') )
     args=$(sed -n 's@/\* YNL-ARG \(.*\) \*/@\1@p' $f)
 
     if [ $f -nt ${params[0]} -a -z "$force" ]; then
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D6D371889;
	Sat, 12 Sep 2026 10:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209786; cv=none; b=GhdXe0n1pYvnCQ2B6VyxHYcsV6M/nuFClFnJiatzuG9tVEnhxL82jyr9B1gy6I3t9ekA0Dj4PSEzyYyz794b9IXHoueMJSbkN6KP5gLhbktGIpYndOIJ3519lhFYNC9u1oRv66TMc79Gtht+FitcztDAIR1xQ8gO+C7K/1t4Nmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209786; c=relaxed/simple;
	bh=9nF4p3KWcT9y6sZlhr6D7g8N/8tCOrGEK62hNUa3sEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvPq1Xcz75Z7xMzqnhFK1uKZd2J5L1T+nZWYmL3OJSACEqJZJUZyak6tXEyUbVvsj6Z/un7/VSP6XWZAwHZDvbVZqlTgayP+8dM9gLuFgwwYbRoO/LtC/Q1X5BleBcODlVbUfDAWvfySBCa0MdFXPJ9CExRa6R5BDBau6ZAhSZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rL9Ajnp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rL9Ajnp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCD01F000FF;
	Sat, 12 Sep 2026 10:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209784;
	bh=C/bSKatM0gHf7ZkUJyIewlrdYT+rvaJpIiEcND5r+Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rL9Ajnp8X852YHyazKyJR5A6TuQbYqwMFefSe80Gtmn0rww8LjNtt2vuS+sRDNYbY
	 ysJ1dbQxB2L4uYlFUqR/LXNW43yAqPvUGig6T6+9W92llN6MYiLWxrQ16zRbX7j9ZI
	 oU0zXYWkwZiXlXtNXON6ZbywNNtq7OdASIuUYAAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Litvin <litvindev@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0892/1518] scripts/tags.sh: Prevent binary files appearing in cscope.files
Date: Sat, 12 Sep 2026 08:51:01 +0200
Message-ID: <20260912065643.629708517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Litvin <litvindev@gmail.com>

[ Upstream commit a9b93c34625a27bed5dc0f80ee2a359ceb955172 ]

When executing the command `make COMPILED_SOURCE=1 cscope`, the resulting
`cscope.files` file contains filenames with the extensions *.rlib, *.rmeta,
and *.so.

To fix this, modify the regular expression in the `all_compiled_sources()`
function so that only files with the extensions *.h, *.c, *.S, and *.rs are
accepted.

The issue has been introduced by commit 4f491bb6ea2a ("scripts/tags.sh:
collect compiled source precisely") which implemented the parsing of
compiled sources from *.cmd files instead of using the "find" command.

Fixes: 4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely")
Signed-off-by: Sergei Litvin <litvindev@gmail.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Nicolas Schier <n.schier@fritz.com>
Reviewed-by: Nicolas Schier <n.schier@fritz.com>
Link: https://patch.msgid.link/20260714083331.69482-1-litvindev@gmail.com
[nsc: cleaned-up commit message line breaks and removed cc trailers]
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/tags.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 99ce427d9a69d..173f5d23c4dc0 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -100,7 +100,7 @@ all_compiled_sources()
 	{
 		echo include/generated/autoconf.h
 		find $ignore -name "*.cmd" -exec \
-			grep -Poh '(?<=^  )\S+|(?<== )\S+[^\\](?=$)' {} \+ |
+			grep -Poh '(?<=^  )\S+\.([chS]|rs)(?=\s)|(?<== )\S+\.(?1)(?=$)' {} \+ |
 		awk '!a[$0]++'
 	} | xargs realpath -esq $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
 	sort -u
-- 
2.53.0




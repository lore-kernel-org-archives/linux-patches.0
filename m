Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F376726AC5;
	Sat, 12 Sep 2026 16:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230820; cv=none; b=NvaCyel3AVr/gjEKZXvZedNoZikU/f71SrWCi/apcHay879Z9fN06wvYynfea95CjgSrKb3kFpNVzGmixf2PkJlPbbtW2SOK6HCsusWTfRCrL2JYdJ7nzLTxmmaVnk9luZ7r/CSMHa/BI//PteklqAtUM2lhaMl0u8LSPqa6wW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230820; c=relaxed/simple;
	bh=taLfHz6CldKVmUQ3DvYQs01nQYAYLLZDXJoJk1OMhYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op7ELHPJRAULzIVDoWYcm5O+Wdub4EPNfUfJ41JbS/6P8gC6BgGbo2uf11RRbIxQ9xTrHjtdtGrhYxFqKLOzyTUtearR3miMwDbYs/r7JDSjeNg0qM09hRw8lWON0hnMccbdPyqbqsl4MyTLkqxD8uvhCPC2/B+zQDph/ureef0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGKQ1mf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGKQ1mf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2048A1F000FF;
	Sat, 12 Sep 2026 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230818;
	bh=xjMiv7YbIrcSsQpvRm9aKYn6mVdUnv30b93EyZ6oDpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGKQ1mf4INqtb7506tzJPb4I1KebYsb3jghIr3xk2S/cj3M474NsXH9xjn92m8y5F
	 5rY9Iwc4/i24BtEAojcoIaUs+sE49a2Gglrr5sUPz+Oqf8pfw0DgmLKDlErG8/Vja/
	 XQXTAvBsDpir8YEWoXmCuNHQz4rqI9/LdbIqR1Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Litvin <litvindev@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0870/1191] scripts/tags.sh: Prevent binary files appearing in cscope.files
Date: Sat, 12 Sep 2026 08:59:58 +0200
Message-ID: <20260912065607.796206556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f6b20f60c914f..3d09cbd236c85 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -98,7 +98,7 @@ all_compiled_sources()
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21411A6816;
	Sat, 12 Sep 2026 12:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217254; cv=none; b=AvNaovLhNLWheanwkEy5fpiQlI0nslxsVc6AtvlsUbj3R1L1aS5Tat4aH7M4u02K8r9bPYSo00dZJ6cxMyPYYbAXBrgcYM9sI2e/HTKR823QNMiNCCuzdDN/mOMk0WEoxnkava8ttUIUghzaHYG+QfLEuKx2i/WbMliQc6fVU+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217254; c=relaxed/simple;
	bh=ml7l3GeEHCr/L35LiwszY4FZGqKCyqaheN5x4hgTNoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ua1Tbf33lmLZm6glzLc4iKCxu3XlvJ76+2EXn7xzNWwBcqPc8b7solLlC+dfVzggEjldIvafqo4onP3QbYHguV0m5lrV9r/eawx9OCTCtMxEkEyD7VxQ94N3GtA5IZ+zDThpfnhS1yqNfI9p5J2v4idbCVvLVEdc/8Ot8HGmHuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJSmES/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJSmES/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE6B1F000FF;
	Sat, 12 Sep 2026 12:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217252;
	bh=VOjrilYcfA2T3W9SfyjFrN5Q4OO2v6dfg0vKwrnWJog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJSmES/BQKWo0mKiCMUPWv+iTw39x0rvstipMfag1DQ645di/1rVNTZ2ocS54l/kV
	 AqlPefyeJyAx2ZTJz29h9sqICbwnu3TqV+HO82aB/gx777D7XuySriE/XD4HT6hWTU
	 OHpl/6Z6ztqdq1gAzb2m+rrKP65a+7KAPTlvBujI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Litvin <litvindev@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0903/1376] scripts/tags.sh: Prevent binary files appearing in cscope.files
Date: Sat, 12 Sep 2026 08:55:29 +0200
Message-ID: <20260912065627.693123405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 191e0461d6d5b..4c194ebf7a70d 100755
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B213A1690;
	Sat, 12 Sep 2026 08:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202149; cv=none; b=l9At3y3kfA9fAfCNWOV7xa/CMEDdTqUlTPGieoWCbFSwhNtg6qJOa5l1hDeoTCMEM3+Zp4BPYH6ChZ3kg3rIeTKHOJziCV10Cd0jpIREp4Tf8J333Cvam0YV5ZxhVVnNBfncPDngABMBAcA4QA1Ok+/huuuQ46Z1nNzisM+f7/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202149; c=relaxed/simple;
	bh=YgdOCZcjWXJAewW+E2nFDWMU/0fs4PyNMckANAncYYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyTV0AQxqX7/gLqyJ7wwWgNsS73TPnjADP5kz5WyVMIxhtdiDeTJXBZEAn6k0mY9fx6Gv4ApKma2yRA+PNSAsiI4PpE35tAhIyEDtUbKbUPH1NgCYJWIHqI+2u/dnCyuhrV9ImeOgpWISEW8eqlaM2dfYYPYQQCSHSKMF8eXUhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2ClGzhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2ClGzhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED6C1F000FF;
	Sat, 12 Sep 2026 08:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202147;
	bh=q6eiENV8rK9dBg8BbMsH2YSqDl5SM6+VzME5up2jf9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2ClGzhsvB/Vu/2G30IxVnFP7BbvZqy6EAqMhjtzTWu/6AGEyiy3RwE1R3M0vELsm
	 x25AZqtUvmui0yRARkBLWocA7ngtLsjh+OTuXvqI7oSCMg80DBWRdmIrqadhB8jEca
	 4s6zmh/jkvZKpL0fl/Sf2P0GZxhT55iCg9OjyJXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Litvin <litvindev@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1100/1815] scripts/tags.sh: Prevent binary files appearing in cscope.files
Date: Sat, 12 Sep 2026 08:47:30 +0200
Message-ID: <20260912065714.841224300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 243373683f98a..c9dc2763a505e 100755
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




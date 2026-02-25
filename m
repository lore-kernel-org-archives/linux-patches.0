Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF032494FE;
	Wed, 25 Feb 2026 01:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982847; cv=none; b=C5uQ2LfO2Kkrfoly/QDSgwVYiLNj0lvMOqa2QqSgEn5gqWauDoqO7sJBs7gq/5L2rOhrToaifrmzF2Wm6jHunmmJU4ie76rz0llXisz1tOW7VsJvjpwSf/6lj1TpMNBULZp3jIDJMvOCeu2ktIcVouOL6DgcgHvu4qUgpJbikTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982847; c=relaxed/simple;
	bh=8xkTS9F6o1XlsM3lEQeEzmhcaDRJ79psN7Tib0BJgMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6rzjy7fNToRow3pGU03NwJcR1Cl63iWK7jSorPw+UPUmBK8+BiT12UfEN8hUK8StngDiRgy/1gpHrbN2tFve1HSDNZQVtnzgaJgQloASuQ5H3hSOQ4mytuykedqq1tBkUsbcdmimuqjxb+JOqu+sx1F3sEMXVvoNKXBGVbM+pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfOXe547; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfOXe547"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A3DC19423;
	Wed, 25 Feb 2026 01:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982847;
	bh=8xkTS9F6o1XlsM3lEQeEzmhcaDRJ79psN7Tib0BJgMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfOXe547Bq8gUCv+hxUvg79dd6aAlBcM1yuv6Gvq/e/42KPBwlSPCWlzXnvF7rDmj
	 NAz73nTcErAuEgT2dpKH6RHiI2RrxXocDlG2I9Otbti3kEbXfBz7r1gmpy5mOkauYO
	 eqLfVFdr7HrO6mF9w5jUmxLqayKPpDGitTtZC83A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 037/781] docs: find-unused-docs.sh: fixup directory usage
Date: Tue, 24 Feb 2026 17:12:26 -0800
Message-ID: <20260225012400.612362057@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e970637707f4f8e5bd098b09090b755f2f57898b ]

The recent move of this script from scripts/ to tools/docs/
did not account for the 'cd' directory usage.
Update "cd .." to "cd ../.." to make the script self-correcting.

This also eliminates a shell warning:
./tools/docs/find-unused-docs.sh: line 33: cd: Documentation/: No such file or directory

Fixes: 184414c6a6ca ("docs: move find-unused-docs.sh to tools/docs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 184414c6a6ca (docs: move find-unused-docs.sh to tools/docs)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260102200657.1040234-1-rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/docs/find-unused-docs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/docs/find-unused-docs.sh b/tools/docs/find-unused-docs.sh
index 05552dbda5bcb..ca4e607ec3f72 100755
--- a/tools/docs/find-unused-docs.sh
+++ b/tools/docs/find-unused-docs.sh
@@ -28,7 +28,7 @@ if ! [ -d "$1" ]; then
 fi
 
 cd "$( dirname "${BASH_SOURCE[0]}" )"
-cd ..
+cd ../..
 
 cd Documentation/
 
-- 
2.51.0




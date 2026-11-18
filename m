Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049336;
	b=e5IzlugUav+tDI0PoPJR2QfJjAvImE0Sj/qhtuBHYlwnMO9RiqcsXfwi8ddxGpa4Zzk2
	 kEFO93EiZvsnClNavGD1FA9jybJH7mB/oTR8hPrFlOFyqnttsliXpJhWY6Bde68QTGfBv
	 EztGjOHnAyVDAmSYlcIEbX5HTj3abWCw5TrwPEr2fk/wcKU82B0QqLHLAvQtmMfQ5dw/n
	 K1F0S8K25CVwOm3Lv+rMfVJMN61XGrSHQQZlJhVPtdEZeR4wciDWYA2yIRYfxkHUHPCV1
	 yShThuudG8/OBNdqfH+49s/N5dmSj9YyDQeOeBZ0edAZptboEKliCb98Pm2wGH7JsvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eTQTx7hiRRNhCSybalb9LL4fEyx35PTUJ/oCwYl1x+A=;
	b=5mYdKEVbLvMnnZaKkgaz38CTP+HvMMfCjdzfvbxgcEJyudFaqcoOLqLToFslfYUUxaIt
	 ewkAg+gMcBjH6VWSg5g+fHwL+aNK3kO9G1dvQkVB103DcsRsviAowmBAG7QmZkem8WE17
	 OnW5sBKS+xvzDdIkOoeYN91UyTvG1KmB+HsDtr0Rl1kkP6LSM12/bGfomSI8CDwdUquAN
	 zYi63Stx1AwL5P5LzI47iMWLWdGgxYxNOkk+C9u9gdR1oyym3iPrNKDCO/T7tOB5aeD+D
	 wfBL8rQkB6osZSt8+B9k8lG0xCSKMR1tLwVnoUwosJjzBrX3qlVI8hYJtke6tyONkfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0nJpWBC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A17606A336;
	Thu, 19 Nov 2026 00:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0nJpWBC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2F41F000C4;
	Thu, 19 Nov 2026 00:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049336;
	bh=eTQTx7hiRRNhCSybalb9LL4fEyx35PTUJ/oCwYl1x+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0nJpWBC9lce15PeWN7z04sOpn/t/nyRVikL5StXvLsOsmJbiAuFXlH943xRmmLV/B
	 YkOo87kk3BJZjiB8jb7GZZYra/94oZxLXnM4MhGcndckzjBn9+ywqSSy79UKxja0yU
	 MUN87JRXL5klZuX86QmGb2jFDnAFkmERehSJPjcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2313/2857] checkkconfigsymbols.py: Parse Git status output line by line
Date: Wed, 18 Nov 2026 15:55:47 +0100
Message-ID: <20261118150324.798809994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit 72a61a7fef954152abd9df9def4f94816eb344ca ]

tree_is_dirty() iterates over the string returned by execute() one
character at a time. Its status check therefore examines filenames as
well as the two status columns.

An otherwise clean tree containing an untracked README is reported as
dirty because its name contains letters matched by [URMADC]. This
prevents --commit and --diff from running, whereas an untracked
notes.txt does not trigger the check.

Split the output into lines before examining the two status columns so
that filenames do not affect the dirty-tree check.

Fixes: b1a3f243485f ("checkkconfigsymbols.py: make it Git aware")
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Link: https://patch.msgid.link/CA+NtrhQqXgjT+4eg6W4P94Hc=DqdV3gQXz3EKKCxWvdWzfND6A@mail.gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkkconfigsymbols.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
index 36c920e713137..9f7aed98d91c0 100755
--- a/scripts/checkkconfigsymbols.py
+++ b/scripts/checkkconfigsymbols.py
@@ -245,7 +245,7 @@ def tree_is_dirty():
     """Return true if the current working tree is dirty (i.e., if any file has
     been added, deleted, modified, renamed or copied but not committed)."""
     stdout = execute(["git", "status", "--porcelain"])
-    for line in stdout:
+    for line in stdout.splitlines():
         if re.findall(r"[URMADC]{1}", line[:2]):
             return True
     return False
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7A529A0;
	Wed,  7 May 2025 19:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644534; cv=none; b=YwRqBteGd0mxt3qnz2NybcnPq5jsjrsDhG5QEkGSuthz6tMUMUeD2u7TIya8a4VMowsm0s22RwYMqsc/Ad0la1m/OnKF+t+BNczrWIw6IO8Wlg2rFnzfDKg68RycpyaTQP9VJJK+3USxF921pgiDfX1coWZiuBwHx7JurvAljrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644534; c=relaxed/simple;
	bh=pSb9mby11niLs9pwTRIoLfKrhwYonMw65ORpjqrWv1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvglGQGlxy11fWZeuwV0wHaRPNt0yvEAphtK7uF/bKAlSUG+nGLHyUfFOWczFsKAYkUP4+j/Z3/95QuZqpmhdNjM3IgtrJdgs+ah83MamimB0/6N3UKTY6hleMcFqfIMNx3HGbR50VLupH8Aj0x7COE4T9u2VE48Fj9fVjSxaPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNja1Ski; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNja1Ski"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7C3C4CEE2;
	Wed,  7 May 2025 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644533;
	bh=pSb9mby11niLs9pwTRIoLfKrhwYonMw65ORpjqrWv1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNja1SkiRLyM4XmMDfO5eJJlYm2hjIuCa25bk5kD1xr9jIRo5dHL1CoOxfxIPHNcP
	 8gBpgYARcDpwLkWiISKOzlcGiI7tEZB/F7pZwVIhwjgHtq5jHd6exu4kmIx6ialM6X
	 rvUF4sQUuhAxQgP+XobF+KImXasySvTliVIy8yAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/164] powerpc/boot: Check for ld-option support
Date: Wed,  7 May 2025 20:39:02 +0200
Message-ID: <20250507183823.244228831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit b2accfe7ca5bc9f9af28e603b79bdd5ad8df5c0b ]

Commit 579aee9fc594 ("powerpc: suppress some linker warnings in recent linker versions")
enabled support to add linker option "--no-warn-rwx-segments",
if the version is greater than 2.39. Similar build warning were
reported recently from linker version 2.35.2.

ld: warning: arch/powerpc/boot/zImage.epapr has a LOAD segment with RWX permissions
ld: warning: arch/powerpc/boot/zImage.pseries has a LOAD segment with RWX permissions

Fix the warning by checking for "--no-warn-rwx-segments"
option support in linker to enable it, instead of checking
for the version range.

Fixes: 579aee9fc594 ("powerpc: suppress some linker warnings in recent linker versions")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/linuxppc-dev/61cf556c-4947-4bd6-af63-892fc0966dad@linux.ibm.com/
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250401004218.24869-1-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/wrapper | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index b1f5549a3c9c4..08f7a1386e8e0 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -234,10 +234,8 @@ fi
 
 # suppress some warnings in recent ld versions
 nowarn="-z noexecstack"
-if ! ld_is_lld; then
-	if [ "$LD_VERSION" -ge "$(echo 2.39 | ld_version)" ]; then
-		nowarn="$nowarn --no-warn-rwx-segments"
-	fi
+if [ $(${CROSS}ld -v --no-warn-rwx-segments &>/dev/null; echo $?) -eq 0 ]; then
+	nowarn="$nowarn --no-warn-rwx-segments"
 fi
 
 platformo=$object/"$platform".o
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E992428BA9F;
	Wed,  7 May 2025 19:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644966; cv=none; b=LFVgtQwuVu7JsenMm4IPoOONbDepm1hyuGnVTJjwCiibQA6lcGKa88s2kH8cAlhgrmJwGXNQ+2QTI7YEm5o6qdSPsWNp2PSEyPa55DUZiFkh4+EQt5z1f/t/pEbONaL4IY/oTbnVemWw1ECANf9sq4MQxsQlyfDE3VRoLLIlSZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644966; c=relaxed/simple;
	bh=/4av3u7LN+1v4DHRAD1a0rxE4sG1juxJz3g4FMlf4tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbR/XroLE69vZ2A4Bq0GVNFO5JQaq3vyfNrxfVyi/nzPUW1am48eZ9Ew/VM2vgWtDX/TVGWGgeTLrgGre87guDpxAJDjj6BUdit7T+A+YxsN8w2esMw7FyJL2aNQMusN8lm7dRagp0s1PKwjbIVmQk/lQ19DDqh5YVu2KgBsoE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBsvIhQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBsvIhQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68003C4CEE2;
	Wed,  7 May 2025 19:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644965;
	bh=/4av3u7LN+1v4DHRAD1a0rxE4sG1juxJz3g4FMlf4tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBsvIhQ2Z43VzmdI/xOWfEAWdMOz8BNo1uUW5Tpz5b7PNBlgzt9RD3uucLxBWkT8F
	 52vZR2URaV1BCyIAZchQxx9ZE94W8ajiwoCD2P2M9FYWdTw5JTFmcwzKDKusNIEf9E
	 iviIyMAZxHKxqhthM1ItJb9ZS/o+eViT5v95XY3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/129] powerpc/boot: Check for ld-option support
Date: Wed,  7 May 2025 20:39:45 +0200
Message-ID: <20250507183815.524741150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 352d7de24018f..fea9694f1047e 100755
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




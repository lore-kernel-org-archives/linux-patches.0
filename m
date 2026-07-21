Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F4B46C4B0;
	Tue, 21 Jul 2026 15:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648771; cv=none; b=VXB2E/xdCDcuPxnf2lTG6ywhIy8jx2Hnek89uGYlFwQqYsXvY6Sy3pEd41qqZdG3Y3rkSNLCYeL5Ge2xJXyjZJOLgYA5Jv6Qd/8G34PEEsrf/jG4GsV/4TMo4fZHlUM8S39CpNmOS85hMiVshXvTR06qXbkSGvcsebDf+7muriM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648771; c=relaxed/simple;
	bh=El0TU1+hT5NN+QPr/Y3VBsU44IRndFbLr5VeHwzgBPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDLXpn0CsAxnoWvvDlBxgK01P3kA2gyDxFBnhk2ga437V6faaOJmRjYUN5ttNr0HEjpO+rebHoLvuRGGFsnpD3XGuzShx15zLoH2JKzYU6LB2ZR+3y9pOCn88msTSVXrXKXAT7sHDRiQarnepdlBV6IQwC9QYcXuBtCcbb+UwVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VehwgKWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VehwgKWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7DD1F000E9;
	Tue, 21 Jul 2026 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648770;
	bh=nBOYJrr1DaaNiG+5qz3bvlpXtcUNXLDt+SbC5s0vq2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VehwgKWLcaO5Vk3itTOTwegjnLgmUp/rQyKnP7TwjhaWg3j0MAPVVvY/A6wjAOkw2
	 wUIeoiBK4mrpfjTf4TD8r/uHsmxHERVPhEuLcw0lKudUQtSmaX6MIw3uYteAMskoNH
	 5vpxfRn3tXLlyhS2U0C76tUn15XAn1MSSxzQABWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Schmaus <flo@geekplace.eu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0326/2077] selftests: Fix Makefile target for nsfs
Date: Tue, 21 Jul 2026 16:59:59 +0200
Message-ID: <20260721152600.370103344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Schmaus <flo@geekplace.eu>

[ Upstream commit 77d1a2d2318fa96f8a662c9ad6647abedcd22734 ]

The kselftests for nsfs where moved under filesystem/ with
commit cae73d3bdce5 ("seltests: move nsfs into filesystems
subfolder"). However, the kselftest TARGETS declaration was not
adjusted.

Since the kselftest Makefile ignores errors unless no target builds,
the invalid target declaration can easily be missed.

Fix this by adjusting the TARGETS accordingly.

Fixes: cae73d3bdce5 ("seltests: move nsfs into filesystems subfolder")
Signed-off-by: Florian Schmaus <flo@geekplace.eu>
Link: https://patch.msgid.link/20260526-kselftest-nsfs-v1-1-7b042ebe42d6@geekplace.eu
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6e59b8f63e4163..641a180fb35f41 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -37,6 +37,7 @@ TARGETS += filesystems/fat
 TARGETS += filesystems/overlayfs
 TARGETS += filesystems/statmount
 TARGETS += filesystems/mount-notify
+TARGETS += filesystems/nsfs
 TARGETS += filesystems/fuse
 TARGETS += filesystems/move_mount
 TARGETS += filesystems/empty_mntns
@@ -85,7 +86,6 @@ TARGETS += net/ppp
 TARGETS += net/rds
 TARGETS += net/tcp_ao
 TARGETS += nolibc
-TARGETS += nsfs
 TARGETS += pci_endpoint
 TARGETS += pcie_bwctrl
 TARGETS += perf_events
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D0C46D084;
	Tue, 21 Jul 2026 17:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656031; cv=none; b=GMz/UstN73YdG9RgEJ54QMbi2TwOKqx/zO1qNsys1L+oSms4bs6YkGcWoRMfOpSFedcyon3b6NFzBNAA+c/ctt3tjitR0/8A69p8NcGwbM8LqWk35Oxia21/2alxtrGS7ra6XSJitHV7vLIu6IqTjXhX3PIzLL741MoyoRhDXVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656031; c=relaxed/simple;
	bh=xGFx08Lv2vzKm+xRBod6kpV0KZX3NOGd0isCTeYB/WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h976qdyc2tdXNLAsBMhvvmragP+WIpKgRuJWAiEDqvA0t8bu8i/MK7bmZW3mayg8rdKh09Se+l4cvcn/+kr+6j7cFtSdVavxc1SvN2ab1M3Mlc7wD0NQI9wez7O+wwr4n948JmLCha0CA9XK3UT+vSw9fDr5lyrS+LZyTPydK1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqbs2Aom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqbs2Aom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BBD1F000E9;
	Tue, 21 Jul 2026 17:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656030;
	bh=as2bq0xb3z9ry3bkgSUTTGBqqHCxPLDuTC3hVPyRioo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqbs2Aoma56PocB7QG13tS4Y4gosfX1gr31Ihq3SGsnRuHGjP6XtOINh2tB/tufqM
	 Hj04BB8iGEUyBBa253StJ0bcEdlbwsR/fRw4/ysuRhoXKFFNQGLLIAyZXmMxU5Xpe1
	 oCF84ncKtmt8Kc1jLzc/4YvD1Spizx/YQrxo0/Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Schmaus <flo@geekplace.eu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0231/1611] selftests: Fix Makefile target for nsfs
Date: Tue, 21 Jul 2026 17:05:47 +0200
Message-ID: <20260721152520.202353574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index c46ebdb9b8ef7d..dbf81e9a7785a5 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -36,6 +36,7 @@ TARGETS += filesystems/fat
 TARGETS += filesystems/overlayfs
 TARGETS += filesystems/statmount
 TARGETS += filesystems/mount-notify
+TARGETS += filesystems/nsfs
 TARGETS += filesystems/fuse
 TARGETS += firmware
 TARGETS += fpu
@@ -79,7 +80,6 @@ TARGETS += net/packetdrill
 TARGETS += net/rds
 TARGETS += net/tcp_ao
 TARGETS += nolibc
-TARGETS += nsfs
 TARGETS += pci_endpoint
 TARGETS += pcie_bwctrl
 TARGETS += perf_events
-- 
2.53.0




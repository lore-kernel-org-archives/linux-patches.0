Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022204;
	b=27+eKLFRwrhpngNlSW5arlKCYTAEVGws2h3r582QmU0a9+o4Hn0KbQtaXVWSDhYi5no6
	 nEKcGZrMvOdp26eBpV1AwWf0DHhXnVkOENu9LDJE7lROJDAl92uDLvSUOFzQjKyWxfJYz
	 KtygTNPy0LIUkPWL56u7/cFEtXn0/3CbmBp6EGoh6Cq8ZHaI6CQZGqBGNTd5Dkx7H03l5
	 CMw7+ARNbYnCwyhIcgtQ8UBoM+r8Ts+B+WfQP6xJjQFqAJG9dQR9njk3fEvMOwgFm9asW
	 hnRLZ9r8774CBxHWu52wiwdxNyDaarnhaeR+oVIs8va3Xdw0cM9+PSlG989vu7gM6Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NV61ujwlR+9Gr9SjMZ2F1U9+q/4Vj8H2zamkyaZ1tRg=;
	b=UZap1VCfeSn2qqYBDWDF0fmbWwKaPXmJl8oAq2jBVrHtwLs8aQivfNqr04P3Q3cddYAw
	 LUGc8m5Jahfi/RKtR3uU4XHYvmWLGJFQy0DBpk+c8Q6QEy5MObP4Cbp/YYxThuE66O/uG
	 hjdJz8ZxJjbMgTIdQXeavDXbm3eW4QidJZ23rT3p5494XOLMps5/4axw0kmSml9Bby6DY
	 LHUJwjhZPxfNUDF7vURmkk9vg5j3pZMTy5U2Khr45VRAJhAwWhpiZXlxATSG8EbFR7kL8
	 A1uWe0bLpkQOGsjP3abQLJpAutvZGQkt7FJSlUWv9n+k/mE5FHkpDpICaxsP47GQPbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKKGFWrt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A630B606A31C;
	Wed, 18 Nov 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKKGFWrt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29751F000C4;
	Wed, 18 Nov 2026 17:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022204;
	bh=NV61ujwlR+9Gr9SjMZ2F1U9+q/4Vj8H2zamkyaZ1tRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKKGFWrtO6j5kmvOTxi3SnydOuA73P/11s6phJtPShptaVKDMd6jq2WmsTUD9LLcz
	 WYD3/hTC1Lfw0eErWa06cdDfFViv+t+fxW0SQ65jacrR0k/8LBmaCUMNcV6wskPsgH
	 HOVd753kqEiqNEEq+Pj4FJX+5z6XCS586TwSwxlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2577/2651] selftests/ovl: fix detached layer mountinfo expectations
Date: Wed, 18 Nov 2026 16:03:37 +0100
Message-ID: <20261118150417.117350285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit aefaf9521c999206b7cd2df8435a270ea8b8112b ]

set_layers_via_detached_mount_fds was copied from the attached-fd test
and still looks for /tmp paths. Detached open_tree() layers are recorded
by d_path() as upperdir=/upper, workdir=/work, and lowerdir+=/ and
datadir+=/ for each cloned directory. The test has failed since it was
added.

Reported-by: Disha Goel <disgoel@linux.ibm.com>
Link: https://lore.kernel.org/linux-unionfs/20260924112858.51392-2-disgoel@linux.ibm.com
Fixes: ccc829b15d48a ("selftests: add tests for using detached mount with overlayfs")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../filesystems/overlayfs/set_layers_via_fds.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
index 7a293544233d7..83bbacb2550f2 100644
--- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
+++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
@@ -686,23 +686,23 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 	while (getline(&line, &len, f_mountinfo) != -1) {
 		char *haystack = line;
 
-		if (strstr(haystack, "workdir=/tmp/w"))
+		if (strstr(haystack, "workdir=/work"))
 			layers_found[0] = true;
-		if (strstr(haystack, "upperdir=/tmp/u"))
+		if (strstr(haystack, "upperdir=/upper"))
 			layers_found[1] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l1"))
+		if (strstr(haystack, "lowerdir+=/"))
 			layers_found[2] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l2"))
+		if (strstr(haystack, "lowerdir+=/"))
 			layers_found[3] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l3"))
+		if (strstr(haystack, "lowerdir+=/"))
 			layers_found[4] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l4"))
+		if (strstr(haystack, "lowerdir+=/"))
 			layers_found[5] = true;
-		if (strstr(haystack, "datadir+=/tmp/d1"))
+		if (strstr(haystack, "datadir+=/"))
 			layers_found[6] = true;
-		if (strstr(haystack, "datadir+=/tmp/d2"))
+		if (strstr(haystack, "datadir+=/"))
 			layers_found[7] = true;
-		if (strstr(haystack, "datadir+=/tmp/d3"))
+		if (strstr(haystack, "datadir+=/"))
 			layers_found[8] = true;
 	}
 	free(line);
-- 
2.53.0




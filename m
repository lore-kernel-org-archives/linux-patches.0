Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028222;
	b=QYCpD5USprCUs6mDrko1dvDU13m/IWKyVpm0D938/gcovXbbkhzgDyQoQVpNETawSqaP
	 g4QPeScVhGdsuaFz3kPFKlPvQN+CciqIK3mdc1EWP0KqtNb5/gQTlzUl8TSajhVuDGGcQ
	 bbX5/E5vUQPp8iVxnrP5N6Omm9ChxdD+OhFSMBC3QthtED7A7xQptXFjnkNUc4mArl+PL
	 I/FIDHZeJfbLr6mZe3FH8+BMm6RRkhC0wOo51GqQXyJKmHfEWOrmtNKn1XF+J16/S11RF
	 cPHeTo8bhsR8xWMTdyMbg9TtVOzRgs8k4FBF1I+k8zcTqFtVzIjsSkVYfgb0wSM/6bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+kpU0bZkYRrEZO2lTdgxXIgHKq8kZi4Dskq4dkkXXCk=;
	b=fhovpLJC+4Ai7OYm4l/AyCqhDPVrErr9t8a46y3wzCmSFIR5F/acaNWbE4JMrumwwwvL
	 NsiMjyTwnlbKvMuUYi5mWkmnjpLurVKpV9NkKtjVY2eyKiK3a6/2hqCq+mUmTvw601sjy
	 HVymEfDMONNeBC+ONAggTBXlmL5C4Cepa545P8gEVX+ubHZK2vjTWQYMA9xRqel2hYqEK
	 U/KYoGM5oTNfPVcG4LId0zqtgwuPj0EC+Ox7DqmtCn20lDx2oYYob4ubdKlD6q5K8eetC
	 XvpZG9K85kdnFT7U+pkhkU/1HRU8pL9934OWWmXkdt3dZIDwnKTPP/wVWuehSR6i+/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bw+a9IZb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3439606A31C;
	Wed, 18 Nov 2026 18:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bw+a9IZb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F9A1F000C4;
	Wed, 18 Nov 2026 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028221;
	bh=+kpU0bZkYRrEZO2lTdgxXIgHKq8kZi4Dskq4dkkXXCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bw+a9IZbPvsFruXvI7D5oIgsxiI0Pss4hzq/OIOSJ+iXEkwLgAg82E2DpdtbANaAC
	 +lv4P+o14rSL4sK4GfoRTp3MU9L2Eqy0jOmZJHmaFChO7A6QO+ViNQi9KKqdRkAEUg
	 hVlL49RNhQyCuBDFfe7FzTS82+M0V5PnI3LCKHh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2068/2151] selftests/ovl: fix detached layer mountinfo expectations
Date: Wed, 18 Nov 2026 16:03:23 +0100
Message-ID: <20261118150237.053953867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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




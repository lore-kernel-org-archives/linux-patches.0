Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621088;
	b=sVRHX9/At2DrBN0EYBUnptDwr07IyZGyU0dxalK5zFO0UuzvJR6HEJmHmONBu7zwXj6p
	 HEO7VzpqzLhpRCdf6VRduR0MahR2kCGcYmQCusNVajWR85k6wSlTjw8JpkVZ9du0B656i
	 3Kn5vjzEEJ6YlvCoU093e67lTyWk8oKyiDpLDRGk5RdvhAd2mqiXgdYCsL6+cktevHmn3
	 bhhKls0hXIiIqyu2/eY0QsSiZLdoADqrcwafeYF4NA8aB8oarYr7rLSe7wynPDxvcmR4K
	 /VQasmFiMvGVIunkwbwarCaceCaYeC6S6m1LQvBWNxCNLvtrPJ+pbe5Vzu3PBUM8H+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4zOgljytyRZT4eTbW7aYoNaRSAXqRAKMwQrBruLwixc=;
	b=tCx8qbvBfRThE7lTuuoDK++wmLtv9j8zQfVyAF6ByxWLh3lnIXudcJL4vBCRmkTeUhKO
	 cG+sJSZHmJYTYkflGFHPigKpOo0jB20eTspY+WrGtFXQQowbzUYt+cON45juRSOSy1xVe
	 RV4b9MVaLncWDC+LJ0jnf7wnwJ5nrRQl1en4eQXyzl4S1e2E5xWIcxMkTys0Uy3lN0H+7
	 dRth8eIYTKKCiSk0z7fT2ZhaRuDjEFAzFcRVg4h5fVwqjr/WlUfurc8Na5wpGdIDaQliK
	 wGL25Nd4nTQ57aAfbzodJpbll2BaM2EHUNpEk18Oz3iwAZzOwOsIh/BOIjJ+OoNRvFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyuY746T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC14E606A31E;
	Wed, 25 Nov 2026 15:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyuY746T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E471F000C6;
	Wed, 25 Nov 2026 15:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621087;
	bh=4zOgljytyRZT4eTbW7aYoNaRSAXqRAKMwQrBruLwixc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyuY746TKF/QrVelZ1d46EIMN2QJ1dUAeYeJo7gbT6JhroCUBg6sZ4t58LG3hikBT
	 htdsoArUexFYlXAZjZn/ksUwGJr2w1bOo0P9s8709PV06pNLAFb6WcmpM89YCSZjE7
	 2roDuk25tRQc7oorqbX+6qxCyq4H2I0MRIm1xemM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/990] net/9p: Replace strlen() strcpy() pair with strscpy()
Date: Wed, 25 Nov 2026 15:23:49 +0100
Message-ID: <20261125143823.539511478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit cc8b15a2c435bd1caf19741ba85286846a115764 ]

Use the result of strscpy() for the overflow check.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Message-ID: <20260606202744.5113-3-david.laight.linux@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: 37dce65a0b43 ("9p: use fc->net_ns for network namespace in RDMA and socket transports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8a03e62992508..f31b2a81ef8bd 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -941,14 +941,12 @@ p9_fd_create_unix(struct p9_client *client, struct fs_context *fc)
 	if (!addr || !strlen(addr))
 		return -EINVAL;
 
-	if (strlen(addr) >= UNIX_PATH_MAX) {
+	sun_server.sun_family = PF_UNIX;
+	if (strscpy(sun_server.sun_path, addr) < 0) {
 		pr_err("%s (%d): address too long: %s\n",
 		       __func__, task_pid_nr(current), addr);
 		return -ENAMETOOLONG;
 	}
-
-	sun_server.sun_family = PF_UNIX;
-	strcpy(sun_server.sun_path, addr);
 	err = __sock_create(current->nsproxy->net_ns, PF_UNIX,
 			    SOCK_STREAM, 0, &csocket, 1);
 	if (err < 0) {
-- 
2.53.0




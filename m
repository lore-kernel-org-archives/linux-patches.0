Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829623;
	b=pwaWWZjxEoUbKZHzFo05vjZEgCsdaew9aIYFH1f+s3YmR+YwUhJJHTozCtjNuxYPNNik
	 MlBVTfe2a9rLVbpj5qtu2Z2OflLUapJiXcjsiI8h/NhvEcLmZ/dzXi45+GrxGKV1CkGKP
	 bGW7mYLWhgmn+IJ6pC2eIGjHc2a2sGIoQ9GVxDIjf6XHiTrg8+Sruq48VyFYGCyAASeyF
	 nTyHqX2RtbkLUVUvaQYQfmZzqpE0GDX0Rxb9nx96xu7IHcag+6IkqG95PxjwvL8JyJ9I7
	 mhzhiDc/7XF3Zerf8r5Te5LtEWINeVdJVtJXrYDn6WRXRIolEH5GrNpmiWVyZCPRJ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zqjix5ZBmBdG3/Ky1SwGnek8AQPOYoZKOSqfsz7o9QQ=;
	b=txYImpbg3PaPycYCGvmmgOuLeDEFhtWvMc9x4F224xBUZuuHVLdFhhcn/81xKfhe/Zay
	 MUuwIn4W0ac9OXTlIg3EfavRJboUYja8ItI3+LpYAIgPSCDzHvLU2xncexTdHbBTiHQ1N
	 pf4teHwaIhzwuAPxtd4dZUC76Wp0i030v6jHrMOQMGC1a7XMpt8GAo7lL7GVRJ5g+lZDn
	 8kw0pD/hRN9+RjuhzBaAMprNTZeTvmqgy4PDSzmjiahqRobENU4vTyhx/uwYlEkJ6GVdK
	 p31CvZzC7cvTmU0puiNWOWybXGCFQXisbgceuXCBaDkhE/NN57WuVD4YKmrgypm80ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y5/jXX6M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA988606AC0D;
	Wed,  4 Nov 2026 22:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5/jXX6M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1F71F00A02;
	Wed,  4 Nov 2026 22:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829622;
	bh=zqjix5ZBmBdG3/Ky1SwGnek8AQPOYoZKOSqfsz7o9QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5/jXX6M1V7ZP7pyxJEBD/L5TeEfzyHsb6nih2tV64XHqzly4ddTpgcEXcHkbBuMK
	 951gJ6YwHH0vK70nlM7HgD7SpW7BQDyYkLobIwYUtPhpPVLypm/ssUX6NNO1OTKQFl
	 1KMs6qB5Re0B0wcOjW+o6qPfn/smsyL4NtnzWmPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0240/1005] ntfs3: initialize err in attr_wof_frame_info
Date: Wed,  4 Nov 2026 15:59:33 -0500
Message-ID: <20261104211050.576519622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit dd64afb32c4d8d3c934ae84df59a2e463d6fa43c ]

attr_wof_frame_info() may reuse a cached offsets folio. In that case the
loop can fill the output offsets without calling attr_load_runs_range()
or ntfs_read_run(), leaving err uninitialized before the common return
path. Initialize err to 0 for the successful cached path.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 501f2ec153ab8..e500f7be8cc38 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1410,7 +1410,7 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 	u8 bytes_per_off;
 	char *addr;
 	struct folio *folio;
-	int i, err;
+	int i, err = 0;
 	__le32 *off32;
 	__le64 *off64;
 
-- 
2.53.0




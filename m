Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060803;
	b=iNu1iTDEWrJ2BQIdMXOIc3Nh25m/NbQ9KKEyZal8xC2B4Q3R3ytv4WHZ39pcm55Mo5Vy
	 9lUxts23G6c3iXNiWJWyB71BtXOYSOkKynLcJ/fK8zUoEmxHggyYS5cNfcl5nZpN96LXF
	 zxGm2YreuTuLoAxGnONce8yDnmBZ4+FYgs0ttFTzOEa5sstv8MfMxwCGvN/Vd2PKLEneA
	 kmPe3JNP1ArVQvPveU9QEvw7R+Q97V3OINfcsLdi0yNolmnIAvLECvNWWwRoU02uvm45K
	 sjT77RRNu73P/VxHZKAh1Pkau+xIBu0+R9Cfp4EVQWeDNisSEDorDyWsQoUqbFtTocQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g9RmA3nk3dQcAS1391poN1DGMhzc9djyyfCFY5tl83g=;
	b=gxN2Oc3mT+Jz9gMVScwDe08HapVdNEg+SSuxhoB6eFTm1Ledw1TvjDvZFc5R4W3o8+A4
	 8tH4FmlYRcTC7wK4/NSCxGOM6bXveyBipSIUnI0Nm5sA6Nj8mdBV6oGD2D6p+CmjCGVJz
	 IkHlV84Lk504Gni+Ek8hoHBP2cAYZBmBRtK2RkyTxStmPdJbwJoqkRgqh4Nezvxzu3xbt
	 1BTvAJR9UVPzJShU3enQgTOjuUtk3Tp5fCc3kVNi6EIUJLjDL4UsTPPtIn0wq5O/ToAOi
	 kGaaISHSXMg81ouB3vesq0/ZVpKSJTZBMwTYefmU7lcvko3TTG4Ab0gPXeFDUc9PItg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STw9jt4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1884E606A326;
	Sat,  7 Nov 2026 14:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STw9jt4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98871F0089F;
	Sat,  7 Nov 2026 14:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060803;
	bh=g9RmA3nk3dQcAS1391poN1DGMhzc9djyyfCFY5tl83g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STw9jt4WBglbd3Ol5cPCXpm93gHbvTJ+b4gfFaR6YS0ATxA1jws0vRi0BqTJ9xxvI
	 EtYF53PENaJJ29njFMwNSm/kgRsCbXT1/6jlgcZ9yrdRlar+1jGLo24J0Ykjvo/24T
	 /CSIwudUiR+cF5WEJo1I0gywbKNJONNDg2VF3bWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0202/1536] ntfs3: initialize err in attr_wof_frame_info
Date: Sat,  7 Nov 2026 08:36:58 -0500
Message-ID: <20261107135003.331333102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 526f86a6fe518..dc928a9a272af 100644
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




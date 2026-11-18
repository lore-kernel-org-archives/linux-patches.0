Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053004;
	b=3g7g6dlOznWps4P2ads3P59gT+flIkA/awTjyUbsAjQ0ZZEmH3aM86VnN1CiINFF24O3
	 6NabhdccJS6gVMRTW6phIk3eeDGMmVDctaz2H7c6HzoprYIn+YMWxXuodNnPaXVAz60Es
	 EED0g8tyRWjXYjRR8AXYmzNIQjKNUZGHpBTyarUk+ebE7z2+x7OHq2boeU3BOfpeGwcqG
	 pkBLEZNMiOBustMLNqAH5zR1K5osOtxpYE4zCOTNMTlNCnzDUz4X0uTj0bJs6GOX2lPHl
	 /HO5UHNSyJRijxRoNghWD+79QklA19aZqBraPLAqbAPPlyL/kVOgCIOkUtU9H+z6yyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZLijQIz0a40137h9i2GNywQaAuqOdlqaPNZslOITS6E=;
	b=EKftfQ3IvMSYnLsGmu1vMNSZQzJTvIV2S1h6ElJ2PuuJrVmBZXk53QRZgGU1Yi9g1mr5
	 CO2/eetwlPyA9RZ6ObflU6WqMZN/ds7+d3c9Y+TigBZfC91+H4OUpk9A9QUcT3BU9SkPu
	 9rbPxxBs5sTO8AesywzQTUbAmuOaNDW4HuYI2fhszsbxLzbUOBDuzcnDu3pb9OBXg70hp
	 MKhpIoz18d/n7Fjcuj48ThO5lxjEZWErGFgB8ekHDX0vWPOpDCKmYWHqwtWscbiRAmH1S
	 shcqgez7QBSBU5af0wskMHby3BkUJ8GIwqME/cMUK9H8qMamm9JBu0D7rzNTgZtofYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSo59eTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC576606A332;
	Thu, 19 Nov 2026 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSo59eTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154871F000CA;
	Thu, 19 Nov 2026 01:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053004;
	bh=ZLijQIz0a40137h9i2GNywQaAuqOdlqaPNZslOITS6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSo59eTdn5HL9/RKixWyv2jPZszeahZ4hCQrWHzSn1h34SCzHuPIb+CrbzAOJr/RS
	 Fc60/3qs/E6ZXVqc+kqxZaygJizDAJMoRfeN2f0HXW+qFVbW8H0KLgHnun7dw4kFFp
	 ekFtdBz4DHfYQ7oHeHivU6AaJEriT+CDQw0TFHFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0764/2214] ovl: add ovl_upper_mnt_userns() wrapper
Date: Wed, 18 Nov 2026 15:40:40 +0100
Message-ID: <20261118150042.269966160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit b65c20acef23cea2989c9f23414930149d38962f ]

Add a tiny wrapper to retrieve the upper mount's idmapping. Have it
return the initial idmapping until we have prepared and converted all
places to take the relevant idmapping into account. Then we can switch
on idmapped layer support by having ovl_upper_mnt_userns() return the
upper mount's idmapping.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 755b5c5c9277 ("ovl: do not copy up an xattr value that was never read")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/ovl_entry.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 08031638bbeec..e319e9969c3a6 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -99,6 +99,11 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
 	return ofs->layers[0].mnt;
 }
 
+static inline struct user_namespace *ovl_upper_mnt_userns(struct ovl_fs *ofs)
+{
+	return &init_user_ns;
+}
+
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 {
 	return (struct ovl_fs *)sb->s_fs_info;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623972;
	b=qgAPFacYmaGQdLtTt7QKKA6jvMEYPEWB6yjs/UpZLGxkHu/hPgrOvbY307nogedWOo8s
	 +qrevJV0JP6yXbt45AcwrusSnujJE9UecAGvGq5jeYePl8/0FxcVGTfLzpPJ9CYnybdAG
	 kksSlaPb+gTpHqUIUbpFw+GEBCFjE3ge5961xxHpnj3ZwqqPAKE9Ny8Ry64HK2r0DDJTW
	 sM0pvJmuoecRwsPT6EcIWKhktbVVLszf3m8yPpgtNcOnhtZg0bYmQvmFobbBzYYXGRdWz
	 Qo97VyZWRNL2qOVvWmZrkaG/gm+cLZpC8dUn4IR/ZcvteXkBssQwOSoDIfx+H5LqZlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NVlwCgiypsI7N2nvZa69NU3aFwDMNBUG++tDMtYDlQc=;
	b=2tG1QJB0Pq6mTl2Kpfl/2dB8n6oT7CZ1+8Bwu7PrPDNNzKAwvCXvS4oxOD4idhxHcPYy
	 wwepXPcXdwPtF7fOxgHa/1PvpwLoClLXzUd4S2RRDXGMMORntkt4ufzWIjcq+9PTEntg5
	 Kx9k+z7jAA9dTnawrLJNAsZJc+Pt/DcefcTwLYNcPdIRtmc6uGl4j2STxh3allkGs3BsZ
	 za1PSSXjcDuRm8i39jribjV05fH1IQhe163GDDULIan0lyY5xqY7fQRNq4LI1tTq7H00D
	 42xSRAZiXrkX6WrOVg1h4u0eAlTq2FcH/JLha35+xfA2J1E8t25kWH2k26cM1I7XPyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7iG4faV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C761C606A31E;
	Wed, 25 Nov 2026 16:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7iG4faV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249E51F000C0;
	Wed, 25 Nov 2026 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623972;
	bh=NVlwCgiypsI7N2nvZa69NU3aFwDMNBUG++tDMtYDlQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7iG4faV+hcgF7wKHaTeQJ3OqJMcU1W/QbuOEvuGBnHfecCaV1VSiWUhcVeLDONUj
	 E7zaVK+TOGkZ2/SlxrdmVM1kA2QNIyG7lb34w9ZU6ilcOaZ8EP44QFYOud3lskEAu3
	 zxcPjILaMzsUN47eMFMw1DcV7WBQi6NzZ9nihkoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/816] fs/fs_parse: Delete macro fsparam_u32hex()
Date: Wed, 25 Nov 2026 15:26:34 +0100
Message-ID: <20261125143850.287670214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 296b67059e3026125a1ca942f5506e6ca051749e ]

Delete macro fsparam_u32hex() since:

- it has no caller.

- it uses as type @fs_param_is_u32_hex which is never defined, so will
  cause compile error when caller uses it.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/20250411-fix_fs-v2-1-5d3395c102e4@quicinc.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 37dce65a0b43 ("9p: use fc->net_ns for network namespace in RDMA and socket transports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/mount_api.rst | 1 -
 include/linux/fs_parser.h               | 2 --
 2 files changed, 3 deletions(-)

diff --git a/Documentation/filesystems/mount_api.rst b/Documentation/filesystems/mount_api.rst
index d92c276f1575a..47dafbb7427e6 100644
--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -671,7 +671,6 @@ The members are as follows:
 	fsparam_bool()		fs_param_is_bool
 	fsparam_u32()		fs_param_is_u32
 	fsparam_u32oct()	fs_param_is_u32_octal
-	fsparam_u32hex()	fs_param_is_u32_hex
 	fsparam_s32()		fs_param_is_s32
 	fsparam_u64()		fs_param_is_u64
 	fsparam_enum()		fs_param_is_enum
diff --git a/include/linux/fs_parser.h b/include/linux/fs_parser.h
index 6cf713a7e6c6f..b093348613ddd 100644
--- a/include/linux/fs_parser.h
+++ b/include/linux/fs_parser.h
@@ -122,8 +122,6 @@ static inline bool fs_validate_description(const char *name,
 #define fsparam_u32(NAME, OPT)	__fsparam(fs_param_is_u32, NAME, OPT, 0, NULL)
 #define fsparam_u32oct(NAME, OPT) \
 			__fsparam(fs_param_is_u32, NAME, OPT, 0, (void *)8)
-#define fsparam_u32hex(NAME, OPT) \
-			__fsparam(fs_param_is_u32_hex, NAME, OPT, 0, (void *)16)
 #define fsparam_s32(NAME, OPT)	__fsparam(fs_param_is_s32, NAME, OPT, 0, NULL)
 #define fsparam_u64(NAME, OPT)	__fsparam(fs_param_is_u64, NAME, OPT, 0, NULL)
 #define fsparam_enum(NAME, OPT, array)	__fsparam(fs_param_is_enum, NAME, OPT, 0, array)
-- 
2.53.0




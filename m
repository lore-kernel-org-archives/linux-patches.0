Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036720;
	b=n5ySYivJriKADPntDJOZw6GOr87PmhD6beH8vTD1NtTHa1F+Yllqxu6AMR7sFOUxrdYH
	 74C+WrwHG5uvwnTYb4YfPZXMHD1Mc603gE8uyw4RY/amZ74//Uux+mTVWQ6xOom/RH3Yu
	 BmOL9Pb/ZNPU6e/HwS/QgRosVJypoOq/w1nOos4dlCAqDEyPbOl4qSZMcAvjUyFCXjytI
	 GS2c0xVpFZaNxsTvXEva/Yw/S1v4Nu0K9TIZp88v6S+724KVya2Vw+ZDPs6TjgnGXTH4t
	 d7jIgsJxU/2DI3/PsH3nxqlFxIhpZVMxHFmDfp6qWvG0/LJAicBF5nV5V6Ry2wwDESg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=sipRqXb50PJEtvMuOEkZvW8xLD5ZlHImtZOeBb0ycC8=;
	b=FbOpppM1aWAQ4u7ldJS7Ai90cEXVCMew51oAHDulcpfx1UEGtiQuAppfTHhq1Ij/LFkz
	 NJe1EaGFP9nBVN+INa+CWYK6BB1K6O2Nc4yO3xFINgHCT00mXt3niga9J2UH5mrzB1z2n
	 gi3LFflGcGMwZZG2wF/Ci5SlSjnbyKK/SdI93O2hht0j88/LJcR0KXeQ8NxwmIDGrc5PQ
	 u0+596r9ZGPigU3ZOAfsxSWm7kJ5G9y9WdLONrmTfu5BLn94aitAY2NeR79F87i9UMEft
	 mBXrBOyRRmaHg2X8vZLbx44WOrHaCZ2cq4hnYftAfJzCbXvuKC8JcSWgy6bIDS/XhbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0K8E76pq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112E8606A325;
	Wed, 18 Nov 2026 21:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0K8E76pq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA681F000C4;
	Wed, 18 Nov 2026 21:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036719;
	bh=sipRqXb50PJEtvMuOEkZvW8xLD5ZlHImtZOeBb0ycC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0K8E76pqAXXcubMASxJkYmuf2TScvs5oxwwHtKVMtJkzkBWGuNzCW+NqHge7xsm4V
	 S7IIwqkyKyo9/LGURE30iwvF2ngMnYNZpu3iUVkmzZgQUS0sYhi6184sRWOrTBldAB
	 1pnni6FVzEu/OEttMdX2ibQZBjR4pd9ljTIRrX9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1106/3318] platform/x86: hp-bioscfg: allow clearing current_password
Date: Wed, 18 Nov 2026 15:28:48 +0100
Message-ID: <20261118150353.174123676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit acada379d5c4dd3a86d48fc69802e769eff29f7e ]

The ABI documents echo "" > current_password as the way to end a
session, but validate_password_input() rejects an empty string when
min_password_length is nonzero, so the password stays cached.

Skip the length check for an empty current_password so the write
clears it.

Compile tested only.

Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-5-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/hp/hp-bioscfg/passwdobj-attributes.c    | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
index d36f75ed1d773..5d4923b90ff38 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -61,7 +61,8 @@ int hp_get_password_instance_for_type(const char *name)
 	return -EINVAL;
 }
 
-static int validate_password_input(int instance_id, const char *buf)
+static int validate_password_input(int instance_id, const char *buf,
+				   bool is_current)
 {
 	int length;
 	struct password_data *password_data = &bioscfg_drv.password_data[instance_id];
@@ -70,6 +71,10 @@ static int validate_password_input(int instance_id, const char *buf)
 	if (length > 0 && buf[length - 1] == '\n')
 		length--;
 
+	/* An empty current_password clears the session password */
+	if (is_current && !length)
+		return 0;
+
 	if (length > MAX_PASSWD_SIZE)
 		return -E2BIG;
 
@@ -98,7 +103,7 @@ static int store_password_instance(struct kobject *kobj, const char *buf,
 		id = get_password_instance_id(kobj);
 
 		if (id >= 0)
-			ret = validate_password_input(id, buf_cp);
+			ret = validate_password_input(id, buf_cp, is_current);
 	}
 
 	if (!ret) {
-- 
2.53.0




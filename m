Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063370;
	b=HeW4bWvwiBLbc2ef4JgvlPt74gWoqo4Uzl5UsOs8MuKMWuBVa/7lXHgfz8F6i/HH3v/J
	 KoFkLMsGStsjoYDzNJM5/EQodQzAKTQBl6rxZvsQ8eyI7KGFJOqSxTT0Jc3R/zRdPCK/z
	 mrLAPSuYJYjyPde7ZY4mqjYwubf0VV0ql4ktVePcce2Cd5kG56JOWLHJyyV58/ySEmQBi
	 g/446i1DzcRBrwi5Z7p3sWloTjpnc9U3Ou6hdUoRgWH5J1y0csrujlFxuIy1hPqi4HK+F
	 9RLJctheHMUND6+F0XkRjMu3DEWEtFUrZbVjuj2dzqxgjobmfuLvaHCJNNhvAfn8MJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3SbQqgIta7YaT3nTQ8IPJ4VUGYWZi2wZ5kVZgeaFcKs=;
	b=qKnk1lkbvVk4q3UI83Ls0dYqzG/IaUVOXp287TYR3m/HLjBXdv+TvFy0anPjgS2LAmIu
	 E1w/a5USJoJHzC8S4TayO116T1yFs4hKzmvl3rOBgeBZ5snbgi639p4UQO04NLFx+XSVH
	 hgdeGxPTeJMOXHZkqzQzi2n6pjE+hs/ktD1hsMJ248+eF3i3Jh9XzYWQ7JxiwRJkdUOrV
	 LW70GPe+DZAAA77dP+atCSdjRK78K7v4BOUNYejYYMfKzoCq2KhxA9pScY0R0AMcS7Sxo
	 BeKVMTQB8Mph4QDjRPBP2ELSfM3pi7Vv0k/YffT48PKEgXQJvyxlK5nJEslbTfJWbAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKt3fpV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E146C606D815;
	Sat,  7 Nov 2026 14:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKt3fpV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9078E1F008A4;
	Sat,  7 Nov 2026 14:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063369;
	bh=3SbQqgIta7YaT3nTQ8IPJ4VUGYWZi2wZ5kVZgeaFcKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKt3fpV0WoTyB5GPyuNuO+dBzAseDpXMZ+OPqbZWPjMWU6tGQ9gjXfIO2gv461g9V
	 4dU1WsWWliYVVk7kE8W4BSGQtlqIF4CP6gmazc4Wv4vl3JL0LBdtGGH1lXl2/jVQGK
	 BVHplIcllutQRWqmroL0xc6WCGc4TbwARwSGH/XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 545/869] platform/x86: hp-bioscfg: allow clearing current_password
Date: Sat,  7 Nov 2026 08:53:47 -0500
Message-ID: <20261107134911.876272788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 43a2fd0c07db1..97990191b71f3 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -60,7 +60,8 @@ int hp_get_password_instance_for_type(const char *name)
 	return -EINVAL;
 }
 
-static int validate_password_input(int instance_id, const char *buf)
+static int validate_password_input(int instance_id, const char *buf,
+				   bool is_current)
 {
 	int length;
 	struct password_data *password_data = &bioscfg_drv.password_data[instance_id];
@@ -69,6 +70,10 @@ static int validate_password_input(int instance_id, const char *buf)
 	if (length > 0 && buf[length - 1] == '\n')
 		length--;
 
+	/* An empty current_password clears the session password */
+	if (is_current && !length)
+		return 0;
+
 	if (length > MAX_PASSWD_SIZE)
 		return -E2BIG;
 
@@ -97,7 +102,7 @@ static int store_password_instance(struct kobject *kobj, const char *buf,
 		id = get_password_instance_id(kobj);
 
 		if (id >= 0)
-			ret = validate_password_input(id, buf_cp);
+			ret = validate_password_input(id, buf_cp, is_current);
 	}
 
 	if (!ret) {
-- 
2.53.0




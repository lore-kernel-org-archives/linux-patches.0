Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062361;
	b=bpiQtZBEZKaA3fgSzeIP7TPcwj8CHkNr5Dknx5M1eF6dkhfv6i39yHlYPIHSx0Q2wtE2
	 B8KdZ0qCzrSEHN7EM91RC7tayD1KhQ+FgyGJzoD78/Iq+InPE3w3LFYkQT+JidOxPgGVS
	 x3ZRK2PPGERAcmBZ9MYO7XZnWIdgAbGJWGDXLbyqRa1xrL52a5e5ZRDKNgHUqT+aZXcle
	 jtl0x/YyQyAsThuHB72RXedsafj0hXZ8w5qm3j0Ja6S3Z/NzPup7PxDGLe1M4japgwxsc
	 bHuefXMsYyDM6IAWFPsO7x3GpzdWlxMz3fOJr5ESdIdOAp+bgL5ks1KQ+/IOPKnAnaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ssO2bn3PlRDYQsvIN9OLzTQOcETDolkApipYM9rKbvk=;
	b=A5TJVkneOkUaDpPy7QU/Zd+tTwYdpi8HwW0XpFg0Oq+A00eMUoQh6d3tCNiLJ7T1sbzD
	 Yb+OQIHbKl83DbcvFdsP32FEKV0C3H95u/+O527AJzkBOhj0e9Z7nK8tFHrcOhGy2OeRQ
	 zWTTZa11mu+/UlQMxCRcPx1Vn8Bj9dcNQVTQKe6if8iHmjlKbKaMyie0cB/AgafL5kmfD
	 JOeYINvC5Ve729DhjJbVLJGpEJOZ3PoJ8lqR3SwZWw0Qil0SIG5cLgagu/B07EEtKXDIl
	 NPxUe1ADBBIK7UXcKxCk3ra6MCXUDF6CUnlHBEDahRCd7OKkxXPzgp6BqacSDbWIB/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ya7nXCtm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EF7606A32C;
	Sat,  7 Nov 2026 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ya7nXCtm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710A01F008A1;
	Sat,  7 Nov 2026 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062360;
	bh=ssO2bn3PlRDYQsvIN9OLzTQOcETDolkApipYM9rKbvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ya7nXCtmcDaBjbBrV2YPsjX9638Ui3sFPAJ+4qdExeubGOZluBxPsFSltapZCxezW
	 O3kVO3exZE/Rog4ta4iGa+PvUq6J7ZfAFwZHC0Z77BXcNjPhgCx4v66kgNQh+YamTm
	 YtSRATcvfIPYYu6lRUdt5CWkWB26ShcTvYIsXXJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1287/1536] platform/x86: hp-bioscfg: allow clearing current_password
Date: Sat,  7 Nov 2026 08:55:03 -0500
Message-ID: <20261107135033.932585191@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 00e91ade56293..52bff847d4297 100644
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




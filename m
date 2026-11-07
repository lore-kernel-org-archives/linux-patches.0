Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064840;
	b=rLJCArxZ7kVKENcclsd02bx651T1deKtFUGOv2SGKhWVIOQVpkjT6bs4y8OxJDY7kxBC
	 hMEsrWlMa4hwDrge4P1aTxUypOdQla8HPGzfpl/o5v9Zap8vyMO/nWMJdi25tT7sDjUzG
	 f1Xv2rf4fUz25JF9QkWMQ8auTm8TnRzEbAuUkBN4jWZS3vLT6YKYbP+LBLZ8Q6RtJno9h
	 yN6i2OFNWfl1bhJ31C/IXrFDQEWspD7p8NQThbjrTk8mnMGX9Wsu7IToxy/KL2TV5rU21
	 3uD/0AY/itcII2pViXfnjoqRMvFszjn0+GC3ABTeCuM6TRL7gIdQzLnTJdekXVZ6O3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aZK+vzlEbEQztNENZtV3m8LBehh6jmo5Tuj5+hWj8Mk=;
	b=OLvT/8ItD/Xiyzacu8scfTzxl622eCd15wB1GdacdtqAD7dADfukWZ16MdX/RQJso15i
	 hOFo3Xdx7jxOIS+sna/orLCiFXK87G8ouFluq6M652L+la2pFr956SckQBM8l6I8FS2Uw
	 2gexYKWGAq7/f9ddhsUg5UZR+s856y8o2tSXWN3+eHpLxRSSeU+K2S+4m8xoWAVf1kryE
	 gHBTAIuFOG6waP3FENT4xnjp8SckuopzL7aymBAMRISKXA5pA6apVcL0U3UDQcvcpTILh
	 XIvja/LGGtNQoyreI8INW+S3VlJcNTOWOOAKIxads2by5Kz5AdQpzIOhPH+Bbqt6CsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A6F6qvf1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FAE606A337;
	Sat,  7 Nov 2026 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A6F6qvf1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B901F008A3;
	Sat,  7 Nov 2026 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064839;
	bh=aZK+vzlEbEQztNENZtV3m8LBehh6jmo5Tuj5+hWj8Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6F6qvf1CQbBwiABES+OU6MUhRPR96e4w3LIjPOKHNaJbyK9eSJJq+IDi1FhnH9wE
	 3/2j35drWYF15S4XTp2zEvRr5I59ZKEXsx2f3hJ0RxB0mEJcS18k8Kcw6dJSM/JeNx
	 LqAXv/xcapJM11mPaizhLzONce+PIdVl5erHBaqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0750/1257] platform/x86: hp-bioscfg: allow clearing current_password
Date: Sat,  7 Nov 2026 08:50:46 -0500
Message-ID: <20261107135000.002372352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3f4c45d9b9f95..f0551b4553794 100644
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




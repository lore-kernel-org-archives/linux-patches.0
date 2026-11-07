Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064821;
	b=Au8Q9PiFinMO7ria9HBgqjCe4G65BMMn/n0MvJ+ox7oTwo8ld2Uqdj4dJywF9u6iamvo
	 C774ZNugCCZ/br6tmp9laCpq6uTLGZBfjqoEq8SV6rr1J0vaLkYUPr9jCKxkDVWNM/46U
	 bnR8bwaDYikgxgKM8T0OXBdkowV6RHeoapwS/aS4FP6cUwjhz95tDTLYvw89Jyxhk+7ye
	 ixUOzPcfuhuDkG3Zi4dfN4leDLqSTRqZWjO18yL+Qkaz7uwLStpw2NgnR67FTxNEahvHQ
	 tKWPlv7TEodr5TiKyc00B/EFURJCtq4jNn8Wn71ZUeqx/HfvU8Yvd7H7b/pszuevJ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=a+F47RL+g65tsX1zhZT/afuiT1Wg1ShuKgHcnwAdsUs=;
	b=359pmLwcO8YG4t+zSJtsA/OWh1tevyBbHkW4JSBnP+7zleUOiKUp4wiYx+om4+X8jvUV
	 xfV/dQvPBH7hVv8dsQKryqg7Zg7F3UXW5mrijBlss2thUOP/kDxD+w3qR1kXKjQlBoYJk
	 jI0pcMUtljS05UrF5Fxjgx6Z6OKOYiq4IrGp8Jw+Go7hY7ooW12wWpbkrI1bEqEe/xPbL
	 peM9fhki5Du/Lu8JLTZsO+7c2aONvys6lHZHChEN3d8nuAgdCZ/dAah9Io4v3Q2ADszvd
	 dy9dgOLPe4lZrvIi6QpwVw8e1PSZM/XXtteOhs+YjQcoNWdhWrV+Pk1uZFNRqUiGgFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goO5JtKR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B927606B88F;
	Sat,  7 Nov 2026 15:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goO5JtKR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A501F0089F;
	Sat,  7 Nov 2026 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064820;
	bh=a+F47RL+g65tsX1zhZT/afuiT1Wg1ShuKgHcnwAdsUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goO5JtKRMvq9YarnHq9IYzbn9CDjFQ1Nh+0Fx/5Ukx5cBoq42/G0ayu+Im08YayvT
	 C04u5t+gErxsFZdzZ+MnTgHUpfAo/Uzzzc8IZtm403HLBVZF3ydeEDfxkUlDRChEfm
	 YmrcZHBcb2V6YszSjHyeHs6xn/1VN9Ko5eN7NNNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0749/1257] platform/x86: hp-bioscfg: return -E2BIG from validate_password_input()
Date: Sat,  7 Nov 2026 08:50:45 -0500
Message-ID: <20261107134959.976484333@linuxfoundation.org>
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

[ Upstream commit a4f19c589b21e18567d3c0ac7b9294f81e29b1de ]

validate_password_input() returns the positive INVALID_BIOS_AUTH on
rejection. store_password_instance() skips the store on nonzero ret,
but its final "return ret < 0 ? ret : count" treats the positive value
as success, so userspace sees count instead of an error.

Return -E2BIG for an invalid password length.

Tested on HP EliteBook 840 G2 (Fedora 44, Linux 7.2.7): writing 999
bytes to current_password returned 999 before this change.

Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-4-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
index a9e1786374162..3f4c45d9b9f95 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -70,12 +70,13 @@ static int validate_password_input(int instance_id, const char *buf)
 		length--;
 
 	if (length > MAX_PASSWD_SIZE)
-		return INVALID_BIOS_AUTH;
+		return -E2BIG;
 
 	if (password_data->min_password_length > length ||
 	    password_data->max_password_length < length)
-		return INVALID_BIOS_AUTH;
-	return SUCCESS;
+		return -E2BIG;
+
+	return 0;
 }
 
 ATTRIBUTE_N_PROPERTY_SHOW(is_enabled, password);
-- 
2.53.0




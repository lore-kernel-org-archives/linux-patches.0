Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063367;
	b=mfpc5f5KE36/T0+gkdH+pM/Urt+Cjqwe/dtf6l4te48l4vOCBQ9aC7WeuCSJXlkh82A7
	 wc9N9GJwigCS0wIRV9MuE1OoPok2eaYVnIQBP7Lclcu5GRwBz1aSP4OqfiRxuMgdbq3Y3
	 PUocn2UyKRtr8lJynv2oehh3JkOwiD8xhPVZIe2ukxvn6dwyglzSMKIvjVXOTxqzb5mp0
	 yRcaj0GJZMRp9ysvkdGx29q4+CtAVzhE7ZbTGdU73HKvF8OtcQyve7a27PRmggUvt6bm8
	 V+0GssHspafubktNVkWW63XZUsnK2kaYin0cm/QzVVVSfM1lWd6bouqT1bLnNLqGoyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UNPepNIpGXWll5W/XDnaYjnB/bGIa/j8KFDS2dLRjuc=;
	b=OaVqjv0Y3o/QkCrf3X9OncpoGryOAgXPlA9Uio88oAvxuWl22XsXLZod5DoSDKrpWrqP
	 oVC+hBV0HVhNZyixW9MuNVp3Zxc6ELXbk2+QLXwKZ5XuYMkB+IbqKJG41IV5joVfQLpaW
	 8ZCMVyXn45/SfN9Pk4vOEKAhJ3XSele5N0dAYEBqwadEECEoIWK74/dwn80SW6b+UOjVs
	 ZVZAe90VJMlSYa+588Ap/qpKZhH5ZAzKU61uAesbc2zmXYHUbBzkHNdLg3XHG15ewggji
	 qLyH8lQUn7FLX9Oz0+YUU5zEWQS5auz2T139h9UwJeZwkPKV6E+BjXVbc8K89BJWacA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCd9AzoP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F518606D802;
	Sat,  7 Nov 2026 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCd9AzoP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB5E1F0089F;
	Sat,  7 Nov 2026 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063367;
	bh=UNPepNIpGXWll5W/XDnaYjnB/bGIa/j8KFDS2dLRjuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCd9AzoPNrroSr2MEb0vaj99cgyogIk3IhRIlVDiU9mjbQPiO5Yf2G34rKnopTl8O
	 HdsQjhJEQb8grKmg1TwHKeHfvQkJsBCT014i255jmLJOpHOuFwZO187FpmOa6iyBJd
	 zX+DIzFacKDwtGY5+teQ3k7FG94vRDL+v7ZHt3ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 544/869] platform/x86: hp-bioscfg: return -E2BIG from validate_password_input()
Date: Sat,  7 Nov 2026 08:53:46 -0500
Message-ID: <20261107134911.846144774@linuxfoundation.org>
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
index 6b94f90bea07a..43a2fd0c07db1 100644
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062252;
	b=qWhpdBwUc3NR8Eelsnc3UxoSRfTMwCU/SAL4UWN42yrOM0qtKhyYOPWOaGbgh6o1MaSn
	 0rS74hfk6e39IS2mRUc/xOSmt8q17hsUEjmpUWHD1VQyo+RmclTZx3Z4ZvCUHHN6YtJ2Y
	 2M9m4/K0EHoUSUj5rLmuvPMJ349yc1IHpZ4ANcMOUPwRpy7f16zj05hAEDqHkeE5iVPGX
	 r3AEd0ZDyrBJM81V2OtX8lHVRTQxhPGzmhJ9gm4eGTnJz1puf9QgESQJ2OIVr4Pr39KQO
	 6d9RRfy4k2ZSvJ+RsxUPIgiQeynmlppFl0MdSW6tqQa0qa+UixKtpmRXWZmnCi28vfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SeSJ9M0VL54eYOIVxXhULzbg/x00Pm7ZHwP8jC8YN4c=;
	b=UP9vmMi92ccriRZ2Kfm/WkUy5srO8DNf87U2dl/gCPnX+UcfB/IseX22fT5facvkPQBI
	 fljddKipmwBuJqcHbNVWcnu5gpXkY5+V4dyq7UM0fdcDrbWXu4CvtuFHYIf74106d66Rk
	 g9dFWygXPHkfTKmlp/sUJ8MsOUX7dSFR4k8KFLOWo+xG73p8u1D78DsWB19QqqdBJ7xAm
	 tW26AT9UGSk8oOagoNtJtnMjfaoTkchkQO0N4M8ZWMiza6dged5xLmr0ImIiJq5GMb0Tz
	 WSUtrLIcirHQnsYOnRuvkxXUn4MAYQhybyLd3m3IetSCK5qeccG9xKduw0n0QdJTIFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7cjWAwB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC93606A326;
	Thu, 19 Nov 2026 04:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7cjWAwB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AF71F000C4;
	Thu, 19 Nov 2026 04:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062252;
	bh=SeSJ9M0VL54eYOIVxXhULzbg/x00Pm7ZHwP8jC8YN4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7cjWAwB8xXDmtuw4vGEsI3Gjdfn7H3GdA8+7+dd+BRHaor9LUVtFgBiKGJh52AdN
	 PbvA7iE66quczwkcNZiDr79oSIK1AJ6zM6J7ERRAyJIuBkEn2wEqh6ZInFcdsVcHkG
	 LuhaQBEtFrEFehWB/tToVvdIGURnOK/1pGr1Gcd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 1844/1848] kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIST
Date: Wed, 18 Nov 2026 16:04:42 +0100
Message-ID: <20261118150036.749026291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

commit a314f52a0210730d0d556de76bb7388e76d4597d upstream.

Most 'make *config' commands use .config as the base configuration file.

When .config does not exist, Kconfig tries to load a file listed in
KCONFIG_DEFCONFIG_LIST instead.

However, since commit b75b0a819af9 ("kconfig: change defconfig_list
option to environment variable"), warning messages have displayed an
incorrect file name in such cases.

Below is a demonstration using Debian Trixie. While loading
/boot/config-6.12.9-amd64, the warning messages incorrectly show .config
as the file name.

With this commit, the correct file name is displayed in warnings.

[Before]

  $ rm -f .config
  $ make config
  #
  # using defaults found in /boot/config-6.12.9-amd64
  #
  .config:6804:warning: symbol value 'm' invalid for FB_BACKLIGHT
  .config:9895:warning: symbol value 'm' invalid for ANDROID_BINDER_IPC

[After]

  $ rm -f .config
  $ make config
  #
  # using defaults found in /boot/config-6.12.9-amd64
  #
  /boot/config-6.12.9-amd64:6804:warning: symbol value 'm' invalid for FB_BACKLIGHT
  /boot/config-6.12.9-amd64:9895:warning: symbol value 'm' invalid for ANDROID_BINDER_IPC

Fixes: b75b0a819af9 ("kconfig: change defconfig_list option to environment variable")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kconfig/confdata.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -388,10 +388,12 @@ int conf_read_simple(const char *name, i
 
 			*p = '\0';
 
-			in = zconf_fopen(env);
+			name = env;
+
+			in = zconf_fopen(name);
 			if (in) {
 				conf_message("using defaults found in %s",
-					     env);
+					     name);
 				goto load;
 			}
 



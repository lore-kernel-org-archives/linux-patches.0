Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A163D381D6;
	Fri, 24 Nov 2023 18:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQOE74LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B61C433C8;
	Fri, 24 Nov 2023 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849775;
	bh=8icLZK2ZEebxifNYzhO9nxRVZ6jSdcnHumeluRtEREY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQOE74LG/q5fcS/Ga3tzoXPw2IWzPuYh2lprlvJEDlzVBsTlXf9LuQVwxi1exCUWO
	 sYh8G6r1BShVsJ/bcj5HqKvoL75pd2qJqyaSHJQO4g6+h/HLqMouWlM17RsfOHWd29
	 IzcYVnQv2smI5ojRfcXcPZhjFonQD6WCx83key9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 315/530] integrity: powerpc: Do not select CA_MACHINE_KEYRING
Date: Fri, 24 Nov 2023 17:48:01 +0000
Message-ID: <20231124172037.627456200@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Suchanek <msuchanek@suse.de>

commit 3edc22655647378dea01900f7b04e017ff96bda9 upstream.

No other platform needs CA_MACHINE_KEYRING, either.

This is policy that should be decided by the administrator, not Kconfig
dependencies.

Cc: stable@vger.kernel.org # v6.6+
Fixes: d7d91c4743c4 ("integrity: PowerVM machine keyring enablement")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 232191ee09e3..b6e074ac0227 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -68,8 +68,6 @@ config INTEGRITY_MACHINE_KEYRING
 	depends on INTEGRITY_ASYMMETRIC_KEYS
 	depends on SYSTEM_BLACKLIST_KEYRING
 	depends on LOAD_UEFI_KEYS || LOAD_PPC_KEYS
-	select INTEGRITY_CA_MACHINE_KEYRING if LOAD_PPC_KEYS
-	select INTEGRITY_CA_MACHINE_KEYRING_MAX if LOAD_PPC_KEYS
 	help
 	 If set, provide a keyring to which Machine Owner Keys (MOK) may
 	 be added. This keyring shall contain just MOK keys.  Unlike keys
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0DD19463
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9ot4eNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06429C433CC;
	Mon,  9 Oct 2023 13:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857107;
	bh=aAEhpef9Dcy0zrzSpKxjMoLhQUfF5ICha+OW9y340vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9ot4eNkGXKFeTZ/hsNOlY/6vuhJdjihyflfKdXLOBslpwP88Ky+AImrwMmcmaF8L
	 2nUREOpVOIjJ8uOpXrlLedPh/YGFncuuZjeHbOHsFy3uJ60AEU3iqb9GlhnE03q9lf
	 Z9uPpQ/I9o21sNU0wDr5U3D4kICMABowqxZK3FCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 091/163] ima: Finish deprecation of IMA_TRUSTED_KEYRING Kconfig
Date: Mon,  9 Oct 2023 15:00:55 +0200
Message-ID: <20231009130126.548452389@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksandr Tymoshenko <ovt@google.com>

[ Upstream commit be210c6d3597faf330cb9af33b9f1591d7b2a983 ]

The removal of IMA_TRUSTED_KEYRING made IMA_LOAD_X509
and IMA_BLACKLIST_KEYRING unavailable because the latter
two depend on the former. Since IMA_TRUSTED_KEYRING was
deprecated in favor of INTEGRITY_TRUSTED_KEYRING use it
as a dependency for the two Kconfigs affected by the
deprecation.

Fixes: 5087fd9e80e5 ("ima: Remove deprecated IMA_TRUSTED_KEYRING Kconfig")
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Reviewed-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index c17660bf5f347..e6df7c930397c 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -268,7 +268,7 @@ config IMA_KEYRINGS_PERMIT_SIGNED_BY_BUILTIN_OR_SECONDARY
 config IMA_BLACKLIST_KEYRING
 	bool "Create IMA machine owner blacklist keyrings (EXPERIMENTAL)"
 	depends on SYSTEM_TRUSTED_KEYRING
-	depends on IMA_TRUSTED_KEYRING
+	depends on INTEGRITY_TRUSTED_KEYRING
 	default n
 	help
 	   This option creates an IMA blacklist keyring, which contains all
@@ -278,7 +278,7 @@ config IMA_BLACKLIST_KEYRING
 
 config IMA_LOAD_X509
 	bool "Load X509 certificate onto the '.ima' trusted keyring"
-	depends on IMA_TRUSTED_KEYRING
+	depends on INTEGRITY_TRUSTED_KEYRING
 	default n
 	help
 	   File signature verification is based on the public keys
-- 
2.40.1




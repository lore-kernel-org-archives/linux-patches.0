Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB021D302
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B876C433C7;
	Tue, 25 Jul 2023 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283369;
	bh=9AB+ocDjifGOrKZcWMOMmB0GOz/87uK0rOP0S0Vz0DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySUYnR7rzrU1569SNkPc/16obxFdlbJV5V4eiyaTG+0glRHojAd6V9jzJ5Q4bJOiG
	 MVMDsQ0zMS6FN2NfBzNW8Fql6o3QUpJePy74/6E0yOwuZCLOge71kpV2op+8RNOuu2
	 pOod7/miD9XtJrhZoZT3bUFnutiRTyIO5f//AW7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Paul Moore <paul@paul-moore.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/78] security: keys: Modify mismatched function name
Date: Tue, 25 Jul 2023 12:46:42 +0200
Message-ID: <20230725104453.251163703@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 2a4152742025c5f21482e8cebc581702a0fa5b01 ]

No functional modification involved.

security/keys/trusted-keys/trusted_tpm2.c:203: warning: expecting prototype for tpm_buf_append_auth(). Prototype was for tpm2_buf_append_auth() instead.

Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5524
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 2b2c8eb258d5b..bc700f85f80be 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -186,7 +186,7 @@ int tpm2_key_priv(void *context, size_t hdrlen,
 }
 
 /**
- * tpm_buf_append_auth() - append TPMS_AUTH_COMMAND to the buffer.
+ * tpm2_buf_append_auth() - append TPMS_AUTH_COMMAND to the buffer.
  *
  * @buf: an allocated tpm_buf instance
  * @session_handle: session handle
-- 
2.39.2




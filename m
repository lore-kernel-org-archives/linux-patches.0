Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81931D2A5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB97C433EF;
	Wed,  7 Jun 2023 20:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170794;
	bh=hiekQ6/qtAXAzA6Hjve+wJbq3GliBwKXy/buQqrRT8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiwvcUKT3LYkw11bSbSjDEoLXGFzXZZNMGyY7Oz+bomX89dib+Xm8/J9iq4cFdd5I
	 2F+gOX2Bp61T3ndbJwMUIKfGW3p/aIFPuAa8aSgJVDQyg4Xi2FzxTcGP0enP8lzvZy
	 42GmTIPdeoKrAHPA0oMiJhmE38lbUWgAttUy2EPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 181/225] tpm, tpm_tis: correct tpm_tis_flags enumeration values
Date: Wed,  7 Jun 2023 22:16:14 +0200
Message-ID: <20230607200920.310769639@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 4ecd704a4c51fd95973fcc3a60444e0e24eb9439 upstream.

With commit 858e8b792d06 ("tpm, tpm_tis: Avoid cache incoherency in test
for interrupts") bit accessor functions are used to access flags in
tpm_tis_data->flags.

However these functions expect bit numbers, while the flags are defined
as bit masks in enum tpm_tis_flag.

Fix this inconsistency by using numbers instead of masks also for the
flags in the enum.

Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 858e8b792d06 ("tpm, tpm_tis: Avoid cache incoherency in test for interrupts")
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Cc: stable@vger.kernel.org
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index e978f457fd4d..610bfadb6acf 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -84,10 +84,10 @@ enum tis_defaults {
 #define ILB_REMAP_SIZE			0x100
 
 enum tpm_tis_flags {
-	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
-	TPM_TIS_INVALID_STATUS		= BIT(1),
-	TPM_TIS_DEFAULT_CANCELLATION	= BIT(2),
-	TPM_TIS_IRQ_TESTED		= BIT(3),
+	TPM_TIS_ITPM_WORKAROUND		= 0,
+	TPM_TIS_INVALID_STATUS		= 1,
+	TPM_TIS_DEFAULT_CANCELLATION	= 2,
+	TPM_TIS_IRQ_TESTED		= 3,
 };
 
 struct tpm_tis_data {
-- 
2.41.0




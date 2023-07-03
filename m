Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFF91094A
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE316C433C7;
	Mon,  3 Jul 2023 18:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410653;
	bh=4n4pT5+bLzUOZ5TQNEQEkoWfpzOrQFSwjHQTV0Ad5O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvtZ3EJqN9E0KcAt0XBV8YIX+k7ooJKYs0p0n/BKfF7NMMVhpWtRjEYNtqSsyVTCW
	 28p+uj7A7Vh0LLLv2sltauitNLUfP9hYInfjw9ofuLdL0OcWIhQ4nG2xlzKsUnWf1l
	 qvU4mfRy8/M9ZaS0dOZorjcesnOybfuMksuIElg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.15 06/15] x86/microcode/AMD: Load late on both threads too
Date: Mon,  3 Jul 2023 20:54:51 +0200
Message-ID: <20230703184519.070005889@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184518.896751186@linuxfoundation.org>
References: <20230703184518.896751186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit a32b0f0db3f396f1c9be2fe621e77c09ec3d8e7d upstream.

Do the same as early loading - load on both threads.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230605141332.25948-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -699,7 +699,7 @@ static enum ucode_state apply_microcode_
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
 	/* need to apply patch? */
-	if (rev >= mc_amd->hdr.patch_id) {
+	if (rev > mc_amd->hdr.patch_id) {
 		ret = UCODE_OK;
 		goto out;
 	}



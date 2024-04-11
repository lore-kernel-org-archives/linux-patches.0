Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB622EAE5;
	Thu, 11 Apr 2024 10:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829673; cv=none; b=NlV7Clq0Vsuym2rWE2AR4le5G+Y5xLYAA7rdO2qkjNKkDIZU39hSkr99EK0xaS0qp6CS0FArL2+QzxMSGGjdATBU8oXobvON6fzokwaEMCuopjUcTey+nG6B9N7/CnHzwlv+Lb0P7T7VEOKvxyy6AWNA2snCB3MKkFuT0ZkwVgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829673; c=relaxed/simple;
	bh=SOkHgWFa73tdi/jq9TyhRFRdHOjMUymdAi7P6UjtY3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnRMgjz4XTzHvGzu/AcVMiWCrYsIPRuAURO3Q8Tu5XjcA8ANEh1AAW94zBtqktpy+VCGDN/azCWa1e0hqJ72qJ5H9d6JgauMr1M0d08EPDNewVhnvJraU/W86LUGrsw0fLMt2xc9y2BsaB4QJNbI8FqH5CKxW8eATmb+b8gVR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWVgMObq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWVgMObq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BC3C433F1;
	Thu, 11 Apr 2024 10:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829673;
	bh=SOkHgWFa73tdi/jq9TyhRFRdHOjMUymdAi7P6UjtY3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWVgMObqP8Vq4mw7IW2G727/c9BChy60j3neWdGSjVIfgmPYGMT3K34xQ7IivP78g
	 W/Mx2/QeoqvulT3+jFARgCt9PhqKlwwA8dXSvLeKSTuqvzQ+JH9V2lCud6k8IlQ8tU
	 9dKS4hk0XtHxqAhEiD3reprKXk4prHS1UzjpinKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/175] x86/CPU/AMD: Update the Zenbleed microcode revisions
Date: Thu, 11 Apr 2024 11:54:49 +0200
Message-ID: <20240411095421.553029460@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 5c84b051bd4e777cf37aaff983277e58c99618d5 ]

Update them to the correct revision numbers.

Fixes: 522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 5b75a4ff6802c..3f6188477e014 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -988,11 +988,11 @@ static bool cpu_has_zenbleed_microcode(void)
 	u32 good_rev = 0;
 
 	switch (boot_cpu_data.x86_model) {
-	case 0x30 ... 0x3f: good_rev = 0x0830107a; break;
-	case 0x60 ... 0x67: good_rev = 0x0860010b; break;
-	case 0x68 ... 0x6f: good_rev = 0x08608105; break;
-	case 0x70 ... 0x7f: good_rev = 0x08701032; break;
-	case 0xa0 ... 0xaf: good_rev = 0x08a00008; break;
+	case 0x30 ... 0x3f: good_rev = 0x0830107b; break;
+	case 0x60 ... 0x67: good_rev = 0x0860010c; break;
+	case 0x68 ... 0x6f: good_rev = 0x08608107; break;
+	case 0x70 ... 0x7f: good_rev = 0x08701033; break;
+	case 0xa0 ... 0xaf: good_rev = 0x08a00009; break;
 
 	default:
 		return false;
-- 
2.43.0




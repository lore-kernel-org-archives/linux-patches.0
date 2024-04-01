Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA5E48781;
	Mon,  1 Apr 2024 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990985; cv=none; b=p6zeP+UlDEe+qD4LTFWU2+EnnzAO9JV36RxKpefmUh2Ps1WKGdpvzkFMT9Q1F2s59uOfrwWq5pN51CMKybd3oMNeWjFAUT9aa6df4KhssaacwD7jDx4AnBRNrNHsv4t5OIpAK8nUmac0HEFk2My+rt0BbiVP+bGioSBFEJs34pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990985; c=relaxed/simple;
	bh=mHESPEr0KvOYbREn2xAdI2iZz6lRm+YQ9KLy7RfRTWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA9VYlDPze9CJX4f5xcRAA2tikMlT2Fp/XsftIMv9FnTI6AH0cIjiZgoCPGFgOAKrtkmOvST8p7OiG1eu62kcViNLs5jj9B+IvX0RI22BAxv2Tq1P5rKqBq1aa2JSQzVGSwHox1nKNKlA0ck2LIhwpQbB+szEIZmUZv0fpSzHec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNbWLwdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNbWLwdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F43C433C7;
	Mon,  1 Apr 2024 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990985;
	bh=mHESPEr0KvOYbREn2xAdI2iZz6lRm+YQ9KLy7RfRTWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNbWLwdDUsl3VLNpb/YyTXI9LfKs4rqnO/POf3Csdk43vUUmMae2bNzX7H8hT7xmP
	 qPHoBffwzCBGJCPI90PPSrPfIKNPXHKKbCcKXV6awAZnK6O3ZGRX7jirQGWFjEB6HQ
	 CNAnOmWkeqsbxTwJ+NmS64PJWZLyWlq1Hd+LKoNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/272] x86/CPU/AMD: Update the Zenbleed microcode revisions
Date: Mon,  1 Apr 2024 17:45:18 +0200
Message-ID: <20240401152534.677062339@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c1d09c8844d67..425092806f8fe 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -997,11 +997,11 @@ static bool cpu_has_zenbleed_microcode(void)
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




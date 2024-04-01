Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A2D46551;
	Mon,  1 Apr 2024 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987118; cv=none; b=pRd9YHXQFiDdhnlJADtpiPcYaKfgHIkeaJ9VZDsPKiBgG2b0nb15ehouG68iwTx7vvkp6WXeZumujeENCkVUUj6prjtellLDbIatNlRjqUxcfnMbQu7kNpiiBtIBz4tO0x2QtoyiQlhDLXS+yK1QPsg/RViKao3Y2gBcHzv7fCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987118; c=relaxed/simple;
	bh=m/LMRvmsrzZN7dszsquYjaZUJgsF4wHfA9kJ1AtsWxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0s8MkACk7VMuOSzt7AKd5M8RYxJbvj3V8zzcRX28lKH1BDPMk82/VLUpUDsOmKPraL6ZExSoXp5WlghCAOcqCs6Z6ap09wgSaMlaPllA74V+j0X3ZKt+i1XGvwdrk5VMX8i4qTGlrev15kZHLJZ19jzpy5CWaA8hINN8Q2mQOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd9U+VO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd9U+VO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5C8C433C7;
	Mon,  1 Apr 2024 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987118;
	bh=m/LMRvmsrzZN7dszsquYjaZUJgsF4wHfA9kJ1AtsWxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zd9U+VO2jfGzwNr2Rdqyk3tGAOc/U3uAiLCjV+88dzhk9f/MnZlzVGj51Mp6bZmYu
	 VdAKGagXffg3WBTK0ngcKNnHrPxXQeXfeD5bEO7PUs77AxDpV+ArV3ENUWxKefWb4Y
	 2B/KXT9trVlrNqmR59oYl+yQbTDTE+rlHYb5QlKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 189/399] x86/CPU/AMD: Update the Zenbleed microcode revisions
Date: Mon,  1 Apr 2024 17:42:35 +0200
Message-ID: <20240401152554.816597265@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index f3abca334199d..dfa8d0cf5e185 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -989,11 +989,11 @@ static bool cpu_has_zenbleed_microcode(void)
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




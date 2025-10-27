Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A24D31DDBC;
	Mon, 27 Oct 2025 19:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592769; cv=none; b=FZUtksythfSqGrcqW0KvnRIivAq+9mC7tAjo4nuX79wrHnWsWLYK/wzBr5dVUTvjqBYV6XXKJA/ZC+k0aeuqCoRWjwxT2CabzU7GJfJKKl4FI+ZojUl1WhCeNu4KcVumlw9b5tqQJfQX4ZSuGB341Ea8qK1RnRQ29gAWSbkcEcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592769; c=relaxed/simple;
	bh=qc1N7B/sNFGKTKuRQ/Dt2g5EZszUIz0633V4CXvokt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQyaP3YY8FdbsL2Ja6YUKPmkzxQK7M9X+3Zg9T1RX1nIDWkQ4DPWEZQyL24wiXXJetHCDOeH3HJXmN12WVccHGYplAcarNmZ4SI8dl8UgpqPYn+CRaS0dHoS0kFnUM6M3nd+8ngtpfgigPyF7dIkxOcMsC5pf9w2XjwG3vRB8FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MszkrkCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MszkrkCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2187C4CEF1;
	Mon, 27 Oct 2025 19:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592769;
	bh=qc1N7B/sNFGKTKuRQ/Dt2g5EZszUIz0633V4CXvokt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MszkrkCa79rhnCxFAnEoErd/RWIy/kLUjEg6QeN2BV2V1qB0/qKQAXbP0tdJlaPlt
	 ZRcCFDJb1le/0XIt8mirproUi511PC5y4K7/2k4dJawX8t5YUy9TfDfsSeEYU87L7m
	 mORb8PQwLUU9xLM63kTBKOuKkAUJu6uFnDUsY5lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 65/84] x86/microcode: Fix Entrysign revision check for Zen1/Naples
Date: Mon, 27 Oct 2025 19:36:54 +0100
Message-ID: <20251027183440.545287579@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 876f0d43af78639790bee0e57b39d498ae35adcf upstream.

... to match AMD's statement here:

https://www.amd.com/en/resources/product-security/bulletin/amd-sb-7033.html

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20251020144124.2930784-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -184,7 +184,7 @@ static bool need_sha_check(u32 cur_rev)
 	}
 
 	switch (cur_rev >> 8) {
-	case 0x80012: return cur_rev <= 0x800126f; break;
+	case 0x80012: return cur_rev <= 0x8001277; break;
 	case 0x80082: return cur_rev <= 0x800820f; break;
 	case 0x83010: return cur_rev <= 0x830107c; break;
 	case 0x86001: return cur_rev <= 0x860010e; break;



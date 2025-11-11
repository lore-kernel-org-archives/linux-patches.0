Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390141C69;
	Tue, 11 Nov 2025 01:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825464; cv=none; b=FtjPD7PS5bJhWD8h/wMt+HiMzgROBQU504GWJkoCejJQvv4koYvLQXKDA403W5U6X76irckOfQIuwiBkBes72tDTY2dd3AgUu/v6o+2b8Icq2wUEVb9zaRQoFAnIAOKgJdPghU5eQE3O/TSBaEH3ZSv9OIr23Bk2XLk7UIr+4tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825464; c=relaxed/simple;
	bh=1uKRyLvwLMluhrdoNbRTTYwgHfSb4BNrik4laonrJAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYUIJiX10vH7otiLvGyFAohUUNO1zuLMl1dyHBFHPJCy2BoClWYpJjdc7NFE5rrwW9ie9ymrmcMgO6L2nQdGhVOpudkdaVNbnZi/jSLHrkOez15ukfFyzq7VpZlFT09q0iBPSyLsIt/eUK6NAIzpUO9vkkMbb8B44eIU0OHwKQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+4YLLLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+4YLLLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB2CC116D0;
	Tue, 11 Nov 2025 01:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825463;
	bh=1uKRyLvwLMluhrdoNbRTTYwgHfSb4BNrik4laonrJAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+4YLLLY/tTku8//6OBJAN9XUiFimuEnuXDZR5OUVZc5mJ2DQqwm4KFk4bIwNVK2G
	 nSN6eSYsUuGZSPQ8UsUg3IyDAPSF4S/wnE7AXUqwGAEBJHnEf4OYxYOICYpepmMDhG
	 Lpi9S0LgSGS+GjTtjIbL+nZ0mdvrNJ525zjEEhPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.17 814/849] x86/microcode/AMD: Add more known models to entry sign checking
Date: Tue, 11 Nov 2025 09:46:24 +0900
Message-ID: <20251111004556.104420996@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit d23550efc6800841b4d1639784afaebdea946ae0 upstream.

Two Zen5 systems are missing from need_sha_check(). Add them.

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20251106182904.4143757-1-superm1@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -220,10 +220,12 @@ static bool need_sha_check(u32 cur_rev)
 	case 0xaa001: return cur_rev <= 0xaa00116; break;
 	case 0xaa002: return cur_rev <= 0xaa00218; break;
 	case 0xb0021: return cur_rev <= 0xb002146; break;
+	case 0xb0081: return cur_rev <= 0xb008111; break;
 	case 0xb1010: return cur_rev <= 0xb101046; break;
 	case 0xb2040: return cur_rev <= 0xb204031; break;
 	case 0xb4040: return cur_rev <= 0xb404031; break;
 	case 0xb6000: return cur_rev <= 0xb600031; break;
+	case 0xb6080: return cur_rev <= 0xb608031; break;
 	case 0xb7000: return cur_rev <= 0xb700031; break;
 	default: break;
 	}



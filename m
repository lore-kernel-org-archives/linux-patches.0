Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503CF24E4A8;
	Thu, 27 Nov 2025 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255892; cv=none; b=VxxWtkGSHVLDCdzqN3TeNmSNkAgXbbNS7IvfcAbbvw+MP823Sg8hg9vYiYd2PECEe4gYTuDEy27n3Le7fS3ScSUB2GBYXE/LCGNFItIl+on0QNDA4TarL4IT9HcFopB8eP3PAjbSSVgvldRnM/JU2NMCgnnBb/rseHKekEQba9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255892; c=relaxed/simple;
	bh=ezhaN527kWZaTAuBRpVYZW1foak+8ha67eytNHG0jM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn+df7ctSQLbEZ3+Xc0YVEYNNs39oSQNyEt3HmZo+GITyhkbzo/ZA0sEZ/VuZNGEySZr63/9qiLMA8ixeay7t0OsTyePHfOjkjGTiiux9+Z/nEdH+u6KrMOyqGKMYEFfgIgscpEvVm988DaU5ZZC9cDnB4LGWEDerCleUiqhJFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFIP6KIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFIP6KIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94DAC4CEF8;
	Thu, 27 Nov 2025 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255892;
	bh=ezhaN527kWZaTAuBRpVYZW1foak+8ha67eytNHG0jM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFIP6KIMyCTpxC8DK0J6oygKLI1DwQ4JmI9gHLiY3eb/shiM88bB7IWYj8BtX5V4k
	 sIhmrPtYAoij7yg41pUgJXhggTFvi4geMjKbRfa1a/c74WW95ZEVdEZw1iW7I7x1Oc
	 SvhvYixLXhVJUWUVHpWUhR8i82upU36QZXsJNx2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 151/175] x86/CPU/AMD: Extend Zen6 model range
Date: Thu, 27 Nov 2025 15:46:44 +0100
Message-ID: <20251127144048.468137116@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 847ebc4476714f81d7dea73e5ea69448d7fe9d3a ]

Add some more Zen6 models.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251029123056.19987-1-bp@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3139713e3a78f..9390312c93b6e 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -516,7 +516,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		case 0x50 ... 0x5f:
-		case 0x90 ... 0xaf:
+		case 0x80 ... 0xaf:
 		case 0xc0 ... 0xcf:
 			setup_force_cpu_cap(X86_FEATURE_ZEN6);
 			break;
-- 
2.51.0




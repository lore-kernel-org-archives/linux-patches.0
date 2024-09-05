Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A050194A60;
	Thu,  5 Sep 2024 09:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529421; cv=none; b=nULIp/L8YdQcXEHa77OYcT5JXYnNUwn4svB4CxVe6kqLAmn4rovPQCAux5d85YEt3p/mXnoCXWQOO3uUGoFKBj61lyiKfG/tgF0lT0DAmy02+yZABHcaE4B6o/n3b8BZcno1acsGt/WHHEPDTewmSBzeXp2ywdyIiL2ZQlCAMZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529421; c=relaxed/simple;
	bh=PsiBqTHBmRXNOe/A7lQ4SUcGvdSq5EUrbgo26knCcYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYZQ0oXsXjsaQJ1hjHY0MMBh1VqlHlZ7DOVU/u7dVcqAMF50oxEvXdJk11aUK8QTQ3+P2HQgFohSpCSIeRdgtMDOfG1fT5xj60D41h4hxFRHzMLkjXZIoDFE080HWI8i/RtL1Z9N4lsHYoUEg9DzYLgc1M3KGNcUq7zHT/tfjgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsGRWrEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsGRWrEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B59C4CEC3;
	Thu,  5 Sep 2024 09:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529421;
	bh=PsiBqTHBmRXNOe/A7lQ4SUcGvdSq5EUrbgo26knCcYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsGRWrEGBxZduyP0udTwodPdqv/RheoMNUZ2Wc16tH8qKSzvklmQ2cNQuG1WJWuxx
	 Qm/qVRgB8cXTMstZ1k8q3rWAORgslA+mN77V1PP3JtLxuVZI3TX0N/lzK2ge6Cn7jV
	 Tvhp0VcejZTnConI/7ioMPviCKDHcWnUFqfDMZAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 008/184] x86/CPU/AMD: Add models 0x60-0x6f to the Zen5 range
Date: Thu,  5 Sep 2024 11:38:41 +0200
Message-ID: <20240905093732.566118575@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit bf5641eccf71bcd13a849930e190563c3a19815d ]

Add some new Zen5 models for the 0x1A family.

  [ bp: Merge the 0x60 and 0x70 ranges. ]

Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240729064626.24297-1-bp@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 44df3f11e7319..7b4940530b462 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -462,7 +462,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		switch (c->x86_model) {
 		case 0x00 ... 0x2f:
 		case 0x40 ... 0x4f:
-		case 0x70 ... 0x7f:
+		case 0x60 ... 0x7f:
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		default:
-- 
2.43.0




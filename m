Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF55226CE33;
	Fri, 21 Nov 2025 13:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731421; cv=none; b=rXuiJKuXVnmj/bRhaz1Q7YnclWMoCy1Yjo0LZXNFggo3+QCXYro+2o38vbCHAUAN0P5STHib7thG668eoqry48FxMvMqp+EFI4AaYeAY7wWirhY0Q2DXFsH/JZ3TVmcI6DbEfgP3akUYLwCiBq7t4ln+mCdN2n4jiv9zQAsZ+Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731421; c=relaxed/simple;
	bh=Km/xiGScPwTRDjCL/MVKEnlh0snBKxfxQc7mT+juMis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RljfNl/KfVrjg6/jYyQq4Ozs9pJ4zv54Tp5undNMCLo7kPLu1fPJIGkKS7tqEQeKGS5vSyssxtjvDS8lcIzocyPJEIFk0ICv5hUTdey+iienKmYcoVk7RZqoRv66ymxDfdC5IeyxEJ2R8KhIxnZjaHK6nTfOVKxWewNiHmkJi+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/BDy4ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/BDy4ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AD4C4CEF1;
	Fri, 21 Nov 2025 13:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731421;
	bh=Km/xiGScPwTRDjCL/MVKEnlh0snBKxfxQc7mT+juMis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/BDy4ZKvPYBYj7LBU/lSnZtvgFy37YgVE8rHgqATT0B+db222dCpdzsSVWjsAe+l
	 zH92Xpp4n0bQogYfYgV8h2grvi9mnk9YRyK4EywKkhl91XuLaVdLsIPrmBDuLmUiKP
	 4GtdddQYVns42LZGKq5btFpKf7T0R1g8KE78VEZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.17 203/247] x86/CPU/AMD: Add additional fixed RDSEED microcode revisions
Date: Fri, 21 Nov 2025 14:12:30 +0100
Message-ID: <20251121130202.010237768@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit e1a97a627cd01d73fac5dd054d8f3de601ef2781 upstream.

Microcode that resolves the RDSEED failure (SB-7055 [1]) has been released for
additional Zen5 models to linux-firmware [2]. Update the zen5_rdseed_microcode
array to cover these new models.

Fixes: 607b9fb2ce24 ("x86/CPU/AMD: Add RDSEED fix for Zen5")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-7055.html [1]
Link: https://gitlab.com/kernel-firmware/linux-firmware/-/commit/6167e5566900cf236f7a69704e8f4c441bc7212a [2]
Link: https://patch.msgid.link/20251113223608.1495655-1-mario.limonciello@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1020,7 +1020,14 @@ static void init_amd_zen4(struct cpuinfo
 
 static const struct x86_cpu_id zen5_rdseed_microcode[] = {
 	ZEN_MODEL_STEP_UCODE(0x1a, 0x02, 0x1, 0x0b00215a),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x08, 0x1, 0x0b008121),
 	ZEN_MODEL_STEP_UCODE(0x1a, 0x11, 0x0, 0x0b101054),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x24, 0x0, 0x0b204037),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x44, 0x0, 0x0b404035),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x44, 0x1, 0x0b404108),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x60, 0x0, 0x0b600037),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x68, 0x0, 0x0b608038),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x70, 0x0, 0x0b700037),
 	{},
 };
 



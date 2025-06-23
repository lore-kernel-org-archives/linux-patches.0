Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1035C221543;
	Mon, 23 Jun 2025 22:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717480; cv=none; b=NW1gBOunEmJSq5WIQNNI6lpYcPUXSKG7gfOd4EuUj2xsm4Q0iRwaVEnza/my4xg4TX4Vc0uk1xq8ul/1MbAkjll76A42h+TG+glQGfVq1th5GgQPHamc/0e7K+Dut/nx2j8buw0ywpxbhkMvs1DPe0WAk2r9wGFj8SvjtvuKwI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717480; c=relaxed/simple;
	bh=rMCJDU+2oQiNZsPMClqs/CNIB64Rl7Wlr6jGTsJRTP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfI6O/Bs5fvF1qigOlocel30BX1GMipJ7N0xMKT1fygyzjOfXzy06IhDUwripbZMnKoaJN9aVxCR71C06w+vXLUGhR7oAHKEhNvAeXGve8zxO90l5BAOeHYPQ2HMOwZf5AZBF/aIRPLyB4c4sGKBU9HsG7i1JQNO+EY9OIRZCMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mI1lVlO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mI1lVlO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D965C4CEEA;
	Mon, 23 Jun 2025 22:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717479;
	bh=rMCJDU+2oQiNZsPMClqs/CNIB64Rl7Wlr6jGTsJRTP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mI1lVlO0t9ywUutzRVF1Vi11EAFDYAEwwiHrd24UyxoCpSzqMRHNPs0/dvje2sSWe
	 eBM/J8zUF8ZB02M97K7ICRKhN0o6wJwET52nebX4S7fdwIZnZJCpjNIJIOlbm8lwoz
	 G3BSw0soOnvq75BtLsn9gvVfyQgkZjtaYMVmQ7DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	reox <mailinglist@reox.at>,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 395/414] EDAC/amd64: Correct number of UMCs for family 19h models 70h-7fh
Date: Mon, 23 Jun 2025 15:08:52 +0200
Message-ID: <20250623130651.815323108@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avadhut Naik <avadhut.naik@amd.com>

commit b2e673ae53ef4b943f68585207a5f21cfc9a0714 upstream.

AMD's Family 19h-based Models 70h-7fh support 4 unified memory controllers
(UMC) per processor die.

The amd64_edac driver, however, assumes only 2 UMCs are supported since
max_mcs variable for the models has not been explicitly set to 4. The same
results in incomplete or incorrect memory information being logged to dmesg by
the module during initialization in some instances.

Fixes: 6c79e42169fe ("EDAC/amd64: Add support for ECC on family 19h model 60h-7Fh")
Closes: https://lore.kernel.org/all/27dc093f-ce27-4c71-9e81-786150a040b6@reox.at/
Reported-by: reox <mailinglist@reox.at>
Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org
Link: https://lore.kernel.org/20250613005233.2330627-1-avadhut.naik@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/amd64_edac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3882,6 +3882,7 @@ static int per_family_init(struct amd64_
 			break;
 		case 0x70 ... 0x7f:
 			pvt->ctl_name			= "F19h_M70h";
+			pvt->max_mcs			= 4;
 			pvt->flags.zn_regs_v2		= 1;
 			break;
 		case 0x90 ... 0x9f:



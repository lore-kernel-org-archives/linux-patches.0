Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058549;
	b=vy+GhtTQeExd8GP8Lg57JNJH45j6qUWcHmOmQZHVmeuqaSPgj0e/1bR/mMIGL8dKaHvJ
	 SQrdt9xg3Dry40J9Dh9s+Fw8HgyEYwZWuvhjlI9TCgBYgV/Oj/EPZ2Qiz0qn8m+AfypA9
	 tUEfj1hpLJ/ZbR1Iqke0rsWT6huO3HMs9a/britNC0iI2IK7XoXpWS+qTCbHOhome5vOq
	 yTgU2FLBf1AwPNZhx0jPMFGfwBvssKRyXSX+kVh1WmUkneemvcjAI+Et3e86eJOD86QLN
	 w+1aVtqIHOtCoNmJI9tJ3gqkUjktG5HlCWZ4OBix8OMLQVRyTwqO+qBRTjLrZHjpwhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VeiKvq5KKsS+K+8IA2PHmr3Lc1evTl/ew+E4eOAbz70=;
	b=Xgiwxoix03PtplQJFrVGA5sz7rkLmYYQvm2o4kE4HqSMqSDWu2wOjzpZ019SIFSZ8vz6
	 xdEwuCRtjn2IW2BJJjaORkWD8TftibXbpkga1v/8H+PyASKHAQfRLwaSBlnEQiOBL1K/I
	 nStV2cw+zFKm9H4eRFUVAyKyDkmUduf0QrrTthmENrKRfKIYMQYxdhD54B3HBH/e+27cT
	 YudsHCNeYiIbswuPcWzn7e9lMt9h3HZ85FTLeouh+V0w1dGaSqDNFTt8wVgNsrFgQQ/RR
	 xpX1NsSxARCp+D8RKchCJHwJOzADEO6cAPrKDnpROw+JU0zoNykLxk3r4maXrJvBLiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnNmOQod;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E081606A320;
	Thu, 19 Nov 2026 03:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnNmOQod
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241C71F000C4;
	Thu, 19 Nov 2026 03:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058548;
	bh=VeiKvq5KKsS+K+8IA2PHmr3Lc1evTl/ew+E4eOAbz70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnNmOQodc2QP9uvl5VmiNLPEvEw4L/j80xuIR2uceamUgiQoC903Cd8Y6VsQH74e9
	 B7ssDqBvt852HdzGhNfsf1TCrLlYJv9HmvcOHlfS4/JUEhmdZ0bPp3IBLCiCHF/hP4
	 sxUdpmOg2+kAwOebkXKXOrWeKr2WmGfLa4DO+jYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0524/1848] efi/libstub: Dont replace an existing LINUX_EFI_MEMRESERVE table
Date: Wed, 18 Nov 2026 15:42:42 +0100
Message-ID: <20261118145936.720667842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit aaf3ed0f46298e18ec8bc477cf0a37478e41f2ea ]

The LINUX_EFI_MEMRESERVE table is the root of a linked list of memory
reservations that need to persist across kexec, such as the GICv3 LPI
pending and property tables, which cannot be moved once the
redistributors have been enabled. Each kernel adds its own reservations
to the list that it finds via the EFI configuration table, and honours
the ones made by its predecessors.

The EFI stub installs a new, empty table unconditionally, replacing any
existing one. This is fine on a cold boot, but not if the stub is being
executed by a loader that passes on the configuration tables of an
earlier kernel, e.g., a kexec loader that runs the incoming kernel's EFI
stub, as the reservations made by earlier kernels would be lost.

So leave an existing table in place, and only install a new one if none
exists yet.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 0ab439c53eee3..a6681d270e9d8 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -79,6 +79,14 @@ static void install_memreserve_table(void)
 	efi_guid_t memreserve_table_guid = LINUX_EFI_MEMRESERVE_TABLE_GUID;
 	efi_status_t status;
 
+	/*
+	 * If an earlier boot stage installed a memreserve table already, e.g.,
+	 * a kexec loader passing on the persistent reservations made by the
+	 * previous kernel, use it as is: installing a new one would replace it.
+	 */
+	if (get_efi_config_table(memreserve_table_guid))
+		return;
+
 	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*rsv),
 			     (void **)&rsv);
 	if (status != EFI_SUCCESS) {
-- 
2.53.0




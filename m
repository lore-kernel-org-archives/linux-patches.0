Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062851;
	b=MyRZ3Pa31sUDURsIcurzu0EVv1RKb633Vzy1o4VH8pBooM4QBZvAmp4RQw16gOgSB4NX
	 ugyfafslGy6y+gwtoKbJcq7nWZOvojBx4iWOhfgIEhvSmRx36qsZDuNnzuWM4vcN27d/X
	 3e4hno/AsSh62Qm9oeV7OxJmIBBJ5T5r8IYNDMQ09dIRCHHB5m6aWg5pbcSyVNzH0ZunC
	 a6t0seu/cXMTFOzhf4TQ3t8j+Tt9wHwuiKqQRuGQa1zGPknJNciSMMbD0FzST5G9g6xbj
	 SCHnNJhe9TAnK/EJxoowvBgo75mrQUCjtkauBuovlTa4evksVk6U1uSfjWfUmWm1x/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Z8/KBpSi7R8tF/vvgKDP0KBAntn0EexVCKd9EhH2CNQ=;
	b=RGut9W1mhTSFhzuxtB3SbzIhFIfn5X4mzCqpq4NyK8Ig2Ifuin6jzzGuns6jl9Ml68qo
	 IzrEBdb2d7xVsVQJRBCBg+BYb8A5hTkcyizlo/mLJJs34SGeeawNPe/65nqB+EeR6YY0l
	 dD9QX1KYdCrzVwpLgYsGBkDXAwzgjypstd4VCTf08sU7qfYbiPNHuhmhnesp79iSXh7zm
	 0YC/RaGY10jZBo7R1oiuOnSg8dPPyRF+GpVk5AO/zntwaRQbXpjyQKQTnsRvXLE5dIsI1
	 VLWH7NvWKW1NK087DGPOlA2YneAoTz4/G2MeniDJL27MAKCiUf4Ls3b9Z1tJwe9vEyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCJHvdcQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4139606A33E;
	Sat,  7 Nov 2026 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCJHvdcQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35DB1F008A1;
	Sat,  7 Nov 2026 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062851;
	bh=Z8/KBpSi7R8tF/vvgKDP0KBAntn0EexVCKd9EhH2CNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCJHvdcQGNTgZz96IxNvbmqIeVJOHlP91Hja0dJIUaEdVe7Uc1mobRP4k+9ssOTOu
	 wK7hBHNyLpzNmVWy07fnrxX4DxvsIEa6aInjrJ0MU7FdnI81a3DUTAkg7/5aCbzFeE
	 aZ5G4Lc+TAaut+EggtuRZKQnHAgAmgzMFVB2IiTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/869] platform/x86: hp-bioscfg: fix slab-out-of-bounds write in hp_convert_hexstr_to_str()
Date: Sat,  7 Nov 2026 08:47:05 -0500
Message-ID: <20261107134857.233711593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 6a6f3051e705b5c8facb0bf5984d5b981509e0b7 ]

hp_convert_hexstr_to_str() decodes an ACPI string made up of
space-separated ASCII hex-byte tokens of the form "0xHH". For
example, the four-byte input "0x41" decodes to the single
character 'A', and the nine-byte input "0x09 0x41" decodes to
"\tA": each token is read in a five-byte step (four characters for
the token, one for the trailing delimiter), and produces one output
byte, or two if that byte is '\\', '\r', '\n', or '\t', which are
written back out as a backslash followed by the matching letter.

The output buffer is sized with kmalloc(input_len, GFP_KERNEL), the
raw encoded length of the input, not the decoded length. For
well-formed input this is generous, since five input bytes never
decode to more than two output bytes. But input_len comes directly
from the ACPI string length reported by firmware and isn't
guaranteed to respect the five-byte encoding, so a short input_len
can undersize the allocation. With input_len == 1, only one byte is
allocated, yet decoding still produces at least one output byte
plus the NUL terminator written unconditionally afterwards, so two
bytes are needed. That terminator write then lands one byte past
the end of the allocation.

KASAN caught exactly this during BIOS attribute enumeration on
boot, triggered by a one-byte encoded input value:

BUG: KASAN: slab-out-of-bounds in hp_convert_hexstr_to_str+0x6d8/0x710 [hp_bioscfg]
Write of size 1 at addr ffff8881032e5d81 by task (udev-worker)/520
The buggy address is located 0 bytes to the right of
allocated 1-byte region [ffff8881032e5d80, ffff8881032e5d81)

Size the allocation to the worst-case decoded length instead of the
raw input length: two output bytes for every five-byte input chunk
(DIV_ROUND_UP(input_len, 5)), plus one byte for the terminator.

Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260915174615.63924-1-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index 274bdecce6852..f665af1c11850 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -442,7 +442,7 @@ int hp_convert_hexstr_to_str(const char *input, u32 input_len, char **str, int *
 	*len = 0;
 	*str = NULL;
 
-	new_str = kmalloc(input_len, GFP_KERNEL);
+	new_str = kmalloc(2 * DIV_ROUND_UP(input_len, 5) + 1, GFP_KERNEL);
 	if (!new_str)
 		return -ENOMEM;
 
-- 
2.53.0




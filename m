Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064039;
	b=IJPHzEvq49pRlRs9/tOSkfs0fh4hXse0H+dBN45rXo5KYcDIJfHoCVOhe+cpaoeuPb/p
	 NIJV00EgxstmBF/tXU+FGq7IQVkTjAvZ69WqJiNN9E8Usca3TzBuBhXYrbcFXzftLpbQt
	 fsOrFceWrVVLqfshSNz3Twq6uST0BWECE/Pc1tiOZ9wseT58Ol7kSAMn8pudIMLmWclgj
	 rficQEfoJB/ryKu6Cq0UTxRzzqRanhzVHPTi3AWhHbTFgfH64CPnf6m3Q86hfgk7pjCRP
	 /YMoM0rPo08NE3TqCCiyk0BHYk1Uq8UtFPl0XQ+rb1gPQbWGhBRVD8P4uJnMs0TOSEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4fb3jaVYNZ1Frrc3fLjODjQBl4pKMh2uSRsVEkGFj1w=;
	b=lRCYphVsDTt8nbI6Ye+2mSx5ivxRGUpbKsZ66r9D+8cPDANpPaMgNN3+tyiClcnq7NDu
	 6heErN9DReC28cBMfHXpSQGJ2o9gkRy7V9YuEpIvEs44MOi2kjjTZakaFJcAYkPjM65Yk
	 iZH7NkpS6abZS6BIGa0PVwihjWXcO0qOzdLM7cIj47ctzJqU0pvuE25408NQ+uHItYUwO
	 IOVPGMl09kWE8VOO8/z70Z79q3a82CLopCifbEvw8bUHc1ABV/dQiBlvPhOeX0ZtBmv6I
	 0N5HjGgm62iwpMwe3HFX0rRutjL8OY2Fhf6GBuaLFF9O+Nh1+rq1w5zrvvGqx7tA2ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GnpTQUmD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D45606A9CB;
	Sat,  7 Nov 2026 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GnpTQUmD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048F21F0089F;
	Sat,  7 Nov 2026 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064039;
	bh=4fb3jaVYNZ1Frrc3fLjODjQBl4pKMh2uSRsVEkGFj1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnpTQUmDom6l9dEbufoOVeIOB9q8zJbRRicimfDgNLHozdsDgfixRfoQQqrGbqgKc
	 qLXi7grqEKRN24pYLZQQT/SU+prC4XkkLNybFfwzY2Vq38L7+EfMtA3Z/tey9YuGJq
	 EbSvyDWHskmc6RgQAOa9aCiBJsIwI+GN3/tZpLxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0175/1257] platform/x86: hp-bioscfg: fix slab-out-of-bounds write in hp_convert_hexstr_to_str()
Date: Sat,  7 Nov 2026 08:41:11 -0500
Message-ID: <20261107134944.299942974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 309634c1cc20e..ff28db7ced008 100644
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064569;
	b=mIvUfZ5DYZwD2KfxzL8lP/vcfYQC2QtIYrZgDjehXVaJYbsCGHcr9OgoX9saZsLTUghQ
	 VPRZLCAmDvTiStVmfukmoYWyqB5NTtAptufmIMF/XOYU2QhwgU/rucCAAM/oi1+yHLMj/
	 LzBH1lNUex1ijx1Yb8bQz4gpJ2vnZszr/9WJfB95Miqs+aS3l1epflR0EAPir4erCtHW4
	 IfkhhT+CdA1NUXMssMj5D5c7UgvTFLc4ewfpBgCDOTz549SSNt2sz17EC+OaXyQtCFQtw
	 bd62+/wc6fneB9uTk6/GbZ8NAXAisD6ZjSvwjEmI+biLG6boQIt0yTk1+387yH/cvzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HiYsFMNfdebwgkvgwgicDhMIDxu3+9J8PiU7P3waDTg=;
	b=AA9671axbf7Y+fm91QzBGhkoljVhW6f536WAnjqILipoDKlqBr/h18YSmUXhMpB/Jyuc
	 4TMrAYGeJfUYzlnbJgv4An1r8COlJM4g+H8HHX3ctrbwu8iVJBWNcKbkAKJRBm1dt/whq
	 p8Yd+c1LZ21HILmjuxOM5lZjsZ5P+CAKX/om0TViMu3oSybDoH4lJBABARpEcP8/Y3xo3
	 cYQyRMeVJ708LRsuI0590OJ7s0gyffm2UjIUE3S5ejTJsKn32DIcDp3vljT+tVGponbs9
	 3xqV0niisoBhl/t+4B2lG1V5A5ljoBaQKu8iYlqwCW5as24gH9EeIFH47Wg/YsCgG4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iy+c0no;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACF7606D809;
	Sat,  7 Nov 2026 15:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iy+c0no
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930C61F0089F;
	Sat,  7 Nov 2026 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064568;
	bh=HiYsFMNfdebwgkvgwgicDhMIDxu3+9J8PiU7P3waDTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iy+c0noU1f59331ffca0UOMPDVwzHXjLGiPSlqngK3+opU+S2b6j3Ak/wfIK65EY
	 bLWqYCNDE68apCJdYAS1gQT9m/fTmzd7ATHREKY2QSl8maqPzW/BLpMR7efHoHamxS
	 RJR7xURYY9AKd4YlUs9cT2dLv3eqKYZFgJXfuvMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0551/1257] PCI/sysfs: Pass the device name length in UTF-16 code units
Date: Sat,  7 Nov 2026 08:47:27 -0500
Message-ID: <20261107134954.608819464@linuxfoundation.org>
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

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit af5ca2d75147bf283239e8ef0fbf6e5e0488ca91 ]

Currently, dsm_label_utf16s_to_utf8s() passes the ACPI buffer length to
utf16s_to_utf8s() unchanged.  The Device Name _DSM may return the device
name as a buffer holding a UTF-16 string, and the ACPI length counts bytes
while the converter counts wchar_t elements.  The converter therefore
receives a count twice the number of code units the buffer holds, and that
count is its only bound on the input.

A NUL code unit ends the conversion early, so a name that carries one is
converted correctly and the error stays hidden.  ACPICA zeroes the entire
result allocation, and the padding placed after the buffer supplies that
NUL for most lengths.  Lengths that leave no padding, or a single byte of
it, do not, and the conversion then runs up to its own length in bytes past
the end of the allocation.  The bytes beyond the allocation are decoded
into the "label" attribute, which is world readable.

Divide the buffer length by the size of wchar_t so that the converter
receives a count of code units.  The division truncates, so the converter
is never told to read more bytes than the buffer holds, including for an
odd length.

Reaching the out of bounds read needs firmware that returns the name as a
buffer and omits the terminator.

Fixes: 6058989bad05 ("PCI: Export ACPI _DSM provided firmware instance number and string name to sysfs")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260814070522.2327975-5-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index 0c64465196404..c224619b9a266 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -144,7 +144,7 @@ static int dsm_label_utf16s_to_utf8s(union acpi_object *obj, char *buf)
 	int len;
 
 	len = utf16s_to_utf8s((const wchar_t *)obj->buffer.pointer,
-			      obj->buffer.length,
+			      obj->buffer.length / sizeof(wchar_t),
 			      UTF16_LITTLE_ENDIAN,
 			      buf, PAGE_SIZE - 1);
 	buf[len++] = '\n';
-- 
2.53.0




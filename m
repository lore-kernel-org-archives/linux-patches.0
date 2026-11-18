Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036372;
	b=fkm55FDjRyLfI+qKYtPrfFgzWNc8ZHiLPK6UcyvI+hHmTxib+n8ZAzEsKSLc6KyUR35V
	 zIAg1TqcWiJTS4J3lJ71XJjJdZi5SHEDu9EsklRy8HEBr0g5eKcKxhOah+VmdMc8S0dlR
	 BNGaea5SZlKTSzY8LlUbveC9rESwGWREG4TuchqE0gDOX144Macn0hpr+Jyn/zRQ6Hce7
	 fEuqsyO9qfAGf88i5nv+JEvbCZxhCRPQ3GkqaP8yUb3+m5jmYObI92gupZPJdevPCkPyn
	 9SPCsGkD0dTKwojzEZs4PvUxS+JPB3n8vKB3P/rLW3ndVCF9Pd7Ua4ZF3/Lxymnu6qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kOE3RjTqgHWKO5Yq91oCRl8iUZXj3IBWltsB5mFhytw=;
	b=FxdVdXTUnhJcPYaYFox99ixqyt6r4/kw22uJUNuuShgPMBU6qOrO/Yb0mzZSltlYCvlC
	 17Laj4WejrY0+T4Iy5mEVOXGUjBXGL/JpR0Il0YgLhKOulwqjfG6dqCi8hDObiyaeNtc4
	 G1Y5NW3AtXkRGBsiT+UiZB4avWaW/fEaQxDR/NQkVkGGzluO8M7dxn0klJtr0Ae1+Ns0w
	 FfyalUJn4BN0w4fdvkvQDD+/rM8Paot5N3IpIctZzBoyx4iLI6l0ILv8VMSpuxcy44kE/
	 f6+4SFjnYSVBYnaUVEHQK/wOzSeeqqNhA4TIlXq6q9nsuD9Hty9yjxR5vRMiceO6Jfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SnNiDS+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F56606A320;
	Wed, 18 Nov 2026 21:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SnNiDS+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2456E1F000C9;
	Wed, 18 Nov 2026 21:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036372;
	bh=kOE3RjTqgHWKO5Yq91oCRl8iUZXj3IBWltsB5mFhytw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnNiDS+5XzoSyjCr5QieU0Btfbky4LRrHzIsOIfsnnAW6Xj+tRbcHynYzO4utLW72
	 q6QPL+/OwbnRNj2nM6YI94DGSeOehIWo1sp6tJzzJrCheUvsuE2p+SRka8L3++qTpR
	 5NUaKIJQ6g3KnokB3VAtZHuxKPlnJHYZcwJo5JxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1036/3318] PCI/sysfs: Pass the device name length in UTF-16 code units
Date: Wed, 18 Nov 2026 15:27:38 +0100
Message-ID: <20261118150350.982072247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




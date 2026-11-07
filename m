Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062240;
	b=Hnwi2CqL3TT1Dc9CaGGDgignKmuRo8YLuQhZRf5LYhji+PpDPm0CPcUuWU1AMm20QH6o
	 ppaB5Ox5SZ0RLkZStEZ7r3RnF3OutPMjcTT8e27G37xN5vJ4ggZvG5lM4uWrE3SPRe9IW
	 Eb8tFgjI5Xy+CmUbI3s1RzXqCVw5kBBJ+J1C6FSG0n9OILTv5Ij79yaosy/6Ts6vwW9rZ
	 OybbEyf33XZJOQRF/h0Ihx0Nv4HoTlUzhJMBEU8yECmFx6I5RS5IqOqIyHZxrbuNze8wB
	 RI2wRdXm6bHKNZrjuLGSSrQQBw9TqpVulFBGi+OYUs5hXoI0PUqqh2kKBia7s+uQ2gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CWbGPmn/QHIfqdEylzWi8NNL7XtfQXIKXkB1hZm3Lf4=;
	b=Ty2DG0TkOASXX1GCZ1aiJbUmMcH46Tkt7YOW21NDbpPC1CwGYaiWurIvcpG0i57cbnCT
	 w5Zm+Y8CEiwdQh7gcOGi/F/75WVKE3va2zeWOLZxKuamaHsrxTBVoRhExGnLfrzP1VjXB
	 YmMpj0ArA1GS8WDEhomZkXZHb0neDWF/+T2rxmoDedR/eKP27Coy171yJLIZXvEEtu6hE
	 VSnDyg5eyUWj+ImNoPR9nNl8gOS3M3W9UMbkrRg9OBibZ0z+aSmAHnLSgPxNvqVQ9kw8k
	 gQ99+4HkUgjB+kML0y2OtrzE0huMvxxz3k7bKQk1HVhASei2lupyNki4unu91Wegm9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMqJNv0p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD79606D827;
	Sat,  7 Nov 2026 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMqJNv0p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFB21F0089F;
	Sat,  7 Nov 2026 14:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062239;
	bh=CWbGPmn/QHIfqdEylzWi8NNL7XtfQXIKXkB1hZm3Lf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMqJNv0piJfaJ/gKrKSNUv2e6pR1q1ZX5WNNu5Uc6sNZQpHyTgvXCJVKsu15zZl60
	 Oo+6YE9YtJym/DI7Ng4aENKG365Hs5RMzULEJT/0HOBsLHM2oOlJjtyjPKm3UghuIO
	 MptsLxM+dCGci8xOem8eYijFK8nUP/LqXz/3wSLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1188/1536] PCI/sysfs: Pass the device name length in UTF-16 code units
Date: Sat,  7 Nov 2026 08:53:24 -0500
Message-ID: <20261107135031.112173929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




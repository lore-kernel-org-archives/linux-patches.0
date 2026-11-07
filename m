Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063195;
	b=r2wG2FdCpFjpxUJeBSuLGVbaEAmeDorjlz32iDGz6MsO/o4guOTw70KvipJUfGANtWk5
	 f27GfAuZlrzSbcc0rWC4vsF0JqUpum4OzcF9JuT0QIwGhkA6uy+4qEziUXXaBHVJrU1wF
	 jWoTtspjr5M5vQ0ZE0DWFWSrt/DKWhik2P4j1v+cc1a9zbxAgR6pFlVj8TGSVnchLx2JP
	 h+tMpirj5fZy4M/TXSKq4umZGCJk5D1tqGR2Wj+WtBmMD6guoReJuEhrkzj5VORdAJgeB
	 2MqJU+Ol7AjqW9sCrcLERPwKeEGxyf5VEAQVKAi20q4BchPb7XN3+/hg+1+vaHhmndw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JjVMusyI1bTLXf5L4Hj5aQrxt14bxsGH97pQ6vs5V0c=;
	b=Q4/JPaLiachVRxEHed/YOrpWpg+vmwK/KI4R5EX9IUvvuwHJWJcx/Dp5YS2/LfYOS0Xv
	 JI0T+NK0+I2JMqyoRIzqnTo94547bikOrrjgK8ZzUp+AnYdLEks/srcOwFjp+qWLEOPUN
	 YdC8NhiX6I/eATrDozN6IYxAE7LTvIk+pIkV2ASN+Z1PMMwuD27XgXhKDGNcKp7wxnTXt
	 r+SP57qbSont3FDLVjl+hjo/vmYE++QT+b9LrfPEraNvvBRGXnhYlk0cg0fegL3ywzhNw
	 XxLbJ7568bvffUOv6bRIpE+BYgXx7qnqBm2vHQZtZYhTc+frKzwFCt+Sip/8mg6EbIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOl2DIBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADD5606D83F;
	Sat,  7 Nov 2026 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOl2DIBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C271F0089F;
	Sat,  7 Nov 2026 14:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063194;
	bh=JjVMusyI1bTLXf5L4Hj5aQrxt14bxsGH97pQ6vs5V0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOl2DIBp/vTIwEwkgYsVwUIFN7YABE1B93YEa4JCmJi6Kr8JdXkZc/Pf7JyhNAdL6
	 iDjXUmCH367LMuu9a5f9+cg1KX1QHr0kjIsSTQ04/xJ4ovMCxAMyh+h7wbc82xp87P
	 sMqYZcHVkmJQIbK61gpruOB0FXkrmoOMPDw0Dno8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 410/869] PCI/sysfs: Pass the device name length in UTF-16 code units
Date: Sat,  7 Nov 2026 08:51:32 -0500
Message-ID: <20261107134907.245605493@linuxfoundation.org>
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591443;
	b=QaEXHRlhhpv2weWZaOPXJm+Cre5vAn3TLVTlwJLvy4/kNIV/sjoSXjpLHHzLV6AcT7XZ
	 yt9D63e0DWWwNbaKwGyAW0qHwbbvJ+eq/xKuu46OERpiaU0O080mBisfyEKFbw5HFnFrU
	 6wQY1+O5UHfnxULsfVy9VYxLBXYITKyAm8UIhU9rzEX9a1u6xcfscWYGk5qzx3wdh1omE
	 AJQjmV9pZAlczeQ7c77LxapoPfjb4XanFwWa+dXN9DxX1xABjA695h/dkl2arqzVTM5CB
	 7+93EX+7n4rDe1CLFlDZM3ze7qw2ffH0Bc0Gx45YHIeIjihXgzrpmiTtyOeUu9Yj/jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hnq1+MQGG77KdN54FzAPWkS2EtSqRC6PvG1/jl015gA=;
	b=cjYOcsRdnZOTTLStlIfVYXx4FsbMyaOLYnEAzfVHblItc5WHUBOsNc0StTY8oc223rBZ
	 1IPvuxyw85BbxoI39/K466T0Z+J1SLdb+hnRvPkO/1rc/IFSC/YMx2uuMDjUJOnfYml4J
	 gWlzh/tqx4/pad7nIW8BP/2u4kvo0KNcMSn+2uOrOnvEhiD4O0FDXYmbpFF/tG7HIb9ku
	 9qVJTaCLD0P+e0MuS4wLFHRF+5tLZWV/sxjGCjSuckxbOZ8J2R2+Hj9qfyNEF+p/ql6Pm
	 gGIIUOqUE2myNv7AJBhDci/TkmhRHKGKy0Sm4B34DFnl2GV11TXlKqE1UslEgnr4UdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PgyT2n5S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B5B607C34C;
	Fri, 13 Nov 2026 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PgyT2n5S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCC91F000C4;
	Fri, 13 Nov 2026 17:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591443;
	bh=hnq1+MQGG77KdN54FzAPWkS2EtSqRC6PvG1/jl015gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgyT2n5SutDTSW/j7Bl8Vr8EwjWyhN/OPzLVJR7KETgZKPmTRxdYtNg+4ar+agSya
	 GbhK9djkrrTuanTARUc9j2DdDUz0LIfkIRGOozeghAgCmkU4HNUoK4A/fPfTe/9utq
	 fuUHUxkHgGA2MkxSBxatgOJBqo1EoblED0I77u4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	patches@opensource.cirrus.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 534/670] ALSA: hda: cs35l41: Use auto-cleanup for put_device()
Date: Fri, 13 Nov 2026 10:51:38 -0500
Message-ID: <20261113153830.005492794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c437a83cc69645edab8e0bfc450a3b706abe759e ]

A temporary refcount management of a struct device can be done
gracefully with __clean(put_device) for avoiding potential leaks.

No functional change but just a code cleanup.

Cc: patches@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260803140100.919071-3-tiwai@suse.de
Stable-dep-of: 8d70e364e866 ("ALSA: hda: cs35l41: Fix ACPI device reference leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index 031978a62cb99..d01691c13bf33 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1895,7 +1895,6 @@ int cs35l41_hda_parse_acpi(struct cs35l41_hda *cs35l41, struct device *physdev,
 static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, int id)
 {
 	struct acpi_device *adev;
-	struct device *physdev;
 	struct spi_device *spi;
 	const char *sub;
 	int ret;
@@ -1907,7 +1906,8 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 	}
 
 	cs35l41->dacpi = adev;
-	physdev = get_device(acpi_get_first_physical_node(adev));
+	struct device *physdev __free(put_device) =
+		get_device(acpi_get_first_physical_node(adev));
 	if (!physdev) {
 		acpi_dev_put(adev);
 		return -ENODEV;
@@ -1925,13 +1925,9 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 	}
 
 	ret = cs35l41_hda_parse_acpi(cs35l41, physdev, id);
-	if (ret) {
-		put_device(physdev);
+	if (ret)
 		return ret;
-	}
 out:
-	put_device(physdev);
-
 	cs35l41->bypass_fw = false;
 	if (cs35l41->control_bus == SPI) {
 		spi = to_spi_device(cs35l41->dev);
-- 
2.53.0




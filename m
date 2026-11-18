Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019686;
	b=lWwroxI7AtNIbuR2ffm7GqvuVGoummiBuOH2DmxTIVNd8KexUzYilc9i6JXxDv2HiK0p
	 epCNRjD96POJ6INv3BAf97cfmu1gy4WRgM58m11C1rtKR+2oZYhlTGG8+/Rd5PteuP8FB
	 axFodfoaOMm/3DUa8BtVaVc7JFvVxzex/pvxu6aVwNyvUpsjl+oNfWkSNtGtYBUMUHGP2
	 p2kqAdQL/MxBJYC4r23egdh+MKmVK34l/x6WRBh9X2ANQZ8OMlsVZM1BXwEexiXDUJQvm
	 +uuChKoYHpDMydX6TEWdftxdPgW7rEy92CFXtQiFGdxXSSxJbeymb5pARPDGvtahi8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hkh7PsX4fsRQKv1La0jRIgx4fyLKhUgfAoASUlhH/Zw=;
	b=4bTUguXyFF3hUhhCqWf2aNI2xDtTmtNJidMkrgnhfuey0Swsfk7j6L4ysZaTmUAZcCJ5
	 BnUK2sqc7QL17WqAP7Pln4LtrgKI3VO62pc7expf2BrcBD/2+ST0+zk3rV62i3iwyWs8A
	 eOlJLUjXSqOywatt3OT3OFA+c+3uc2+ucZDRJn540N++FgpRYmA/2U8mtwA+g4GHoCMxU
	 KbIHplLyUSYzPC8iWlb9TIXohreQPE8hQ9/KY2dZyzvQAwyUvwVZSYL59E4femGoLL71R
	 PINtjCpkF20vsH9IU1IfaK7NLCd1zlels7lZW5Ri5+h3hmrXapPZaxKy8dVaME1GyZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AbBCy6WB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18539606A32C;
	Wed, 18 Nov 2026 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AbBCy6WB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9F31F000C4;
	Wed, 18 Nov 2026 16:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019685;
	bh=hkh7PsX4fsRQKv1La0jRIgx4fyLKhUgfAoASUlhH/Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AbBCy6WBb5R3uKoecq5YD2mt8bXlaJIXR/Oq+o4zoL/UH3fdpTAx6gue4J+zc7Tir
	 ww4r8WEa7ltDleXF4zdDROOFpscANP0STTt6H3JgAg4pNbr7Rbb25wRRwEsFivY36F
	 uIV6ERCHJ7cOQb9QK+X4x1aglB54SONvce1azy0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1684/2651] platform/x86/amd/pmf: fix compat ioctl handling
Date: Wed, 18 Nov 2026 15:48:44 +0100
Message-ID: <20261118150348.305088621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 655d731c391ec3912503b91ecf6269883b13e0c2 ]

Build testing with -Wpadded shows a structure that is incompatible
between 32-bit and 64-bit x86 userspace:

./usr/include/linux/amd-pmf.h:202:1: error: padding struct size to alignment boundary with 4 bytes [-Werror=padded]

Use the 64-bit padded on all architectures here to avoid both
the warning and allow compat ioctl handling.

Fixes: 98432eec3180 ("platform/x86/amd/pmf: Add util layer and userspace character device interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260915202535.3689880-1-arnd@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/util.c | 1 +
 include/uapi/linux/amd-pmf.h        | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/platform/x86/amd/pmf/util.c b/drivers/platform/x86/amd/pmf/util.c
index 4d1a61e4f1b90..2befc1b14842f 100644
--- a/drivers/platform/x86/amd/pmf/util.c
+++ b/drivers/platform/x86/amd/pmf/util.c
@@ -123,6 +123,7 @@ static const struct file_operations pmf_if_ops = {
 	.owner          = THIS_MODULE,
 	.open           = amd_pmf_open,
 	.unlocked_ioctl = amd_pmf_set_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 static struct miscdevice amd_pmf_util_if = {
diff --git a/include/uapi/linux/amd-pmf.h b/include/uapi/linux/amd-pmf.h
index 24cf9926dc590..151f264cd7d6c 100644
--- a/include/uapi/linux/amd-pmf.h
+++ b/include/uapi/linux/amd-pmf.h
@@ -199,6 +199,9 @@ struct amd_pmf_info {
 	/* BIOS parameters */
 	__u32 bios_input[AMD_PMF_BIOS_PARAMS_MAX];
 	__u32 bios_output[AMD_PMF_BIOS_PARAMS_MAX];
+
+	/* align to 64 bit boundary */
+	__u32 __pad;
 };
 
 #endif /* _UAPI_LINUX_AMD_PMF_H */
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033780;
	b=TcGh5f0B09JWkvWkDhRGhHXLa131CCdJ/A9Mb5CjcgPCDniO5M9dBVh7uKnIJ8130mqZ
	 MowUfcqz+zFcToPA9+apyW8h7vJHP3iX0VkXR4vmhkXe6+K3fdmwhZ3Vmv4mbc2awJCXM
	 lkrLBXjxEGRsTQkwkjUA5Lnfi+nnIdHMhoo3b4F36hHBe0zFUl3oHC+J9XFlTOtlfS745
	 +FzRh2MvU5DWC+2BvfgdQ6XT5t1xZkOp1Y3b+3vns9rUWl491mhPVNAT6k+bP+SLzCJZn
	 q/Jcu0Djo8AiwuVM3qVGdIYCO8H5OgAmMUBHdND4q5wF2Abkyr5LtqvaozbyZlyqG0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t3DO8TJ2cdL9tvBeDedss+L1vF09ubEpOKEm2GNM+K8=;
	b=HaKEfxw2S3BTbuTg/Yx6UZ7dCp1f8rRogVe9cq8NyLjl8DDqFjdciKeD42+27UVS+JWH
	 gElMb79e3Tkc53ihiOtVp5ndGGthUC+YgI9n2QI+nveIjeXRDigm92ibaXPKQ265gpr+G
	 HB5cDo3Yoioin3BvTZ9UCVIo7DuY/X4cpjzU08YvgFyS1zwbjcO+QxaXjaAr7IPI3nKhN
	 IRHpOvo44SH+2Bpp8g76xbdIqbmbR8Y+IJQ2HRoBQKIldctE3G8vbfLXwSj2Smuyfsudf
	 xcX/N9fmLeahQHXuZ4e1zBl1m5G4JRDjwTtMCStvsrofyI4YMqNffv1QhwKSfPa3WBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VRr/e+Bv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A0B606A31C;
	Wed, 18 Nov 2026 20:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRr/e+Bv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA561F000C4;
	Wed, 18 Nov 2026 20:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033780;
	bh=t3DO8TJ2cdL9tvBeDedss+L1vF09ubEpOKEm2GNM+K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRr/e+BvBzKryNXR2uG4CR0JYwed8aKMJHmAgJa9tmhceFaaMUbGgvIUyzTgyFzKv
	 FrtOYfNBEY2N76jd+t+aO5XIBmivf/+O+QcB3yWna3y6JXlij9oZZl4IXZ8P/vJrqF
	 aDrYLxVgz3U2dqNdBh2RuZ08PBQ+O2WVh0y0yHQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0136/3318] greybus: manifest: validate string descriptor header
Date: Wed, 18 Nov 2026 15:12:38 +0100
Message-ID: <20261118150318.507438152@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 18b6510f642dbcb856c3af8be974d1600f3ba2d3 ]

identify_descriptor() computes a string descriptor size from
desc->string.length.

Require the descriptor to contain the fixed string descriptor header
before reading the variable string length. The existing descriptor-size
check then reports the short descriptor.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706091935.78020-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/manifest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/greybus/manifest.c b/drivers/greybus/manifest.c
index dd7040697bde9..469da3f39afb4 100644
--- a/drivers/greybus/manifest.c
+++ b/drivers/greybus/manifest.c
@@ -122,6 +122,8 @@ static int identify_descriptor(struct gb_interface *intf,
 	switch (desc_header->type) {
 	case GREYBUS_TYPE_STRING:
 		expected_size += sizeof(struct greybus_descriptor_string);
+		if (desc_size < expected_size)
+			break;
 		expected_size += desc->string.length;
 
 		/* String descriptors are padded to 4 byte boundaries */
-- 
2.53.0




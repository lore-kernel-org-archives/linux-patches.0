Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466BF443E22;
	Mon, 17 Aug 2026 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976018; cv=none; b=kGyEl3BxkYEXKG4cSvGo+XCCdT+kPvpBVH1AGxHYTrYuTbVnPGv8pYViDvRkDPAwxYD89rLi2+Dy8gPXTtoKPkpuPUplPNQ8G31k7JketRHHCV9dMYizGGAflDxKsEwzK4KEMhQsX2vJ8o5f/G8pvIJvD2Y94joVvLoRTjnIX90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976018; c=relaxed/simple;
	bh=a+qoAq4Xw/9SWAXFwUj2OGs+F3Uu7ps5sNjoNRrJrSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq11DHLotx7V46KAyDghG6BcS33AjSQdUCBluGnvZkUfK+iB83VKmPdglBdpM4rykROTCmKm2GQV3N9qS4P4wORnbgfXisMB3YzZKPbHxwtcjiK5GrGkj2f4DCxBz2OGc6uiQvhHr+QFoUc/pBPkV8pwUb+iBQA84GeIzWHuyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ad3M1yiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ad3M1yiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953CC1F000E9;
	Mon, 17 Aug 2026 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976017;
	bh=H2QN6hDC57JEzjXj2HLAaDZAh5s2Exi4B3mtgdNKQDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ad3M1yiR2bbAbyVC37D51CE4mhjAz8qAtb7jb35XojMP3Uw67+ANxFN4R2SEhb+8p
	 VFp7/DzkWy6xN++2LFSiIoD4Eh6/rxDJ8I3evRYsEO5ia6aTzgdajc+nl4g/is1d9w
	 w+jozimE5IcJ6YbIBJC1B1nJt3+G3I6sfsUAouSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/389] powerpc/boot: Fix treeboot-akebono CPU node lookup check
Date: Mon, 17 Aug 2026 15:31:06 +0200
Message-ID: <20260817132548.079634148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit b24fc8278b70a9d27ec801a427ab4de9b769d69a ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: 2a2c74b2efcb ("IBM Akebono: Add the Akebono platform")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-6-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/treeboot-akebono.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/treeboot-akebono.c b/arch/powerpc/boot/treeboot-akebono.c
index e3cc2599869cc..1b529037480fb 100644
--- a/arch/powerpc/boot/treeboot-akebono.c
+++ b/arch/powerpc/boot/treeboot-akebono.c
@@ -146,7 +146,7 @@ void platform_init(char *userdata)
 
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 					     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0




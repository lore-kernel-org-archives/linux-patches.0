Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306D3314A73;
	Fri,  7 Aug 2026 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114938; cv=none; b=VtoKNGCV+LpshIcwL3oFoFiLMA9Mb5n9xhuBRlgOVJCKn11gxfUi1s7I9LLsDKs3q0oc13Yiz1vspeL21FWG3oJesRhuFOdGfHg3R6wksyymexe9vPbH7aB9tQLEoqkqigSv049g0+49195R2Sxv5urtFSrUxC1mz5IJ9Lc1+LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114938; c=relaxed/simple;
	bh=AYkhBSfDQqsZZ1wsQ/dp95BLg/vhx/8Jw+A7UgAkd3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWOwn5GeCJNwK1O++e/68Vw4vRVphIo1W6Fmz2wbB+bSZk0TVTPgjS2aUUCDj0m+nWZAeyQ3de1JJX7yj23QTyd1/hTth58ZPoXTZAHkYHaouMDRmE7UqtCT+FilKEPmKh1X8C+grS9Ye1JNROGJwQv8iKyWuml/Hi21sf6ZiD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkXEMkiz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkXEMkiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0081F000E9;
	Fri,  7 Aug 2026 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114937;
	bh=a/kfONYSg7Waq4nFabrpUCEOBp6QWZpx1qRZ3FxpQik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkXEMkizxzvNBxzvUgRysM6LvY9fY1zPtotnEsydwsSJ5mjyNUJXhqZmmVfJqvVyQ
	 //TTwkfrGStzdTb6oj6Xssod3lkn9sFAptbZOJVxKvscBrSEFfY8ZgaQBp/Z+dup2p
	 PAdZFjnaCecsS6zN6QFSJtHnr4hE5GHXTq+B7xGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/396] powerpc/boot: Fix simpleboot CPU node lookup check
Date: Fri,  7 Aug 2026 16:34:13 +0200
Message-ID: <20260807143426.287078554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c824ab65685bb119c6c6a3a200b3428c72862d5a ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: d2477b5cc8ca ("[POWERPC] bootwrapper: Add a firmware-independent simpleboot target.")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-4-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simpleboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/simpleboot.c b/arch/powerpc/boot/simpleboot.c
index c80691d83880b..27591df41e9e8 100644
--- a/arch/powerpc/boot/simpleboot.c
+++ b/arch/powerpc/boot/simpleboot.c
@@ -68,7 +68,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	/* finally, setup the timebase */
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 					     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0




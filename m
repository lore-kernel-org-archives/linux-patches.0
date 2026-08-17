Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7DA43BDB8;
	Mon, 17 Aug 2026 14:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977288; cv=none; b=VvTMjGiWDvlznA5x6Gh6dlpwlGuow5GPnjtCDmZTHbNoejePaeeh0XfFWU1FbDp7AT4FiLw9b8nPLcgyiVytBuXck/URQnmvEHdEmU5Ehq082uyqN5SmiDefmlv/2HH4alKZpnARONH6lmU4StWzj3MCHOmUKkADjpWVfWa0/8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977288; c=relaxed/simple;
	bh=NOcUCNlFH0TvdR08Bc4qbbZEczpAbIlRaWsTZlSHouw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJaGA9S4RkirIfwSheBlAKtmEMaZPpDGgzEYkMyJnA1SzeGsxyXQO5mkFQepWFYEh4cR90z1cjyFQS8bsMWkHCjyrzO+dqETOnj0rQMSEzwN0Ibyke8XGXxaLIf8VDD29v6io9gmkUltFw7frYRyuwBJohpyDERiQwjTOXtv2kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIoc/bx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIoc/bx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7691D1F00A3A;
	Mon, 17 Aug 2026 14:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977287;
	bh=rDnw4KBO9HFta2b2grEbJgreSO2DAaCXjdfMhAvXudM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIoc/bx2pNmZghg2//D3Y3XrVPy2A9pCP0Z+hww0d5jOAO8RbEW3yC6aOOqzs6u0P
	 s4skioiizDtiuut3Wxdq4i6nD4SjCIitndcl4dlYqYyzkBX08gpKIwwRaHjE3XcrZQ
	 EIV/zuv+4A50goqjg57zoxG8p9lIwh7BjSafFNNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/456] powerpc/boot: Fix treeboot-akebono CPU node lookup check
Date: Mon, 17 Aug 2026 15:31:08 +0200
Message-ID: <20260817132550.828709932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




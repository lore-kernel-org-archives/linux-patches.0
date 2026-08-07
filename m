Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84359432E85;
	Fri,  7 Aug 2026 15:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116858; cv=none; b=TwUHeUJp9aAWHdz6QV/6ivoY43PlWZ5Hkq1+8r0XjkigQaLU5MYHxg0PRNTJvwZVutCRDtzvN4uwDzkSjtIsOvFgh97D7lLX73N1/kK1LmsLnEUo33M/9Sg7AdiEyL0LUQGWs8ejc1ATHH7BfFwsTfvQnArqGyOx5EoLtGBRO0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116858; c=relaxed/simple;
	bh=XFpBbM7dKf6vueF5qonzaePZm8FfI6ihpnTx6A1HJxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgnmLgk0fUgYObRNYnOrlOscCTqbA0Um2ajVXuRSCTAp9YjeXIZWZdRaTgLeAxIFB6+0WVKfoaHjAXIw6yMV93kvVdxujn8yGJNZDlazCDE2jAE29uofzaszG6tKDDIl7RMysI0gSdbnKhadIX1OmeY42Jns+niSZchY5CQO1p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2wkRMIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2wkRMIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF2A1F00A3A;
	Fri,  7 Aug 2026 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116857;
	bh=SALSkfKvgEkOECsttcK6xHg/I1xU7wLKXgmSQq1Po34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2wkRMIKuD+UcdvG2HL/brQOqazDI1EERxu9nPwd0xitRFRtl5uN3lEJ/8dit3mRL
	 35y5MrAeSAooYzSnPNVFknPxiIvt5pPyryeDeP37G7Ek/wPl0c560V2J+Qtu1SHUxK
	 3b9OzNN1wFZjDLVlkj1SoIXp+Qd6mzp6iM9Eqtuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 113/438] powerpc/boot: Fix treeboot-currituck CPU node lookup check
Date: Fri,  7 Aug 2026 16:35:09 +0200
Message-ID: <20260807143430.404124468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 43863f6575d2211e8c5157fefb83ad0ad046aab4 ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: 228d55053397 ("powerpc/47x: Add support for the new IBM currituck platform")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-5-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/treeboot-currituck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/treeboot-currituck.c b/arch/powerpc/boot/treeboot-currituck.c
index d53e8a592f816..5b5363b74f9f3 100644
--- a/arch/powerpc/boot/treeboot-currituck.c
+++ b/arch/powerpc/boot/treeboot-currituck.c
@@ -102,7 +102,7 @@ void platform_init(void)
 
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 	                                     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0




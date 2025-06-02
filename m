Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575C222A7E3;
	Mon,  2 Jun 2025 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875508; cv=none; b=PlKDcNKbQnduh3eFf4LLTQvQna16TygNo1FwYLnKmXbZuEpfzqCikA5K57LOm2tXoK+KVLs5aHfWsy5Hwh8cU9Pz285LdgHTtU5naTBFu0ZckLSs6cvGQmj2WchkRtBcXjFAKf4M/BYiGw9JkEVaOWzNxjadwCoR7FhAGZMGYEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875508; c=relaxed/simple;
	bh=RxXHtSKbTZrj7SONCPB5stwR/ezJMP/NcQyulypr4G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxYi3bwETlEhJP300SBRgJVfWdk40KUzc6bieCJZQKEyk4vSMjCl27qvj88tcCefbRhaHiRSV/IGygoXJpp4xDzUeS2KkPhB38CiVoHbJOdSdCY1Ps/Wby5gneodKa4+q68Jrx3zvKFk7rnxqU4v4edBqMwzAyMOg0ZlG0Za8GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVdX9Axv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVdX9Axv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B235CC4CEEB;
	Mon,  2 Jun 2025 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875508;
	bh=RxXHtSKbTZrj7SONCPB5stwR/ezJMP/NcQyulypr4G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVdX9AxvLYmrW6ISreWGkrimsd5yWFN691243mzY/LMhOHGQjSp5tDlYe1ZIExN3U
	 h0PV/noDSRwLmjna5rV+YA6Xy28scUaoQ+P0SemiaAdOHwgvgY6kFOGR2cj4hstmu/
	 Y9uWwuuFvvM6i12omD/ZamUUoZb4I+OWOrqXRGRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/270] powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7
Date: Mon,  2 Jun 2025 15:47:20 +0200
Message-ID: <20250602134313.553765270@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andreas Schwab <schwab@linux-m68k.org>

[ Upstream commit 7e67ef889c9ab7246547db73d524459f47403a77 ]

Similar to the PowerMac3,1, the PowerBook6,7 is missing the #size-cells
property on the i2s node.

Depends-on: commit 045b14ca5c36 ("of: WARN on deprecated #address-cells/#size-cells handling")
Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
[maddy: added "commit" work in depends-on to avoid checkpatch error]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/875xmizl6a.fsf@igel.home
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 9a753c4dafab6..b29135dd73342 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2944,11 +2944,11 @@ static void __init fixup_device_tree_pmac(void)
 	char type[8];
 	phandle node;
 
-	// Some pmacs are missing #size-cells on escc nodes
+	// Some pmacs are missing #size-cells on escc or i2s nodes
 	for (node = 0; prom_next_node(&node); ) {
 		type[0] = '\0';
 		prom_getprop(node, "device_type", type, sizeof(type));
-		if (prom_strcmp(type, "escc"))
+		if (prom_strcmp(type, "escc") && prom_strcmp(type, "i2s"))
 			continue;
 
 		if (prom_getproplen(node, "#size-cells") != PROM_ERROR)
-- 
2.39.5




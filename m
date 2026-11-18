Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038710;
	b=GIjifB/wH9D8v/2/IDBKK2Goopdm0b/ps+23gUVzY+0mxoB+9ecDhogAWiz890qO1u4x
	 80S1q8bNr4jpEm0rQs60RpNXihEtBhTAnihkTWH67X+xGKNEQsPY+jKobTyiC3tvv3QBj
	 PRtymcdc8gzQ3HxmDXv6wdy2Ja01XknjcEeO7bjfUQHDLNEmBI8JyBXeoHK/50z3kWGke
	 FsuwEMiphRZ4P2QwmyB7u5l+GwQ7OaoLtHchvki7Lc9vHh1dn1CgoWXYbTncd/XN7l5OE
	 L+trYbmvW7/+ltOrb15Xe5UcvzPjpM9c8xvBplif3fCJGhuXGhDd74bjEdfjVg3MGkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Qngbz9BVaG3MBpbJ1AUxA85nj8BOu1R0PY+cDs0OxJk=;
	b=Zf/KvxMRAQWmTcZT4Ygk5dkqdE+YIY99rQu6qB1F3C0S7wPUqfyww6V8KQaavHIXjwDu
	 UV2U39n7BBrOV0bVocZH59TU6DbS/h9+ATR1qU0/6XSCAIUFreukjAEfNlSaB0U2n4oYe
	 4V0+MWHmUvyFkUQaKuljFR6kguQCHx+XpMTKVOehjvbrws1NncIgof/i5hq+MQrp+37+s
	 H2ECf7HisRsmVcXWYMkQwjzzY7VqlyHHnHc7uggGudQhEMoHNlyWq+MVxP5Blfzw1snWU
	 FLnEHwmjv0H6+YbtNmkluUVIepQB5X5LipPjvwNJkQwLRqz0E1VY7c+UFNH9O9kX/IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ls83bKus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D39C606A31C;
	Wed, 18 Nov 2026 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ls83bKus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722521F000C5;
	Wed, 18 Nov 2026 21:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038710;
	bh=Qngbz9BVaG3MBpbJ1AUxA85nj8BOu1R0PY+cDs0OxJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ls83bKusWcgvKfrHkTthvC5BXBsW4FXow8l4RGEnQ30/702Azq6u+MpS59jSxD+u/
	 ymoENon7elyrRX5+GmrZs/SMwLOI1cd0ibwIUhtQ367HI/XAi6HGNEZuRe/pRd+lhu
	 YfJDPL8hg5NSQ7v/Abb8qX/1tUmqH4dJWSCOkmkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1841/3318] platform/x86/amd/pmf: Add AMDI0112 ACPI ID
Date: Wed, 18 Nov 2026 15:41:03 +0100
Message-ID: <20261118150417.088237816@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 325bcc126cf7a512a0e2da0efddad665f69badac ]

The AMDI0112 ID is used to bind the PMF driver to some platforms.
It doesn't have any Linux side code changes relative to the most
similar AMDI0105.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260826163611.2268377-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: Adjusted ACPI table context to insert AMDI0112 after AMDI0103 because the intervening upstream entries are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index 78ed3ee22555d..19dbc189ee17d 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -342,6 +342,7 @@ static const struct acpi_device_id amd_pmf_acpi_ids[] = {
 	{"AMDI0100", 0x100},
 	{"AMDI0102", 0},
 	{"AMDI0103", 0},
+	{"AMDI0112", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmf_acpi_ids);
-- 
2.53.0




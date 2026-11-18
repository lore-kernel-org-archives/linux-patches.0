Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020339;
	b=1SAc4nwN/m8g5lgm7aiJCTgtAxlAv0BGcEiLpmanQjDkBoIPwsaPgFtBT1rNNkGEkc8M
	 yOiYt8Y8y43B4pIvASm94b2Q2fS3IjL1l8D9CJ3XsjWfojj60yc49zbYd8RmnAwaDRHz9
	 feaC9qyAfE8tA+uT3Asg1lw9WhFw6xvPDPMOQAfvviO8SjOgpZMBt/Dph6heg/IoFi47Q
	 22baOO0daV2lTmc4t8WzhC8rnK3tLIe5eD6iXg9YrMGoMCYyESqwbl5agQuih0Cj44UX8
	 I0yJlm8D7JQNAnCfDn/wgRvEOYvqcNUYM2m9rBCILZR6jeiC6O59dyHjJXIulaa8Oaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=btzSQs79VpfMWIpbz7OpDFoPVBQbgNmrkFjBrJ7ORzo=;
	b=H9thsnn2ttsAeeeY2eZFNWEOyJcsODXsQmXg10uLqk7gVSuIIZY5A4ORKkDZedXOMpzN
	 XMpoeT9bozUQHfX9YE6Jb6MESPbiQxjWF0nbAb3o9q2Ys18qlbyOM5ozW/0TCPUo+MPkt
	 XpFy2YpDL8UOZ+CUY04ktifkP+wJ+MmNagVS7ZxobseKy7UhqNnWtQs8bTd5fOMltn8aa
	 gZaDvBGSUr1hp2Msp3QYGDTE0pyNEHgqY2N+fxwgW3bssDBh6mPB/N/ypVA06boSq/0S+
	 4qkA54zOc2mVCDZjuzv8xy8pmfyrhQUlvtc+u01ammuZLHvrc5amYGUfVVUp1NXm5QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rv4+QweQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E174606A31C;
	Wed, 18 Nov 2026 16:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rv4+QweQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763471F000C4;
	Wed, 18 Nov 2026 16:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020339;
	bh=btzSQs79VpfMWIpbz7OpDFoPVBQbgNmrkFjBrJ7ORzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rv4+QweQoRE8kD4TKXkuLQMEVW3LZ8mJCPu9cY+qYo2l4SIWsuHukCrN4lShdQPKc
	 N3T9TmyaOx+ru6f4Nt/+C10z5RLTg+/PXv8hENoz7tldlgZ2qowuNVys9ftpJP/iSQ
	 2XpjSXg+0zJ9f+iOoQ24iSWcexhsnmJJ754vQWOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1915/2651] resolve_btfids: Fix the --fatal_warnings exit status
Date: Wed, 18 Nov 2026 15:52:35 +0100
Message-ID: <20261118150355.710096223@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 201a454df948021916e051b0a84a674f4f0f9671 ]

The resolve_btfids --fatal_warnings option is intended to make the tool
exit with a non-zero status if any warnings are reported. main()
initializes err to -1 and uses 'goto out' to return this status when
a sub-operation fails. If no error occurs,
'if (!(fatal_warnings && warnings)) err = 0;' modifies the final status
depending on whether any warnings have been reported.

Commit 522397d05e7d ("resolve_btfids: Change in-place update with raw
binary output") broke this logic by assigning the return values of newly
added sub-operations to err. As a result, successful sub-operations
overwrite the initial err value of -1 with 0, causing the tool to exit
successfully even when --fatal_warnings is enabled and warnings have been
reported.

Fix the issue by setting the final value of err unconditionally, so the
code doesn't depend on its previous value.

Fixes: 522397d05e7d ("resolve_btfids: Change in-place update with raw binary output")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20261008-resolve_btfids-warnings-v1-1-0d4e613ffa6e@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 37d7e7224207d..2a93517ca9ec1 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -1842,8 +1842,7 @@ int main(int argc, const char **argv)
 			goto out;
 	}
 
-	if (!(fatal_warnings && warnings))
-		err = 0;
+	err = fatal_warnings && warnings ? -1 : 0;
 out:
 	btf__free(obj.base_btf);
 	btf__free(obj.btf);
-- 
2.53.0




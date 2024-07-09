Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638C755E4C;
	Tue,  9 Jul 2024 11:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524750; cv=none; b=OgBOb7WJeSDtB3Ut/9fkjUu5RtuxRdLiszyOQDNPxE2eOMWZEFwlMab/PstPh+5GeCdCLzGWkIxY5bsfu8g4jhoFtq1jndjUYVsJxnlrXutSm/fgnZQ+XuyYI+nSvZHmSsj31Nxu/5npAN6eOfZ1gmAxFl5NV6NxU27hGwmrZx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524750; c=relaxed/simple;
	bh=CwXKF6uNBvzh5yh5mRkPiapyPqot6MqXji3h3ZVayeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a201rKTH0tPzH6PaC1SfPKsHrPFo3hGmcPE2E7yTYzrLC1T+kRLSGZMvW8OFoGU/K8uw2KsyiaIq7cjtR8wnt5NTV0MP+NXAvFMu1wBS8BSD2eOhdafAUNT+8rJIk+vurPbL6vMC3qZ7OIPUM1Fm42oXL0tWggFN2tmDplX0irI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vESBCRXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vESBCRXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCF9C3277B;
	Tue,  9 Jul 2024 11:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524750;
	bh=CwXKF6uNBvzh5yh5mRkPiapyPqot6MqXji3h3ZVayeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vESBCRXQ40ZeThjCbnUUjosb21sB10BbqwIRIMRCQ8aTv7Lf51tchnRKoKDK57Htw
	 YRinO8c0I/XETrcexxCEn8IIRRKrL7IKdADM3NpRJi8H4C8W1Awq+ZgGU2ZCSsqCpG
	 ZLIko53sxc+BtPlEh8TLhc03UqvsLp281NzkyW68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Xiaochun Lu <xiaochun.lu@bytedance.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/102] selftests: make order checking verbose in msg_zerocopy selftest
Date: Tue,  9 Jul 2024 13:10:21 +0200
Message-ID: <20240709110653.639663494@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 7d6d8f0c8b700c9493f2839abccb6d29028b4219 ]

We find that when lock debugging is on, notifications may not come in
order. Thus, we have order checking outputs managed by cfg_verbose, to
avoid too many outputs in this case.

Fixes: 07b65c5b31ce ("test: add msg_zerocopy test")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Signed-off-by: Xiaochun Lu <xiaochun.lu@bytedance.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240701225349.3395580-3-zijianzhang@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/msg_zerocopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/msg_zerocopy.c b/tools/testing/selftests/net/msg_zerocopy.c
index 926556febc83c..7ea5fb28c93db 100644
--- a/tools/testing/selftests/net/msg_zerocopy.c
+++ b/tools/testing/selftests/net/msg_zerocopy.c
@@ -438,7 +438,7 @@ static bool do_recv_completion(int fd, int domain)
 	/* Detect notification gaps. These should not happen often, if at all.
 	 * Gaps can occur due to drops, reordering and retransmissions.
 	 */
-	if (lo != next_completion)
+	if (cfg_verbose && lo != next_completion)
 		fprintf(stderr, "gap: %u..%u does not append to %u\n",
 			lo, hi, next_completion);
 	next_completion = hi + 1;
-- 
2.43.0



